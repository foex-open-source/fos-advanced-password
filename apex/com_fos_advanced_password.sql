prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_190200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2019.10.04'
,p_release=>'19.2.0.00.18'
,p_default_workspace_id=>1620873114056663
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'FOS_MASTER_WS'
);
end;
/

prompt APPLICATION 102 - FOS Dev - Plugin Master
--
-- Application Export:
--   Application:     102
--   Name:            FOS Dev - Plugin Master
--   Exported By:     FOS_MASTER_WS
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 61118001090994374
--     PLUGIN: 134108205512926532
--     PLUGIN: 1039471776506160903
--     PLUGIN: 547902228942303344
--     PLUGIN: 217651153971039957
--     PLUGIN: 412155278231616931
--     PLUGIN: 1389837954374630576
--     PLUGIN: 461352325906078083
--     PLUGIN: 13235263798301758
--     PLUGIN: 216426771609128043
--     PLUGIN: 37441962356114799
--     PLUGIN: 1846579882179407086
--     PLUGIN: 8354320589762683
--     PLUGIN: 50031193176975232
--     PLUGIN: 106296184223956059
--     PLUGIN: 35822631205839510
--     PLUGIN: 2674568769566617
--     PLUGIN: 183507938916453268
--     PLUGIN: 14934236679644451
--     PLUGIN: 2600618193722136
--     PLUGIN: 2657630155025963
--     PLUGIN: 284978227819945411
--     PLUGIN: 56714461465893111
--     PLUGIN: 98648032013264649
--     PLUGIN: 455014954654760331
--     PLUGIN: 98504124924145200
--     PLUGIN: 212503470416800524
--   Manifest End
--   Version:         19.2.0.00.18
--   Instance ID:     250144500186934
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/item_type/com_fos_advanced_password
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(98504124924145200)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'COM.FOS.ADVANCED_PASSWORD'
,p_display_name=>'FOS - Advanced Password '
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_javascript_file_urls=>'#PLUGIN_FILES#script.js'
,p_css_file_urls=>'#PLUGIN_FILES#style.css'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- =============================================================================',
'--',
'--  FOS = FOEX Open Source (fos.world), by FOEX GmbH, Austria (www.foex.at)',
'--',
'--  This plug-in provides you with an advanced Password item.',
'--',
'--  License: MIT',
'--',
'--  GitHub: https://github.com/foex-open-source/fos-advanced-password-item',
'--',
'-- =============================================================================',
'procedure render ',
'  ( p_item   in            apex_plugin.t_item',
'  , p_plugin in            apex_plugin.t_plugin',
'  , p_param  in            apex_plugin.t_item_render_param',
'  , p_result in out nocopy apex_plugin.t_item_render_result ',
'  ) ',
'as',
'    l_item_name_esc                 varchar2(4000)             := apex_escape.html_attribute(p_item.name);   ',
'    ',
'    l_icon                          varchar2(4000)             := p_item.icon_css_classes;                   ',
'    l_icon_esc                      varchar2(4000)             := apex_escape.html_attribute(l_icon);',
'    l_has_icon                      varchar2(4000)             := case when l_icon is not null then ''apex-item-has-icon'' else '''' end;',
'    l_placeholder                   varchar2(4000)             := apex_escape.html_attribute(p_item.placeholder);',
'     ',
'    -- width of the <input> Tag',
'    l_width_esc                     varchar2(4000)             := apex_escape.html_attribute(p_item.element_width);',
'    ',
'    l_init_js_fn                    varchar2(32767)            := nvl(apex_plugin_util.replace_substitutions(p_item.init_javascript_code), ''undefined'');',
'    ',
'    -- peek support',
'    l_peek_support                  p_item.attribute_01%type   := p_item.attribute_01;',
'    ',
'    -- rules container',
'    l_rules_container               p_item.attribute_02%type   := p_item.attribute_02;',
'    l_rules_comp_text               p_item.attribute_03%type   := p_item.attribute_03;',
'    ',
'    -- options',
'    l_rule_minimum_length           boolean                    := instr(p_item.attribute_04, ''require-min-length'')           > 0;',
'    l_rule_numbers                  boolean                    := instr(p_item.attribute_04, ''require-number'')               > 0;',
'    l_rule_special_characters       boolean                    := instr(p_item.attribute_04, ''require-spec-char'')            > 0;',
'    l_rule_capital_letters          boolean                    := instr(p_item.attribute_04, ''require-capital-letter'')       > 0;',
'    l_show_password_strength        boolean                    := instr(p_item.attribute_04, ''show-pwd-strength-bar'')        > 0;',
'    l_show_caps_lock                boolean                    := instr(p_item.attribute_04, ''show-caps-lock-on'')            > 0;',
'    l_show_error_if_incorrect       boolean                    := instr(p_item.attribute_04, ''show-error-if-incorrect'')      > 0;',
'    l_disable_items                 boolean                    := instr(p_item.attribute_04, ''disable-button-if-incorrect'')  > 0;',
'    l_strecth_rules_con             boolean                    := instr(p_item.attribute_04, ''stretch-rules-container'')      > 0;',
'    l_inline_check_icon             boolean                    := instr(p_item.attribute_04, ''enable-inline-icons'')          > 0;',
'    l_expect_new_pwd                boolean                    := instr(p_item.attribute_04, ''new-password'')                 > 0;',
'    l_is_confirmation_item          boolean                    := instr(p_item.attribute_04, ''is-confirmation-item'')         > 0;',
'    l_submit_on_enter               boolean                    := instr(p_item.attribute_04, ''submit-enter'')                 > 0;',
'    ',
'    -- autocomplete value',
'    l_autocomplete                  varchar2(100)              := case when l_expect_new_pwd then ''new-password'' else ''current-password'' end;',
'    ',
'    -- rule - length',
'    l_min_length                    p_item.attribute_05%type   := p_item.attribute_05;',
'    l_min_length_msg                p_item.attribute_06%type   := p_item.attribute_06;',
'    l_min_length_msg_esc            varchar2(1000)             := apex_escape.html_attribute(replace(l_min_length_msg,''#MIN_LENGTH#'',l_min_length));',
'    ',
'    -- rule - numbers',
'    l_num_of_nums                   p_item.attribute_07%type   := p_item.attribute_07;',
'    l_num_msg                       p_item.attribute_08%type   := p_item.attribute_08;',
'    l_num_msg_esc                   varchar2(1000)             := apex_escape.html_attribute(replace(l_num_msg,''#MIN_NUMS#'',l_num_of_nums));',
'    ',
'    -- rule - special characters',
'    l_list_of_spec_chars            p_item.attribute_09%type   := apex_escape.regexp(p_item.attribute_09);',
'    l_num_of_spec_chars             p_item.attribute_10%type   := p_item.attribute_10;',
'    l_spec_chars_msg                p_item.attribute_12%type   := p_item.attribute_11;',
'    l_spec_chars_msg_esc            varchar2(1000)             := apex_escape.html_attribute(replace(replace(l_spec_chars_msg,''#MIN_SPEC_CHARS#'',l_num_of_spec_chars),''#SPEC_CHARS_LIST#'', p_item.attribute_09));',
'    ',
'    -- rule - capital letters',
'    l_num_of_capital_letters        p_item.attribute_11%type   := p_item.attribute_12;',
'    l_capital_letters_msg           p_item.attribute_12%type   := p_item.attribute_13;',
'    l_capital_letters_msg_esc       varchar2(1000)             := apex_escape.html_attribute(replace(l_capital_letters_msg,''#MIN_CAPS#'',l_num_of_capital_letters));',
'    ',
'    l_rules_container_style        varchar2(100)               := case when l_strecth_rules_con then ''fos-ap-rule-container-stretch'' else ''fos-ap-rule-container'' end;',
'    l_items_to_disable             apex_t_varchar2             := nvl(apex_string.split(p_item.attribute_14,'',''), apex_t_varchar2());',
'    l_confirmation_item            p_item.attribute_15%type    := p_item.attribute_15;',
'    ',
'    l_check_length                 boolean                     := l_rule_minimum_length     and l_min_length             is not null and l_min_length             > 0;',
'    l_check_num                    boolean                     := l_rule_numbers            and l_num_of_nums            is not null and l_num_of_nums            > 0;',
'    l_check_caps                   boolean                     := l_rule_capital_letters    and l_num_of_capital_letters is not null and l_num_of_capital_letters > 0;',
'    l_check_spec                   boolean                     := l_rule_special_characters and l_num_of_spec_chars      is not null and l_num_of_spec_chars      > 0;',
'    ',
'begin',
'    --debug',
'    if apex_application.g_debug and substr(:DEBUG,6) >= 6',
'    then',
'        apex_plugin_util.debug_page_item',
'          ( p_plugin    => p_plugin',
'          , p_page_item => p_item',
'          );',
'    end if;',
'    ',
'    if p_param.is_readonly or p_param.is_printer_friendly ',
'    then',
'        apex_plugin_util.print_hidden_if_readonly',
'          ( p_item  => p_item',
'          , p_param => p_param',
'          );',
'        ',
'        apex_plugin_util.print_display_only',
'          ( p_item             => p_item',
'          , p_display_value    => p_param.value',
'          , p_show_line_breaks => true',
'          , p_escape           => false',
'          , p_show_icon        => false',
'          );',
'    else ',
'        -- outer container open',
'        sys.htp.p(''<div id="'' || l_item_name_esc || ''_region" class="fos-ap-outer-container">'');',
'        -- inner wrapper open',
'        sys.htp.p(''    <div class="fos-ap-inner-container">''); ',
'        sys.htp.p(''        <input type="password" name="'' || l_item_name_esc || ''" placeholder="''|| l_placeholder ||''" autocomplete="''|| l_autocomplete ||''" size="'' || l_width_esc || ''" maxlength="" value="" id="'' || l_item_name_esc || ''" class="pass'
||'word apex-item-text '' || l_has_icon || ''">'');',
'        -- apex icon',
'        if l_icon is not null ',
'        then',
'            sys.htp.p(''    <span class="apex-item-icon fa '' || l_icon_esc || ''" aria-hidden="true"></span>'');',
'        end if;',
'        -- caps lock',
'        if l_show_caps_lock ',
'        then',
'            sys.htp.p(''    <span class="apex-item-icon fa ap-caps-lock fos-ap-capslock" aria-hidden="true"></span>'');',
'        end if;',
'        -- peek icon',
'        if l_peek_support != ''disabled''',
'        then',
'            sys.htp.p(''    <span class="apex-item-icon fa ap-password-eye" aria-hidden="true"></span>'');',
'        end if;',
'',
'        -- inline check icon',
'        if l_inline_check_icon',
'        then',
'            sys.htp.p(''    <span class="apex-item-icon fos-ap-inline-check fa"></span>'');',
'        end if;',
'        -- inner wrapper - close',
'        sys.htp.p(''</div>'');',
'        ',
'        if not l_is_confirmation_item',
'        then',
'            -- strenght bar',
'            if l_show_password_strength ',
'            then ',
'                sys.htp.p(''<div class="fos-strength-bar-container">'');',
'                sys.htp.p(''    <div class="fos-strength-bg"></div>'');',
'                sys.htp.p(''    <div class="fos-strength-container"></div>'');',
'                sys.htp.p(''</div>'');',
'            end if;',
'',
'            -- collapsible region title bar',
'            if l_rules_container = ''collapsible'' and (l_rule_minimum_length or l_rule_numbers or l_rule_capital_letters or l_rule_special_characters)',
'            then',
'                sys.htp.p(''<div class="fos-ap-constraints-title" name=""></div>'');',
'            end if;',
'',
'            -- rules container open',
'            sys.htp.p(''    <div class="fos-ap-constraints ''|| l_rules_container_style ||'' fos-ap-container fos-ap-container-''|| l_rules_container ||''">'');',
'',
'',
'            if l_check_length',
'            then      ',
'                sys.htp.p(''<div class="fos-ap-rule password-rule-length" name="FOSpwdLength">'');',
'                sys.htp.p(''    <span class="fa fos-pwd-fail fos-pwd"></span>'');',
'                sys.htp.p(''    <span class="fos-ap-rule-text"> '' || l_min_length_msg_esc || '' </span>'');',
'                sys.htp.p(''</div>''); ',
'            end if; ',
'',
'            if l_check_num ',
'            then ',
'                sys.htp.p(''<div class="fos-ap-rule password-rule-numbers" name="FOSpwdNums">'');',
'                sys.htp.p(''    <span class="fa fos-pwd-fail fos-pwd"></span>''); ',
'                sys.htp.p(''    <span class="fos-ap-rule-text"> '' || l_num_msg_esc || '' </span> '');',
'                sys.htp.p(''</div>''); ',
'            end if;',
'',
'            if l_check_caps ',
'            then',
'                sys.htp.p(''<div class="fos-ap-rule password-rule-capital-letters" name="FOSpwdCapitals">''); ',
'                sys.htp.p(''    <span class="fa fos-pwd-fail fos-pwd"></span>''); ',
'                sys.htp.p(''    <span class="fos-ap-rule-text"> '' || l_capital_letters_msg_esc || ''</span>'');',
'                sys.htp.p(''</div>'');',
'            end if; ',
'',
'            if l_check_spec',
'            then',
'                sys.htp.p(''<div class="fos-ap-rule password-rule-special-characters" name="FOSpwdSpecChars">'');         ',
'                sys.htp.p(''    <span class="fa fos-pwd-fail fos-pwd"></span>''); ',
'                sys.htp.p(''    <span class="fos-ap-rule-text"> '' || l_spec_chars_msg_esc || ''</span> '');',
'                sys.htp.p(''</div>''); ',
'            end if;',
'            -- rules container close',
'            sys.htp.p(''    </div>'');',
'        end if;',
'        -- outer container close',
'        sys.htp.p(''</div>'');',
'    ',
'    end if;',
'',
'    apex_json.initialize_clob_output;',
'',
'    apex_json.open_object;',
'    apex_json.write(''itemName''           , l_item_name_esc           );',
'    apex_json.write(''pwdPeek''            , l_peek_support            );',
'    apex_json.write(''showStrengthBar''    , l_show_password_strength  );',
'    apex_json.write(''showCapsLock''       , l_show_caps_lock          );',
'    apex_json.write(''rulesContainer''     , l_rules_container         );',
'    apex_json.write(''rulesCompText''      , l_rules_comp_text         );',
'    apex_json.write(''showErrorIfInc''     , l_show_error_if_incorrect );',
'    apex_json.write(''disableItems''       , l_disable_items           );',
'    apex_json.write(''itemsToDisable''     , l_items_to_disable        , true);',
'    apex_json.write(''confItem''           , l_confirmation_item       );',
'    apex_json.write(''inlineIcon''         , l_inline_check_icon       );',
'    apex_json.write(''isConfirmationItem'' , l_is_confirmation_item    ); ',
'    apex_json.write(''submitOnEnter''      , l_submit_on_enter         );',
'    ',
'    apex_json.open_object(''rules'');  ',
'    ',
'    if l_check_length',
'    then',
'        apex_json.open_object(''pwdLength''                            );',
'        apex_json.open_object(''attributes''                           );',
'        apex_json.write(''length''          , l_min_length             );',
'        apex_json.close_object;',
'        apex_json.close_object;',
'    end if;',
'',
'    if l_check_num',
'    then',
'        apex_json.open_object(''pwdNums''                              );',
'        apex_json.open_object(''attributes''                           );',
'        apex_json.write(''length''         , l_num_of_nums             );',
'        apex_json.close_object;',
'        apex_json.close_object;',
'    end if;',
'    ',
'    if l_check_caps',
'    then',
'        apex_json.open_object(''pwdCapitals'');',
'        apex_json.open_object(''attributes'');',
'        apex_json.write(''length''         , l_num_of_capital_letters  );    ',
'        apex_json.close_object;',
'        apex_json.close_object;',
'    end if;',
'    ',
'    if l_check_spec ',
'    then',
'        apex_json.open_object(''pwdSpecChars'');',
'        apex_json.open_object(''attributes'');',
'        apex_json.write(''listOfSpecChar'' , l_list_of_spec_chars      );    ',
'        apex_json.write(''length''         , l_num_of_spec_chars       );  ',
'        apex_json.close_object;',
'        apex_json.close_object;',
'    end if;',
'',
'    apex_json.close_object;',
'    apex_json.close_object;',
'    ',
'    apex_javascript.add_onload_code(''FOS.item.advancedPassword.init(''|| apex_json.get_clob_output  ||'', ''|| l_init_js_fn ||'')'');',
'',
'    apex_json.free_output;',
'  ',
'end render;',
'',
'procedure validate',
'  ( p_item     in apex_plugin.t_item',
'  , p_plugin   in apex_plugin.t_plugin',
'  , p_param    in apex_plugin.t_item_validation_param',
'  , p_result   in out nocopy apex_plugin.t_item_validation_result',
'  )',
'as',
'    l_value                         p_param.value%type         := p_param.value; ',
'    l_is_required                   boolean                    := p_item.is_required;',
'    l_rule_minimum_length           boolean                    := instr(p_item.attribute_04, ''require-min-length'')           > 0;',
'    l_rule_numbers                  boolean                    := instr(p_item.attribute_04, ''require-number'')               > 0;',
'    l_rule_special_characters       boolean                    := instr(p_item.attribute_04, ''require-spec-char'')            > 0;',
'    l_rule_capital_letters          boolean                    := instr(p_item.attribute_04, ''require-capital-letter'')       > 0;',
'    ',
'    -- rule - length',
'    l_min_length                    p_item.attribute_05%type   := p_item.attribute_05;',
'    l_min_length_msg                p_item.attribute_06%type   := p_item.attribute_06;',
'    l_min_length_msg_esc            varchar2(1000)             := replace(l_min_length_msg,''#MIN_LENGTH#'',l_min_length);',
'    -- rule - numbers',
'    l_num_of_nums                   p_item.attribute_07%type   := p_item.attribute_07;',
'    l_num_msg                       p_item.attribute_08%type   := p_item.attribute_08;',
'    l_num_msg_esc                   varchar2(1000)             := replace(l_num_msg,''#MIN_NUMS#'',l_num_of_nums);',
'    -- rule - special characters',
'    l_list_of_spec_chars            p_item.attribute_09%type   := p_item.attribute_09;',
'    l_num_of_spec_chars             p_item.attribute_10%type   := p_item.attribute_10;',
'    l_spec_chars_msg                p_item.attribute_12%type   := p_item.attribute_11;',
'    l_spec_chars_msg_esc            varchar2(1000)             := replace(replace(l_spec_chars_msg,''#MIN_SPEC_CHARS#'',l_num_of_spec_chars),''#SPEC_CHARS_LIST#'', p_item.attribute_09);',
'    ',
'    l_right_bracket                 varchar2(100);',
'    -- rule - capital letters',
'    l_num_of_capital_letters        p_item.attribute_11%type   := p_item.attribute_12;',
'    l_capital_letters_msg           p_item.attribute_12%type   := p_item.attribute_13;',
'    l_capital_letters_msg_esc       varchar2(1000)             := replace(l_capital_letters_msg,''#MIN_CAPS#'',l_num_of_capital_letters);',
'    ',
'    l_confirmation_item             p_item.attribute_15%type   := p_item.attribute_15;',
'    ',
'    l_check_length                 boolean                     := l_rule_minimum_length     and l_min_length             is not null and l_min_length             > 0;',
'    l_check_num                    boolean                     := l_rule_numbers            and l_num_of_nums            is not null and l_num_of_nums            > 0;',
'    l_check_caps                   boolean                     := l_rule_capital_letters    and l_num_of_capital_letters is not null and l_num_of_capital_letters > 0;',
'    l_check_spec                   boolean                     := l_rule_special_characters and l_num_of_spec_chars      is not null and l_num_of_spec_chars      > 0;',
'begin',
'    -- set the position for the error message',
'    p_result.display_location := apex_plugin.c_inline_with_field;',
'    ',
'    -- if required, check the value',
'    if l_is_required and l_value is null ',
'    then',
'        p_result.message := ''Value required'';',
'        return;',
'    end if;',
'    ',
'    -- check the length',
'    if l_check_length',
'    then',
'        if length(l_value) < l_min_length',
'        then',
'            p_result.message := l_min_length_msg_esc;',
'            return;',
'        end if;',
'    end if;',
'    ',
'    -- check if it contains numbers',
'    if l_check_num',
'    then',
'        if not regexp_like(l_value,''([0-9].*){''|| l_num_of_nums ||'',}'')',
'        then',
'            p_result.message := l_num_msg_esc;',
'            return;',
'        end if;',
'    end if;',
'    ',
'    -- check for spec characters',
'    if l_check_spec',
'    then',
'        l_right_bracket := instr(l_list_of_spec_chars, '']'');',
'        if l_right_bracket > 0',
'        then',
'            l_list_of_spec_chars := replace(l_list_of_spec_chars, '']'','''');',
'            l_list_of_spec_chars := '']'' || apex_escape.regexp(l_list_of_spec_chars);',
'        end if;',
'        if not regexp_like(l_value, ''([''|| l_list_of_spec_chars ||''].*){''|| l_num_of_spec_chars ||''}'')',
'        then',
'            p_result.message := l_spec_chars_msg_esc;',
'            return;',
'        end if;',
'    end if;',
'    ',
'    -- check for capital letters',
'    if l_check_caps',
'    then',
'        if not regexp_like(l_value,''([A-Z].*){''|| l_num_of_capital_letters ||'',}'')',
'        then',
'            p_result.message := l_capital_letters_msg_esc;',
'            return;',
'        end if;',
'    end if;',
'   ',
'end validate;',
''))
,p_api_version=>2
,p_render_function=>'render'
,p_validation_function=>'validate'
,p_standard_attributes=>'VISIBLE:FORM_ELEMENT:SESSION_STATE:READONLY:ESCAPE_OUTPUT:ELEMENT:WIDTH:ELEMENT_OPTION:PLACEHOLDER:ICON:ENCRYPT:INIT_JAVASCRIPT_CODE'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>The <strong>FOS - Advanced Password</strong> item plug-in offers a visual, highly customisable alternative to the regular password input item. This plug-in is the ideal solution to enforce your applications password requirements like length, case,'
||' character mix, special characters etc. it really shines for password confirmation in signup or password reset forms.</p>',
'<p>Visual features include: </p>',
'<ul>',
'   <li>Optionally show the password rules with a visual indicator showing if/when rules have been met (or not)</li>',
'   <li>Optionally display an icon when the "Caps Lock" is active</li>',
'   <li>Optionally add a "Peek" button to reveal the typed in password (helps the user avoid typing mistakes)</li>',
'   <li>Optionally display a coloured bar beneath the input field that checks the strength of the password as the user types</li>',
'   <li>Optionally disable other page items until all the rules are completed e.g. a confirmation password page item</li>',
'</ul>'))
,p_version_identifier=>'22.1.0'
,p_about_url=>'https://fos.world'
,p_plugin_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Settings for the FOS browser extension',
'@fos-auto-return-to-page',
'@fos-auto-open-files:script.js'))
,p_files_version=>4434
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(116419464860597281)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Peek Support'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'enabled-toggle'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>The <i>Peek support</i> places a button next to password fields with the chosen icon, that when set to active will show your password in place of the asterisks allowing you to check or edit it.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(118584957117953687)
,p_plugin_attribute_id=>wwv_flow_api.id(116419464860597281)
,p_display_sequence=>10
,p_display_value=>'Disabled'
,p_return_value=>'disabled'
,p_help_text=>'The feature is disabled, there will be no button added to the item.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(118585370392955389)
,p_plugin_attribute_id=>wwv_flow_api.id(116419464860597281)
,p_display_sequence=>20
,p_display_value=>'Enabled - Toggle'
,p_return_value=>'enabled-toggle'
,p_help_text=>'The password display will change state on mouse click(/tap on touchscreen), eg. on the first click it is shown, on the next one it is hidden.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(118585732068958652)
,p_plugin_attribute_id=>wwv_flow_api.id(116419464860597281)
,p_display_sequence=>30
,p_display_value=>'Enabled - Only during click/press'
,p_return_value=>'enabled-click-press'
,p_help_text=>'The password stays revealed only as long as the "Peek" button is pressed. In the moment of mouse-up, mouse-leave the value will be hidden.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(119187864161641820)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Password Rules Container'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'collapsible'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'require-min-length,require-number,require-spec-char,require-capital-letter'
,p_lov_type=>'STATIC'
,p_help_text=>'<p>With the help of the <i>Rules Container</i> you''re able to list the rules regarding the password strength, so your users will be clear with the criteria from the beginning, so they won''t get any late, annoying error message. Plus, optionally you c'
||'an provide a <i>Success Message</i> which will be displayed when all the rules are completed.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(119188128636642724)
,p_plugin_attribute_id=>wwv_flow_api.id(119187864161641820)
,p_display_sequence=>10
,p_display_value=>'Hidden'
,p_return_value=>'hidden'
,p_help_text=>'There will be no container displayed.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(119188540231643872)
,p_plugin_attribute_id=>wwv_flow_api.id(119187864161641820)
,p_display_sequence=>20
,p_display_value=>'Static'
,p_return_value=>'static'
,p_help_text=>'A static region containing the rules.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(119188996183645041)
,p_plugin_attribute_id=>wwv_flow_api.id(119187864161641820)
,p_display_sequence=>30
,p_display_value=>'Collapsible'
,p_return_value=>'collapsible'
,p_help_text=>'A collapsible region which, in collapsed state, shows the first failed rule.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(119300558803061380)
,p_plugin_attribute_id=>wwv_flow_api.id(119187864161641820)
,p_display_sequence=>40
,p_display_value=>'External'
,p_return_value=>'external'
,p_help_text=>'If you''d rather display the list in another place, then just provide the ID of the region(/element) in the "JavaScript Initialization Code".'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(119202499193054030)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Rules Completed Message'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'Good to go'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(119187864161641820)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'collapsible'
,p_examples=>'You''re good to go...'
,p_help_text=>'The message which will be displayed when all the rules are completed.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(116430937073834745)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Options'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'A list of options you can apply on the item.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(116431282473838349)
,p_plugin_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_display_sequence=>10
,p_display_value=>'Require Minimum Length'
,p_return_value=>'require-min-length'
,p_help_text=>'The password must have a minimum required length.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(116431653878840151)
,p_plugin_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_display_sequence=>20
,p_display_value=>'Require Number(s)'
,p_return_value=>'require-number'
,p_help_text=>'The password must contain a number.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(116432017326843543)
,p_plugin_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_display_sequence=>30
,p_display_value=>'Require Special Character(s)'

,p_return_value=>'require-spec-char'
,p_help_text=>'The password must contain a special character.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(116432466962845957)
,p_plugin_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_display_sequence=>40
,p_display_value=>'Require Capital Letter(s)'
,p_return_value=>'require-capital-letter'
,p_help_text=>'The password must contain a capital letter.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(116432886410850543)
,p_plugin_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_display_sequence=>50
,p_display_value=>'Show Password Strength-bar'
,p_return_value=>'show-pwd-strength-bar'
,p_help_text=>'Display a bar under the input field which indicates the ratio of the completed-failed rules.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(119234272062909670)
,p_plugin_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_display_sequence=>60
,p_display_value=>'Stretch Rules Container'
,p_return_value=>'stretch-rules-container'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Only if the "Rules Container" is <i>Static</i> or <i>Collapsible</i>.',
'The rules will be listed horizontally next to each other, in the full length of the item.'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(116447484511780230)
,p_plugin_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_display_sequence=>70
,p_display_value=>'Show Caps Lock On'
,p_return_value=>'show-caps-lock-on'
,p_help_text=>'Show an icon when the CapsLock is active.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(118314210629825109)
,p_plugin_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_display_sequence=>80
,p_display_value=>'Show Error If Invalid'
,p_return_value=>'show-error-if-incorrect'
,p_help_text=>'Display an error message after change when the provided value does not pass all the rules.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(118314680113827148)
,p_plugin_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_display_sequence=>90
,p_display_value=>'Disable Item(s)/Button(s) If Incorrect'
,p_return_value=>'disable-button-if-incorrect'
,p_help_text=>'Disable items/buttons as long as all the rules are not completed.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(124604293504992343)
,p_plugin_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_display_sequence=>100
,p_display_value=>'Enable Inline Icons'
,p_return_value=>'enable-inline-icons'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Show an inline icon with the current state of the item.',
'With this option you can easily set up a similar field to the one from the regular APEX login page.'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(173608086445582859)
,p_plugin_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_display_sequence=>110
,p_display_value=>'Expect New Password'
,p_return_value=>'new-password'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>If this option is checked, the plug-in''s <i>"autocomplete"</i> attribute will be set to <i>"new-password"</i>, i.e. it may be used by the browser both to avoid accidentally filling in an existing password and to offer assistance in creating a secu'
||'re password.</p>',
'',
'<p>If it is unchecked, it''ll be set to <i>"current-password"</i>.</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(131975200148502732)
,p_plugin_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_display_sequence=>120
,p_display_value=>'Is Confirmation Item'
,p_return_value=>'is-confirmation-item'
,p_help_text=>'This option <strong>must</strong> be set if the current plug-in instance is a "Confirmation Item" of an other <i>FOS - Advanced Password</i> plug-in.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(177509558238620843)
,p_plugin_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_display_sequence=>130
,p_display_value=>'Submit when Enter pressed'
,p_return_value=>'submit-enter'
,p_help_text=>'<p>Specify whether pressing the <em>Enter</em> key while in this field automatically submits the page.</p>'
);
end;
/
begin
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(116433969199863758)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Minimum Length'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'7'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'require-min-length'
,p_help_text=>'Set the number of the minimum required characters.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(116434276582866885)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Minimum Length Message'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Must contain at least #MIN_LENGTH# characters.'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'require-min-length'
,p_examples=>'Must contain at least #MIN_LENGTH# characters.'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'The message which will be displayed in the "Rules Container" or as an error message.',
'You can use #MIN_LENGTH# to reference to the value from the "Required Minimum Length" field.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(116434534913873698)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Required Number of Digits'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'1'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'require-number'
,p_help_text=>'The minimum number of digits the password must contain.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(116434828939876754)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Required Digits Message'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'At least #MIN_NUMS# digits.'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'require-number'
,p_examples=>'Must contain at least #MIN_NUMS# digits.'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'The message which will be displayed in the "Rules Container" or as an error message.',
'You can use the #MIN_NUMS# placeholder to reference to the value from the "Required Number of Digits" attribute.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(116435137227885326)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'List of Required Special Characters'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>unistr('?><,./|}[]~\00A7@#$%')
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'require-spec-char'
,p_help_text=>'Write a list of characters that you''d like to be considered in the special category.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(116435437033888520)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Number of Required Special Characters'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'2'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'require-spec-char'
,p_help_text=>'The number of the required special characters the password must contain.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(116435779311895656)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Require Special Character(s) Message'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'At least #MIN_SPEC_CHARS# from the list: #SPEC_CHARS_LIST#'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'require-spec-char'
,p_examples=>'Must contain at least #MIN_SPEC_CHARS# from the list: #SPEC_CHARS_LIST#.'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'The message which will be displayed in the "Rules Container" or as an error message.',
'You can use the #SPEC_CHARS_LIST# and the #MIN_SPEC_CHARS# placeholders to reference to the values from the "List of Special Character(s)" and the "Required number of Special Character(s)" attribute.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(116436042279900197)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>120
,p_prompt=>'Required number of Capital Letter(s)'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'1'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'require-capital-letter'
,p_help_text=>'The required number of Capital Letters.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(116436380869904866)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>130
,p_prompt=>'Require Capital Letters Message'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Must contain at least #MIN_CAPS# capital letters'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'require-capital-letter'
,p_examples=>'The password must contain at least #MINUMUM_CAPITAL# capital letters.'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'The message which will be displayed in the "Rules Container" or as an error message.',
'You can use the #SPEC_CHAR_LIST# and the #MINIMUM_CAPITAL# placeholders to reference to the value from the "Required Capital Letter(s)" attribute.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(119249273941365504)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>140
,p_prompt=>'Items To Disable If Invalid'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(116430937073834745)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'disable-button-if-incorrect'
,p_help_text=>'Provide a list of page items if you want them to be disabled as long as all the rules are not completed.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(119325973854522958)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>15
,p_display_sequence=>150
,p_prompt=>'Confirmation Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'The user has to confirm the password in this item, i.e. add the very same value, otherwise an error message will be displayed.'
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(113128769622180216)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_name=>'INIT_JAVASCRIPT_CODE'
,p_is_required=>false
,p_depending_on_has_to_exist=>true
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'function(config){',
'    // Icon to be displayed when the password is revealed',
'    config.peekShownIcon	 = ''fa-eye'';',
'',
'    // Icon to be displayed when the password is hidden',
'    config.peekHiddenIcon        = ''fa-eye-slash'';',
'',
'    // The icon which indicates when the CapsLock is turned on',
'    config.capsLockIcon		 = ''fa-change-case'';',
'',
'    // The icon which will be used when an individual rule is fulfilled',
'    config.rulesCheckIcon	 = ''fa-check-circle-o'';',
'',
'    // The icon which will be used when an individual rule is not fulfilled',
'    config.rulesFailIcon	 = ''fa-times-circle-o'';',
'',
'    // If it''s provided, then this icon will be displayed in the item when the input field becomes valid',
'    config.inlineCheckIcon	 = ''fa-check-circle-o'';',
'',
'    // If it''s provided, then this icon will be displayed in the item when the input field becomes invalid',
'    config.inlineFailIcon	 = ''fa-times-circle-o'';',
'',
'    // Error message to display when the the the rules are not passed on the plug-in instance',
'    config.errorMessage		 = ''Invalid password.'';',
'',
'    // Error message to display (under the confirmation item) when the provided passwords do no match',
'    config.confItemErrorMessage  = ''Passwords do not match.'';',
'',
'    // Style of the strength bar [dynamic | static]',
'    config.strengthBarStyle	 = ''dynamic'';',
'',
'    // Background color of the strength bar',
'    config.strengthBarBgColor    = ''#778899'';',
'',
'    // Color of the completed icons/rules/strength-bar',
'    config.successColor		 = ''#5ac240'';',
'',
'    // Color of the failed icons/rules',
'    config.errorColor		 = ''#eb4034'';',
'',
'    return config;',
'}',
'</pre>'))
,p_help_text=>'This setting allows you to define a Javascript initialization function that allows you to override any settings right before the notification is shown. These are the values which you can override:'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(118911588548242930)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_name=>'fos-ap-every-rule-complete'
,p_display_name=>'FOS - Advanced Password - Every Rule Complete'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(120008784172764813)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_name=>'fos-ap-invalid-field'
,p_display_name=>'FOS - Advanced Password - Invalid Field'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(118354784833416310)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_name=>'fos-ap-rule-complete'
,p_display_name=>'FOS - Advanced Password - Rule Complete'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(119103751911884326)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_name=>'fos-ap-rule-fail'
,p_display_name=>'FOS - Advanced Password - Rule Fail'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '0A2F2A20546F206D616B65207468652044796E616D696320436F6E646974696F6E732066616C6C206F6E6520616674657220746865206F74686572202A2F0A2E742D466F726D2D6669656C64436F6E7461696E65722D2D666C6F6174696E674C6162656C';
wwv_flow_api.g_varchar2_table(2) := '202E742D466F726D2D6974656D57726170706572207B0A09666C65782D777261703A20777261703B0A7D0A0A2F2A20546F206D616B652074686520457965206F6E20746F7020202A2F0A7370616E2E617065782D6974656D2D69636F6E2E61702D706173';
wwv_flow_api.g_varchar2_table(3) := '73776F72642D657965207B0A202020206F726465723A20333B0A202020206C6566743A202D302E3172656D21696D706F7274616E743B0A202020207A2D696E6465783A20323B0A20202020706F736974696F6E3A2072656C61746976653B0A2020202070';
wwv_flow_api.g_varchar2_table(4) := '6F696E7465722D6576656E74733A20616C6C3B0A09626F782D736861646F773A20302E3172656D20302030202364666466646620696E73657421696D706F7274616E743B0A20202020636F6C6F723A20233430343034303B0A7D0A7370616E2E61706578';
wwv_flow_api.g_varchar2_table(5) := '2D6974656D2D69636F6E2E61702D70617373776F72642D6579653A3A6166746572207B0A096D617267696E2D72696768743A20303B0A096D617267696E2D626F74746F6D3A20303B0A0972696768743A2033253B0A09626F74746F6D3A203233253B0A7D';
wwv_flow_api.g_varchar2_table(6) := '0A0A7370616E2E617065782D6974656D2D69636F6E2E61702D636170732D6C6F636B207B0A096F726465723A20333B0A202020206C6566743A202D332E3172656D3B0A202020207A2D696E6465783A20323B0A20202020706F696E7465722D6576656E74';
wwv_flow_api.g_varchar2_table(7) := '733A20616C6C3B0A20202020706F736974696F6E3A2072656C61746976653B0A09626F782D736861646F773A206E6F6E653B0A20202020636F6C6F723A20233430343034303B0A7D0A0A2E666F732D61702D636F6E73747261696E7473203E206469767B';
wwv_flow_api.g_varchar2_table(8) := '0A096D617267696E3A203370783B0A7D0A0A2E666F732D61702D72756C652D636F6E7461696E6572207B0A09666C65782D646972656374696F6E3A20636F6C756D6E3B0A7D0A0A2E666F732D61702D696E6E65722D636F6E7461696E6572207B0A096469';
wwv_flow_api.g_varchar2_table(9) := '73706C61793A20666C65783B0A7D0A0A2E666F732D61702D72756C652D636F6E7461696E65722D73747265746368207B0A09666C65782D646972656374696F6E3A20726F773B0A09666C65782D777261703A20777261703B0A7D0A0A2E666F732D61702D';
wwv_flow_api.g_varchar2_table(10) := '636F6E73747261696E7473207B0A09646973706C61793A20666C65783B0A0970616464696E672D6C6566743A203170783B0A7D0A0A2E666F732D61702D6F757465722D636F6E7461696E6572207B0A0977696474683A20313030253B0A7D0A0A2E617065';
wwv_flow_api.g_varchar2_table(11) := '782D6974656D2D6861732D69636F6E3A64697361626C6564207E202E617065782D6974656D2D69636F6E7B0A096F7061636974793A202E353B0A09706F696E7465722D6576656E74733A206E6F6E653B0A7D0A0A2F2A0A2A0950617373776F7264207374';
wwv_flow_api.g_varchar2_table(12) := '72656E677468206261720A2A2F0A2E666F732D737472656E6774682D6261722D636F6E7461696E6572207B0A096F726465723A20343B0A0977696474683A20313030253B0A09666C65782D62617369733A20313030253B0A09706F736974696F6E3A2072';
wwv_flow_api.g_varchar2_table(13) := '656C61746976653B0A096865696768743A203370783B0A096F7061636974793A20303B0A096D617267696E2D746F703A203270783B0A7D0A0A2E666F732D737472656E6774682D6267207B0A20202020646973706C61793A20626C6F636B3B0A20202020';
wwv_flow_api.g_varchar2_table(14) := '77696474683A20313030253B0A20202020706F736974696F6E3A206162736F6C7574653B0A202020206865696768743A203370783B0A7D0A0A2E666F732D737472656E6774682D636F6E7461696E6572207B0A0977696474683A20303B0A09646973706C';
wwv_flow_api.g_varchar2_table(15) := '61793A20626C6F636B3B0A09706F736974696F6E3A206162736F6C7574653B0A096865696768743A203370783B0A097472616E736974696F6E3A20616C6C202E347320656173652D696E2D6F75743B0A7D0A0A2E666F732D737472656E6774682D73706C';
wwv_flow_api.g_varchar2_table(16) := '6974207B0A09646973706C61793A20696E6C696E652D626C6F636B3B0A09706F736974696F6E3A206162736F6C7574653B0A0977696474683A203170783B0A097A2D696E6465783A203130303B0A096261636B67726F756E642D636F6C6F723A20776869';
wwv_flow_api.g_varchar2_table(17) := '74653B0A096865696768743A203370783B0A7D0A0A2E666F732D6261722D616374697665207B0A096F7061636974793A20313B0A7D0A0A2F2A0A2A20436F6C6C61707369626C6520636F6E747261696E747320726567696F6E0A2A2F0A2E666F732D6170';
wwv_flow_api.g_varchar2_table(18) := '2D636F6E73747261696E74732D7469746C65207B0A09637572736F723A20706F696E7465723B0A0977696474683A20313030253B0A09626F726465723A206E6F6E653B0A09746578742D616C69676E3A206C6566743B0A096F75746C696E653A206E6F6E';
wwv_flow_api.g_varchar2_table(19) := '653B0A096D617267696E2D746F703A203370783B0A096F766572666C6F773A2068696464656E3B0A09666F6E742D73697A653A20313270783B0A0970616464696E672D6C6566743A203170783B0A7D0A0A2E666F732D61702D636F6E73747261696E7473';
wwv_flow_api.g_varchar2_table(20) := '2D7469746C652E666F732D76616C75652D6C65617665207B0A097472616E736974696F6E3A20616C6C202E32732063756269632D62657A69657228312E302C20302E352C20302E382C20312E30293B0A097472616E73666F726D3A207472616E736C6174';
wwv_flow_api.g_varchar2_table(21) := '6559282D377078293B0A2020096F7061636974793A20303B0A7D0A0A2E666F732D61702D636F6E73747261696E74732D7469746C652E666F732D76616C75652D656E746572207B0A097472616E736974696F6E3A20616C6C202E31733B0A7D0A0A2E666F';
wwv_flow_api.g_varchar2_table(22) := '732D61702D636F6E73747261696E74732D7469746C653A6265666F7265207B0A09636F6E74656E743A20275C30303242273B0A09636F6C6F723A206C69676874677261793B0A09666F6E742D7765696768743A20626F6C643B0A09666C6F61743A207269';
wwv_flow_api.g_varchar2_table(23) := '6768743B0A096D617267696E2D72696768743A203570783B0A7D0A0A2E6163746976653A6265666F7265207B0A09636F6E74656E743A20225C32323132223B090A7D0A0A2E666F732D61702D636F6E73747261696E74732E666F732D61702D636F6E7461';
wwv_flow_api.g_varchar2_table(24) := '696E65722D68696464656E207B0A09646973706C61793A206E6F6E653B0A7D0A0A2E666F732D61702D636F6E73747261696E74732E666F732D61702D636F6E7461696E65722D636F6C6C61707369626C65207B0A096D61782D6865696768743A20303B0A';
wwv_flow_api.g_varchar2_table(25) := '096F766572666C6F773A2068696464656E3B0A097472616E736974696F6E3A206D61782D68656967687420302E327320656173652D6F75743B0A7D0A0A2E666F732D61702D636F6E7461696E65722D636F6C6C61707369626C65202E666F732D61702D72';
wwv_flow_api.g_varchar2_table(26) := '756C65207B0A096D617267696E3A203070783B0A096D617267696E2D72696768743A20313070783B0A7D0A0A2E666F732D61702D72756C65207370616E2E66612C202E666F732D61702D636F6E73747261696E74732D7469746C65207370616E2C202E66';
wwv_flow_api.g_varchar2_table(27) := '6F732D61702D72756C652D74657874207B0A09766572746963616C2D616C69676E3A206D6964646C653B0A09666F6E742D73697A653A20313270783B0A7D0A0A2F2A0A2A20696E6C696E652069636F6E0A2A2F0A2E666F732D61702D696E6C696E652D63';
wwv_flow_api.g_varchar2_table(28) := '6865636B207B0A096F7061636974793A20313B0A097A2D696E6465783A20333B0A09626F782D736861646F773A206E6F6E6521696D706F7274616E743B0A096F726465723A203321696D706F7274616E743B0A20202020706F696E7465722D6576656E74';
wwv_flow_api.g_varchar2_table(29) := '733A20616C6C3B0A20202020706F736974696F6E3A2072656C61746976653B0A202020206C696E652D6865696768743A20342E3872656D3B0A202020206D617267696E2D6C6566743A202D332E3272656D3B0A20202020746578742D616C69676E3A2063';
wwv_flow_api.g_varchar2_table(30) := '656E7465723B0A202020207472616E736974696F6E3A202E327320656173653B0A20202020666C65782D736872696E6B3A20303B0A7D0A0A2E666F732D61702D73686F77207B0A09646973706C61793A20666C65783B0A7D0A0A2E666F732D61702D6869';
wwv_flow_api.g_varchar2_table(31) := '6465207B0A09646973706C61793A206E6F6E6521696D706F7274616E743B0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(98616199702504112)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_file_name=>'style.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A20676C6F62616C20617065782C24202A2F0A0A76617220464F53203D2077696E646F772E464F53207C7C207B7D3B0A464F532E6974656D203D20464F532E6974656D207C7C207B7D3B0A464F532E6974656D2E616476616E63656450617373776F72';
wwv_flow_api.g_varchar2_table(2) := '64203D20464F532E6974656D2E616476616E63656450617373776F7264207C7C207B7D3B0A0A0A2F2A2A0A202A0A202A2040706172616D207B6F626A6563747D20202009636F6E6669672009202020202020202020202020202020202020202009436F6E';
wwv_flow_api.g_varchar2_table(3) := '66696775726174696F6E206F626A65637420636F6E7461696E696E672074686520706C7567696E2073657474696E67730A202A2040706172616D207B737472696E677D20202009636F6E6669672E6974656D4E616D652020202020202020202020202009';
wwv_flow_api.g_varchar2_table(4) := '546865206E616D65206F6620746865206974656D0A202A2040706172616D207B6F626A6563747D20202009636F6E6669672E72756C657320202020202020202020202020202020094F626A65637420686F6C64696E6720696E666F726D6174696F6E2061';
wwv_flow_api.g_varchar2_table(5) := '626F7574207468652073656C65637465642076616C69646174696F6E2072756C65730A202A2040706172616D207B626F6F6C65616E7D0909636F6E6669672E73686F77436170734C6F636B090909095768656E2074727565207468656E20616E2069636F';
wwv_flow_api.g_varchar2_table(6) := '6E2077696C6C20626520646973706C61796564206966207468652043617073204C6F636B206973206163746976650A202A2040706172616D207B626F6F6C65616E7D0909636F6E6669672E7375626D69744F6E456E7465720909095768656E2074727565';
wwv_flow_api.g_varchar2_table(7) := '2074686520706167652077696C6C206265207375626D6974746564207768656E2074686520656E746572206B65792069732070726573736564207768656E20747970696E6720696E20746865206974656D2076616C75650A202A2040706172616D207B73';
wwv_flow_api.g_varchar2_table(8) := '7472696E677D0909636F6E6669672E7077645065656B0909090909546865207374796C65206F662074686520277065656B272066756E6374696F6E616C6974790A202A2040706172616D207B737472696E677D09202020205B636F6E6669672E6973436F';
wwv_flow_api.g_varchar2_table(9) := '6E6669726D6174696F6E4974656D5D09094D75737420746F20626520747275652C2069662074686520696E7374616E6365206973206120636F6E6669726D6174696F6E73287365636F6E6461727929206974656D0A202A2040706172616D207B73747269';
wwv_flow_api.g_varchar2_table(10) := '6E677D09095B636F6E6669672E7065656B53686F776E49636F6E5D09090949636F6E20746F20626520646973706C61796564207768656E207468652070617373776F72642069732072657665616C65640A202A2040706172616D207B737472696E677D09';
wwv_flow_api.g_varchar2_table(11) := '095B636F6E6669672E7065656B48696464656E49636F6E5D09090949636F6E20746F20626520646973706C61796564207768656E207468652070617373776F72642069732068696464656E20200A202A2040706172616D207B626F6F6C65616E7D090963';
wwv_flow_api.g_varchar2_table(12) := '6F6E6669672E73686F77537472656E6774684261720909095768656E2074727565207468656E2061206261722077696C6C20626520646973706C6179656420756E64657220746865206974656D2077686963682073686F77732074686520737461746520';
wwv_flow_api.g_varchar2_table(13) := '6F662074686520636F6D706C657465642076616C69646174696F6E2072756C65730A202A2040706172616D207B737472696E677D09095B636F6E6669672E737472656E6774684261725374796C655D09095374796C65206F662074686520737472656E67';
wwv_flow_api.g_varchar2_table(14) := '746820626172205B64796E616D6963207C207374617469635D0A202A2040706172616D207B737472696E677D0909636F6E6669672E72756C6573436F6E7461696E6572090909546865207374796C65206F662074686520636F6E7461696E657220776869';
wwv_flow_api.g_varchar2_table(15) := '636820636F6E7461696E732074686520696E646976696475616C2072756C6573205B636F6C6C61707369626C65207C20737461746963207C2068696464656E5D0A202A2040706172616D207B737472696E677D0909636F6E6669672E72756C6573436F6E';
wwv_flow_api.g_varchar2_table(16) := '7461696E65724964090909546865204944206F6620746865207461726765742065787465726E616C2072756C657320636F6E7461696E657220656C656D656E742E0A202A2040706172616D207B737472696E677D09095B636F6E6669672E72756C657343';
wwv_flow_api.g_varchar2_table(17) := '6F6D70546578745D090909496620746865202772756C65732D636F6E7461696E65722720697320636F6C6C61707369626C652C207468656E20612073756363657373206D6573736167652063616E20626520646973706C61796564207768656E20616C6C';
wwv_flow_api.g_varchar2_table(18) := '207468652072756C6573207061737365640A202A2040706172616D207B737472696E677D09095B636F6E6669672E72756C6573436865636B49636F6E5D0909095468652069636F6E2077686963682077696C6C2062652075736564207768656E20616E20';
wwv_flow_api.g_varchar2_table(19) := '696E646976696475616C2072756C652069732066756C66696C6C65640A202A2040706172616D207B737472696E677D09095B636F6E6669672E72756C65734661696C49636F6E5D0909095468652069636F6E2077686963682077696C6C20626520757365';
wwv_flow_api.g_varchar2_table(20) := '64207768656E20616E20696E646976696475616C2072756C65206973206661696C65647A0A202A2040706172616D207B737472696E677D09202020205B636F6E6669672E696E6C696E65436865636B49636F6E5D0909496620697427732070726F766964';
wwv_flow_api.g_varchar2_table(21) := '65642C207468656E20746869732069636F6E2077696C6C20626520646973706C6179656420696E20746865206974656D207768656E2074686520696E707574206669656C64206265636F6D65732076616C69640A202A2040706172616D207B737472696E';
wwv_flow_api.g_varchar2_table(22) := '677D09202020205B636F6E6669672E696E6C696E654661696C49636F6E5D090909496620697427732070726F76696465642C207468656E20746869732069636F6E2077696C6C20626520646973706C6179656420696E20746865206974656D207768656E';
wwv_flow_api.g_varchar2_table(23) := '2074686520696E707574206669656C6420697320696E76616C69640A202A2040706172616D207B737472696E677D09095B636F6E6669672E6361704C6F636B49636F6E5D0909095468652069636F6E20776869636820696E64696361746573207768656E';
wwv_flow_api.g_varchar2_table(24) := '2074686520436170734C6F636B206973207475726E65640A202A2040706172616D207B61727261797D0909636F6E6669672E6974656D73546F44697361626C650909094172726179206F662070616765206974656D73282F627574746F6E73292E205468';
wwv_flow_api.g_varchar2_table(25) := '6520656C656D656E7473206F662074686973206C6973742077696C6C2064697361626C6564206173206C6F6E6720617320616C6C207468652072756C657320617265206E6F7420636F6D706C65746564200909090A202A2040706172616D207B73747269';
wwv_flow_api.g_varchar2_table(26) := '6E677D0909636F6E6669672E636F6E664974656D0909090909436F6E6669726D6174696F6E206974656D2E20496620697427732070726F76696465642C207468656E20746865206974656D7320696E2074686520276974656D73546F44697361626C6527';
wwv_flow_api.g_varchar2_table(27) := '2061727261792061726520646570656E64696E67206F6E207468697320656C656D656E7427732073746174650A202A2040706172616D207B737472696E677D09095B636F6E6669672E636F6E664974656D4572726F724D6573736167655D094572726F72';
wwv_flow_api.g_varchar2_table(28) := '206D657373616765206966207468652070617373776F72647320646F206E6F74206D617463680A202A2040706172616D207B737472696E677D09095B636F6E6669672E6572726F724D6573736167655D0909094572726F72206D65737361676520696620';

wwv_flow_api.g_varchar2_table(29) := '74686520746865207468652072756C657320617265206E6F74207061737365640A202A2040706172616D207B737472696E677D09095B636F6E6669672E6572726F72436F6C6F725D09090909436F6C6F72206F6620746865206661696C65642069636F6E';
wwv_flow_api.g_varchar2_table(30) := '732F72756C65730A202A2040706172616D207B737472696E677D09095B636F6E6669672E73756363657373436F6C6F725D090909436F6C6F72206F662074686520636F6D706C657465642069636F6E732F72756C65732F737472656E6774682D6261720A';
wwv_flow_api.g_varchar2_table(31) := '202A2040706172616D207B737472696E677D09095B636F6E6669672E737472656E6774684261724267436F6C6F725D09094261636B67726F756E6420636F6C6F72206F662074686520737472656E677468206261720A202A2040706172616D207B6E756D';
wwv_flow_api.g_varchar2_table(32) := '6265727D09095B636F6E6669672E737472656E67746842617257696474685063745D095769647468206F662074686520737472656E677468206261722072656C617469766520746F2074686520696E707574206669656C640A202A2040706172616D207B';
wwv_flow_api.g_varchar2_table(33) := '66756E6374696F6E7D202009696E69744A7320200909090909094F7074696F6E616C20496E697469616C697A6174696F6E204A61766153637269707420436F64652066756E6374696F6E0A202A2F0A0A464F532E6974656D2E616476616E636564506173';
wwv_flow_api.g_varchar2_table(34) := '73776F72642E696E6974203D2066756E6374696F6E2028636F6E6669672C20696E69744A7329207B0A092F2F2064656661756C742076616C75657320746F20746865206174747269627574657320746861742063616E20626520736574206F6E6C792074';
wwv_flow_api.g_varchar2_table(35) := '726F75676820696E69744A730A09636F6E6669672E7065656B53686F776E49636F6E203D202766612D657965273B0A09636F6E6669672E7065656B48696464656E49636F6E203D202766612D6579652D736C617368273B0A09636F6E6669672E63617073';
wwv_flow_api.g_varchar2_table(36) := '4C6F636B49636F6E203D202766612D6368616E67652D63617365273B0A09636F6E6669672E72756C6573436865636B49636F6E203D202766612D636865636B2D636972636C652D6F273B0A09636F6E6669672E72756C65734661696C49636F6E203D2027';
wwv_flow_api.g_varchar2_table(37) := '66612D74696D65732D636972636C652D6F273B0A09636F6E6669672E696E6C696E65436865636B49636F6E203D202766612D636865636B2D636972636C652D6F273B0A09636F6E6669672E696E6C696E654661696C49636F6E203D202766612D74696D65';
wwv_flow_api.g_varchar2_table(38) := '732D636972636C652D6F273B0A09636F6E6669672E6572726F724D657373616765203D2027496E76616C69642070617373776F72642E273B0A09636F6E6669672E636F6E664974656D4572726F724D657373616765203D202750617373776F7264732064';
wwv_flow_api.g_varchar2_table(39) := '6F206E6F74206D617463682E273B0A09636F6E6669672E737472656E6774684261725374796C65203D202764796E616D6963273B0A09636F6E6669672E73756363657373436F6C6F72203D202723356163323430273B0A09636F6E6669672E6572726F72';
wwv_flow_api.g_varchar2_table(40) := '436F6C6F72203D202723656234303334273B0A09636F6E6669672E737472656E6774684261724267436F6C6F72203D202723373738383939273B0A09636F6E6669672E737472656E6774684261725769647468506374203D203130303B0A0A092F2F2065';
wwv_flow_api.g_varchar2_table(41) := '7865637574652074686520696E69744A732066756E6374696F6E0A0969662028696E69744A7320262620696E69744A7320696E7374616E63656F662046756E6374696F6E29207B0A0909696E69744A732E63616C6C28746869732C20636F6E666967293B';
wwv_flow_api.g_varchar2_table(42) := '0A097D0A0A09617065782E64656275672E696E666F2827464F53202D20416476616E6365642050617373776F72643A20272C20636F6E666967293B0A0A096C6574206974656D4E616D65203D20636F6E6669672E6974656D4E616D653B0A096C65742069';
wwv_flow_api.g_varchar2_table(43) := '74656D526567696F6E203D202428272327202B206974656D4E616D65202B20275F726567696F6E27293B0A092F2F2074686520696E707574206669656C6420697473656C660A096C657420696E7075744669656C64203D202428272327202B206974656D';
wwv_flow_api.g_varchar2_table(44) := '4E616D65293B0A092F2F2072657175697265642072756C65730A096C65742072756C6573203D20636F6E6669672E72756C65733B0A092F2F20746865206E756D626572206F662072756C65730A096C657420746573744E756D203D204F626A6563742E6B';
wwv_flow_api.g_varchar2_table(45) := '6579732872756C6573292E6C656E6774683B0A092F2F2063616C63756C61746520746865206E756D626572206F6620736570617261746F727320696E2074686520737472656E677468206261720A096C657420736570506F73203D204D6174682E666C6F';
wwv_flow_api.g_varchar2_table(46) := '6F7228313030202F20746573744E756D293B0A092F2F2077652073746F726520746865207374617465206F662065766572792072756C6520696E20616E206F626A6563740A096C657420746573745374617465203D207B7D3B0A092F2F20746865207374';
wwv_flow_api.g_varchar2_table(47) := '72656E67746862617220656C656D656E740A096C657420737472656E677468426172456C2C207469746C65456C2C2072756C6573436F6E7461696E6572456C3B0A092F2F2073686F7720737472656E677468206261720A096C657420737472656E677468';
wwv_flow_api.g_varchar2_table(48) := '4261725769647468506374203D20636F6E6669672E737472656E6774684261725769647468506374202F203130303B0A0A096C6574206C656E456C203D206974656D526567696F6E2E66696E6428272E70617373776F72642D72756C652D6C656E677468';
wwv_flow_api.g_varchar2_table(49) := '202E666F732D70776427293B0A096C6574206E756D456C203D206974656D526567696F6E2E66696E6428272E70617373776F72642D72756C652D6E756D62657273202E666F732D70776427293B0A096C65742073706563456C203D206974656D52656769';
wwv_flow_api.g_varchar2_table(50) := '6F6E2E66696E6428272E70617373776F72642D72756C652D7370656369616C2D63686172616374657273202E666F732D70776427293B0A096C657420636170456C203D206974656D526567696F6E2E66696E6428272E70617373776F72642D72756C652D';
wwv_flow_api.g_varchar2_table(51) := '6361706974616C2D6C657474657273202E666F732D70776427293B0A0A09636F6E737420464F535F41505F48494444454E5F434C415353203D2027666F732D61702D68696465273B0A09636F6E73742052554C455F434F4D504C4554455F4556454E5420';
wwv_flow_api.g_varchar2_table(52) := '3D2027666F732D61702D72756C652D636F6D706C657465273B0A09636F6E73742052554C455F414C4C5F434F4D504C4554455F4556454E54203D2027666F732D61702D65766572792D72756C652D636F6D706C657465273B0A09636F6E73742052554C45';
wwv_flow_api.g_varchar2_table(53) := '5F4641494C5F4556454E54203D2027666F732D61702D72756C652D6661696C273B0A09636F6E737420494E56414C49445F4649454C445F4556454E54203D2027666F732D61702D696E76616C69642D6669656C64273B0A0A09666F7220286C6574206B65';
wwv_flow_api.g_varchar2_table(54) := '7920696E2072756C657329207B0A09096966202872756C65735B6B65795D29207B0A0909097465737453746174655B6B65795D203D2066616C73653B0A09097D0A097D0A092F2F20636865636B2069662074686572652773206174206C65617374206F6E';
wwv_flow_api.g_varchar2_table(55) := '652072756C652061646465642073656C65637465640A096C65742076616C69646174655265717569726564203D20216A51756572792E6973456D7074794F626A65637428746573745374617465292026262021636F6E6669672E6973436F6E6669726D61';
wwv_flow_api.g_varchar2_table(56) := '74696F6E4974656D3B0A0A092F2F20696E6C696E6520636865636B2069636F6E0A096C657420696E6C696E6549636F6E456C3B0A0969662028636F6E6669672E696E6C696E6549636F6E29207B0A0909696E6C696E6549636F6E456C203D206974656D52';
wwv_flow_api.g_varchar2_table(57) := '6567696F6E2E66696E6428277370616E2E666F732D61702D696E6C696E652D636865636B27293B0A0909696E6C696E6549636F6E456C2E616464436C617373285B636F6E6669672E696E6C696E654661696C49636F6E2C20464F535F41505F4849444445';
wwv_flow_api.g_varchar2_table(58) := '4E5F434C4153535D293B0A0909696E6C696E6549636F6E456C2E637373287B20276C656674273A20272D2E3272656D272C2027636F6C6F72273A20636F6E6669672E6572726F72436F6C6F72207D293B0A0909696620282176616C696461746552657175';
wwv_flow_api.g_varchar2_table(59) := '697265642026262021636F6E6669672E6973436F6E6669726D6174696F6E4974656D29207B0A090909696E7075744669656C642E6F6E2827666F637573272C2066756E6374696F6E20286529207B0A09090909696E6C696E6549636F6E456C2E72656D6F';
wwv_flow_api.g_varchar2_table(60) := '7665436C61737328464F535F41505F48494444454E5F434C415353293B0A0909097D293B0A090909696E7075744669656C642E6F6E2827696E707574272C2066756E6374696F6E20286529207B0A09090909746F67676C65496E6C696E6549636F6E2869';
wwv_flow_api.g_varchar2_table(61) := '6E6C696E6549636F6E456C2C20652E63757272656E745461726765742E76616C75652E6C656E677468203E2030293B0A0909097D293B0A09097D0A097D0A0A092F2F206164642076616C69646174696F6E2069662072657175697265640A096966202876';
wwv_flow_api.g_varchar2_table(62) := '616C6964617465526571756972656429207B0A0909696E7075744669656C642E6F6E28276B65797570206368616E6765272C2066756E6374696F6E20286529207B0A09090969662028636F6E6669672E696E6C696E6549636F6E29207B0A090909096973';
wwv_flow_api.g_varchar2_table(63) := '457665727952756C655061737365642866756E6374696F6E202829207B0A0909090909746F67676C65496E6C696E6549636F6E28696E6C696E6549636F6E456C2C2066616C7365293B0A090909097D293B0A0909097D0A09090976616C69646174652865';
wwv_flow_api.g_varchar2_table(64) := '293B0A09097D293B0A097D0A0A092F2F20746865205065656B2066756E6374696F6E616C6974790A0969662028636F6E6669672E7077645065656B20213D202764697361626C65642729207B0A0909636F6E6669672E7065656B48696464656E49636F6E';
wwv_flow_api.g_varchar2_table(65) := '203D20636F6E6669672E7065656B48696464656E49636F6E2E73706C697428272027293B0A0909636F6E6669672E7065656B53686F776E49636F6E203D20636F6E6669672E7065656B53686F776E49636F6E2E73706C697428272027293B0A09096C6574';
wwv_flow_api.g_varchar2_table(66) := '2073686F7749636F6E203D206974656D526567696F6E2E66696E6428272E61702D70617373776F72642D65796527293B0A090973686F7749636F6E2E616464436C61737328636F6E6669672E7065656B48696464656E49636F6E293B0A09092F2F206578';
wwv_flow_api.g_varchar2_table(67) := '74656E642074686520696E707574206669656C640A0909696E7075744669656C642E637373287B202770616464696E672D7269676874273A2027332E3372656D27207D293B0A09092F2F20746F2061766F6964206F7665726C617070696E672C20776520';
wwv_flow_api.g_varchar2_table(68) := '6861766520746F206D6F646966792074686520696E6C696E652069636F6E277320706F736974696F6E0A090969662028636F6E6669672E696E6C696E6549636F6E29207B0A090909696E6C696E6549636F6E456C2E637373287B20276C656674273A2027';
wwv_flow_api.g_varchar2_table(69) := '2D332E3372656D27207D293B0A09097D0A09092F2F2061646420746865206C697374656E657273206261736564206F6E207468652073657474696E67730A090969662028636F6E6669672E7077645065656B203D3D3D2027656E61626C65642D636C6963';
wwv_flow_api.g_varchar2_table(70) := '6B2D70726573732729207B0A09090973686F7749636F6E2E6F6E28276D6F7573657570206D6F7573656C6561766520746F756368656E64272C2068696465507764293B0A09090973686F7749636F6E2E6F6E28276D6F757365646F776E272C2066756E63';
wwv_flow_api.g_varchar2_table(71) := '74696F6E20286529207B0A0909090969662028652E627574746F6E203D3D3D203029207B0A090909090973686F775077642E63616C6C2873686F7749636F6E293B0A090909097D0A0909097D293B0A09090973686F7749636F6E2E6F6E2827746F756368';
wwv_flow_api.g_varchar2_table(72) := '7374617274272C2066756E6374696F6E20286529207B0A090909096C657420746F756368203D20652E746F75636865735B305D3B0A090909096C6574207349636F6E203D20646F63756D656E742E656C656D656E7446726F6D506F696E7428746F756368';
wwv_flow_api.g_varchar2_table(73) := '2E636C69656E74582C20746F7563682E636C69656E7459293B0A09090909696620287349636F6E29207B0A090909090973686F775077642E63616C6C2873686F7749636F6E293B0A090909097D0A0909097D293B0A09097D20656C73652069662028636F';
wwv_flow_api.g_varchar2_table(74) := '6E6669672E7077645065656B203D3D3D2027656E61626C65642D746F67676C652729207B0A09090973686F7749636F6E2E6F6E2827636C69636B272C20746F67676C65507764293B0A09097D0A097D0A092F2F2073686F7720636170734C6F636B206F6E';
wwv_flow_api.g_varchar2_table(75) := '0A0969662028636F6E6669672E73686F77436170734C6F636B29207B0A09096C6574206361707349636F6E203D206974656D526567696F6E2E66696E6428272E61702D636170732D6C6F636B27293B0A09096361707349636F6E2E616464436C61737328';
wwv_flow_api.g_varchar2_table(76) := '5B636F6E6669672E636170734C6F636B49636F6E2C20464F535F41505F48494444454E5F434C4153535D293B0A09092F2F20746F2061766F6964206F7665726C617070696E67207765206861766520746F206D6F64696679207468652069636F6E277320';
wwv_flow_api.g_varchar2_table(77) := '706F736974696F6E0A09096C65742069636F6E506F73203D20636F6E6669672E7077645065656B203D3D3D202764697361626C656427203F20272D2E3272656D27203A20272D332E3372656D273B0A09096361707349636F6E2E637373287B20276C6566';
wwv_flow_api.g_varchar2_table(78) := '74273A2069636F6E506F73207D293B0A09092F2F2068696465207468652069636F6E20696620746865206669656C64206973206E6F74206163746976650A0909696E7075744669656C642E6F6E2827666F6375736F7574272C2066756E6374696F6E2028';
wwv_flow_api.g_varchar2_table(79) := '6529207B0A09090969662028636F6E6669672E696E6C696E6549636F6E29207B0A09090909696E6C696E6549636F6E456C2E72656D6F7665436C61737328464F535F41505F48494444454E5F434C415353293B0A0909097D0A0909096361707349636F6E';
wwv_flow_api.g_varchar2_table(80) := '2E616464436C61737328464F535F41505F48494444454E5F434C415353293B0A09097D293B0A09092F2F2061646420746865206C697374656E6572206F6E20746865206669656C640A0909696E7075744669656C642E6F6E28276B65797570272C206675';
wwv_flow_api.g_varchar2_table(81) := '6E6374696F6E20286529207B0A09090969662028652E6F726967696E616C4576656E742E6765744D6F64696669657253746174652827436170734C6F636B272929207B0A0909090969662028636F6E6669672E696E6C696E6549636F6E29207B0A090909';
wwv_flow_api.g_varchar2_table(82) := '0909696E6C696E6549636F6E456C2E616464436C61737328464F535F41505F48494444454E5F434C415353293B0A090909097D0A090909096361707349636F6E2E72656D6F7665436C61737328464F535F41505F48494444454E5F434C415353293B0A09';
wwv_flow_api.g_varchar2_table(83) := '09097D20656C7365207B0A0909090969662028636F6E6669672E696E6C696E6549636F6E29207B0A0909090909696E6C696E6549636F6E456C2E72656D6F7665436C61737328464F535F41505F48494444454E5F434C415353293B0A090909097D0A0909';
wwv_flow_api.g_varchar2_table(84) := '09096361707349636F6E2E616464436C61737328464F535F41505F48494444454E5F434C415353293B0A0909097D0A09097D293B0A097D0A0A092F2F20537570706F7274207375626D697474696E67207468652070616765206F6E20656E7465720A0969';
wwv_flow_api.g_varchar2_table(85) := '662028636F6E6669672E7375626D69744F6E456E74657229207B0A0909696E7075744669656C642E6F6E28276B65797570272C2066756E6374696F6E20286529207B0A090909617065782E7375626D6974287B0A09090909726571756573743A20697465';
wwv_flow_api.g_varchar2_table(86) := '6D4E616D652C0A090909097375626D69744966456E7465723A20652C0A0909090969676E6F72654368616E67653A20747275652C0A0909090973686F77576169743A20747275650A0909097D293B0A09097D293B0A097D0A0A0969662028636F6E666967';
wwv_flow_api.g_varchar2_table(87) := '2E72756C6573436F6E7461696E657220213D202768696464656E2729207B0A09096974656D526567696F6E2E66696E6428272E666F732D70776427292E656163682866756E6374696F6E202829207B0A0909096C657420656C203D20242874686973293B';
wwv_flow_api.g_varchar2_table(88) := '0A090909656C2E616464436C61737328636F6E6669672E72756C65734661696C49636F6E293B0A090909656C2E637373287B2027636F6C6F72273A20636F6E6669672E6572726F72436F6C6F72207D293B0A09097D293B0A097D0A0A0969662028636F6E';
wwv_flow_api.g_varchar2_table(89) := '6669672E72756C6573436F6E7461696E6572203D3D202765787465726E616C2720262620636F6E6669672E72756C6573436F6E7461696E6572496429207B0A09096C657420726567696F6E456C203D206974656D526567696F6E2E66696E6428272E666F';
wwv_flow_api.g_varchar2_table(90) := '732D61702D636F6E7461696E65722D65787465726E616C27292E64657461636828293B0A09096C657420746172676574456C203D202428272327202B20636F6E6669672E72756C6573436F6E7461696E65724964293B0A09096C657420657874436F6E74';
wwv_flow_api.g_varchar2_table(91) := '61696E6572426F6479203D20746172676574456C2E66696E6428272E742D526567696F6E2D626F647927293B0A090969662028657874436F6E7461696E6572426F64792E6C656E677468203D3D3D203129207B0A090909657874436F6E7461696E657242';
wwv_flow_api.g_varchar2_table(92) := '6F64792E617070656E6428726567696F6E456C293B0A09097D20656C7365207B0A090909746172676574456C2E617070656E6428726567696F6E456C293B0A09097D0A097D20656C7365207B0A090969662028636F6E6669672E72756C6573436F6E7461';
wwv_flow_api.g_varchar2_table(93) := '696E657220213D202768696464656E2729207B0A0909097469746C65456C203D206974656D526567696F6E2E66696E6428272E666F732D61702D636F6E73747261696E74732D7469746C6527293B0A09090972756C6573436F6E7461696E6572456C203D';
wwv_flow_api.g_varchar2_table(94) := '206974656D526567696F6E2E66696E6428272E666F732D61702D636F6E7461696E657227293B0A090909736574456C656D656E745769647468287469746C65456C293B0A090909736574456C656D656E7457696474682872756C6573436F6E7461696E65';
wwv_flow_api.g_varchar2_table(95) := '72456C293B0A09097D0A090969662028636F6E6669672E72756C6573436F6E7461696E6572203D3D2027636F6C6C61707369626C65272026262076616C6964617465526571756972656429207B0A0909092F2F2073656C65637420746865206669727374';
wwv_flow_api.g_varchar2_table(96) := '206661696C65642072756C650A0909096C65742066616C736552756C65203D206974656D526567696F6E2E66696E6428272E666F732D61702D72756C6527292E666972737428293B0A0909092F2F207075742074686520636F6E74656E74206F66206974';
wwv_flow_api.g_varchar2_table(97) := '20696E746F20746865207469746C6520656C656D656E740A0909097469746C65456C2E68746D6C2866616C736552756C652E68746D6C2829293B0A0909097469746C65456C2E6174747228276E616D65272C20277469746C6527202B2066616C73655275';
wwv_flow_api.g_varchar2_table(98) := '6C652E6174747228276E616D652729293B0A0909092F2F20616E6420686964652069742066726F6D2074686520636F6E7461696E65720A09090966616C736552756C652E637373287B2027646973706C6179273A20276E6F6E6527207D293B0A0909092F';
wwv_flow_api.g_varchar2_table(99) := '2F206164642074686520636F6C6C617073652F657870616E642066756E6374696F6E616C6974790A0909097469746C65456C2E6F6E2827636C69636B272C2066756E6374696F6E20286529207B0A09090909242874686973292E746F67676C65436C6173';
wwv_flow_api.g_varchar2_table(100) := '73282761637469766527293B0A090909096C65742072756C6573436F6E203D2072756C6573436F6E7461696E6572456C3B0A090909096966202872756C6573436F6E2E6865696768742829203E203029207B0A090909090972756C6573436F6E2E637373';
wwv_flow_api.g_varchar2_table(101) := '287B20276D61782D686569676874273A2030207D293B0A090909097D20656C7365207B0A090909090972756C6573436F6E2E637373287B20276D61782D686569676874273A2072756C6573436F6E2E70726F7028277363726F6C6C486569676874272920';
wwv_flow_api.g_varchar2_table(102) := '2B2027707827207D293B0A090909097D0A0909097D293B0A09097D0A097D0A092F2F2064697361626C65206974656D7320696620696E76616C69640A0969662028636F6E6669672E64697361626C654974656D7329207B0A09092F2F2072656D6F766520';
wwv_flow_api.g_varchar2_table(103) := '74686520636F6E6669726D6174696F6E20656C656D656E742066726F6D20746865206974656D73546F44697361626C652061727261792C20697427732068616E646C656420696E206120646966666572656E74207761790A090969662028636F6E666967';
wwv_flow_api.g_varchar2_table(104) := '2E636F6E664974656D29207B0A0909096C657420636F6E664974656D496478203D20636F6E6669672E6974656D73546F44697361626C652E696E6465784F6628636F6E6669672E636F6E664974656D293B0A09090969662028636F6E664974656D496478';
wwv_flow_api.g_varchar2_table(105) := '203E202D3129207B0A09090909636F6E6669672E6974656D73546F44697361626C652E73706C69636528636F6E664974656D4964782C2031293B0A0909097D0A09097D0A09097365744974656D735374617465282764697361626C6527293B0A097D0A0A';
wwv_flow_api.g_varchar2_table(106) := '092F2F2073686F77206572726F7220696620696E76616C69640A0969662028636F6E6669672E73686F774572726F724966496E632026262076616C6964617465526571756972656429207B0A0909696E7075744669656C642E6F6E28276368616E676527';
wwv_flow_api.g_varchar2_table(107) := '2C2066756E6374696F6E20286529207B0A0909096973457665727952756C655061737365642866756E6374696F6E202829207B0A09090909617065782E6D6573736167652E73686F774572726F7273287B0A0909090909747970653A20276572726F7227';
wwv_flow_api.g_varchar2_table(108) := '2C0A09090909096C6F636174696F6E3A2027696E6C696E65272C0A0909090909706167654974656D3A206974656D4E616D652C0A09090909096D6573736167653A20636F6E6669672E6572726F724D6573736167650A090909097D293B0A090909096170';
wwv_flow_api.g_varchar2_table(109) := '65782E6576656E742E7472696767657228272327202B206974656D4E616D652C20494E56414C49445F4649454C445F4556454E542C20746573745374617465293B0A0909097D293B0A09097D293B0A0909696E7075744669656C642E6F6E2827666F6375';
wwv_flow_api.g_varchar2_table(110) := '73696E272C2066756E6374696F6E20286529207B0A090909617065782E6D6573736167652E636C6561724572726F7273286974656D4E616D65293B0A09097D293B0A097D0A0A0969662028636F6E6669672E73686F77537472656E67746842617229207B';
wwv_flow_api.g_varchar2_table(111) := '0A09092F2F737472656E6774684261725769647468506374203D20636F6E6669672E737472656E6774684261725769647468506374202F203130303B0A0909737472656E677468426172456C203D206974656D526567696F6E2E66696E6428272E666F73';
wwv_flow_api.g_varchar2_table(112) := '2D737472656E6774682D636F6E7461696E657227293B0A09092F2F207365742074686520636F6C6F720A09096C657420626172436F6E7461696E6572203D206974656D526567696F6E2E66696E6428272E666F732D737472656E6774682D6261722D636F';
wwv_flow_api.g_varchar2_table(113) := '6E7461696E657227293B0A0909626172436F6E7461696E65722E66696E6428272E666F732D737472656E6774682D626727292E637373287B20276261636B67726F756E642D636F6C6F72273A20636F6E6669672E737472656E6774684261724267436F6C';
wwv_flow_api.g_varchar2_table(114) := '6F72207D293B0A0909626172436F6E7461696E65722E66696E6428272E666F732D737472656E6774682D636F6E7461696E657227292E637373287B20276261636B67726F756E642D636F6C6F72273A20636F6E6669672E73756363657373436F6C6F7220';
wwv_flow_api.g_varchar2_table(115) := '7D293B0A0A09092F2F206861766520746F20726563616C63756C61746520746865207769647468206F662074686520626172206F6E2077696E646F7720726573697A650A090977696E646F772E6164644576656E744C697374656E65722827726573697A';
wwv_flow_api.g_varchar2_table(116) := '65272C2066756E6374696F6E20286529207B0A090909736574456C656D656E74576964746828626172436F6E7461696E65722C20737472656E6774684261725769647468506374293B0A09097D293B0A09092F2F20616E64206F6E206F70656E20616E64';
wwv_flow_api.g_varchar2_table(117) := '20636C6F7365206F66207468652073696465206E61766261720A0909617065782E6A5175657279282223745F547265654E617622292E6F6E28277468656D6534326C61796F75746368616E676564272C2066756E6374696F6E20286576656E742C206F62';
wwv_flow_api.g_varchar2_table(118) := '6A29207B0A09090973657454696D656F75742866756E6374696F6E202829207B0A09090909736574456C656D656E74576964746828626172436F6E7461696E65722C20737472656E6774684261725769647468506374293B0A0909097D2C20333030293B';
wwv_flow_api.g_varchar2_table(119) := '0A09097D293B0A0A0909736574456C656D656E74576964746828626172436F6E7461696E65722C20737472656E6774684261725769647468506374293B0A0A090969662028636F6E6669672E737472656E6774684261725374796C65203D3D202764796E';
wwv_flow_api.g_varchar2_table(120) := '616D69632729207B0A090909696E7075744669656C642E6F6E2827666F637573696E272C2066756E6374696F6E20286529207B0A09090909626172436F6E7461696E65722E616464436C6173732827666F732D6261722D61637469766527293B0A090909';
wwv_flow_api.g_varchar2_table(121) := '7D293B0A090909696E7075744669656C642E6F6E2827666F6375736F7574272C2066756E6374696F6E20286529207B0A09090909626172436F6E7461696E65722E72656D6F7665436C6173732827666F732D6261722D61637469766527293B0A0909097D';
wwv_flow_api.g_varchar2_table(122) := '293B0A09097D20656C73652069662028636F6E6669672E737472656E6774684261725374796C65203D3D20277374617469632729207B0A090909626172436F6E7461696E65722E616464436C6173732827666F732D6261722D61637469766527293B0A09';
wwv_flow_api.g_varchar2_table(123) := '097D0A0A0909666F7220286C65742069203D20313B2069203C20746573744E756D3B20692B2B29207B0A090909626172436F6E7461696E65722E617070656E6428273C646976207374796C653D226C6566743A27202B20736570506F73202A2069202B20';
wwv_flow_api.g_varchar2_table(124) := '27252220636C6173733D22666F732D737472656E6774682D73706C6974223E3C2F6469763E27293B0A09097D0A097D0A0A092F2F20636F6E6669726D6174696F6E206974656D0A0969662028636F6E6669672E636F6E664974656D29207B0A09092F2F20';
wwv_flow_api.g_varchar2_table(125) := '7365742074686520636F6E6669726D6174696F6E206974656D20746F2064697361626C65640A0909617065782E6974656D28636F6E6669672E636F6E664974656D292E64697361626C6528293B0A09092F2F2067657420746865206974656D0A09096C65';
wwv_flow_api.g_varchar2_table(126) := '7420636F6E664974656D203D202428272327202B20636F6E6669672E636F6E664974656D293B0A09092F2F206F6E206576657279206368616765206F6E2074686520706C7567696E206669656C642074686520636F6E6669726D6174696F6E206974656D';
wwv_flow_api.g_varchar2_table(127) := '2077696C6C2062652073657420746F206E756C6C0A0909696E7075744669656C642E6F6E2827696E707574272C2066756E6374696F6E20286529207B0A090909617065782E6974656D28636F6E6669672E636F6E664974656D292E73657456616C756528';
wwv_flow_api.g_varchar2_table(128) := '2727293B0A090909746F67676C65496E6C696E6549636F6E28636F6E6649636F6E456C2C2066616C7365293B0A0909097365744974656D735374617465282764697361626C6527293B0A090909696620282176616C696461746552657175697265642920';
wwv_flow_api.g_varchar2_table(129) := '7B0A0909090969662028652E63757272656E745461726765742E76616C75652E6C656E677468203E203029207B0A0909090909617065782E6974656D28636F6E6669672E636F6E664974656D292E656E61626C6528293B0A090909097D20656C7365207B';
wwv_flow_api.g_varchar2_table(130) := '0A0909090909617065782E6974656D28636F6E6669672E636F6E664974656D292E64697361626C6528293B0A090909097D0A0909097D0A09097D293B0A0A0909636F6E664974656D2E6F6E2827666F637573696E272C2066756E6374696F6E2028652920';
wwv_flow_api.g_varchar2_table(131) := '7B0A090909636F6E6649636F6E456C2E72656D6F7665436C61737328464F535F41505F48494444454E5F434C415353293B0A090909617065782E6D6573736167652E636C6561724572726F727328636F6E6669672E636F6E664974656D293B0A09097D29';
wwv_flow_api.g_varchar2_table(132) := '3B0A0A09096C657420636F6E6649636F6E456C203D202428272327202B20636F6E6669672E636F6E664974656D202B20275F726567696F6E207370616E2E666F732D61702D696E6C696E652D636865636B27293B0A0909636F6E664974656D2E6F6E2827';
wwv_flow_api.g_varchar2_table(133) := '696E707574272C2066756E6374696F6E20286529207B0A0909096C6574206974656D56616C7565203D20696E7075744669656C642E76616C28293B0A09090969662028652E7461726765742E76616C756520213D206974656D56616C756529207B0A0909';
wwv_flow_api.g_varchar2_table(134) := '0909746F67676C65496E6C696E6549636F6E28636F6E6649636F6E456C2C2066616C7365293B0A090909097365744974656D735374617465282764697361626C6527293B0A0909097D20656C7365207B0A09090909746F67676C65496E6C696E6549636F';
wwv_flow_api.g_varchar2_table(135) := '6E28636F6E6649636F6E456C2C2074727565293B0A090909097365744974656D7353746174652827656E61626C6527293B0A0909097D0A09097D293B0A0A0909636F6E664974656D2E6F6E28276368616E6765272C2066756E6374696F6E20286529207B';
wwv_flow_api.g_varchar2_table(136) := '0A0909096C6574206974656D56616C7565203D20696E7075744669656C642E76616C28293B0A09090969662028652E7461726765742E76616C756520213D206974656D56616C756529207B0A0909090969662028636F6E6669672E73686F774572726F72';
wwv_flow_api.g_varchar2_table(137) := '4966496E6329207B0A0909090909617065782E6D6573736167652E73686F774572726F7273287B0A090909090909747970653A20226572726F72222C0A0909090909096C6F636174696F6E3A2022696E6C696E65222C0A09090909090970616765497465';
wwv_flow_api.g_varchar2_table(138) := '6D3A20636F6E6669672E636F6E664974656D2C0A0909090909096D6573736167653A20636F6E6669672E636F6E664974656D4572726F724D6573736167650A09090909097D293B0A090909097D0A090909097365744974656D7353746174652827646973';
wwv_flow_api.g_varchar2_table(139) := '61626C6527293B0A0909097D20656C7365207B0A090909097365744974656D7353746174652827656E61626C6527293B0A0909097D0A09097D293B0A097D0A0A0966756E6374696F6E2076616C696461746528696E70757429207B0A09096C6574206E65';
wwv_flow_api.g_varchar2_table(140) := '7756616C7565203D20696E7075742E7461726765742E76616C75653B0A09096C657420746573745265733B0A0A09092F2F206C656E6774680A09096966202872756C65732E7077644C656E67746829207B0A09090974657374526573203D206E65775661';
wwv_flow_api.g_varchar2_table(141) := '6C75652E6C656E677468203C2072756C65732E7077644C656E6774682E617474726962757465732E6C656E6774683B0A0909096966202874657374526573202626207465737453746174652E7077644C656E67746829207B0A0909090974657374537461';
wwv_flow_api.g_varchar2_table(142) := '74652E7077644C656E677468203D2066616C73653B0A09090909736574546F4661696C6564286C656E456C293B0A0909097D20656C73652069662028217465737452657320262620217465737453746174652E7077644C656E67746829207B0A09090909';
wwv_flow_api.g_varchar2_table(143) := '7465737453746174652E7077644C656E677468203D20747275653B0A09090909736574546F436F6D706C65746564286C656E456C293B0A0909097D0A09097D0A0A09092F2F206E756D626572730A09096966202872756C65732E7077644E756D7329207B';
wwv_flow_api.g_varchar2_table(144) := '0A09090974657374526573203D20636F6E7461696E734E756D62657273286E657756616C7565293B0A090909696620287465737452657320262620217465737453746174652E7077644E756D7329207B0A090909097465737453746174652E7077644E75';
wwv_flow_api.g_varchar2_table(145) := '6D73203D20747275653B0A09090909736574546F436F6D706C65746564286E756D456C293B0A0909097D20656C736520696620282174657374526573202626207465737453746174652E7077644E756D7329207B0A090909097465737453746174652E70';
wwv_flow_api.g_varchar2_table(146) := '77644E756D73203D2066616C73653B0A09090909736574546F4661696C6564286E756D456C293B0A0909097D0A09097D0A0A09092F2F206361706974616C206C6574746572730A09096966202872756C65732E7077644361706974616C7329207B0A0909';
wwv_flow_api.g_varchar2_table(147) := '0974657374526573203D20636F6E7461696E734361706974616C4C657474657273286E657756616C7565293B0A090909696620287465737452657320262620217465737453746174652E7077644361706974616C7329207B0A0909090974657374537461';
wwv_flow_api.g_varchar2_table(148) := '74652E7077644361706974616C73203D20747275653B0A09090909736574546F436F6D706C6574656428636170456C293B0A0909097D20656C736520696620282174657374526573202626207465737453746174652E7077644361706974616C7329207B';
wwv_flow_api.g_varchar2_table(149) := '0A090909097465737453746174652E7077644361706974616C73203D2066616C73653B0A09090909736574546F4661696C656428636170456C293B0A0909097D0A09097D0A0A09092F2F207370656369616C20636861726163746572730A090969662028';
wwv_flow_api.g_varchar2_table(150) := '72756C65732E70776453706563436861727329207B0A09090974657374526573203D20636F6E7461696E735370656369616C43686172616374657273286E657756616C7565293B0A09090969662028746573745265732026262021746573745374617465';
wwv_flow_api.g_varchar2_table(151) := '2E70776453706563436861727329207B0A090909097465737453746174652E707764537065634368617273203D20747275653B0A09090909736574546F436F6D706C657465642873706563456C293B0A0909097D20656C73652069662028217465737452';
wwv_flow_api.g_varchar2_table(152) := '6573202626207465737453746174652E70776453706563436861727329207B0A090909097465737453746174652E707764537065634368617273203D2066616C73653B0A09090909736574546F4661696C65642873706563456C293B0A0909097D0A0909';

wwv_flow_api.g_varchar2_table(153) := '7D0A0A09092F2F206869646520616E642073686F772066756E6374696F6E616C697479206F662074686520636F6C6C61707369626C652072756C6520726567696F6E0A090969662028636F6E6669672E72756C6573436F6E7461696E6572203D3D202763';
wwv_flow_api.g_varchar2_table(154) := '6F6C6C61707369626C652729207B0A0909096C6574207469746C65456C5370616E203D206974656D526567696F6E2E66696E6428272E666F732D61702D636F6E73747261696E74732D7469746C65202E666F732D70776427293B0A0909096C657420646F';
wwv_flow_api.g_varchar2_table(155) := '6E65203D20747275653B0A0909096973457665727952756C655061737365642866756E6374696F6E202829207B0A09090909646F6E65203D2066616C73653B0A0909097D293B0A0909096C6574207469746C654E616D65203D207469746C65456C2E6174';
wwv_flow_api.g_varchar2_table(156) := '747228276E616D6527293B0A09090969662028646F6E65202626207469746C654E616D6520213D2027646F6E652729207B0A09090909617065782E6D6573736167652E636C6561724572726F7273286974656D4E616D65293B0A090909096368616E6765';
wwv_flow_api.g_varchar2_table(157) := '5469746C6552756C6528636F6E6669672E72756C6573436F6D70546578742C2027646F6E6527293B0A09090909736574546F436F6D706C65746564287469746C65456C5370616E2C2066616C7365293B0A090909096C65742072756C6573436F6E456C20';
wwv_flow_api.g_varchar2_table(158) := '3D2072756C6573436F6E7461696E6572456C3B0A09090909646F63756D656E742E717565727953656C6563746F72416C6C28272327202B206974656D4E616D65202B20275F726567696F6E202E666F732D61702D72756C6527292E666F72456163682866';
wwv_flow_api.g_varchar2_table(159) := '756E6374696F6E202872756C6529207B0A090909090972756C652E7374796C652E646973706C6179203D2027626C6F636B273B0A090909097D293B0A090909096966202872756C6573436F6E456C2E6865696768742829203E203029207B0A0909090909';
wwv_flow_api.g_varchar2_table(160) := '72756C6573436F6E456C2E637373287B20276D61782D686569676874273A2072756C6573436F6E456C2E70726F7028277363726F6C6C4865696768742729202B2027707827207D293B0A090909097D0A0909097D20656C7365207B0A0909090969662028';
wwv_flow_api.g_varchar2_table(161) := '7465737453746174655B7469746C654E616D652E7375627374722838295D207C7C207469746C654E616D65203D3D2027646F6E652729207B0A09090909096C6574207469746C65526566726573686564203D2066616C73653B0A0909090909666F722028';
wwv_flow_api.g_varchar2_table(162) := '6C65742070726F7020696E2074657374537461746529207B0A0909090909096C65742072756C65456C203D20646F63756D656E742E717565727953656C6563746F7228272327202B206974656D4E616D65202B20275F726567696F6E202E666F732D6170';
wwv_flow_api.g_varchar2_table(163) := '2D72756C655B6E616D653D22464F5327202B2070726F70202B2027225D27293B0A09090909090969662028217465737453746174655B70726F705D29207B0A0909090909090969662028217469746C6552656672657368656429207B0A09090909090909';
wwv_flow_api.g_varchar2_table(164) := '0972756C65456C2E7374796C652E646973706C6179203D20276E6F6E65273B0A0909090909090909696620287469746C654E616D6520213D2027646F6E652729207B0A090909090909090909736574546F436F6D706C65746564287469746C65456C5370';
wwv_flow_api.g_varchar2_table(165) := '616E2C2066616C7365293B0A09090909090909097D0A09090909090909096368616E67655469746C6552756C652872756C65456C2E696E6E657248544D4C2C20277469746C65464F5327202B2070726F70293B0A09090909090909097469746C65526566';
wwv_flow_api.g_varchar2_table(166) := '726573686564203D20747275653B0A090909090909097D20656C7365207B0A090909090909090972756C65456C2E7374796C652E646973706C6179203D2027626C6F636B273B0A090909090909097D0A0909090909097D20656C7365207B0A0909090909';
wwv_flow_api.g_varchar2_table(167) := '090972756C65456C2E7374796C652E646973706C6179203D2027626C6F636B273B0A0909090909097D0A09090909097D0A090909097D0A0909097D0A09097D0A097D0A0A092F2F205574696C6974792066756E6374696F6E730A0966756E6374696F6E20';
wwv_flow_api.g_varchar2_table(168) := '736574456C656D656E74576964746828656C2C20706374203D203129207B0A0909656C2E63737328277769647468272C20696E7075744669656C642E6F7574657257696474682829202A20706374202B2027707827293B0A097D0A0966756E6374696F6E';
wwv_flow_api.g_varchar2_table(169) := '20636F6E7461696E734E756D62657273287329207B0A09096C65742072657175697265644E756D203D2072756C65732E7077644E756D732E617474726962757465732E6C656E6774683B0A09097265676578203D206E6577205265674578702827285B30';
wwv_flow_api.g_varchar2_table(170) := '2D395D2E2A297B27202B2072657175697265644E756D202B20272C7D272C20276727293B0A090972657475726E2072656765782E746573742873293B0A097D0A0966756E6374696F6E20636F6E7461696E734361706974616C4C65747465727328732920';
wwv_flow_api.g_varchar2_table(171) := '7B0A09096C657420726571756972656443617073203D2072756C65732E7077644361706974616C732E617474726962757465732E6C656E6774683B0A09097265676578203D206E6577205265674578702827285B412D5A5D2E2A297B27202B2072657175';
wwv_flow_api.g_varchar2_table(172) := '6972656443617073202B20272C7D272C20276727293B0A090972657475726E2072656765782E746573742873293B0A097D0A0966756E6374696F6E20636F6E7461696E735370656369616C43686172616374657273287329207B0A09096C657420726571';
wwv_flow_api.g_varchar2_table(173) := '756972656453706563203D2072756C65732E7077645370656343686172732E617474726962757465732E6C6973744F6653706563436861723B0A09096C6574207265717569726564534E756D203D2072756C65732E7077645370656343686172732E6174';
wwv_flow_api.g_varchar2_table(174) := '74726962757465732E6C656E6774683B0A09097265676578203D206E6577205265674578702827285B27202B20726571756972656453706563202B20275D2E2A297B27202B207265717569726564534E756D202B20272C7D272C20276727293B0A090972';
wwv_flow_api.g_varchar2_table(175) := '657475726E2072656765782E746573742873293B0A097D0A0966756E6374696F6E20746F67676C655077642829207B0A0909696E7075744669656C642E617474722827747970652729203D3D202770617373776F726427203F2073686F775077642E6361';
wwv_flow_api.g_varchar2_table(176) := '6C6C287468697329203A20686964655077642E63616C6C2874686973293B0A097D0A0966756E6374696F6E2073686F775077642829207B0A0909242874686973292E72656D6F7665436C61737328636F6E6669672E7065656B48696464656E49636F6E29';
wwv_flow_api.g_varchar2_table(177) := '2E616464436C61737328636F6E6669672E7065656B53686F776E49636F6E293B0A0909696E7075744669656C642E61747472282274797065222C20227465787422293B0A097D0A0966756E6374696F6E20686964655077642829207B0A09092428746869';
wwv_flow_api.g_varchar2_table(178) := '73292E72656D6F7665436C61737328636F6E6669672E7065656B53686F776E49636F6E292E616464436C61737328636F6E6669672E7065656B48696464656E49636F6E293B0A0909696E7075744669656C642E61747472282274797065222C2022706173';
wwv_flow_api.g_varchar2_table(179) := '73776F726422293B0A097D0A0966756E6374696F6E20746F67676C65496E6C696E6549636F6E28656C2C207479706529207B0A0909696620287479706529207B0A090909656C2E637373287B2027636F6C6F72273A20636F6E6669672E73756363657373';
wwv_flow_api.g_varchar2_table(180) := '436F6C6F72207D293B0A090909656C2E72656D6F7665436C61737328636F6E6669672E696E6C696E654661696C49636F6E292E616464436C61737328636F6E6669672E696E6C696E65436865636B49636F6E293B0A09097D20656C7365207B0A09090965';
wwv_flow_api.g_varchar2_table(181) := '6C2E637373287B2027636F6C6F72273A20636F6E6669672E6572726F72436F6C6F72207D293B0A090909656C2E72656D6F7665436C61737328636F6E6669672E696E6C696E65436865636B49636F6E292E616464436C61737328636F6E6669672E696E6C';
wwv_flow_api.g_varchar2_table(182) := '696E654661696C49636F6E293B0A09097D0A097D0A0966756E6374696F6E207365744974656D735374617465287479706529207B0A09096966202821636F6E6669672E64697361626C654974656D7329207B0A09090972657475726E3B0A09097D0A0909';
wwv_flow_api.g_varchar2_table(183) := '636F6E6669672E6974656D73546F44697361626C652E666F72456163682866756E6374696F6E20286974656D29207B0A090909617065782E6D6573736167652E636C6561724572726F7273286974656D293B0A0909096966202874797065203D3D202765';
wwv_flow_api.g_varchar2_table(184) := '6E61626C652729207B0A090909092428272327202B206974656D292E72656D6F7665436C6173732827617065785F64697361626C656427293B0A09090909617065782E6974656D286974656D292E656E61626C6528293B0A0909097D20656C7365207B0A';
wwv_flow_api.g_varchar2_table(185) := '090909092428272327202B206974656D292E616464436C6173732827617065785F64697361626C656427293B0A09090909617065782E6974656D286974656D292E64697361626C6528293B0A0909097D0A09097D293B0A097D0A0966756E6374696F6E20';
wwv_flow_api.g_varchar2_table(186) := '6368616E67655469746C6552756C6528636F6E74656E742C206E616D6529207B0A09097469746C65456C2E637373287B2027636F6C6F72273A20636F6E6669672E73756363657373436F6C6F72207D293B0A09097469746C65456C2E72656D6F7665436C';
wwv_flow_api.g_varchar2_table(187) := '6173732827666F732D76616C75652D656E74657227293B0A09097469746C65456C2E616464436C6173732827666F732D76616C75652D6C6561766527293B0A090973657454696D656F75742866756E6374696F6E202829207B0A0909097469746C65456C';
wwv_flow_api.g_varchar2_table(188) := '2E72656D6F7665436C6173732827666F732D76616C75652D6C6561766527293B0A0909097469746C65456C2E616464436C6173732827666F732D76616C75652D656E74657227293B0A090909696620286E616D6520213D2027646F6E652729207B0A0909';
wwv_flow_api.g_varchar2_table(189) := '09097469746C65456C2E637373287B2027636F6C6F72273A20636F6E6669672E6572726F72436F6C6F72207D293B0A0909097D0A0909097469746C65456C2E68746D6C28636F6E74656E74207C7C202727293B0A0909097469746C65456C2E6174747228';
wwv_flow_api.g_varchar2_table(190) := '276E616D65272C206E616D65293B0A09097D2C20333030293B0A097D0A0966756E6374696F6E206973457665727952756C6550617373656428636229207B0A0909666F7220286C6574206920696E2074657374537461746529207B0A0909096966202821';
wwv_flow_api.g_varchar2_table(191) := '7465737453746174655B695D29207B0A09090909636228293B0A09090909627265616B3B0A0909097D0A09097D0A097D0A0966756E6374696F6E20736574546F436F6D706C6574656428656C2C20747269676765724576656E74203D207472756529207B';
wwv_flow_api.g_varchar2_table(192) := '0A09096C6574207061737365645465737473203D20303B0A0909666F7220286C6574206B657920696E2074657374537461746529207B0A090909696620287465737453746174655B6B65795D29207B0A0909090970617373656454657374732B2B3B0A09';
wwv_flow_api.g_varchar2_table(193) := '09097D0A09097D0A090969662028636F6E6669672E73686F77537472656E67746842617229207B0A0909096C6574206261725769646874203D207061737365645465737473202A20736570506F733B0A0909096261725769646874203D20626172576964';
wwv_flow_api.g_varchar2_table(194) := '6874203D3D203939203F20313030203A2062617257696468743B0A090909737472656E677468426172456C2E63737328277769647468272C206261725769646874202B20272527293B0A09097D0A0909656C2E706172656E7428292E637373287B202763';
wwv_flow_api.g_varchar2_table(195) := '6F6C6F72273A20636F6E6669672E73756363657373436F6C6F72207D293B0A0909656C2E616464436C61737328636F6E6669672E72756C6573436865636B49636F6E292E72656D6F7665436C61737328636F6E6669672E72756C65734661696C49636F6E';
wwv_flow_api.g_varchar2_table(196) := '293B0A0909656C2E637373287B2027636F6C6F72273A20636F6E6669672E73756363657373436F6C6F72207D293B0A0909696620287061737365645465737473203D3D20746573744E756D29207B0A09090969662028747269676765724576656E742920';
wwv_flow_api.g_varchar2_table(197) := '7B0A09090909617065782E6576656E742E7472696767657228272327202B206974656D4E616D652C2052554C455F414C4C5F434F4D504C4554455F4556454E542C20746573745374617465293B0A0909097D0A09090969662028636F6E6669672E636F6E';
wwv_flow_api.g_varchar2_table(198) := '664974656D29207B0A09090909617065782E6974656D28636F6E6669672E636F6E664974656D292E656E61626C6528293B0A0909097D0A09090969662028636F6E6669672E64697361626C654974656D732026262021636F6E6669672E636F6E66497465';
wwv_flow_api.g_varchar2_table(199) := '6D29207B0A090909097365744974656D7353746174652827656E61626C6527293B0A0909097D0A09090969662028636F6E6669672E696E6C696E6549636F6E29207B0A09090909746F67676C65496E6C696E6549636F6E28696E6C696E6549636F6E456C';
wwv_flow_api.g_varchar2_table(200) := '2C2074727565293B0A0909097D0A09097D20656C7365207B0A09090969662028747269676765724576656E7429207B0A09090909617065782E6576656E742E7472696767657228272327202B206974656D4E616D652C2052554C455F434F4D504C455445';
wwv_flow_api.g_varchar2_table(201) := '5F4556454E542C20746573745374617465293B0A0909097D0A09097D0A097D0A0966756E6374696F6E20736574546F4661696C656428656C29207B0A090969662028636F6E6669672E73686F77537472656E67746842617229207B0A0909096C65742066';
wwv_flow_api.g_varchar2_table(202) := '61696C65645465737473203D20303B0A090909666F7220286C6574206B657920696E2074657374537461746529207B0A0909090969662028217465737453746174655B6B65795D29207B0A09090909096661696C656454657374732B2B3B0A090909097D';
wwv_flow_api.g_varchar2_table(203) := '0A0909097D0A0909096C6574206261725769647468203D20313030202D206661696C65645465737473202A20736570506F733B0A0909096261725769647468203D20746573744E756D203D3D2033203F206261725769647468202D2031203A2062617257';
wwv_flow_api.g_varchar2_table(204) := '696474683B0A090909737472656E677468426172456C2E63737328277769647468272C206261725769647468202B20272527293B0A09097D0A0909656C2E706172656E7428292E637373287B2027636F6C6F72273A20636F6E6669672E6572726F72436F';
wwv_flow_api.g_varchar2_table(205) := '6C6F72207D293B0A0909656C2E616464436C61737328636F6E6669672E72756C65734661696C49636F6E292E72656D6F7665436C61737328636F6E6669672E72756C6573436865636B49636F6E293B0A0909656C2E637373287B2027636F6C6F72273A20';
wwv_flow_api.g_varchar2_table(206) := '636F6E6669672E6572726F72436F6C6F72207D293B0A0909617065782E6576656E742E7472696767657228272327202B206974656D4E616D652C2052554C455F4641494C5F4556454E542C20746573745374617465293B0A090969662028636F6E666967';
wwv_flow_api.g_varchar2_table(207) := '2E636F6E664974656D29207B0A090909617065782E6974656D28636F6E6669672E636F6E664974656D292E64697361626C6528293B0A09097D0A090969662028636F6E6669672E64697361626C654974656D732026262021636F6E6669672E636F6E6649';
wwv_flow_api.g_varchar2_table(208) := '74656D29207B0A0909097365744974656D735374617465282764697361626C6527293B0A09097D0A090969662028636F6E6669672E696E6C696E6549636F6E29207B0A090909746F67676C65496E6C696E6549636F6E28696E6C696E6549636F6E456C2C';
wwv_flow_api.g_varchar2_table(209) := '2066616C7365293B0A09097D0A097D0A7D3B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(98616509555504638)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_file_name=>'script.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '76617220464F533D77696E646F772E464F537C7C7B7D3B464F532E6974656D3D464F532E6974656D7C7C7B7D2C464F532E6974656D2E616476616E63656450617373776F72643D464F532E6974656D2E616476616E63656450617373776F72647C7C7B7D';
wwv_flow_api.g_varchar2_table(2) := '2C464F532E6974656D2E616476616E63656450617373776F72642E696E69743D66756E6374696F6E28652C6E297B652E7065656B53686F776E49636F6E3D2266612D657965222C652E7065656B48696464656E49636F6E3D2266612D6579652D736C6173';
wwv_flow_api.g_varchar2_table(3) := '68222C652E636170734C6F636B49636F6E3D2266612D6368616E67652D63617365222C652E72756C6573436865636B49636F6E3D2266612D636865636B2D636972636C652D6F222C652E72756C65734661696C49636F6E3D2266612D74696D65732D6369';
wwv_flow_api.g_varchar2_table(4) := '72636C652D6F222C652E696E6C696E65436865636B49636F6E3D2266612D636865636B2D636972636C652D6F222C652E696E6C696E654661696C49636F6E3D2266612D74696D65732D636972636C652D6F222C652E6572726F724D6573736167653D2249';
wwv_flow_api.g_varchar2_table(5) := '6E76616C69642070617373776F72642E222C652E636F6E664974656D4572726F724D6573736167653D2250617373776F72647320646F206E6F74206D617463682E222C652E737472656E6774684261725374796C653D2264796E616D6963222C652E7375';
wwv_flow_api.g_varchar2_table(6) := '6363657373436F6C6F723D2223356163323430222C652E6572726F72436F6C6F723D2223656234303334222C652E737472656E6774684261724267436F6C6F723D2223373738383939222C652E737472656E67746842617257696474685063743D313030';
wwv_flow_api.g_varchar2_table(7) := '2C6E26266E20696E7374616E63656F662046756E6374696F6E26266E2E63616C6C28746869732C65292C617065782E64656275672E696E666F2822464F53202D20416476616E6365642050617373776F72643A20222C65293B6C657420732C742C6F2C61';
wwv_flow_api.g_varchar2_table(8) := '3D652E6974656D4E616D652C693D24282223222B612B225F726567696F6E22292C723D24282223222B61292C6C3D652E72756C65732C633D4F626A6563742E6B657973286C292E6C656E6774682C643D4D6174682E666C6F6F72283130302F63292C663D';
wwv_flow_api.g_varchar2_table(9) := '7B7D2C703D652E737472656E67746842617257696474685063742F3130302C753D692E66696E6428222E70617373776F72642D72756C652D6C656E677468202E666F732D70776422292C6D3D692E66696E6428222E70617373776F72642D72756C652D6E';
wwv_flow_api.g_varchar2_table(10) := '756D62657273202E666F732D70776422292C683D692E66696E6428222E70617373776F72642D72756C652D7370656369616C2D63686172616374657273202E666F732D70776422292C673D692E66696E6428222E70617373776F72642D72756C652D6361';
wwv_flow_api.g_varchar2_table(11) := '706974616C2D6C657474657273202E666F732D70776422293B636F6E737420433D22666F732D61702D68696465223B666F72286C6574206520696E206C296C5B655D262628665B655D3D2131293B6C657420772C493D216A51756572792E6973456D7074';
wwv_flow_api.g_varchar2_table(12) := '794F626A656374286629262621652E6973436F6E6669726D6174696F6E4974656D3B696628652E696E6C696E6549636F6E262628773D692E66696E6428227370616E2E666F732D61702D696E6C696E652D636865636B22292C772E616464436C61737328';
wwv_flow_api.g_varchar2_table(13) := '5B652E696E6C696E654661696C49636F6E2C435D292C772E637373287B6C6566743A222D2E3272656D222C636F6C6F723A652E6572726F72436F6C6F727D292C497C7C652E6973436F6E6669726D6174696F6E4974656D7C7C28722E6F6E2822666F6375';
wwv_flow_api.g_varchar2_table(14) := '73222C2866756E6374696F6E2865297B772E72656D6F7665436C6173732843297D29292C722E6F6E2822696E707574222C2866756E6374696F6E2865297B6B28772C652E63757272656E745461726765742E76616C75652E6C656E6774683E30297D2929';
wwv_flow_api.g_varchar2_table(15) := '29292C492626722E6F6E28226B65797570206368616E6765222C2866756E6374696F6E286E297B652E696E6C696E6549636F6E262645282866756E6374696F6E28297B6B28772C2131297D29292C66756E6374696F6E286E297B6C657420732C723D6E2E';
wwv_flow_api.g_varchar2_table(16) := '7461726765742E76616C75653B6C2E7077644C656E677468262628733D722E6C656E6774683C6C2E7077644C656E6774682E617474726962757465732E6C656E6774682C732626662E7077644C656E6774683F28662E7077644C656E6774683D21312C4F';
wwv_flow_api.g_varchar2_table(17) := '287529293A737C7C662E7077644C656E6774687C7C28662E7077644C656E6774683D21302C4628752929293B6C2E7077644E756D73262628733D66756E6374696F6E2865297B6C6574206E3D6C2E7077644E756D732E617474726962757465732E6C656E';
wwv_flow_api.g_varchar2_table(18) := '6774683B72657475726E2072656765783D6E6577205265674578702822285B302D395D2E2A297B222B6E2B222C7D222C226722292C72656765782E746573742865297D2872292C73262621662E7077644E756D733F28662E7077644E756D733D21302C46';
wwv_flow_api.g_varchar2_table(19) := '286D29293A21732626662E7077644E756D73262628662E7077644E756D733D21312C4F286D2929293B6C2E7077644361706974616C73262628733D66756E6374696F6E2865297B6C6574206E3D6C2E7077644361706974616C732E617474726962757465';
wwv_flow_api.g_varchar2_table(20) := '732E6C656E6774683B72657475726E2072656765783D6E6577205265674578702822285B412D5A5D2E2A297B222B6E2B222C7D222C226722292C72656765782E746573742865297D2872292C73262621662E7077644361706974616C733F28662E707764';
wwv_flow_api.g_varchar2_table(21) := '4361706974616C733D21302C46286729293A21732626662E7077644361706974616C73262628662E7077644361706974616C733D21312C4F28672929293B6C2E707764537065634368617273262628733D66756E6374696F6E2865297B6C6574206E3D6C';
wwv_flow_api.g_varchar2_table(22) := '2E7077645370656343686172732E617474726962757465732E6C6973744F6653706563436861722C733D6C2E7077645370656343686172732E617474726962757465732E6C656E6774683B72657475726E2072656765783D6E6577205265674578702822';
wwv_flow_api.g_varchar2_table(23) := '285B222B6E2B225D2E2A297B222B732B222C7D222C226722292C72656765782E746573742865297D2872292C73262621662E7077645370656343686172733F28662E7077645370656343686172733D21302C46286829293A21732626662E707764537065';
wwv_flow_api.g_varchar2_table(24) := '634368617273262628662E7077645370656343686172733D21312C4F28682929293B69662822636F6C6C61707369626C65223D3D652E72756C6573436F6E7461696E6572297B6C6574206E3D692E66696E6428222E666F732D61702D636F6E7374726169';
wwv_flow_api.g_varchar2_table(25) := '6E74732D7469746C65202E666F732D70776422292C733D21303B45282866756E6374696F6E28297B733D21317D29293B6C657420723D742E6174747228226E616D6522293B69662873262622646F6E6522213D72297B617065782E6D6573736167652E63';
wwv_flow_api.g_varchar2_table(26) := '6C6561724572726F72732861292C5328652E72756C6573436F6D70546578742C22646F6E6522292C46286E2C2131293B6C657420733D6F3B646F63756D656E742E717565727953656C6563746F72416C6C282223222B612B225F726567696F6E202E666F';
wwv_flow_api.g_varchar2_table(27) := '732D61702D72756C6522292E666F7245616368282866756E6374696F6E2865297B652E7374796C652E646973706C61793D22626C6F636B227D29292C732E68656967687428293E302626732E637373287B226D61782D686569676874223A732E70726F70';
wwv_flow_api.g_varchar2_table(28) := '28227363726F6C6C48656967687422292B227078227D297D656C736520696628665B722E7375627374722838295D7C7C22646F6E65223D3D72297B6C657420653D21313B666F72286C6574207320696E2066297B6C657420743D646F63756D656E742E71';
wwv_flow_api.g_varchar2_table(29) := '7565727953656C6563746F72282223222B612B275F726567696F6E202E666F732D61702D72756C655B6E616D653D22464F53272B732B27225D27293B665B735D7C7C653F742E7374796C652E646973706C61793D22626C6F636B223A28742E7374796C65';
wwv_flow_api.g_varchar2_table(30) := '2E646973706C61793D226E6F6E65222C22646F6E6522213D72262646286E2C2131292C5328742E696E6E657248544D4C2C227469746C65464F53222B73292C653D2130297D7D7D7D286E297D29292C2264697361626C656422213D652E7077645065656B';
wwv_flow_api.g_varchar2_table(31) := '297B652E7065656B48696464656E49636F6E3D652E7065656B48696464656E49636F6E2E73706C697428222022292C652E7065656B53686F776E49636F6E3D652E7065656B53686F776E49636F6E2E73706C697428222022293B6C6574206E3D692E6669';
wwv_flow_api.g_varchar2_table(32) := '6E6428222E61702D70617373776F72642D65796522293B6E2E616464436C61737328652E7065656B48696464656E49636F6E292C722E637373287B2270616464696E672D7269676874223A22332E3372656D227D292C652E696E6C696E6549636F6E2626';
wwv_flow_api.g_varchar2_table(33) := '772E637373287B6C6566743A222D332E3372656D227D292C22656E61626C65642D636C69636B2D7072657373223D3D3D652E7077645065656B3F286E2E6F6E28226D6F7573657570206D6F7573656C6561766520746F756368656E64222C78292C6E2E6F';
wwv_flow_api.g_varchar2_table(34) := '6E28226D6F757365646F776E222C2866756E6374696F6E2865297B303D3D3D652E627574746F6E2626762E63616C6C286E297D29292C6E2E6F6E2822746F7563687374617274222C2866756E6374696F6E2865297B6C657420733D652E746F7563686573';
wwv_flow_api.g_varchar2_table(35) := '5B305D3B646F63756D656E742E656C656D656E7446726F6D506F696E7428732E636C69656E74582C732E636C69656E7459292626762E63616C6C286E297D2929293A22656E61626C65642D746F67676C65223D3D3D652E7077645065656B26266E2E6F6E';
wwv_flow_api.g_varchar2_table(36) := '2822636C69636B222C2866756E6374696F6E28297B2270617373776F7264223D3D722E6174747228227479706522293F762E63616C6C2874686973293A782E63616C6C2874686973297D29297D696628652E73686F77436170734C6F636B297B6C657420';
wwv_flow_api.g_varchar2_table(37) := '6E3D692E66696E6428222E61702D636170732D6C6F636B22293B6E2E616464436C617373285B652E636170734C6F636B49636F6E2C435D293B6C657420733D2264697361626C6564223D3D3D652E7077645065656B3F222D2E3272656D223A222D332E33';
wwv_flow_api.g_varchar2_table(38) := '72656D223B6E2E637373287B6C6566743A737D292C722E6F6E2822666F6375736F7574222C2866756E6374696F6E2873297B652E696E6C696E6549636F6E2626772E72656D6F7665436C6173732843292C6E2E616464436C6173732843297D29292C722E';
wwv_flow_api.g_varchar2_table(39) := '6F6E28226B65797570222C2866756E6374696F6E2873297B732E6F726967696E616C4576656E742E6765744D6F64696669657253746174652822436170734C6F636B22293F28652E696E6C696E6549636F6E2626772E616464436C6173732843292C6E2E';
wwv_flow_api.g_varchar2_table(40) := '72656D6F7665436C617373284329293A28652E696E6C696E6549636F6E2626772E72656D6F7665436C6173732843292C6E2E616464436C617373284329297D29297D696628652E7375626D69744F6E456E7465722626722E6F6E28226B65797570222C28';
wwv_flow_api.g_varchar2_table(41) := '66756E6374696F6E2865297B617065782E7375626D6974287B726571756573743A612C7375626D69744966456E7465723A652C69676E6F72654368616E67653A21302C73686F77576169743A21307D297D29292C2268696464656E22213D652E72756C65';
wwv_flow_api.g_varchar2_table(42) := '73436F6E7461696E65722626692E66696E6428222E666F732D70776422292E65616368282866756E6374696F6E28297B6C6574206E3D242874686973293B6E2E616464436C61737328652E72756C65734661696C49636F6E292C6E2E637373287B636F6C';
wwv_flow_api.g_varchar2_table(43) := '6F723A652E6572726F72436F6C6F727D297D29292C2265787465726E616C223D3D652E72756C6573436F6E7461696E65722626652E72756C6573436F6E7461696E65724964297B6C6574206E3D692E66696E6428222E666F732D61702D636F6E7461696E';
wwv_flow_api.g_varchar2_table(44) := '65722D65787465726E616C22292E64657461636828292C733D24282223222B652E72756C6573436F6E7461696E65724964292C743D732E66696E6428222E742D526567696F6E2D626F647922293B313D3D3D742E6C656E6774683F742E617070656E6428';
wwv_flow_api.g_varchar2_table(45) := '6E293A732E617070656E64286E297D656C7365206966282268696464656E22213D652E72756C6573436F6E7461696E6572262628743D692E66696E6428222E666F732D61702D636F6E73747261696E74732D7469746C6522292C6F3D692E66696E642822';
wwv_flow_api.g_varchar2_table(46) := '2E666F732D61702D636F6E7461696E657222292C622874292C62286F29292C22636F6C6C61707369626C65223D3D652E72756C6573436F6E7461696E6572262649297B6C657420653D692E66696E6428222E666F732D61702D72756C6522292E66697273';
wwv_flow_api.g_varchar2_table(47) := '7428293B742E68746D6C28652E68746D6C2829292C742E6174747228226E616D65222C227469746C65222B652E6174747228226E616D652229292C652E637373287B646973706C61793A226E6F6E65227D292C742E6F6E2822636C69636B222C2866756E';
wwv_flow_api.g_varchar2_table(48) := '6374696F6E2865297B242874686973292E746F67676C65436C617373282261637469766522293B6C6574206E3D6F3B6E2E68656967687428293E303F6E2E637373287B226D61782D686569676874223A307D293A6E2E637373287B226D61782D68656967';
wwv_flow_api.g_varchar2_table(49) := '6874223A6E2E70726F7028227363726F6C6C48656967687422292B227078227D297D29297D696628652E64697361626C654974656D73297B696628652E636F6E664974656D297B6C6574206E3D652E6974656D73546F44697361626C652E696E6465784F';
wwv_flow_api.g_varchar2_table(50) := '6628652E636F6E664974656D293B6E3E2D312626652E6974656D73546F44697361626C652E73706C696365286E2C31297D79282264697361626C6522297D696628652E73686F774572726F724966496E63262649262628722E6F6E28226368616E676522';
wwv_flow_api.g_varchar2_table(51) := '2C2866756E6374696F6E286E297B45282866756E6374696F6E28297B617065782E6D6573736167652E73686F774572726F7273287B747970653A226572726F72222C6C6F636174696F6E3A22696E6C696E65222C706167654974656D3A612C6D65737361';
wwv_flow_api.g_varchar2_table(52) := '67653A652E6572726F724D6573736167657D292C617065782E6576656E742E74726967676572282223222B612C22666F732D61702D696E76616C69642D6669656C64222C66297D29297D29292C722E6F6E2822666F637573696E222C2866756E6374696F';
wwv_flow_api.g_varchar2_table(53) := '6E2865297B617065782E6D6573736167652E636C6561724572726F72732861297D2929292C652E73686F77537472656E677468426172297B733D692E66696E6428222E666F732D737472656E6774682D636F6E7461696E657222293B6C6574206E3D692E';
wwv_flow_api.g_varchar2_table(54) := '66696E6428222E666F732D737472656E6774682D6261722D636F6E7461696E657222293B6E2E66696E6428222E666F732D737472656E6774682D626722292E637373287B226261636B67726F756E642D636F6C6F72223A652E737472656E677468426172';
wwv_flow_api.g_varchar2_table(55) := '4267436F6C6F727D292C6E2E66696E6428222E666F732D737472656E6774682D636F6E7461696E657222292E637373287B226261636B67726F756E642D636F6C6F72223A652E73756363657373436F6C6F727D292C77696E646F772E6164644576656E74';
wwv_flow_api.g_varchar2_table(56) := '4C697374656E65722822726573697A65222C2866756E6374696F6E2865297B62286E2C70297D29292C617065782E6A5175657279282223745F547265654E617622292E6F6E28227468656D6534326C61796F75746368616E676564222C2866756E637469';
wwv_flow_api.g_varchar2_table(57) := '6F6E28652C73297B73657454696D656F7574282866756E6374696F6E28297B62286E2C70297D292C333030297D29292C62286E2C70292C2264796E616D6963223D3D652E737472656E6774684261725374796C653F28722E6F6E2822666F637573696E22';
wwv_flow_api.g_varchar2_table(58) := '2C2866756E6374696F6E2865297B6E2E616464436C6173732822666F732D6261722D61637469766522297D29292C722E6F6E2822666F6375736F7574222C2866756E6374696F6E2865297B6E2E72656D6F7665436C6173732822666F732D6261722D6163';
wwv_flow_api.g_varchar2_table(59) := '7469766522297D2929293A22737461746963223D3D652E737472656E6774684261725374796C6526266E2E616464436C6173732822666F732D6261722D61637469766522293B666F72286C657420653D313B653C633B652B2B296E2E617070656E642827';
wwv_flow_api.g_varchar2_table(60) := '3C646976207374796C653D226C6566743A272B642A652B27252220636C6173733D22666F732D737472656E6774682D73706C6974223E3C2F6469763E27297D696628652E636F6E664974656D297B617065782E6974656D28652E636F6E664974656D292E';
wwv_flow_api.g_varchar2_table(61) := '64697361626C6528293B6C6574206E3D24282223222B652E636F6E664974656D293B722E6F6E2822696E707574222C2866756E6374696F6E286E297B617065782E6974656D28652E636F6E664974656D292E73657456616C7565282222292C6B28732C21';
wwv_flow_api.g_varchar2_table(62) := '31292C79282264697361626C6522292C497C7C286E2E63757272656E745461726765742E76616C75652E6C656E6774683E303F617065782E6974656D28652E636F6E664974656D292E656E61626C6528293A617065782E6974656D28652E636F6E664974';
wwv_flow_api.g_varchar2_table(63) := '656D292E64697361626C652829297D29292C6E2E6F6E2822666F637573696E222C2866756E6374696F6E286E297B732E72656D6F7665436C6173732843292C617065782E6D6573736167652E636C6561724572726F727328652E636F6E664974656D297D';
wwv_flow_api.g_varchar2_table(64) := '29293B6C657420733D24282223222B652E636F6E664974656D2B225F726567696F6E207370616E2E666F732D61702D696E6C696E652D636865636B22293B6E2E6F6E2822696E707574222C2866756E6374696F6E2865297B6C6574206E3D722E76616C28';
wwv_flow_api.g_varchar2_table(65) := '293B652E7461726765742E76616C7565213D6E3F286B28732C2131292C79282264697361626C652229293A286B28732C2130292C792822656E61626C652229297D29292C6E2E6F6E28226368616E6765222C2866756E6374696F6E286E297B6C65742073';
wwv_flow_api.g_varchar2_table(66) := '3D722E76616C28293B6E2E7461726765742E76616C7565213D733F28652E73686F774572726F724966496E632626617065782E6D6573736167652E73686F774572726F7273287B747970653A226572726F72222C6C6F636174696F6E3A22696E6C696E65';

wwv_flow_api.g_varchar2_table(67) := '222C706167654974656D3A652E636F6E664974656D2C6D6573736167653A652E636F6E664974656D4572726F724D6573736167657D292C79282264697361626C652229293A792822656E61626C6522297D29297D66756E6374696F6E206228652C6E3D31';
wwv_flow_api.g_varchar2_table(68) := '297B652E63737328227769647468222C722E6F75746572576964746828292A6E2B22707822297D66756E6374696F6E207628297B242874686973292E72656D6F7665436C61737328652E7065656B48696464656E49636F6E292E616464436C6173732865';
wwv_flow_api.g_varchar2_table(69) := '2E7065656B53686F776E49636F6E292C722E61747472282274797065222C227465787422297D66756E6374696F6E207828297B242874686973292E72656D6F7665436C61737328652E7065656B53686F776E49636F6E292E616464436C61737328652E70';
wwv_flow_api.g_varchar2_table(70) := '65656B48696464656E49636F6E292C722E61747472282274797065222C2270617373776F726422297D66756E6374696F6E206B286E2C73297B733F286E2E637373287B636F6C6F723A652E73756363657373436F6C6F727D292C6E2E72656D6F7665436C';
wwv_flow_api.g_varchar2_table(71) := '61737328652E696E6C696E654661696C49636F6E292E616464436C61737328652E696E6C696E65436865636B49636F6E29293A286E2E637373287B636F6C6F723A652E6572726F72436F6C6F727D292C6E2E72656D6F7665436C61737328652E696E6C69';
wwv_flow_api.g_varchar2_table(72) := '6E65436865636B49636F6E292E616464436C61737328652E696E6C696E654661696C49636F6E29297D66756E6374696F6E2079286E297B652E64697361626C654974656D732626652E6974656D73546F44697361626C652E666F7245616368282866756E';
wwv_flow_api.g_varchar2_table(73) := '6374696F6E2865297B617065782E6D6573736167652E636C6561724572726F72732865292C22656E61626C65223D3D6E3F2824282223222B65292E72656D6F7665436C6173732822617065785F64697361626C656422292C617065782E6974656D286529';
wwv_flow_api.g_varchar2_table(74) := '2E656E61626C652829293A2824282223222B65292E616464436C6173732822617065785F64697361626C656422292C617065782E6974656D2865292E64697361626C652829297D29297D66756E6374696F6E2053286E2C73297B742E637373287B636F6C';
wwv_flow_api.g_varchar2_table(75) := '6F723A652E73756363657373436F6C6F727D292C742E72656D6F7665436C6173732822666F732D76616C75652D656E74657222292C742E616464436C6173732822666F732D76616C75652D6C6561766522292C73657454696D656F7574282866756E6374';
wwv_flow_api.g_varchar2_table(76) := '696F6E28297B742E72656D6F7665436C6173732822666F732D76616C75652D6C6561766522292C742E616464436C6173732822666F732D76616C75652D656E74657222292C22646F6E6522213D732626742E637373287B636F6C6F723A652E6572726F72';
wwv_flow_api.g_varchar2_table(77) := '436F6C6F727D292C742E68746D6C286E7C7C2222292C742E6174747228226E616D65222C73297D292C333030297D66756E6374696F6E20452865297B666F72286C6574206E20696E20662969662821665B6E5D297B6528293B627265616B7D7D66756E63';
wwv_flow_api.g_varchar2_table(78) := '74696F6E2046286E2C743D2130297B6C6574206F3D303B666F72286C6574206520696E206629665B655D26266F2B2B3B696628652E73686F77537472656E677468426172297B6C657420653D6F2A643B653D39393D3D653F3130303A652C732E63737328';
wwv_flow_api.g_varchar2_table(79) := '227769647468222C652B222522297D6E2E706172656E7428292E637373287B636F6C6F723A652E73756363657373436F6C6F727D292C6E2E616464436C61737328652E72756C6573436865636B49636F6E292E72656D6F7665436C61737328652E72756C';
wwv_flow_api.g_varchar2_table(80) := '65734661696C49636F6E292C6E2E637373287B636F6C6F723A652E73756363657373436F6C6F727D292C6F3D3D633F28742626617065782E6576656E742E74726967676572282223222B612C22666F732D61702D65766572792D72756C652D636F6D706C';
wwv_flow_api.g_varchar2_table(81) := '657465222C66292C652E636F6E664974656D2626617065782E6974656D28652E636F6E664974656D292E656E61626C6528292C652E64697361626C654974656D73262621652E636F6E664974656D2626792822656E61626C6522292C652E696E6C696E65';
wwv_flow_api.g_varchar2_table(82) := '49636F6E26266B28772C213029293A742626617065782E6576656E742E74726967676572282223222B612C22666F732D61702D72756C652D636F6D706C657465222C66297D66756E6374696F6E204F286E297B696628652E73686F77537472656E677468';
wwv_flow_api.g_varchar2_table(83) := '426172297B6C657420653D303B666F72286C6574206E20696E206629665B6E5D7C7C652B2B3B6C6574206E3D3130302D652A643B6E3D333D3D633F6E2D313A6E2C732E63737328227769647468222C6E2B222522297D6E2E706172656E7428292E637373';
wwv_flow_api.g_varchar2_table(84) := '287B636F6C6F723A652E6572726F72436F6C6F727D292C6E2E616464436C61737328652E72756C65734661696C49636F6E292E72656D6F7665436C61737328652E72756C6573436865636B49636F6E292C6E2E637373287B636F6C6F723A652E6572726F';
wwv_flow_api.g_varchar2_table(85) := '72436F6C6F727D292C617065782E6576656E742E74726967676572282223222B612C22666F732D61702D72756C652D6661696C222C66292C652E636F6E664974656D2626617065782E6974656D28652E636F6E664974656D292E64697361626C6528292C';
wwv_flow_api.g_varchar2_table(86) := '652E64697361626C654974656D73262621652E636F6E664974656D262679282264697361626C6522292C652E696E6C696E6549636F6E26266B28772C2131297D7D3B0A2F2F2320736F757263654D617070696E6755524C3D7363726970742E6A732E6D61';
wwv_flow_api.g_varchar2_table(87) := '70';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(98660160727401448)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_file_name=>'script.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B227363726970742E6A73225D2C226E616D6573223A5B22464F53222C2277696E646F77222C226974656D222C22616476616E63656450617373776F7264222C22696E6974222C22636F6E6669';
wwv_flow_api.g_varchar2_table(2) := '67222C22696E69744A73222C227065656B53686F776E49636F6E222C227065656B48696464656E49636F6E222C22636170734C6F636B49636F6E222C2272756C6573436865636B49636F6E222C2272756C65734661696C49636F6E222C22696E6C696E65';
wwv_flow_api.g_varchar2_table(3) := '436865636B49636F6E222C22696E6C696E654661696C49636F6E222C226572726F724D657373616765222C22636F6E664974656D4572726F724D657373616765222C22737472656E6774684261725374796C65222C2273756363657373436F6C6F72222C';
wwv_flow_api.g_varchar2_table(4) := '226572726F72436F6C6F72222C22737472656E6774684261724267436F6C6F72222C22737472656E6774684261725769647468506374222C2246756E6374696F6E222C2263616C6C222C2274686973222C2261706578222C226465627567222C22696E66';
wwv_flow_api.g_varchar2_table(5) := '6F222C22737472656E677468426172456C222C227469746C65456C222C2272756C6573436F6E7461696E6572456C222C226974656D4E616D65222C226974656D526567696F6E222C2224222C22696E7075744669656C64222C2272756C6573222C227465';
wwv_flow_api.g_varchar2_table(6) := '73744E756D222C224F626A656374222C226B657973222C226C656E677468222C22736570506F73222C224D617468222C22666C6F6F72222C22746573745374617465222C226C656E456C222C2266696E64222C226E756D456C222C2273706563456C222C';
wwv_flow_api.g_varchar2_table(7) := '22636170456C222C22464F535F41505F48494444454E5F434C415353222C226B6579222C22696E6C696E6549636F6E456C222C2276616C69646174655265717569726564222C226A5175657279222C226973456D7074794F626A656374222C226973436F';
wwv_flow_api.g_varchar2_table(8) := '6E6669726D6174696F6E4974656D222C22696E6C696E6549636F6E222C22616464436C617373222C22637373222C226C656674222C22636F6C6F72222C226F6E222C2265222C2272656D6F7665436C617373222C22746F67676C65496E6C696E6549636F';
wwv_flow_api.g_varchar2_table(9) := '6E222C2263757272656E74546172676574222C2276616C7565222C226973457665727952756C65506173736564222C22696E707574222C2274657374526573222C226E657756616C7565222C22746172676574222C227077644C656E677468222C226174';
wwv_flow_api.g_varchar2_table(10) := '7472696275746573222C22736574546F4661696C6564222C22736574546F436F6D706C65746564222C227077644E756D73222C2273222C2272657175697265644E756D222C227265676578222C22526567457870222C2274657374222C22636F6E746169';
wwv_flow_api.g_varchar2_table(11) := '6E734E756D62657273222C227077644361706974616C73222C22726571756972656443617073222C22636F6E7461696E734361706974616C4C657474657273222C22707764537065634368617273222C22726571756972656453706563222C226C697374';
wwv_flow_api.g_varchar2_table(12) := '4F665370656343686172222C227265717569726564534E756D222C22636F6E7461696E735370656369616C43686172616374657273222C2272756C6573436F6E7461696E6572222C227469746C65456C5370616E222C22646F6E65222C227469746C654E';
wwv_flow_api.g_varchar2_table(13) := '616D65222C2261747472222C226D657373616765222C22636C6561724572726F7273222C226368616E67655469746C6552756C65222C2272756C6573436F6D7054657874222C2272756C6573436F6E456C222C22646F63756D656E74222C227175657279';
wwv_flow_api.g_varchar2_table(14) := '53656C6563746F72416C6C222C22666F7245616368222C2272756C65222C227374796C65222C22646973706C6179222C22686569676874222C2270726F70222C22737562737472222C227469746C65526566726573686564222C2272756C65456C222C22';
wwv_flow_api.g_varchar2_table(15) := '717565727953656C6563746F72222C22696E6E657248544D4C222C2276616C6964617465222C227077645065656B222C2273706C6974222C2273686F7749636F6E222C2268696465507764222C22627574746F6E222C2273686F77507764222C22746F75';
wwv_flow_api.g_varchar2_table(16) := '6368222C22746F7563686573222C22656C656D656E7446726F6D506F696E74222C22636C69656E7458222C22636C69656E7459222C2273686F77436170734C6F636B222C226361707349636F6E222C2269636F6E506F73222C226F726967696E616C4576';
wwv_flow_api.g_varchar2_table(17) := '656E74222C226765744D6F6469666965725374617465222C227375626D69744F6E456E746572222C227375626D6974222C2272657175657374222C227375626D69744966456E746572222C2269676E6F72654368616E6765222C2273686F775761697422';
wwv_flow_api.g_varchar2_table(18) := '2C2265616368222C22656C222C2272756C6573436F6E7461696E65724964222C22726567696F6E456C222C22646574616368222C22746172676574456C222C22657874436F6E7461696E6572426F6479222C22617070656E64222C22736574456C656D65';
wwv_flow_api.g_varchar2_table(19) := '6E745769647468222C2266616C736552756C65222C226669727374222C2268746D6C222C22746F67676C65436C617373222C2272756C6573436F6E222C2264697361626C654974656D73222C22636F6E664974656D222C22636F6E664974656D49647822';
wwv_flow_api.g_varchar2_table(20) := '2C226974656D73546F44697361626C65222C22696E6465784F66222C2273706C696365222C227365744974656D735374617465222C2273686F774572726F724966496E63222C2273686F774572726F7273222C2274797065222C226C6F636174696F6E22';
wwv_flow_api.g_varchar2_table(21) := '2C22706167654974656D222C226576656E74222C2274726967676572222C2273686F77537472656E677468426172222C22626172436F6E7461696E6572222C226164644576656E744C697374656E6572222C226F626A222C2273657454696D656F757422';
wwv_flow_api.g_varchar2_table(22) := '2C2269222C2264697361626C65222C2273657456616C7565222C22636F6E6649636F6E456C222C22656E61626C65222C226974656D56616C7565222C2276616C222C22706374222C226F757465725769647468222C22636F6E74656E74222C226E616D65';
wwv_flow_api.g_varchar2_table(23) := '222C226362222C22747269676765724576656E74222C227061737365645465737473222C226261725769646874222C22706172656E74222C226661696C65645465737473222C226261725769647468225D2C226D617070696E6773223A22414145412C49';
wwv_flow_api.g_varchar2_table(24) := '414149412C4941414D432C4F41414F442C4B41414F2C4741437842412C49414149452C4B41414F462C49414149452C4D4141512C4741437642462C49414149452C4B41414B432C694241416D42482C49414149452C4B41414B432C6B4241416F422C4741';
wwv_flow_api.g_varchar2_table(25) := '6D437A44482C49414149452C4B41414B432C694241416942432C4B41414F2C53414155432C45414151432C4741456C44442C4541414F452C63414167422C5341437642462C4541414F472C65414169422C6541437842482C4541414F492C614141652C69';
wwv_flow_api.g_varchar2_table(26) := '42414374424A2C4541414F4B2C65414169422C6F42414378424C2C4541414F4D2C63414167422C6F42414376424E2C4541414F4F2C674241416B422C6F4241437A42502C4541414F512C65414169422C6F4241437842522C4541414F532C614141652C6F';
wwv_flow_api.g_varchar2_table(27) := '4241437442542C4541414F552C7142414175422C304241433942562C4541414F572C694241416D422C5541433142582C4541414F592C614141652C55414374425A2C4541414F612C574141612C5541437042622C4541414F632C6D42414171422C554143';
wwv_flow_api.g_varchar2_table(28) := '3542642C4541414F652C6F42414173422C4941477A42642C47414155412C6141416B42652C5541432F42662C4541414F67422C4B41414B432C4B41414D6C422C4741476E426D422C4B41414B432C4D41414D432C4B41414B2C34424141364272422C4741';
wwv_flow_api.g_varchar2_table(29) := '4537432C4941614973422C45414165432C45414153432C4541627842432C454141577A422C4541414F79422C5341436C42432C45414161432C454141452C4941414D462C454141572C5741456843472C45414161442C454141452C4941414D462C474145';
wwv_flow_api.g_varchar2_table(30) := '7242492C4541415137422C4541414F36422C4D414566432C45414155432C4F41414F432C4B41414B482C4741414F492C4F41453742432C45414153432C4B41414B432C4D41414D2C4941414D4E2C47414531424F2C454141592C4741495A74422C454141';
wwv_flow_api.g_varchar2_table(31) := '7342662C4541414F652C6F42414173422C4941456E4475422C454141515A2C45414157612C4B41414B2C6B4341437842432C45414151642C45414157612C4B41414B2C6D4341437842452C45414153662C45414157612C4B41414B2C384341437A42472C';
wwv_flow_api.g_varchar2_table(32) := '4541415168422C45414157612C4B41414B2C3243414535422C4D41414D492C45414173422C63414D35422C4941414B2C49414149432C4B41414F662C45414358412C4541414D652C4B414354502C454141554F2C4941414F2C4741496E422C4941474943';
wwv_flow_api.g_varchar2_table(33) := '2C45414841432C4741416F42432C4F41414F432C63414163582C4B41416572432C4541414F69442C6D42412B426E452C47413342496A442C4541414F6B442C614143564C2C454141656E422C45414157612C4B41414B2C344241432F424D2C454141614D';
wwv_flow_api.g_varchar2_table(34) := '2C534141532C434141436E442C4541414F512C65414167426D432C4941433943452C454141614F2C494141492C43414145432C4B4141512C53414155432C4D41415374442C4541414F612C614143684469432C474141714239432C4541414F69442C7142';
wwv_flow_api.g_varchar2_table(35) := '4143684372422C4541415732422C474141472C534141532C53414155432C4741436843582C45414161592C59414159642C4D41453142662C4541415732422C474141472C534141532C53414155432C4741436843452C4541416942622C45414163572C45';
wwv_flow_api.g_varchar2_table(36) := '414145472C63414163432C4D41414D33422C4F4141532C51414D3744612C474143486C422C4541415732422C474141472C6742414167422C53414155432C4741436E4378442C4541414F6B442C59414356572C4741416B422C5741436A42482C45414169';
wwv_flow_api.g_varchar2_table(37) := '42622C474141632C4D4173506E432C5341416B4269422C4741436A422C49414349432C45414441432C45414157462C4541414D472C4F41414F4C2C4D414978422F422C4541414D71432C59414354482C45414155432C454141532F422C4F4141534A2C45';
wwv_flow_api.g_varchar2_table(38) := '41414D71432C55414155432C574141576C432C4F41436E4438422C4741415731422C4541415536422C574143784237422C4541415536422C574141592C4541437442452C4541415939422C4941434479422C4741415931422C4541415536422C5941436A';
wwv_flow_api.g_varchar2_table(39) := '4337422C4541415536422C574141592C4541437442472C454141652F422C4B414B62542C4541414D79432C55414354502C45416B46462C5341417942512C47414378422C49414149432C4541416333432C4541414D79432C51414151482C574141576C43';
wwv_flow_api.g_varchar2_table(40) := '2C4F414533432C4F41444177432C4D4141512C49414149432C4F41414F2C61414165462C454141632C4B41414D2C4B41432F43432C4D41414D452C4B41414B4A2C47417246504B2C43414167425A2C4741437442442C4941415931422C4541415569432C';
wwv_flow_api.g_varchar2_table(41) := '5341437A426A432C4541415569432C534141552C4541437042442C4541416537422C4B41434A75422C4741415731422C4541415569432C55414368436A432C4541415569432C534141552C4541437042462C4541415935422C4B414B56582C4541414D67';
wwv_flow_api.g_varchar2_table(42) := '442C63414354642C45413245462C5341416743512C4741432F422C494141494F2C454141656A442C4541414D67442C59414159562C574141576C432C4F414568442C4F41444177432C4D4141512C49414149432C4F41414F2C61414165492C454141652C';
wwv_flow_api.g_varchar2_table(43) := '4B41414D2C4B414368444C2C4D41414D452C4B41414B4A2C4741394550512C4341417542662C4741433742442C4941415931422C4541415577432C6141437A4278432C4541415577432C614141632C4541437842522C4541416533422C4B41434A71422C';
wwv_flow_api.g_varchar2_table(44) := '4741415731422C4541415577432C634143684378432C4541415577432C614141632C4541437842542C4541415931422C4B414B56622C4541414D6D442C654143546A422C45416F45462C5341416D43512C4741436C432C49414149552C4541416570442C';
wwv_flow_api.g_varchar2_table(45) := '4541414D6D442C61414161622C57414157652C6541433743432C4541416574442C4541414D6D442C61414161622C574141576C432C4F41456A442C4F41444177432C4D4141512C49414149432C4F41414F2C4B41414F4F2C454141652C51414155452C45';
wwv_flow_api.g_varchar2_table(46) := '4141652C4B41414D2C4B41436A45562C4D41414D452C4B41414B4A2C4741784550612C434141304270422C4741436843442C4941415931422C4541415532432C6341437A4233432C4541415532432C634141652C4541437A42582C4541416535422C4B41';
wwv_flow_api.g_varchar2_table(47) := '434A73422C4741415731422C4541415532432C654143684333432C4541415532432C634141652C4541437A425A2C4541415933422C4B414B642C47414136422C6541417A427A432C4541414F71462C65414169432C43414333432C49414149432C454141';
wwv_flow_api.g_varchar2_table(48) := '6335442C45414157612C4B41414B2C73434143394267442C4741414F2C4541435831422C4741416B422C5741436A4230422C4741414F2C4B4145522C49414149432C454141596A452C454141516B452C4B41414B2C51414337422C47414149462C474141';
wwv_flow_api.g_varchar2_table(49) := '71422C51414162432C45414171422C434143684372452C4B41414B75452C51414151432C594141596C452C4741437A426D452C454141674235462C4541414F36462C634141652C514143744378422C4541416569422C474141612C47414335422C494141';
wwv_flow_api.g_varchar2_table(50) := '49512C4541416174452C4541436A4275452C53414153432C6942414169422C4941414D76452C454141572C77424141774277452C534141512C53414155432C4741437046412C4541414B432C4D41414D432C514141552C5741456C424E2C454141574F2C';
wwv_flow_api.g_varchar2_table(51) := '534141572C4741437A42502C4541415731432C494141492C434141452C6141416330432C45414157512C4B41414B2C674241416B422C5941476C452C474141496A452C454141556D442C45414155652C4F41414F2C4B41416F422C51414162662C454141';
wwv_flow_api.g_varchar2_table(52) := '71422C43414331442C4941414967422C47414169422C45414372422C4941414B2C49414149462C4B4141516A452C454141572C43414333422C494141496F452C45414153562C53414153572C634141632C4941414D6A462C454141572C694341416D4336';
wwv_flow_api.g_varchar2_table(53) := '452C4541414F2C4D414331466A452C4541415569452C49414354452C4541574C432C4541414F4E2C4D41414D432C514141552C53415674424B2C4541414F4E2C4D41414D432C514141552C4F41434E2C514141625A2C474143486E422C4541416569422C';
wwv_flow_api.g_varchar2_table(54) := '474141612C47414537424D2C4541416742612C4541414F452C554141572C574141614C2C4741432F43452C47414169422C4D4174557442492C4341415370442C4D414B572C5941416C4278442C4541414F36472C51414175422C4341436A4337472C4541';
wwv_flow_api.g_varchar2_table(55) := '414F472C6541416942482C4541414F472C6541416532472C4D41414D2C4B4143704439472C4541414F452C6341416742462C4541414F452C6341416334472C4D41414D2C4B41436C442C49414149432C4541415772462C45414157612C4B41414B2C6F42';
wwv_flow_api.g_varchar2_table(56) := '41432F4277452C4541415335442C534141536E442C4541414F472C674241457A4279422C4541415777422C494141492C434141452C6742414169422C574145394270442C4541414F6B442C594143564C2C454141614F2C494141492C43414145432C4B41';
wwv_flow_api.g_varchar2_table(57) := '41512C5941474C2C774241416E4272442C4541414F36472C53414356452C4541415378442C474141472C384241412B4279442C4741433343442C4541415378442C474141472C614141612C53414155432C4741436A422C49414162412C4541414579442C';
wwv_flow_api.g_varchar2_table(58) := '5141434C432C454141516A472C4B41414B38462C4D414766412C4541415378442C474141472C634141632C53414155432C4741436E432C4941414932442C4541415133442C4541414534442C514141512C4741435672422C5341415373422C6942414169';
wwv_flow_api.g_varchar2_table(59) := '42462C4541414D472C51414153482C4541414D492C55414531444C2C454141516A472C4B41414B38462C4F4147632C6D4241416E422F472C4541414F36472C5341436A42452C4541415378442C474141472C53417555642C57414334422C594141334233';
wwv_flow_api.g_varchar2_table(60) := '422C4541415736442C4B41414B2C514141774279422C454141516A472C4B41414B432C4D41415138462C454141512F462C4B41414B432C5341705533452C474141496C422C4541414F77482C614141632C43414378422C49414149432C454141572F462C';
wwv_flow_api.g_varchar2_table(61) := '45414157612C4B41414B2C694241432F426B462C4541415374452C534141532C434141436E442C4541414F492C6141416375432C49414578432C494141492B452C45414136422C6141416E4231482C4541414F36472C51414179422C534141572C554143';
wwv_flow_api.g_varchar2_table(62) := '7A44592C4541415372452C494141492C43414145432C4B41415171452C494145764239462C4541415732422C474141472C594141592C53414155432C4741432F4278442C4541414F6B442C594143564C2C45414161592C59414159642C47414531423845';
wwv_flow_api.g_varchar2_table(63) := '2C4541415374452C53414153522C4D41476E42662C4541415732422C474141472C534141532C53414155432C4741433542412C454141456D452C63414163432C6942414169422C614143684335482C4541414F6B442C594143564C2C454141614D2C5341';
wwv_flow_api.g_varchar2_table(64) := '4153522C474145764238452C4541415368452C59414159642C4B41456A4233432C4541414F6B442C594143564C2C45414161592C59414159642C474145314238452C4541415374452C53414153522C4F41794272422C47416E424933432C4541414F3648';
wwv_flow_api.g_varchar2_table(65) := '2C654143566A472C4541415732422C474141472C534141532C53414155432C474143684372432C4B41414B32472C4F41414F2C43414358432C5141415374472C4541435475472C6341416578452C4541436679452C634141632C45414364432C55414155';
wwv_flow_api.g_varchar2_table(66) := '2C4F414B67422C5541417A426C492C4541414F71462C674241435633442C45414157612C4B41414B2C5941415934462C4D41414B2C57414368432C49414149432C4541414B7A472C45414145542C4D4143586B482C454141476A462C534141536E442C45';
wwv_flow_api.g_varchar2_table(67) := '41414F4D2C6541436E4238482C4541414768462C494141492C43414145452C4D41415374442C4541414F612C67424149452C5941417A42622C4541414F71462C67424141674372462C4541414F71492C694241416B422C4341436E452C49414149432C45';
wwv_flow_api.g_varchar2_table(68) := '41415735472C45414157612C4B41414B2C38424141384267472C5341437A44432C4541415737472C454141452C4941414D33422C4541414F71492C6B4241433142492C4541416D42442C454141536A472C4B41414B2C6B4241434C2C49414135426B472C';
wwv_flow_api.g_varchar2_table(69) := '454141694278472C4F4143704277472C4541416942432C4F41414F4A2C4741457842452C45414153452C4F41414F4A2C5141536A422C47414E36422C5541417A4274492C4541414F71462C694241435639442C45414155472C45414157612C4B41414B2C';
wwv_flow_api.g_varchar2_table(70) := '364241433142662C4541416D42452C45414157612C4B41414B2C714241436E436F472C454141674270482C47414368426F482C45414167426E482C494145592C6541417A4278422C4541414F71462C674241416D4376432C4541416B422C4341452F442C';
wwv_flow_api.g_varchar2_table(71) := '4941414938462C454141596C482C45414157612C4B41414B2C67424141674273472C514145684474482C4541415175482C4B41414B462C45414155452C514143764276482C454141516B452C4B41414B2C4F4141512C514141556D442C454141556E442C';
wwv_flow_api.g_varchar2_table(72) := '4B41414B2C53414539436D442C4541415578462C494141492C4341414567442C514141572C534145334237452C4541415167432C474141472C534141532C53414155432C474143374237422C45414145542C4D41414D36482C594141592C55414370422C';
wwv_flow_api.g_varchar2_table(73) := '49414149432C4541415778482C4541435877482C4541415333432C534141572C454143764232432C4541415335462C494141492C434141452C614141632C494145374234462C4541415335462C494141492C434141452C6141416334462C454141533143';
wwv_flow_api.g_varchar2_table(74) := '2C4B41414B2C674241416B422C55414D6A452C4741414974472C4541414F694A2C614141632C43414578422C474141496A4A2C4541414F6B4A2C534141552C43414370422C49414149432C454141636E4A2C4541414F6F4A2C65414165432C5141415172';
wwv_flow_api.g_varchar2_table(75) := '4A2C4541414F6B4A2C5541436E44432C474141652C4741436C426E4A2C4541414F6F4A2C65414165452C4F41414F482C454141612C4741473543492C454141632C57417142662C47416A4249764A2C4541414F774A2C674241416B4231472C4941433542';
wwv_flow_api.g_varchar2_table(76) := '6C422C4541415732422C474141472C554141552C53414155432C4741436A434B2C4741416B422C5741436A4231432C4B41414B75452C514141512B442C574141572C4341437642432C4B41414D2C5141434E432C534141552C53414356432C534141556E';
wwv_flow_api.g_varchar2_table(77) := '492C4541435669452C5141415331462C4541414F532C6541456A42552C4B41414B30492C4D41414D432C514141512C4941414D72492C45416A4C412C754241694C2B42592C5341473144542C4541415732422C474141472C574141572C53414155432C47';
wwv_flow_api.g_varchar2_table(78) := '41436C4372432C4B41414B75452C51414151432C594141596C452C4F414976427A422C4541414F2B4A2C6742414169422C43414533427A492C4541416742492C45414157612C4B41414B2C3242414568432C4941414979482C4541416574492C45414157';
wwv_flow_api.g_varchar2_table(79) := '612C4B41414B2C2B4241436E4379482C454141617A482C4B41414B2C6F4241416F42612C494141492C434141452C6D4241416F4270442C4541414F632C7142414376456B4A2C454141617A482C4B41414B2C324241413242612C494141492C434141452C';
wwv_flow_api.g_varchar2_table(80) := '6D4241416F4270442C4541414F592C654147394568422C4F41414F714B2C6942414169422C554141552C534141557A472C47414333436D462C454141674271422C454141636A4A2C4D41472F42492C4B41414B34422C4F41414F2C63414163512C474141';
wwv_flow_api.g_varchar2_table(81) := '472C7742414177422C5341415573472C4541414F4B2C4741437245432C594141572C5741435678422C454141674271422C454141636A4A2C4B414335422C5141474A34482C454141674271422C454141636A4A2C474145432C5741413342662C4541414F';
wwv_flow_api.g_varchar2_table(82) := '572C6B4241435669422C4541415732422C474141472C574141572C53414155432C4741436C4377472C4541416137472C534141532C71424145764276422C4541415732422C474141472C594141592C53414155432C4741436E4377472C4541416176472C';
wwv_flow_api.g_varchar2_table(83) := '594141592C73424145572C55414133427A442C4541414F572C6B4241436A42714A2C4541416137472C534141532C6B42414776422C4941414B2C4941414969482C454141492C45414147412C4541414974492C4541415373492C49414335424A2C454141';
wwv_flow_api.g_varchar2_table(84) := '6174422C4F41414F2C6F424141734278472C454141536B492C454141492C7743414B7A442C47414149704B2C4541414F6B4A2C534141552C43414570422F482C4B41414B74422C4B41414B472C4541414F6B4A2C554141556D422C55414533422C494141';
wwv_flow_api.g_varchar2_table(85) := '496E422C4541415776482C454141452C4941414D33422C4541414F6B4A2C554145394274482C4541415732422C474141472C534141532C53414155432C474143684372432C4B41414B74422C4B41414B472C4541414F6B4A2C554141556F422C53414153';
wwv_flow_api.g_varchar2_table(86) := '2C494143704335472C454141694236472C474141592C474143374268422C454141632C574143547A472C49414341552C45414145472C63414163432C4D41414D33422C4F4141532C4541436C43642C4B41414B74422C4B41414B472C4541414F6B4A2C55';
wwv_flow_api.g_varchar2_table(87) := '41415573422C5341453342724A2C4B41414B74422C4B41414B472C4541414F6B4A2C554141556D422C63414B39426E422C4541415333462C474141472C574141572C53414155432C47414368432B472C4541415739472C59414159642C47414376427842';
wwv_flow_api.g_varchar2_table(88) := '2C4B41414B75452C51414151432C5941415933462C4541414F6B4A2C6141476A432C4941414971422C4541416135492C454141452C4941414D33422C4541414F6B4A2C534141572C6F4341433343412C4541415333462C474141472C534141532C534141';
wwv_flow_api.g_varchar2_table(89) := '55432C47414339422C4941414969482C4541415937492C4541415738492C4D414376426C482C45414145532C4F41414F4C2C4F41415336472C47414372422F472C454141694236472C474141592C474143374268422C454141632C6141456437462C4541';
wwv_flow_api.g_varchar2_table(90) := '41694236472C474141592C474143374268422C454141632C63414968424C2C4541415333462C474141472C554141552C53414155432C4741432F422C4941414969482C4541415937492C4541415738492C4D414376426C482C45414145532C4F41414F4C';
wwv_flow_api.g_varchar2_table(91) := '2C4F41415336472C4741436A427A4B2C4541414F774A2C674241435672492C4B41414B75452C514141512B442C574141572C4341437642432C4B41414D2C5141434E432C534141552C53414356432C53414155354A2C4541414F6B4A2C5341436A427844';
wwv_flow_api.g_varchar2_table(92) := '2C5141415331462C4541414F552C754241476C4236492C454141632C59414564412C454141632C614173476A422C534141535A2C4541416742502C4541414975432C4541414D2C4741436C4376432C4541414768462C494141492C5141415378422C4541';
wwv_flow_api.g_varchar2_table(93) := '4157674A2C61414165442C4541414D2C4D4171426A442C534141537A442C4941435276462C45414145542C4D41414D75432C594141597A442C4541414F472C67424141674267442C534141536E442C4541414F452C654143334430422C4541415736442C';
wwv_flow_api.g_varchar2_table(94) := '4B41414B2C4F4141512C5141457A422C5341415375422C4941435272462C45414145542C4D41414D75432C594141597A442C4541414F452C6541416569442C534141536E442C4541414F472C67424143314479422C4541415736442C4B41414B2C4F4141';
wwv_flow_api.g_varchar2_table(95) := '512C5941457A422C534141532F422C454141694230452C4541414973422C4741437A42412C4741434874422C4541414768462C494141492C43414145452C4D41415374442C4541414F592C6541437A4277482C4541414733452C594141597A442C454141';
wwv_flow_api.g_varchar2_table(96) := '4F512C67424141674232432C534141536E442C4541414F4F2C6D424145744436482C4541414768462C494141492C43414145452C4D41415374442C4541414F612C6141437A4275482C4541414733452C594141597A442C4541414F4F2C69424141694234';
wwv_flow_api.g_varchar2_table(97) := '432C534141536E442C4541414F512C694241477A442C534141532B492C45414163472C4741436A42314A2C4541414F694A2C6341475A6A4A2C4541414F6F4A2C654141656E442C534141512C5341415570472C474143764373422C4B41414B75452C5141';
wwv_flow_api.g_varchar2_table(98) := '4151432C5941415939462C474143622C55414152364A2C474143482F482C454141452C4941414D39422C4741414D34442C594141592C69424143314274432C4B41414B74422C4B41414B412C4741414D324B2C574145684237492C454141452C4941414D';
wwv_flow_api.g_varchar2_table(99) := '39422C4741414D73442C534141532C69424143764268432C4B41414B74422C4B41414B412C4741414D774B2C6341496E422C534141537A452C454141674269462C45414153432C4741436A43764A2C4541415136422C494141492C43414145452C4D4141';
wwv_flow_api.g_varchar2_table(100) := '5374442C4541414F592C6541433942572C454141516B432C594141592C6D42414370426C432C4541415134422C534141532C6D4241436A4267482C594141572C5741435635492C454141516B432C594141592C6D42414370426C432C4541415134422C53';
wwv_flow_api.g_varchar2_table(101) := '4141532C6D4241434C2C5141415232482C47414348764A2C4541415136422C494141492C43414145452C4D41415374442C4541414F612C6141452F42552C4541415175482C4B41414B2B422C474141572C4941437842744A2C454141516B452C4B41414B';
wwv_flow_api.g_varchar2_table(102) := '2C4F41415171462C4B41436E422C4B41454A2C534141536A482C4541416B426B482C47414331422C4941414B2C49414149582C4B41414B2F482C454143622C4941414B412C454141552B482C474141492C4341436C42572C494143412C4F4149482C5341';
wwv_flow_api.g_varchar2_table(103) := '415331472C454141652B442C4541414934432C474141652C47414331432C49414149432C454141632C4541436C422C4941414B2C4941414972492C4B41414F502C45414358412C454141554F2C4941436271492C494147462C474141496A4C2C4541414F';

wwv_flow_api.g_varchar2_table(104) := '2B4A2C6742414169422C43414333422C494141496D422C45414157442C454141632F492C4541433742674A2C45414175422C4941415A412C45414169422C4941414D412C4541436C43354A2C4541416338422C494141492C5141415338482C454141572C';
wwv_flow_api.g_varchar2_table(105) := '4B4145764339432C454141472B432C534141532F482C494141492C43414145452C4D41415374442C4541414F592C6541436C4377482C454141476A462C534141536E442C4541414F4B2C6742414167426F442C594141597A442C4541414F4D2C65414374';
wwv_flow_api.g_varchar2_table(106) := '4438482C4541414768462C494141492C43414145452C4D41415374442C4541414F592C6541437242714B2C474141656E4A2C474143646B4A2C47414348374A2C4B41414B30492C4D41414D432C514141512C4941414D72492C45417264492C3642417164';
wwv_flow_api.g_varchar2_table(107) := '2B42592C4741457A4472432C4541414F6B4A2C554143562F482C4B41414B74422C4B41414B472C4541414F6B4A2C5541415573422C5341457842784B2C4541414F694A2C65414169426A4A2C4541414F6B4A2C5541436C434B2C454141632C5541455876';
wwv_flow_api.g_varchar2_table(108) := '4A2C4541414F6B442C59414356512C4541416942622C474141632C49414735426D492C47414348374A2C4B41414B30492C4D41414D432C514141512C4941414D72492C45416E65412C7542416D652B42592C47414933442C534141532B422C4541415967';
wwv_flow_api.g_varchar2_table(109) := '452C47414370422C4741414970492C4541414F2B4A2C6742414169422C43414333422C4941414971422C454141632C4541436C422C4941414B2C4941414978492C4B41414F502C45414356412C454141554F2C4941436477492C494147462C4941414943';
wwv_flow_api.g_varchar2_table(110) := '2C454141572C4941414D442C454141636C4A2C4541436E436D4A2C45414173422C47414158764A2C45414165754A2C454141572C45414149412C4541437A432F4A2C4541416338422C494141492C5141415369492C454141572C4B414576436A442C4541';
wwv_flow_api.g_varchar2_table(111) := '41472B432C534141532F482C494141492C43414145452C4D41415374442C4541414F612C6141436C4375482C454141476A462C534141536E442C4541414F4D2C654141656D442C594141597A442C4541414F4B2C6742414372442B482C4541414768462C';
wwv_flow_api.g_varchar2_table(112) := '494141492C43414145452C4D41415374442C4541414F612C6141437A424D2C4B41414B30492C4D41414D432C514141512C4941414D72492C45417066462C6D42416F663642592C474143684472432C4541414F6B4A2C554143562F482C4B41414B74422C';
wwv_flow_api.g_varchar2_table(113) := '4B41414B472C4541414F6B4A2C554141556D422C5541457842724B2C4541414F694A2C65414169426A4A2C4541414F6B4A2C5541436C434B2C454141632C57414558764A2C4541414F6B442C59414356512C4541416942622C47414163222C2266696C65';
wwv_flow_api.g_varchar2_table(114) := '223A227363726970742E6A73227D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(98660523221401450)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_file_name=>'script.js.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E742D466F726D2D6669656C64436F6E7461696E65722D2D666C6F6174696E674C6162656C202E742D466F726D2D6974656D577261707065727B666C65782D777261703A777261707D7370616E2E617065782D6974656D2D69636F6E2E61702D70617373';
wwv_flow_api.g_varchar2_table(2) := '776F72642D6579657B6F726465723A333B6C6566743A2D2E3172656D21696D706F7274616E743B7A2D696E6465783A323B706F736974696F6E3A72656C61746976653B706F696E7465722D6576656E74733A616C6C3B626F782D736861646F773A2E3172';
wwv_flow_api.g_varchar2_table(3) := '656D20302030202364666466646620696E73657421696D706F7274616E743B636F6C6F723A233430343034307D7370616E2E617065782D6974656D2D69636F6E2E61702D70617373776F72642D6579653A3A61667465727B6D617267696E2D7269676874';
wwv_flow_api.g_varchar2_table(4) := '3A303B6D617267696E2D626F74746F6D3A303B72696768743A33253B626F74746F6D3A3233257D7370616E2E617065782D6974656D2D69636F6E2E61702D636170732D6C6F636B7B6F726465723A333B6C6566743A2D332E3172656D3B7A2D696E646578';
wwv_flow_api.g_varchar2_table(5) := '3A323B706F696E7465722D6576656E74733A616C6C3B706F736974696F6E3A72656C61746976653B626F782D736861646F773A6E6F6E653B636F6C6F723A233430343034307D2E666F732D61702D636F6E73747261696E74733E6469767B6D617267696E';
wwv_flow_api.g_varchar2_table(6) := '3A3370787D2E666F732D61702D72756C652D636F6E7461696E65727B666C65782D646972656374696F6E3A636F6C756D6E7D2E666F732D61702D696E6E65722D636F6E7461696E65727B646973706C61793A666C65787D2E666F732D61702D72756C652D';
wwv_flow_api.g_varchar2_table(7) := '636F6E7461696E65722D737472657463687B666C65782D646972656374696F6E3A726F773B666C65782D777261703A777261707D2E666F732D61702D636F6E73747261696E74737B646973706C61793A666C65783B70616464696E672D6C6566743A3170';
wwv_flow_api.g_varchar2_table(8) := '787D2E666F732D61702D6F757465722D636F6E7461696E65727B77696474683A313030257D2E617065782D6974656D2D6861732D69636F6E3A64697361626C65647E2E617065782D6974656D2D69636F6E7B6F7061636974793A2E353B706F696E746572';
wwv_flow_api.g_varchar2_table(9) := '2D6576656E74733A6E6F6E657D2E666F732D737472656E6774682D6261722D636F6E7461696E65727B6F726465723A343B77696474683A313030253B666C65782D62617369733A313030253B706F736974696F6E3A72656C61746976653B686569676874';
wwv_flow_api.g_varchar2_table(10) := '3A3370783B6F7061636974793A303B6D617267696E2D746F703A3270787D2E666F732D737472656E6774682D62672C2E666F732D737472656E6774682D636F6E7461696E65727B646973706C61793A626C6F636B3B77696474683A313030253B706F7369';
wwv_flow_api.g_varchar2_table(11) := '74696F6E3A6162736F6C7574653B6865696768743A3370787D2E666F732D737472656E6774682D636F6E7461696E65727B77696474683A303B7472616E736974696F6E3A616C6C202E347320656173652D696E2D6F75747D2E666F732D737472656E6774';
wwv_flow_api.g_varchar2_table(12) := '682D73706C69747B646973706C61793A696E6C696E652D626C6F636B3B706F736974696F6E3A6162736F6C7574653B77696474683A3170783B7A2D696E6465783A3130303B6261636B67726F756E642D636F6C6F723A236666663B6865696768743A3370';
wwv_flow_api.g_varchar2_table(13) := '787D2E666F732D6261722D6163746976657B6F7061636974793A317D2E666F732D61702D636F6E73747261696E74732D7469746C657B637572736F723A706F696E7465723B77696474683A313030253B626F726465723A303B746578742D616C69676E3A';
wwv_flow_api.g_varchar2_table(14) := '6C6566743B6F75746C696E653A303B6D617267696E2D746F703A3370783B6F766572666C6F773A68696464656E3B666F6E742D73697A653A313270783B70616464696E672D6C6566743A3170787D2E666F732D61702D636F6E73747261696E74732D7469';
wwv_flow_api.g_varchar2_table(15) := '746C652E666F732D76616C75652D6C656176657B7472616E736974696F6E3A616C6C202E32732063756269632D62657A69657228312C2E352C2E382C31293B7472616E73666F726D3A7472616E736C61746559282D377078293B6F7061636974793A307D';
wwv_flow_api.g_varchar2_table(16) := '2E666F732D61702D636F6E73747261696E74732D7469746C652E666F732D76616C75652D656E7465727B7472616E736974696F6E3A616C6C202E31737D2E666F732D61702D636F6E73747261696E74732D7469746C653A6265666F72657B636F6E74656E';
wwv_flow_api.g_varchar2_table(17) := '743A275C30303242273B636F6C6F723A236433643364333B666F6E742D7765696768743A3730303B666C6F61743A72696768743B6D617267696E2D72696768743A3570787D2E6163746976653A6265666F72657B636F6E74656E743A225C32323132227D';
wwv_flow_api.g_varchar2_table(18) := '2E666F732D61702D636F6E73747261696E74732E666F732D61702D636F6E7461696E65722D68696464656E7B646973706C61793A6E6F6E657D2E666F732D61702D636F6E73747261696E74732E666F732D61702D636F6E7461696E65722D636F6C6C6170';
wwv_flow_api.g_varchar2_table(19) := '7369626C657B6D61782D6865696768743A303B6F766572666C6F773A68696464656E3B7472616E736974696F6E3A6D61782D686569676874202E327320656173652D6F75747D2E666F732D61702D636F6E7461696E65722D636F6C6C61707369626C6520';
wwv_flow_api.g_varchar2_table(20) := '2E666F732D61702D72756C657B6D617267696E3A302031307078203020307D2E666F732D61702D636F6E73747261696E74732D7469746C65207370616E2C2E666F732D61702D72756C65207370616E2E66612C2E666F732D61702D72756C652D74657874';
wwv_flow_api.g_varchar2_table(21) := '7B766572746963616C2D616C69676E3A6D6964646C653B666F6E742D73697A653A313270787D2E666F732D61702D696E6C696E652D636865636B7B6F7061636974793A313B7A2D696E6465783A333B626F782D736861646F773A6E6F6E6521696D706F72';
wwv_flow_api.g_varchar2_table(22) := '74616E743B6F726465723A3321696D706F7274616E743B706F696E7465722D6576656E74733A616C6C3B706F736974696F6E3A72656C61746976653B6C696E652D6865696768743A342E3872656D3B6D617267696E2D6C6566743A2D332E3272656D3B74';
wwv_flow_api.g_varchar2_table(23) := '6578742D616C69676E3A63656E7465723B7472616E736974696F6E3A2E327320656173653B666C65782D736872696E6B3A307D2E666F732D61702D73686F777B646973706C61793A666C65787D2E666F732D61702D686964657B646973706C61793A6E6F';
wwv_flow_api.g_varchar2_table(24) := '6E6521696D706F7274616E747D0A2F2A2320736F757263654D617070696E6755524C3D7374796C652E6373732E6D61702A2F';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(112909027717745238)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_file_name=>'style.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B227374796C652E637373225D2C226E616D6573223A5B5D2C226D617070696E6773223A22414145412C79442C434143432C632C434149442C6D432C434143492C4F2C434143412C71422C4341';
wwv_flow_api.g_varchar2_table(2) := '43412C532C434143412C69422C434143412C6B422C434143482C34432C434143472C612C4341454A2C30432C434143432C632C434143412C652C434143412C512C434143412C552C434147442C67432C434143432C4F2C434143472C592C434143412C53';
wwv_flow_api.g_varchar2_table(3) := '2C434143412C6B422C434143412C69422C434143482C652C434143472C612C4341474A2C75422C434143432C552C434147442C73422C434143432C71422C434147442C75422C434143432C592C434147442C38422C434143432C6B422C434143412C632C';
wwv_flow_api.g_varchar2_table(4) := '434147442C6D422C434143432C592C434143412C67422C434147442C75422C434143432C552C434147442C34432C434143432C552C434143412C6D422C43414D442C32422C434143432C4F2C434143412C552C434143412C652C434143412C69422C4341';
wwv_flow_api.g_varchar2_table(5) := '43412C552C434143412C532C434143412C632C434147442C67422C43414F412C75422C43414E492C612C434143412C552C434143412C69422C434143412C552C4341474A2C75422C434143432C4F2C434149412C38422C434147442C6D422C434143432C';
wwv_flow_api.g_varchar2_table(6) := '6F422C434143412C69422C434143412C532C434143412C572C434143412C71422C434143412C552C434147442C652C434143432C532C43414D442C79422C434143432C632C434143412C552C434143412C512C434143412C652C434143412C532C434143';
wwv_flow_api.g_varchar2_table(7) := '412C632C434143412C652C434143412C632C434143412C67422C434147442C79432C434143432C30432C434143412C30422C434143452C532C434147482C79432C434143432C6B422C434147442C67432C434143432C652C434143412C612C434143412C';
wwv_flow_api.g_varchar2_table(8) := '652C434143412C572C434143412C67422C434147442C632C434143432C652C434147442C32432C434143432C592C434147442C67442C434143432C592C434143412C652C434143412C6B432C434147442C30432C434145432C69422C43414771422C3842';
wwv_flow_api.g_varchar2_table(9) := '2C43414174422C6F422C43414173442C69422C43414372442C71422C434143412C632C43414D442C6F422C434143432C532C434143412C532C434143412C79422C434143412C69422C434143472C6B422C434143412C69422C434143412C6B422C434143';
wwv_flow_api.g_varchar2_table(10) := '412C6D422C434143412C69422C434143412C6D422C434143412C612C4341474A2C592C434143432C592C434147442C592C434143432C7342222C2266696C65223A227374796C652E637373222C22736F7572636573436F6E74656E74223A5B225C6E2F2A';
wwv_flow_api.g_varchar2_table(11) := '20546F206D616B65207468652044796E616D696320436F6E646974696F6E732066616C6C206F6E6520616674657220746865206F74686572202A2F5C6E2E742D466F726D2D6669656C64436F6E7461696E65722D2D666C6F6174696E674C6162656C202E';
wwv_flow_api.g_varchar2_table(12) := '742D466F726D2D6974656D57726170706572207B5C6E5C74666C65782D777261703A20777261703B5C6E7D5C6E5C6E2F2A20546F206D616B652074686520457965206F6E20746F7020202A2F5C6E7370616E2E617065782D6974656D2D69636F6E2E6170';
wwv_flow_api.g_varchar2_table(13) := '2D70617373776F72642D657965207B5C6E202020206F726465723A20333B5C6E202020206C6566743A202D302E3172656D21696D706F7274616E743B5C6E202020207A2D696E6465783A20323B5C6E20202020706F736974696F6E3A2072656C61746976';
wwv_flow_api.g_varchar2_table(14) := '653B5C6E20202020706F696E7465722D6576656E74733A20616C6C3B5C6E5C74626F782D736861646F773A20302E3172656D20302030202364666466646620696E73657421696D706F7274616E743B5C6E20202020636F6C6F723A20233430343034303B';
wwv_flow_api.g_varchar2_table(15) := '5C6E7D5C6E7370616E2E617065782D6974656D2D69636F6E2E61702D70617373776F72642D6579653A3A6166746572207B5C6E5C746D617267696E2D72696768743A20303B5C6E5C746D617267696E2D626F74746F6D3A20303B5C6E5C7472696768743A';
wwv_flow_api.g_varchar2_table(16) := '2033253B5C6E5C74626F74746F6D3A203233253B5C6E7D5C6E5C6E7370616E2E617065782D6974656D2D69636F6E2E61702D636170732D6C6F636B207B5C6E5C746F726465723A20333B5C6E202020206C6566743A202D332E3172656D3B5C6E20202020';
wwv_flow_api.g_varchar2_table(17) := '7A2D696E6465783A20323B5C6E20202020706F696E7465722D6576656E74733A20616C6C3B5C6E20202020706F736974696F6E3A2072656C61746976653B5C6E5C74626F782D736861646F773A206E6F6E653B5C6E20202020636F6C6F723A2023343034';
wwv_flow_api.g_varchar2_table(18) := '3034303B5C6E7D5C6E5C6E2E666F732D61702D636F6E73747261696E7473203E206469767B5C6E5C746D617267696E3A203370783B5C6E7D5C6E5C6E2E666F732D61702D72756C652D636F6E7461696E6572207B5C6E5C74666C65782D64697265637469';
wwv_flow_api.g_varchar2_table(19) := '6F6E3A20636F6C756D6E3B5C6E7D5C6E5C6E2E666F732D61702D696E6E65722D636F6E7461696E6572207B5C6E5C74646973706C61793A20666C65783B5C6E7D5C6E5C6E2E666F732D61702D72756C652D636F6E7461696E65722D73747265746368207B';
wwv_flow_api.g_varchar2_table(20) := '5C6E5C74666C65782D646972656374696F6E3A20726F773B5C6E5C74666C65782D777261703A20777261703B5C6E7D5C6E5C6E2E666F732D61702D636F6E73747261696E7473207B5C6E5C74646973706C61793A20666C65783B5C6E5C7470616464696E';
wwv_flow_api.g_varchar2_table(21) := '672D6C6566743A203170783B5C6E7D5C6E5C6E2E666F732D61702D6F757465722D636F6E7461696E6572207B5C6E5C7477696474683A20313030253B5C6E7D5C6E5C6E2E617065782D6974656D2D6861732D69636F6E3A64697361626C6564207E202E61';
wwv_flow_api.g_varchar2_table(22) := '7065782D6974656D2D69636F6E7B5C6E5C746F7061636974793A202E353B5C6E5C74706F696E7465722D6576656E74733A206E6F6E653B5C6E7D5C6E5C6E2F2A5C6E2A5C7450617373776F726420737472656E677468206261725C6E2A2F5C6E2E666F73';
wwv_flow_api.g_varchar2_table(23) := '2D737472656E6774682D6261722D636F6E7461696E6572207B5C6E5C746F726465723A20343B5C6E5C7477696474683A20313030253B5C6E5C74666C65782D62617369733A20313030253B5C6E5C74706F736974696F6E3A2072656C61746976653B5C6E';
wwv_flow_api.g_varchar2_table(24) := '5C746865696768743A203370783B5C6E5C746F7061636974793A20303B5C6E5C746D617267696E2D746F703A203270783B5C6E7D5C6E5C6E2E666F732D737472656E6774682D6267207B5C6E20202020646973706C61793A20626C6F636B3B5C6E202020';
wwv_flow_api.g_varchar2_table(25) := '2077696474683A20313030253B5C6E20202020706F736974696F6E3A206162736F6C7574653B5C6E202020206865696768743A203370783B5C6E7D5C6E5C6E2E666F732D737472656E6774682D636F6E7461696E6572207B5C6E5C7477696474683A2030';
wwv_flow_api.g_varchar2_table(26) := '3B5C6E5C74646973706C61793A20626C6F636B3B5C6E5C74706F736974696F6E3A206162736F6C7574653B5C6E5C746865696768743A203370783B5C6E5C747472616E736974696F6E3A20616C6C202E347320656173652D696E2D6F75743B5C6E7D5C6E';
wwv_flow_api.g_varchar2_table(27) := '5C6E2E666F732D737472656E6774682D73706C6974207B5C6E5C74646973706C61793A20696E6C696E652D626C6F636B3B5C6E5C74706F736974696F6E3A206162736F6C7574653B5C6E5C7477696474683A203170783B5C6E5C747A2D696E6465783A20';
wwv_flow_api.g_varchar2_table(28) := '3130303B5C6E5C746261636B67726F756E642D636F6C6F723A2077686974653B5C6E5C746865696768743A203370783B5C6E7D5C6E5C6E2E666F732D6261722D616374697665207B5C6E5C746F7061636974793A20313B5C6E7D5C6E5C6E2F2A5C6E2A20';
wwv_flow_api.g_varchar2_table(29) := '436F6C6C61707369626C6520636F6E747261696E747320726567696F6E5C6E2A2F5C6E2E666F732D61702D636F6E73747261696E74732D7469746C65207B5C6E5C74637572736F723A20706F696E7465723B5C6E5C7477696474683A20313030253B5C6E';
wwv_flow_api.g_varchar2_table(30) := '5C74626F726465723A206E6F6E653B5C6E5C74746578742D616C69676E3A206C6566743B5C6E5C746F75746C696E653A206E6F6E653B5C6E5C746D617267696E2D746F703A203370783B5C6E5C746F766572666C6F773A2068696464656E3B5C6E5C7466';
wwv_flow_api.g_varchar2_table(31) := '6F6E742D73697A653A20313270783B5C6E5C7470616464696E672D6C6566743A203170783B5C6E7D5C6E5C6E2E666F732D61702D636F6E73747261696E74732D7469746C652E666F732D76616C75652D6C65617665207B5C6E5C747472616E736974696F';
wwv_flow_api.g_varchar2_table(32) := '6E3A20616C6C202E32732063756269632D62657A69657228312E302C20302E352C20302E382C20312E30293B5C6E5C747472616E73666F726D3A207472616E736C61746559282D377078293B5C6E20205C746F7061636974793A20303B5C6E7D5C6E5C6E';
wwv_flow_api.g_varchar2_table(33) := '2E666F732D61702D636F6E73747261696E74732D7469746C652E666F732D76616C75652D656E746572207B5C6E5C747472616E736974696F6E3A20616C6C202E31733B5C6E7D5C6E5C6E2E666F732D61702D636F6E73747261696E74732D7469746C653A';
wwv_flow_api.g_varchar2_table(34) := '6265666F7265207B5C6E5C74636F6E74656E743A20275C5C30303242273B5C6E5C74636F6C6F723A206C69676874677261793B5C6E5C74666F6E742D7765696768743A20626F6C643B5C6E5C74666C6F61743A2072696768743B5C6E5C746D617267696E';
wwv_flow_api.g_varchar2_table(35) := '2D72696768743A203570783B5C6E7D5C6E5C6E2E6163746976653A6265666F7265207B5C6E5C74636F6E74656E743A205C225C5C323231325C223B5C745C6E7D5C6E5C6E2E666F732D61702D636F6E73747261696E74732E666F732D61702D636F6E7461';
wwv_flow_api.g_varchar2_table(36) := '696E65722D68696464656E207B5C6E5C74646973706C61793A206E6F6E653B5C6E7D5C6E5C6E2E666F732D61702D636F6E73747261696E74732E666F732D61702D636F6E7461696E65722D636F6C6C61707369626C65207B5C6E5C746D61782D68656967';
wwv_flow_api.g_varchar2_table(37) := '68743A20303B5C6E5C746F766572666C6F773A2068696464656E3B5C6E5C747472616E736974696F6E3A206D61782D68656967687420302E327320656173652D6F75743B5C6E7D5C6E5C6E2E666F732D61702D636F6E7461696E65722D636F6C6C617073';
wwv_flow_api.g_varchar2_table(38) := '69626C65202E666F732D61702D72756C65207B5C6E5C746D617267696E3A203070783B5C6E5C746D617267696E2D72696768743A20313070783B5C6E7D5C6E5C6E2E666F732D61702D72756C65207370616E2E66612C202E666F732D61702D636F6E7374';
wwv_flow_api.g_varchar2_table(39) := '7261696E74732D7469746C65207370616E2C202E666F732D61702D72756C652D74657874207B5C6E5C74766572746963616C2D616C69676E3A206D6964646C653B5C6E5C74666F6E742D73697A653A20313270783B5C6E7D5C6E5C6E2F2A5C6E2A20696E';
wwv_flow_api.g_varchar2_table(40) := '6C696E652069636F6E5C6E2A2F5C6E2E666F732D61702D696E6C696E652D636865636B207B5C6E5C746F7061636974793A20313B5C6E5C747A2D696E6465783A20333B5C6E5C74626F782D736861646F773A206E6F6E6521696D706F7274616E743B5C6E';
wwv_flow_api.g_varchar2_table(41) := '5C746F726465723A203321696D706F7274616E743B5C6E20202020706F696E7465722D6576656E74733A20616C6C3B5C6E20202020706F736974696F6E3A2072656C61746976653B5C6E202020206C696E652D6865696768743A20342E3872656D3B5C6E';
wwv_flow_api.g_varchar2_table(42) := '202020206D617267696E2D6C6566743A202D332E3272656D3B5C6E20202020746578742D616C69676E3A2063656E7465723B5C6E202020207472616E736974696F6E3A202E327320656173653B5C6E20202020666C65782D736872696E6B3A20303B5C6E';
wwv_flow_api.g_varchar2_table(43) := '7D5C6E5C6E2E666F732D61702D73686F77207B5C6E5C74646973706C61793A20666C65783B5C6E7D5C6E5C6E2E666F732D61702D68696465207B5C6E5C74646973706C61793A206E6F6E6521696D706F7274616E743B5C6E7D5C6E225D7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(112909448996745239)
,p_plugin_id=>wwv_flow_api.id(98504124924145200)
,p_file_name=>'style.css.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done


