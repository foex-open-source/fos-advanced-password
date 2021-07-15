create or replace package body com_fos_advanced_password
as

-- =============================================================================
--
--  FOS = FOEX Open Source (fos.world), by FOEX GmbH, Austria (www.foex.at)
--
--  This plug-in provides you with an advanced Password item.
--
--  License: MIT
--
--  GitHub: https://github.com/foex-open-source/fos-advanced-password-item
--
-- =============================================================================
procedure render
    ( p_item   in            apex_plugin.t_item
    , p_plugin in            apex_plugin.t_plugin
    , p_param  in            apex_plugin.t_item_render_param
    , p_result in out nocopy apex_plugin.t_item_render_result
    )
as
    l_item_name_esc                 varchar2(4000)             := apex_escape.html_attribute(p_item.name);

    l_icon                          varchar2(4000)             := p_item.icon_css_classes;
    l_icon_esc                      varchar2(4000)             := apex_escape.html_attribute(l_icon);
    l_has_icon                      varchar2(4000)             := case when l_icon is not null then 'apex-item-has-icon' else '' end;
    l_placeholder                   varchar2(4000)             := apex_escape.html_attribute(p_item.placeholder);

    -- width of the <input> Tag
    l_width_esc                     varchar2(4000)             := apex_escape.html_attribute(p_item.element_width);

    l_init_js_fn                    varchar2(32767)            := nvl(apex_plugin_util.replace_substitutions(p_item.init_javascript_code), 'undefined');

    -- peek support
    l_peek_support                  p_item.attribute_01%type   := p_item.attribute_01;

    -- rules container
    l_rules_container               p_item.attribute_02%type   := p_item.attribute_02;
    l_rules_comp_text               p_item.attribute_03%type   := p_item.attribute_03;

    -- options
    l_rule_minimum_length           boolean                    := instr(p_item.attribute_04, 'require-min-length')           > 0;
    l_rule_numbers                  boolean                    := instr(p_item.attribute_04, 'require-number')               > 0;
    l_rule_special_characters       boolean                    := instr(p_item.attribute_04, 'require-spec-char')            > 0;
    l_rule_capital_letters          boolean                    := instr(p_item.attribute_04, 'require-capital-letter')       > 0;
    l_show_password_strength        boolean                    := instr(p_item.attribute_04, 'show-pwd-strength-bar')        > 0;
    l_show_caps_lock                boolean                    := instr(p_item.attribute_04, 'show-caps-lock-on')            > 0;
    l_show_error_if_incorrect       boolean                    := instr(p_item.attribute_04, 'show-error-if-incorrect')      > 0;
    l_disable_items                 boolean                    := instr(p_item.attribute_04, 'disable-button-if-incorrect')  > 0;
    l_strecth_rules_con             boolean                    := instr(p_item.attribute_04, 'stretch-rules-container')      > 0;
    l_inline_check_icon             boolean                    := instr(p_item.attribute_04, 'enable-inline-icons')          > 0;
    l_expect_new_pwd                boolean                    := instr(p_item.attribute_04, 'new-password')                 > 0;
    l_is_confirmation_item          boolean                    := instr(p_item.attribute_04, 'is-confirmation-item')         > 0;

    -- autocomplete value
    l_autocomplete                  varchar2(100)              := case when l_expect_new_pwd then 'new-password' else 'current-password' end;

    -- rule - length
    l_min_length                    p_item.attribute_05%type   := p_item.attribute_05;
    l_min_length_msg                p_item.attribute_06%type   := p_item.attribute_06;
    l_min_length_msg_esc            varchar2(1000)             := apex_escape.html_attribute(replace(l_min_length_msg,'#MIN_LENGTH#',l_min_length));

    -- rule - numbers
    l_num_of_nums                   p_item.attribute_07%type   := p_item.attribute_07;
    l_num_msg                       p_item.attribute_08%type   := p_item.attribute_08;
    l_num_msg_esc                   varchar2(1000)             := apex_escape.html_attribute(replace(l_num_msg,'#MIN_NUMS#',l_num_of_nums));

    -- rule - special characters
    l_list_of_spec_chars            p_item.attribute_09%type   := apex_escape.regexp(p_item.attribute_09);
    l_num_of_spec_chars             p_item.attribute_10%type   := p_item.attribute_10;
    l_spec_chars_msg                p_item.attribute_12%type   := p_item.attribute_11;
    l_spec_chars_msg_esc            varchar2(1000)             := apex_escape.html_attribute(replace(replace(l_spec_chars_msg,'#MIN_SPEC_CHARS#',l_num_of_spec_chars),'#SPEC_CHARS_LIST#', p_item.attribute_09));

    -- rule - capital letters
    l_num_of_capital_letters        p_item.attribute_11%type   := p_item.attribute_12;
    l_capital_letters_msg           p_item.attribute_12%type   := p_item.attribute_13;
    l_capital_letters_msg_esc       varchar2(1000)             := apex_escape.html_attribute(replace(l_capital_letters_msg,'#MIN_CAPS#',l_num_of_capital_letters));

    l_rules_container_style        varchar2(100)               := case when l_strecth_rules_con then 'fos-ap-rule-container-stretch' else 'fos-ap-rule-container' end;
    l_items_to_disable             apex_t_varchar2             := nvl(apex_string.split(p_item.attribute_14,','), apex_t_varchar2());
    l_confirmation_item            p_item.attribute_15%type    := p_item.attribute_15;

begin
    --debug
    if apex_application.g_debug
    then
        apex_plugin_util.debug_page_item
          ( p_plugin    => p_plugin
          , p_page_item => p_item
          );
    end if;

    if p_param.is_readonly or p_param.is_printer_friendly
    then
        apex_plugin_util.print_hidden_if_readonly
          ( p_item  => p_item
          , p_param => p_param
          );

        apex_plugin_util.print_display_only
          ( p_item             => p_item
          , p_display_value    => p_param.value
          , p_show_line_breaks => true
          , p_escape           => false
          , p_show_icon        => false
          );
    else
        -- outer container open
        sys.htp.p('<div id="' || l_item_name_esc || '_region" class="fos-ap-outer-container">');
        -- inner wrapper open
        sys.htp.p('    <div class="fos-ap-inner-container">');
        sys.htp.p('        <input type="password" name="' || l_item_name_esc || '" placeholder="'|| l_placeholder ||'" autocomplete="'|| l_autocomplete ||'" size="' || l_width_esc || '" maxlength="" value="" id="' || l_item_name_esc || '" class="password apex-item-text ' || l_has_icon || '">');
        -- apex icon
        if l_icon is not null
        then
            sys.htp.p('    <span class="apex-item-icon fa ' || l_icon_esc || '" aria-hidden="true"></span>');
        end if;
        -- caps lock
        if l_show_caps_lock
        then
            sys.htp.p('    <span class="apex-item-icon fa ap-caps-lock fos-ap-capslock" aria-hidden="true"></span>');
        end if;
        -- peek icon
        if l_peek_support != 'disabled'
        then
            sys.htp.p('    <span class="apex-item-icon fa ap-password-eye" aria-hidden="true"></span>');
        end if;

        -- inline check icon
        if l_inline_check_icon
        then
            sys.htp.p('    <span class="apex-item-icon fos-ap-inline-check fa"></span>');
        end if;
        -- inner wrapper - close
        sys.htp.p('</div>');

        if not l_is_confirmation_item
        then
            -- strenght bar
            if l_show_password_strength
            then
                sys.htp.p('<div class="fos-strength-bar-container">');
                sys.htp.p('    <div class="fos-strength-bg"></div>');
                sys.htp.p('    <div class="fos-strength-container"></div>');
                sys.htp.p('</div>');
            end if;

            -- collapsible region title bar
            if l_rules_container = 'collapsible' and (l_rule_minimum_length or l_rule_numbers or l_rule_capital_letters or l_rule_special_characters)
            then
                sys.htp.p('<div class="fos-ap-constraints-title" name=""></div>');
            end if;

            -- rules container open
            sys.htp.p('    <div class="fos-ap-constraints '|| l_rules_container_style ||' fos-ap-container fos-ap-container-'|| l_rules_container ||'">');


            if l_rule_minimum_length
            then
                sys.htp.p('<div class="fos-ap-rule password-rule-length" name="FOSpwdLength">');
                sys.htp.p('    <span class="fa fos-pwd-fail fos-pwd"></span>');
                sys.htp.p('    <span class="fos-ap-rule-text"> ' || l_min_length_msg_esc || ' </span>');
                sys.htp.p('</div>');
            end if;

            if l_rule_numbers
            then
                sys.htp.p('<div class="fos-ap-rule password-rule-numbers" name="FOSpwdNums">');
                sys.htp.p('    <span class="fa fos-pwd-fail fos-pwd"></span>');
                sys.htp.p('    <span class="fos-ap-rule-text"> ' || l_num_msg_esc || ' </span> ');
                sys.htp.p('</div>');
            end if;

            if l_rule_capital_letters
            then
                sys.htp.p('<div class="fos-ap-rule password-rule-capital-letters" name="FOSpwdCapitals">');
                sys.htp.p('    <span class="fa fos-pwd-fail fos-pwd"></span>');
                sys.htp.p('    <span class="fos-ap-rule-text"> ' || l_capital_letters_msg_esc || '</span>');
                sys.htp.p('</div>');
            end if;

            if l_rule_special_characters
            then
                sys.htp.p('<div class="fos-ap-rule password-rule-special-characters" name="FOSpwdSpecChars">');
                sys.htp.p('    <span class="fa fos-pwd-fail fos-pwd"></span>');
                sys.htp.p('    <span class="fos-ap-rule-text"> ' || l_spec_chars_msg_esc || '</span> ');
                sys.htp.p('</div>');
            end if;
            -- rules container close
            sys.htp.p('    </div>');
        end if;
        -- outer container close
        sys.htp.p('</div>');

    end if;

    apex_json.initialize_clob_output;

    apex_json.open_object;
    apex_json.write('itemName'           , l_item_name_esc           );
    apex_json.write('pwdPeek'            , l_peek_support            );
    apex_json.write('showStrengthBar'    , l_show_password_strength  );
    apex_json.write('showCapsLock'       , l_show_caps_lock          );
    apex_json.write('rulesContainer'     , l_rules_container         );
    apex_json.write('rulesCompText'      , l_rules_comp_text         );
    apex_json.write('showErrorIfInc'     , l_show_error_if_incorrect );
    apex_json.write('disableItems'       , l_disable_items           );
    apex_json.write('itemsToDisable'     , l_items_to_disable        , true);
    apex_json.write('confItem'           , l_confirmation_item       );
    apex_json.write('inlineIcon'         , l_inline_check_icon       );
    apex_json.write('isConfirmationItem' , l_is_confirmation_item    );

    apex_json.open_object('rules');

    if l_rule_minimum_length
    then
        apex_json.open_object('pwdLength'                            );
        apex_json.open_object('attributes'                           );
        apex_json.write('length'          , l_min_length             );
        apex_json.close_object;
        apex_json.close_object;
    end if;

    if l_rule_numbers
    then
        apex_json.open_object('pwdNums'                              );
        apex_json.open_object('attributes'                           );
        apex_json.write('length'         , l_num_of_nums             );
        apex_json.close_object;
        apex_json.close_object;
    end if;

    if l_rule_capital_letters
    then
        apex_json.open_object('pwdCapitals');
        apex_json.open_object('attributes');
        apex_json.write('length'         , l_num_of_capital_letters  );
        apex_json.close_object;
        apex_json.close_object;
    end if;

    if l_rule_special_characters
    then
        apex_json.open_object('pwdSpecChars');
        apex_json.open_object('attributes');
        apex_json.write('listOfSpecChar' , l_list_of_spec_chars      );
        apex_json.write('length'         , l_num_of_spec_chars       );
        apex_json.close_object;
        apex_json.close_object;
    end if;

    apex_json.close_object;
    apex_json.close_object;

    apex_javascript.add_onload_code('FOS.item.advancedPassword.init('|| apex_json.get_clob_output  ||', '|| l_init_js_fn ||')');

    apex_json.free_output;

end render;

procedure validate
    ( p_item     in apex_plugin.t_item
    , p_plugin   in apex_plugin.t_plugin
    , p_param    in apex_plugin.t_item_validation_param
    , p_result   in out nocopy apex_plugin.t_item_validation_result
    )
as
    l_value                         p_param.value%type         := p_param.value;
    l_is_required                   boolean                    := p_item.is_required;
    l_rule_minimum_length           boolean                    := instr(p_item.attribute_04, 'require-min-length')           > 0;
    l_rule_numbers                  boolean                    := instr(p_item.attribute_04, 'require-number')               > 0;
    l_rule_special_characters       boolean                    := instr(p_item.attribute_04, 'require-spec-char')            > 0;
    l_rule_capital_letters          boolean                    := instr(p_item.attribute_04, 'require-capital-letter')       > 0;

    -- rule - length
    l_min_length                    p_item.attribute_05%type   := p_item.attribute_05;
    l_min_length_msg                p_item.attribute_06%type   := p_item.attribute_06;
    l_min_length_msg_esc            varchar2(1000)             := replace(l_min_length_msg,'#MIN_LENGTH#',l_min_length);
    -- rule - numbers
    l_num_of_nums                   p_item.attribute_07%type   := p_item.attribute_07;
    l_num_msg                       p_item.attribute_08%type   := p_item.attribute_08;
    l_num_msg_esc                   varchar2(1000)             := replace(l_num_msg,'#MIN_NUMS#',l_num_of_nums);
    -- rule - special characters
    l_list_of_spec_chars            p_item.attribute_09%type   := p_item.attribute_09;
    l_num_of_spec_chars             p_item.attribute_10%type   := p_item.attribute_10;
    l_spec_chars_msg                p_item.attribute_12%type   := p_item.attribute_11;
    l_spec_chars_msg_esc            varchar2(1000)             := replace(replace(l_spec_chars_msg,'#MIN_SPEC_CHARS#',l_num_of_spec_chars),'#SPEC_CHARS_LIST#', p_item.attribute_09);

    l_right_bracket                 varchar2(100);
    -- rule - capital letters
    l_num_of_capital_letters        p_item.attribute_11%type   := p_item.attribute_12;
    l_capital_letters_msg           p_item.attribute_12%type   := p_item.attribute_13;
    l_capital_letters_msg_esc       varchar2(1000)             := replace(l_capital_letters_msg,'#MIN_CAPS#',l_num_of_capital_letters);


    l_confirmation_item             p_item.attribute_15%type   := p_item.attribute_15;
begin
    -- set the position for the error message
    p_result.display_location := apex_plugin.c_inline_with_field;

    -- if required, check the value
    if l_is_required and l_value is null
    then
        p_result.message := 'Value required';
        return;
    end if;

    -- check the length
    if l_rule_minimum_length
    then
        if length(l_value) < l_min_length
        then
            p_result.message := l_min_length_msg_esc;
            return;
        end if;
    end if;

    -- check if it contains numbers
    if l_rule_numbers
    then
        if not regexp_like(l_value,'([0-9].*){'|| l_num_of_nums ||',}')
        then
            p_result.message := l_num_msg_esc;
            return;
        end if;
    end if;

    -- check for spec characters
    if l_rule_special_characters
    then
        l_right_bracket := instr(l_list_of_spec_chars, ']');
        if l_right_bracket > 0
        then
            l_list_of_spec_chars := replace(l_list_of_spec_chars, ']','');
            l_list_of_spec_chars := ']' || apex_escape.regexp(l_list_of_spec_chars);
        end if;
        if not regexp_like(l_value, '(['|| l_list_of_spec_chars ||'].*){'|| l_num_of_spec_chars ||'}')
        then
            p_result.message := l_spec_chars_msg_esc;
            return;
        end if;
    end if;

    -- check for capital letters
    if l_rule_capital_letters
    then
        if not regexp_like(l_value,'([A-Z].*){'|| l_num_of_capital_letters ||',}')
        then
            p_result.message := l_capital_letters_msg_esc;
            return;
        end if;
    end if;

end validate;


end;
/


