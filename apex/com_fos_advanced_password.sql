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
--     PLUGIN: 412155278231616931
--     PLUGIN: 1200087692794692554
--     PLUGIN: 461352325906078083
--     PLUGIN: 13235263798301758
--     PLUGIN: 37441962356114799
--     PLUGIN: 1846579882179407086
--     PLUGIN: 8354320589762683
--     PLUGIN: 50031193176975232
--     PLUGIN: 106296184223956059
--     PLUGIN: 35822631205839510
--     PLUGIN: 2674568769566617
--     PLUGIN: 14934236679644451
--     PLUGIN: 2600618193722136
--     PLUGIN: 2657630155025963
--     PLUGIN: 284978227819945411
--     PLUGIN: 56714461465893111
--     PLUGIN: 98648032013264649
--     PLUGIN: 455014954654760331
--     PLUGIN: 98504124924145200
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
'    ( p_item   in            apex_plugin.t_item',
'    , p_plugin in            apex_plugin.t_plugin',
'    , p_param  in            apex_plugin.t_item_render_param',
'    , p_result in out nocopy apex_plugin.t_item_render_result ',
'    ) ',
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
'begin',
'    --debug',
'    if apex_application.g_debug ',
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
'            if l_rule_minimum_length',
'            then      ',
'                sys.htp.p(''<div class="fos-ap-rule password-rule-length" name="FOSpwdLength">'');',
'                sys.htp.p(''    <span class="fa fos-pwd-fail fos-pwd"></span>'');',
'                sys.htp.p(''    <span class="fos-ap-rule-text"> '' || l_min_length_msg_esc || '' </span>'');',
'                sys.htp.p(''</div>''); ',
'            end if; ',
'',
'            if l_rule_numbers ',
'            then ',
'                sys.htp.p(''<div class="fos-ap-rule password-rule-numbers" name="FOSpwdNums">'');',
'                sys.htp.p(''    <span class="fa fos-pwd-fail fos-pwd"></span>''); ',
'                sys.htp.p(''    <span class="fos-ap-rule-text"> '' || l_num_msg_esc || '' </span> '');',
'                sys.htp.p(''</div>''); ',
'            end if;',
'',
'            if l_rule_capital_letters ',
'            then',
'                sys.htp.p(''<div class="fos-ap-rule password-rule-capital-letters" name="FOSpwdCapitals">''); ',
'                sys.htp.p(''    <span class="fa fos-pwd-fail fos-pwd"></span>''); ',
'                sys.htp.p(''    <span class="fos-ap-rule-text"> '' || l_capital_letters_msg_esc || ''</span>'');',
'                sys.htp.p(''</div>'');',
'            end if; ',
'',
'            if l_rule_special_characters',
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
'    ',
'    apex_json.open_object(''rules'');  ',
'    ',
'    if l_rule_minimum_length',
'    then',
'        apex_json.open_object(''pwdLength''                            );',
'        apex_json.open_object(''attributes''                           );',
'        apex_json.write(''length''          , l_min_length             );',
'        apex_json.close_object;',
'        apex_json.close_object;',
'    end if;',
'',
'    if l_rule_numbers',
'    then',
'        apex_json.open_object(''pwdNums''                              );',
'        apex_json.open_object(''attributes''                           );',
'        apex_json.write(''length''         , l_num_of_nums             );',
'        apex_json.close_object;',
'        apex_json.close_object;',
'    end if;',
'    ',
'    if l_rule_capital_letters',
'    then',
'        apex_json.open_object(''pwdCapitals'');',
'        apex_json.open_object(''attributes'');',
'        apex_json.write(''length''         , l_num_of_capital_letters  );    ',
'        apex_json.close_object;',
'        apex_json.close_object;',
'    end if;',
'    ',
'    if l_rule_special_characters ',
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
'    ( p_item     in apex_plugin.t_item',
'    , p_plugin   in apex_plugin.t_plugin',
'    , p_param    in apex_plugin.t_item_validation_param',
'    , p_result   in out nocopy apex_plugin.t_item_validation_result',
'    )',
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
'    ',
'    l_confirmation_item             p_item.attribute_15%type   := p_item.attribute_15;',
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
'    if l_rule_minimum_length',
'    then',
'        if length(l_value) < l_min_length',
'        then',
'            p_result.message := l_min_length_msg_esc;',
'            return;',
'        end if;',
'    end if;',
'    ',
'    -- check if it contains numbers',
'    if l_rule_numbers',
'    then',
'        if not regexp_like(l_value,''([0-9].*){''|| l_num_of_nums ||'',}'')',
'        then',
'            p_result.message := l_num_msg_esc;',
'            return;',
'        end if;',
'    end if;',
'    ',
'    -- check for spec characters',
'    if l_rule_special_characters',
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
'    if l_rule_capital_letters',
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
,p_version_identifier=>'21.1.0'
,p_about_url=>'https://fos.world'
,p_plugin_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Settings for the FOS browser extension',
'@fos-auto-return-to-page',
'@fos-auto-open-files:script.js'))
,p_files_version=>4410
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
end;
/
begin
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
wwv_flow_api.g_varchar2_table(2) := '64203D20464F532E6974656D2E616476616E63656450617373776F726420207C7C207B7D3B0A0A2F2A2A0A202A0A202A2040706172616D207B6F626A6563747D20202009636F6E6669672009202020202020202020202020202020202020202009436F6E';
wwv_flow_api.g_varchar2_table(3) := '66696775726174696F6E206F626A65637420636F6E7461696E696E672074686520706C7567696E2073657474696E67730A202A2040706172616D207B737472696E677D20202009636F6E6669672E6974656D4E616D652020202020202020202020202009';
wwv_flow_api.g_varchar2_table(4) := '546865206E616D65206F6620746865206974656D0A202A2040706172616D207B6F626A6563747D20202009636F6E6669672E72756C657320202020202020202020202020202020094F626A65637420686F6C64696E6720696E666F726D6174696F6E2061';
wwv_flow_api.g_varchar2_table(5) := '626F7574207468652073656C65637465642076616C69646174696F6E2072756C65730A202A2040706172616D207B626F6F6C65616E7D0909636F6E6669672E73686F77436170734C6F636B090909095768656E2074727565207468656E20616E2069636F';
wwv_flow_api.g_varchar2_table(6) := '6E2077696C6C20626520646973706C61796564206966207468652043617073204C6F636B206973206163746976650A202A2040706172616D207B737472696E677D0909636F6E6669672E7077645065656B0909090909546865207374796C65206F662074';
wwv_flow_api.g_varchar2_table(7) := '686520277065656B272066756E6374696F6E616C6974790A202A2040706172616D207B737472696E677D09202020205B636F6E6669672E6973436F6E6669726D6174696F6E4974656D5D09094D75737420746F20626520747275652C2069662074686520';
wwv_flow_api.g_varchar2_table(8) := '696E7374616E6365206973206120636F6E6669726D6174696F6E73287365636F6E6461727929206974656D0A202A2040706172616D207B737472696E677D09095B636F6E6669672E7065656B53686F776E49636F6E5D09090949636F6E20746F20626520';
wwv_flow_api.g_varchar2_table(9) := '646973706C61796564207768656E207468652070617373776F72642069732072657665616C65640A202A2040706172616D207B737472696E677D09095B636F6E6669672E7065656B48696464656E49636F6E5D09090949636F6E20746F20626520646973';
wwv_flow_api.g_varchar2_table(10) := '706C61796564207768656E207468652070617373776F72642069732068696464656E20200A202A2040706172616D207B626F6F6C65616E7D0909636F6E6669672E73686F77537472656E6774684261720909095768656E2074727565207468656E206120';
wwv_flow_api.g_varchar2_table(11) := '6261722077696C6C20626520646973706C6179656420756E64657220746865206974656D2077686963682073686F777320746865207374617465206F662074686520636F6D706C657465642076616C69646174696F6E2072756C65730A202A2040706172';
wwv_flow_api.g_varchar2_table(12) := '616D207B737472696E677D09095B636F6E6669672E737472656E6774684261725374796C655D09095374796C65206F662074686520737472656E67746820626172205B64796E616D6963207C207374617469635D0A202A2040706172616D207B73747269';
wwv_flow_api.g_varchar2_table(13) := '6E677D0909636F6E6669672E72756C6573436F6E7461696E6572090909546865207374796C65206F662074686520636F6E7461696E657220776869636820636F6E7461696E732074686520696E646976696475616C2072756C6573205B636F6C6C617073';
wwv_flow_api.g_varchar2_table(14) := '69626C65207C20737461746963207C2068696464656E5D0A202A2040706172616D207B737472696E677D0909636F6E6669672E72756C6573436F6E7461696E65724964090909546865204944206F6620746865207461726765742065787465726E616C20';
wwv_flow_api.g_varchar2_table(15) := '72756C657320636F6E7461696E657220656C656D656E742E0A202A2040706172616D207B737472696E677D09095B636F6E6669672E72756C6573436F6D70546578745D090909496620746865202772756C65732D636F6E7461696E65722720697320636F';
wwv_flow_api.g_varchar2_table(16) := '6C6C61707369626C652C207468656E20612073756363657373206D6573736167652063616E20626520646973706C61796564207768656E20616C6C207468652072756C6573207061737365640A202A2040706172616D207B737472696E677D09095B636F';
wwv_flow_api.g_varchar2_table(17) := '6E6669672E72756C6573436865636B49636F6E5D0909095468652069636F6E2077686963682077696C6C2062652075736564207768656E20616E20696E646976696475616C2072756C652069732066756C66696C6C65640A202A2040706172616D207B73';
wwv_flow_api.g_varchar2_table(18) := '7472696E677D09095B636F6E6669672E72756C65734661696C49636F6E5D0909095468652069636F6E2077686963682077696C6C2062652075736564207768656E20616E20696E646976696475616C2072756C65206973206661696C65647A0A202A2040';
wwv_flow_api.g_varchar2_table(19) := '706172616D207B737472696E677D09202020205B636F6E6669672E696E6C696E65436865636B49636F6E5D0909496620697427732070726F76696465642C207468656E20746869732069636F6E2077696C6C20626520646973706C6179656420696E2074';
wwv_flow_api.g_varchar2_table(20) := '6865206974656D207768656E2074686520696E707574206669656C64206265636F6D65732076616C69640A202A2040706172616D207B737472696E677D09202020205B636F6E6669672E696E6C696E654661696C49636F6E5D0909094966206974277320';
wwv_flow_api.g_varchar2_table(21) := '70726F76696465642C207468656E20746869732069636F6E2077696C6C20626520646973706C6179656420696E20746865206974656D207768656E2074686520696E707574206669656C6420697320696E76616C69640A202A2040706172616D207B7374';
wwv_flow_api.g_varchar2_table(22) := '72696E677D09095B636F6E6669672E6361704C6F636B49636F6E5D0909095468652069636F6E20776869636820696E64696361746573207768656E2074686520436170734C6F636B206973207475726E65640A202A2040706172616D207B61727261797D';
wwv_flow_api.g_varchar2_table(23) := '0909636F6E6669672E6974656D73546F44697361626C650909094172726179206F662070616765206974656D73282F627574746F6E73292E2054686520656C656D656E7473206F662074686973206C6973742077696C6C2064697361626C656420617320';
wwv_flow_api.g_varchar2_table(24) := '6C6F6E6720617320616C6C207468652072756C657320617265206E6F7420636F6D706C65746564200909090A202A2040706172616D207B737472696E677D0909636F6E6669672E636F6E664974656D0909090909436F6E6669726D6174696F6E20697465';
wwv_flow_api.g_varchar2_table(25) := '6D2E20496620697427732070726F76696465642C207468656E20746865206974656D7320696E2074686520276974656D73546F44697361626C65272061727261792061726520646570656E64696E67206F6E207468697320656C656D656E742773207374';
wwv_flow_api.g_varchar2_table(26) := '6174650A202A2040706172616D207B737472696E677D09095B636F6E6669672E636F6E664974656D4572726F724D6573736167655D094572726F72206D657373616765206966207468652070617373776F72647320646F206E6F74206D617463680A202A';
wwv_flow_api.g_varchar2_table(27) := '2040706172616D207B737472696E677D09095B636F6E6669672E6572726F724D6573736167655D0909094572726F72206D6573736167652069662074686520746865207468652072756C657320617265206E6F74207061737365640A202A204070617261';
wwv_flow_api.g_varchar2_table(28) := '6D207B737472696E677D09095B636F6E6669672E6572726F72436F6C6F725D09090909436F6C6F72206F6620746865206661696C65642069636F6E732F72756C65730A202A2040706172616D207B737472696E677D09095B636F6E6669672E7375636365';
wwv_flow_api.g_varchar2_table(29) := '7373436F6C6F725D090909436F6C6F72206F662074686520636F6D706C657465642069636F6E732F72756C65732F737472656E6774682D6261720A202A2040706172616D207B737472696E677D09095B636F6E6669672E737472656E6774684261724267';
wwv_flow_api.g_varchar2_table(30) := '436F6C6F725D09094261636B67726F756E6420636F6C6F72206F662074686520737472656E677468206261720A202A2040706172616D207B6E756D6265727D09095B636F6E6669672E737472656E67746842617257696474685063745D09576964746820';
wwv_flow_api.g_varchar2_table(31) := '6F662074686520737472656E6774206261722072656C617469766520746F2074686520696E707574206669656C640A202A2040706172616D207B66756E6374696F6E7D202009696E69744A7320200909090909094F7074696F6E616C20496E697469616C';
wwv_flow_api.g_varchar2_table(32) := '697A6174696F6E204A61766153637269707420436F64652066756E6374696F6E0A202A2F0A0A464F532E6974656D2E616476616E63656450617373776F72642E696E6974203D2066756E6374696F6E28636F6E6669672C20696E69744A73297B0A092F2F';
wwv_flow_api.g_varchar2_table(33) := '2064656661756C742076616C75657320746F20746865206174747269627574657320746861742063616E20626520736574206F6E6C792074726F75676820696E69744A730A09636F6E6669672E7065656B53686F776E49636F6E0909203D202766612D65';
wwv_flow_api.g_varchar2_table(34) := '7965273B0A09636F6E6669672E7065656B48696464656E49636F6E0909203D202766612D6579652D736C617368273B0A09636F6E6669672E636170734C6F636B49636F6E09092009203D202766612D6368616E67652D63617365273B0A09636F6E666967';
wwv_flow_api.g_varchar2_table(35) := '2E72756C6573436865636B49636F6E0909203D202766612D636865636B2D636972636C652D6F273B0A09636F6E6669672E72756C65734661696C49636F6E0909203D202766612D74696D65732D636972636C652D6F273B0A09636F6E6669672E696E6C69';
wwv_flow_api.g_varchar2_table(36) := '6E65436865636B49636F6E0909203D202766612D636865636B2D636972636C652D6F273B0A09636F6E6669672E696E6C696E654661696C49636F6E0909203D202766612D74696D65732D636972636C652D6F273B0A09636F6E6669672E6572726F724D65';

wwv_flow_api.g_varchar2_table(37) := '737361676509092009203D2027496E76616C69642070617373776F72642E273B0A09636F6E6669672E636F6E664974656D4572726F724D65737361676520203D202750617373776F72647320646F206E6F74206D617463682E273B0A09636F6E6669672E';
wwv_flow_api.g_varchar2_table(38) := '737472656E6774684261725374796C65092009203D202764796E616D6963273B0A09636F6E6669672E73756363657373436F6C6F72090920202020203D202723356163323430273B0A09636F6E6669672E6572726F72436F6C6F72090909203D20272365';
wwv_flow_api.g_varchar2_table(39) := '6234303334273B0A09636F6E6669672E737472656E6774684261724267436F6C6F72202020203D202723373738383939273B0A09636F6E6669672E737472656E677468426172576964746850637409203D203130303B0A0A092F2F206578656375746520';
wwv_flow_api.g_varchar2_table(40) := '74686520696E69744A732066756E6374696F6E0A09696628696E69744A7320262620696E69744A7320696E7374616E63656F662046756E6374696F6E297B0A0909696E69744A732E63616C6C28746869732C636F6E666967293B0A097D0A096C65742069';
wwv_flow_api.g_varchar2_table(41) := '74656D4E616D65203D20636F6E6669672E6974656D4E616D653B0A096C6574206974656D526567696F6E203D2024282723272B6974656D4E616D652B275F726567696F6E27293B0A092F2F2074686520696E707574206669656C6420697473656C660A09';
wwv_flow_api.g_varchar2_table(42) := '6C657420696E7075744669656C64203D2024282723272B6974656D4E616D65293B0A092F2F2072657175697265642072756C65730A096C65742072756C6573203D20636F6E6669672E72756C65733B0A092F2F20746865206E756D626572206F66207275';
wwv_flow_api.g_varchar2_table(43) := '6C65730A096C657420746573744E756D203D204F626A6563742E6B6579732872756C6573292E6C656E6774683B0A092F2F2063616C63756C61746520746865206E756D626572206F6620736570617261746F727320696E2074686520737472656E677468';
wwv_flow_api.g_varchar2_table(44) := '206261720A096C657420736570506F73203D204D6174682E666C6F6F7228313030202F20746573744E756D293B0A092F2F2077652073746F726520746865207374617465206F662065766572792072756C6520696E20616E206F626A6563740A096C6574';
wwv_flow_api.g_varchar2_table(45) := '20746573745374617465203D207B7D3B0A092F2F2074686520737472656E67746862617220656C656D656E740A096C657420737472656E677468426172456C2C7469746C65456C2C72756C6573436F6E7461696E6572456C3B0A092F2F2073686F772073';
wwv_flow_api.g_varchar2_table(46) := '7472656E677468206261720A096C657420737472656E6774684261725769647468506374203D20636F6E6669672E737472656E6774684261725769647468506374202F203130303B0A0A096C6574206C656E456C20203D206974656D526567696F6E2E66';
wwv_flow_api.g_varchar2_table(47) := '696E6428272E70617373776F72642D72756C652D6C656E677468202E666F732D70776427293B0A096C6574206E756D456C20203D206974656D526567696F6E2E66696E6428272E70617373776F72642D72756C652D6E756D62657273202E666F732D7077';
wwv_flow_api.g_varchar2_table(48) := '6427293B0A096C65742073706563456C203D206974656D526567696F6E2E66696E6428272E70617373776F72642D72756C652D7370656369616C2D63686172616374657273202E666F732D70776427293B0A096C657420636170456C20203D206974656D';
wwv_flow_api.g_varchar2_table(49) := '526567696F6E2E66696E6428272E70617373776F72642D72756C652D6361706974616C2D6C657474657273202E666F732D70776427293B0A0A09636F6E737420464F535F41505F48494444454E5F434C415353203D2027666F732D61702D68696465273B';
wwv_flow_api.g_varchar2_table(50) := '0A09636F6E73742052554C455F434F4D504C4554455F4556454E54203D2027666F732D61702D72756C652D636F6D706C657465273B0A09636F6E73742052554C455F414C4C5F434F4D504C4554455F4556454E54203D2027666F732D61702D6576657279';
wwv_flow_api.g_varchar2_table(51) := '2D72756C652D636F6D706C657465273B0A09636F6E73742052554C455F4641494C5F4556454E54203D2027666F732D61702D72756C652D6661696C273B0A09636F6E737420494E56414C49445F4649454C445F4556454E54203D2027666F732D61702D69';
wwv_flow_api.g_varchar2_table(52) := '6E76616C69642D6669656C64273B0A0A09666F72286C6574206B657920696E2072756C6573297B0A090969662872756C65735B6B65795D297B0A0909097465737453746174655B6B65795D203D2066616C73653B0A09097D0A097D0A092F2F2063686563';
wwv_flow_api.g_varchar2_table(53) := '6B2069662074686572652773206174206C65617374206F6E652072756C652061646465642073656C65637465640A096C65742076616C69646174655265717569726564203D20216A51756572792E6973456D7074794F626A656374287465737453746174';
wwv_flow_api.g_varchar2_table(54) := '65292026262021636F6E6669672E6973436F6E6669726D6174696F6E4974656D3B0A0A092F2F20696E6C696E6520636865636B2069636F6E0A096C657420696E6C696E6549636F6E456C3B0A09696628636F6E6669672E696E6C696E6549636F6E297B0A';
wwv_flow_api.g_varchar2_table(55) := '0909696E6C696E6549636F6E456C203D206974656D526567696F6E2E66696E6428277370616E2E666F732D61702D696E6C696E652D636865636B27293B0A0909696E6C696E6549636F6E456C2E616464436C617373285B636F6E6669672E696E6C696E65';
wwv_flow_api.g_varchar2_table(56) := '4661696C49636F6E2C20464F535F41505F48494444454E5F434C4153535D293B0A0909696E6C696E6549636F6E456C2E637373287B276C656674273A20272D2E3272656D272C2027636F6C6F72273A20636F6E6669672E6572726F72436F6C6F727D293B';
wwv_flow_api.g_varchar2_table(57) := '0A09096966282176616C696461746552657175697265642026262021636F6E6669672E6973436F6E6669726D6174696F6E4974656D297B0A090909696E7075744669656C642E6F6E2827666F637573272C2066756E6374696F6E2865297B0A0909090969';
wwv_flow_api.g_varchar2_table(58) := '6E6C696E6549636F6E456C2E72656D6F7665436C61737328464F535F41505F48494444454E5F434C415353293B0A0909097D293B0A090909696E7075744669656C642E6F6E2827696E707574272C2066756E6374696F6E2865297B0A09090909746F6767';
wwv_flow_api.g_varchar2_table(59) := '6C65496E6C696E6549636F6E28696E6C696E6549636F6E456C2C20652E63757272656E745461726765742E76616C75652E6C656E677468203E2030293B0A0909097D293B0A09097D0A097D0A0A092F2F206164642076616C69646174696F6E2069662072';
wwv_flow_api.g_varchar2_table(60) := '657175697265640A0969662876616C69646174655265717569726564297B0A0909696E7075744669656C642E6F6E28276B65797570206368616E6765272C2066756E6374696F6E2865297B0A090909696628636F6E6669672E696E6C696E6549636F6E29';
wwv_flow_api.g_varchar2_table(61) := '7B0A090909096973457665727952756C655061737365642866756E6374696F6E28297B0A0909090909746F67676C65496E6C696E6549636F6E28696E6C696E6549636F6E456C2C66616C7365293B0A090909097D293B0A0909097D090A09090976616C69';
wwv_flow_api.g_varchar2_table(62) := '646174652865293B0A09097D293B0A097D0A090A092F2F20746865205065656B2066756E6374696F6E616C6974790A09696628636F6E6669672E7077645065656B20213D202764697361626C656427297B0A0909636F6E6669672E7065656B4869646465';
wwv_flow_api.g_varchar2_table(63) := '6E49636F6E203D20636F6E6669672E7065656B48696464656E49636F6E2E73706C697428272027293B0A0909636F6E6669672E7065656B53686F776E49636F6E203D20636F6E6669672E7065656B53686F776E49636F6E2E73706C697428272027293B0A';
wwv_flow_api.g_varchar2_table(64) := '09096C65742073686F7749636F6E203D206974656D526567696F6E2E66696E6428272E61702D70617373776F72642D65796527293B0A090973686F7749636F6E2E616464436C61737328636F6E6669672E7065656B48696464656E49636F6E293B0A0909';
wwv_flow_api.g_varchar2_table(65) := '2F2F20657874656E642074686520696E707574206669656C640A0909696E7075744669656C642E637373287B2770616464696E672D7269676874273A27332E3372656D277D293B0A09092F2F20746F2061766F6964206F7665726C617070696E672C2077';
wwv_flow_api.g_varchar2_table(66) := '65206861766520746F206D6F646966792074686520696E6C696E652069636F6E277320706F736974696F6E0A0909696628636F6E6669672E696E6C696E6549636F6E297B0A090909696E6C696E6549636F6E456C2E637373287B276C656674273A20272D';
wwv_flow_api.g_varchar2_table(67) := '332E3372656D277D293B0A09097D0A09092F2F2061646420746865206C697374656E657273206261736564206F6E207468652073657474696E67730A0909696628636F6E6669672E7077645065656B203D3D3D2027656E61626C65642D636C69636B2D70';
wwv_flow_api.g_varchar2_table(68) := '7265737327297B0A09090973686F7749636F6E2E6F6E28276D6F7573657570206D6F7573656C6561766520746F756368656E64272C2068696465507764293B0A09090973686F7749636F6E2E6F6E28276D6F757365646F776E272C2066756E6374696F6E';
wwv_flow_api.g_varchar2_table(69) := '2865297B0A09090909696628652E627574746F6E203D3D3D2030297B0A090909090973686F775077642E63616C6C2873686F7749636F6E293B0A090909097D0A0909097D293B0A09090973686F7749636F6E2E6F6E2827746F7563687374617274272C20';
wwv_flow_api.g_varchar2_table(70) := '66756E6374696F6E2865297B0A090909096C657420746F756368203D20652E746F75636865735B305D3B0A090909096C6574207349636F6E203D20646F63756D656E742E656C656D656E7446726F6D506F696E7428746F7563682E636C69656E74582C74';
wwv_flow_api.g_varchar2_table(71) := '6F7563682E636C69656E7459293B0A090909096966287349636F6E297B0A090909090973686F775077642E63616C6C2873686F7749636F6E293B0A090909097D0A0909097D293B0A09097D20656C736520696628636F6E6669672E7077645065656B203D';
wwv_flow_api.g_varchar2_table(72) := '3D3D2027656E61626C65642D746F67676C6527297B0A09090973686F7749636F6E2E6F6E2827636C69636B272C20746F67676C65507764293B0A09097D0A097D0A092F2F2073686F7720636170734C6F636B206F6E0A09696628636F6E6669672E73686F';
wwv_flow_api.g_varchar2_table(73) := '77436170734C6F636B297B0A09096C6574206361707349636F6E203D206974656D526567696F6E2E66696E6428272E61702D636170732D6C6F636B27293B0A09096361707349636F6E2E616464436C617373285B636F6E6669672E636170734C6F636B49';
wwv_flow_api.g_varchar2_table(74) := '636F6E2C464F535F41505F48494444454E5F434C4153535D293B0A09092F2F20746F2061766F6964206F7665726C617070696E67207765206861766520746F206D6F64696679207468652069636F6E277320706F736974696F6E0A09096C65742069636F';
wwv_flow_api.g_varchar2_table(75) := '6E506F73203D20636F6E6669672E7077645065656B203D3D3D202764697361626C656427203F20272D2E3272656D27203A20272D332E3372656D273B0A09096361707349636F6E2E637373287B276C656674273A2069636F6E506F737D293B0A09092F2F';
wwv_flow_api.g_varchar2_table(76) := '2068696465207468652069636F6E20696620746865206669656C64206973206E6F74206163746976650A0909696E7075744669656C642E6F6E2827666F6375736F7574272C2066756E6374696F6E2865297B0A090909696628636F6E6669672E696E6C69';
wwv_flow_api.g_varchar2_table(77) := '6E6549636F6E297B0A09090909696E6C696E6549636F6E456C2E72656D6F7665436C61737328464F535F41505F48494444454E5F434C415353293B0A0909097D0A0909096361707349636F6E2E616464436C61737328464F535F41505F48494444454E5F';
wwv_flow_api.g_varchar2_table(78) := '434C415353293B0A09097D293B0A09092F2F2061646420746865206C697374656E6572206F6E20746865206669656C640A0909696E7075744669656C642E6F6E28276B65797570272C2066756E6374696F6E2865297B0A090909696628652E6F72696769';
wwv_flow_api.g_varchar2_table(79) := '6E616C4576656E742E6765744D6F64696669657253746174652827436170734C6F636B2729297B0A09090909696628636F6E6669672E696E6C696E6549636F6E297B0A0909090909696E6C696E6549636F6E456C2E616464436C61737328464F535F4150';
wwv_flow_api.g_varchar2_table(80) := '5F48494444454E5F434C415353293B0A090909097D0A090909096361707349636F6E2E72656D6F7665436C61737328464F535F41505F48494444454E5F434C415353293B0A0909097D20656C7365207B0A09090909696628636F6E6669672E696E6C696E';
wwv_flow_api.g_varchar2_table(81) := '6549636F6E297B0A0909090909696E6C696E6549636F6E456C2E72656D6F7665436C61737328464F535F41505F48494444454E5F434C415353293B0A090909097D0A090909096361707349636F6E2E616464436C61737328464F535F41505F4849444445';
wwv_flow_api.g_varchar2_table(82) := '4E5F434C415353293B0A0909097D0A0909207D293B0A097D0A0A09696628636F6E6669672E72756C6573436F6E7461696E657220213D202768696464656E27297B0A09096974656D526567696F6E2E66696E6428272E666F732D70776427292E65616368';
wwv_flow_api.g_varchar2_table(83) := '2866756E6374696F6E28297B0A0909096C657420656C203D20242874686973293B0A090909656C2E616464436C61737328636F6E6669672E72756C65734661696C49636F6E293B0A090909656C2E637373287B27636F6C6F72273A20636F6E6669672E65';
wwv_flow_api.g_varchar2_table(84) := '72726F72436F6C6F727D293B0A09097D293B0A097D0A0A09696628636F6E6669672E72756C6573436F6E7461696E6572203D3D202765787465726E616C2720262620636F6E6669672E72756C6573436F6E7461696E65724964297B0A09096C6574207265';
wwv_flow_api.g_varchar2_table(85) := '67696F6E456C203D206974656D526567696F6E2E66696E6428272E666F732D61702D636F6E7461696E65722D65787465726E616C27292E64657461636828293B0A09096C657420746172676574456C203D2024282723272B636F6E6669672E72756C6573';
wwv_flow_api.g_varchar2_table(86) := '436F6E7461696E65724964293B0A09096C657420657874436F6E7461696E6572426F6479203D20746172676574456C2E66696E6428272E742D526567696F6E2D626F647927293B0A0909696628657874436F6E7461696E6572426F64792E6C656E677468';
wwv_flow_api.g_varchar2_table(87) := '203D3D3D2031297B0A090909657874436F6E7461696E6572426F64792E617070656E6428726567696F6E456C293B0A09097D20656C7365207B0A090909746172676574456C2E617070656E6428726567696F6E456C293B0A09097D0A097D20656C736520';
wwv_flow_api.g_varchar2_table(88) := '7B0A0909696628636F6E6669672E72756C6573436F6E7461696E657220213D202768696464656E27297B0A0909097469746C65456C203D206974656D526567696F6E2E66696E6428272E666F732D61702D636F6E73747261696E74732D7469746C652729';
wwv_flow_api.g_varchar2_table(89) := '3B0A09090972756C6573436F6E7461696E6572456C203D206974656D526567696F6E2E66696E6428272E666F732D61702D636F6E7461696E657227293B0A090909736574456C656D656E745769647468287469746C65456C293B0A090909736574456C65';
wwv_flow_api.g_varchar2_table(90) := '6D656E7457696474682872756C6573436F6E7461696E6572456C293B0A09097D0A0909696628636F6E6669672E72756C6573436F6E7461696E6572203D3D2027636F6C6C61707369626C65272026262076616C69646174655265717569726564297B0A09';
wwv_flow_api.g_varchar2_table(91) := '09092F2F2073656C65637420746865206669727374206661696C65642072756C650A0909096C65742066616C736552756C65203D206974656D526567696F6E2E66696E6428272E666F732D61702D72756C6527292E666972737428293B0A0909092F2F20';
wwv_flow_api.g_varchar2_table(92) := '7075742074686520636F6E74656E74206F6620697420696E746F20746865207469746C6520656C656D656E740A0909097469746C65456C2E68746D6C2866616C736552756C652E68746D6C2829293B0A0909097469746C65456C2E6174747228276E616D';
wwv_flow_api.g_varchar2_table(93) := '65272C20277469746C65272B66616C736552756C652E6174747228276E616D652729293B0A0909092F2F20616E6420686964652069742066726F6D2074686520636F6E7461696E65720A09090966616C736552756C652E637373287B27646973706C6179';
wwv_flow_api.g_varchar2_table(94) := '273A20276E6F6E65277D293B0A0909092F2F206164642074686520636F6C6C617073652F657870616E642066756E6374696F6E616C6974790A0909097469746C65456C2E6F6E2827636C69636B272C2066756E6374696F6E2865297B0A09090909242874';
wwv_flow_api.g_varchar2_table(95) := '686973292E746F67676C65436C617373282761637469766527293B0A090909096C65742072756C6573436F6E203D2072756C6573436F6E7461696E6572456C3B0A0909090969662872756C6573436F6E2E6865696768742829203E2030297B0A09090909';
wwv_flow_api.g_varchar2_table(96) := '0972756C6573436F6E2E637373287B276D61782D686569676874273A20307D293B0A090909097D20656C7365207B0A090909090972756C6573436F6E2E637373287B276D61782D686569676874273A2072756C6573436F6E2E70726F7028277363726F6C';
wwv_flow_api.g_varchar2_table(97) := '6C48656967687427292B277078277D293B0A090909097D0A0909097D293B0A09097D0A097D0A092F2F2064697361626C65206974656D7320696620696E76616C69640A09696628636F6E6669672E64697361626C654974656D73297B0A09092F2F207265';
wwv_flow_api.g_varchar2_table(98) := '6D6F76652074686520636F6E6669726D6174696F6E20656C656D656E742066726F6D20746865206974656D73546F44697361626C652061727261792C20697427732068616E646C656420696E206120646966666572656E74207761790A0909696628636F';
wwv_flow_api.g_varchar2_table(99) := '6E6669672E636F6E664974656D297B0A0909096C657420636F6E664974656D496478203D20636F6E6669672E6974656D73546F44697361626C652E696E6465784F6628636F6E6669672E636F6E664974656D293B0A090909696628636F6E664974656D49';
wwv_flow_api.g_varchar2_table(100) := '6478203E202D31297B0A09090909636F6E6669672E6974656D73546F44697361626C652E73706C69636528636F6E664974656D4964782C31293B0A0909097D0A09097D0A09097365744974656D735374617465282764697361626C6527293B0A097D0A0A';
wwv_flow_api.g_varchar2_table(101) := '092F2F2073686F77206572726F7220696620696E76616C69640A09696628636F6E6669672E73686F774572726F724966496E632026262076616C69646174655265717569726564297B0A0909696E7075744669656C642E6F6E2827666F6375736F757427';
wwv_flow_api.g_varchar2_table(102) := '2C2066756E6374696F6E2865297B0A0909096973457665727952756C655061737365642866756E6374696F6E28297B0A09090909617065782E6D6573736167652E73686F774572726F7273287B0A0909090909747970653A20276572726F72272C0A0909';
wwv_flow_api.g_varchar2_table(103) := '0909096C6F636174696F6E3A2027696E6C696E65272C0A0909090909706167654974656D3A206974656D4E616D652C0A09090909096D6573736167653A20636F6E6669672E6572726F724D6573736167650A090909097D293B0A09090909617065782E65';
wwv_flow_api.g_varchar2_table(104) := '76656E742E74726967676572282723272B6974656D4E616D652C20494E56414C49445F4649454C445F4556454E542C20746573745374617465293B0A0909097D293B0A09097D293B0A0909696E7075744669656C642E6F6E2827666F637573696E272C20';
wwv_flow_api.g_varchar2_table(105) := '66756E6374696F6E2865297B0A090909617065782E6D6573736167652E636C6561724572726F7273286974656D4E616D65293B0A09097D293B0A097D0A0A09696628636F6E6669672E73686F77537472656E677468426172297B0A09092F2F737472656E';
wwv_flow_api.g_varchar2_table(106) := '6774684261725769647468506374203D20636F6E6669672E737472656E6774684261725769647468506374202F203130303B0A0909737472656E677468426172456C203D206974656D526567696F6E2E66696E6428272E666F732D737472656E6774682D';
wwv_flow_api.g_varchar2_table(107) := '636F6E7461696E657227293B0A09092F2F207365742074686520636F6C6F720A09096C657420626172436F6E7461696E6572203D206974656D526567696F6E2E66696E6428272E666F732D737472656E6774682D6261722D636F6E7461696E657227293B';
wwv_flow_api.g_varchar2_table(108) := '0A0909626172436F6E7461696E65722E66696E6428272E666F732D737472656E6774682D626727292E637373287B276261636B67726F756E642D636F6C6F72273A20636F6E6669672E737472656E6774684261724267436F6C6F727D293B0A0909626172';
wwv_flow_api.g_varchar2_table(109) := '436F6E7461696E65722E66696E6428272E666F732D737472656E6774682D636F6E7461696E657227292E637373287B276261636B67726F756E642D636F6C6F72273A20636F6E6669672E73756363657373436F6C6F727D293B0A0A09092F2F2068617665';
wwv_flow_api.g_varchar2_table(110) := '20746F20726563616C63756C61746520746865207769647468206F662074686520626172206F6E2077696E646F7720726573697A650A090977696E646F772E6164644576656E744C697374656E65722827726573697A65272C66756E6374696F6E286529';
wwv_flow_api.g_varchar2_table(111) := '7B0A090909736574456C656D656E74576964746828626172436F6E7461696E65722C737472656E6774684261725769647468506374293B0A09097D293B0A09092F2F20616E64206F6E206F70656E20616E6420636C6F7365206F66207468652073696465';
wwv_flow_api.g_varchar2_table(112) := '206E61766261720A0909617065782E6A5175657279282223745F547265654E617622292E6F6E28277468656D6534326C61796F75746368616E676564272C2066756E6374696F6E286576656E742C206F626A29207B0A09090973657454696D656F757428';
wwv_flow_api.g_varchar2_table(113) := '66756E6374696F6E28297B0A09090909736574456C656D656E74576964746828626172436F6E7461696E65722C737472656E6774684261725769647468506374293B0A0909097D2C20333030293B0A20202020097D293B0A0A0909736574456C656D656E';
wwv_flow_api.g_varchar2_table(114) := '74576964746828626172436F6E7461696E65722C737472656E6774684261725769647468506374293B0A09090A0909696628636F6E6669672E737472656E6774684261725374796C65203D3D202764796E616D696327297B0A090909696E707574466965';
wwv_flow_api.g_varchar2_table(115) := '6C642E6F6E2827666F637573696E272C2066756E6374696F6E2865297B0A09090909626172436F6E7461696E65722E616464436C6173732827666F732D6261722D61637469766527293B0A0909097D293B0A090909696E7075744669656C642E6F6E2827';
wwv_flow_api.g_varchar2_table(116) := '666F6375736F7574272C2066756E6374696F6E2865297B0A09090909626172436F6E7461696E65722E72656D6F7665436C6173732827666F732D6261722D61637469766527293B0A0909097D293B0A09097D20656C736520696628636F6E6669672E7374';
wwv_flow_api.g_varchar2_table(117) := '72656E6774684261725374796C65203D3D202773746174696327297B0A090909626172436F6E7461696E65722E616464436C6173732827666F732D6261722D61637469766527293B0A09097D0A0A0909666F72286C65742069203D20313B2069203C2074';
wwv_flow_api.g_varchar2_table(118) := '6573744E756D3B20692B2B297B0A090909626172436F6E7461696E65722E617070656E6428273C646976207374796C653D226C6566743A272B20736570506F73202A20692B27252220636C6173733D22666F732D737472656E6774682D73706C6974223E';
wwv_flow_api.g_varchar2_table(119) := '3C2F6469763E27293B0909090A09097D0A097D0A090A092F2F20636F6E6669726D6174696F6E206974656D0A09696628636F6E6669672E636F6E664974656D297B0A09092F2F207365742074686520636F6E6669726D6174696F6E206974656D20746F20';
wwv_flow_api.g_varchar2_table(120) := '64697361626C65640A0909617065782E6974656D28636F6E6669672E636F6E664974656D292E64697361626C6528293B0A09092F2F2067657420746865206974656D0A09096C657420636F6E664974656D203D2024282723272B636F6E6669672E636F6E';
wwv_flow_api.g_varchar2_table(121) := '664974656D293B0A09092F2F206F6E206576657279206368616765206F6E2074686520706C7567696E206669656C642074686520636F6E6669726D6174696F6E206974656D2077696C6C2062652073657420746F206E756C6C0A0909696E707574466965';
wwv_flow_api.g_varchar2_table(122) := '6C642E6F6E2827696E707574272C2066756E6374696F6E2865297B0A090909617065782E6974656D28636F6E6669672E636F6E664974656D292E73657456616C7565282727293B0A090909746F67676C65496E6C696E6549636F6E28636F6E6649636F6E';
wwv_flow_api.g_varchar2_table(123) := '456C2C66616C7365293B0A0909097365744974656D735374617465282764697361626C6527293B0A0909096966282176616C69646174655265717569726564297B0A09090909696628652E63757272656E745461726765742E76616C75652E6C656E6774';
wwv_flow_api.g_varchar2_table(124) := '68203E2030297B0A0909090909617065782E6974656D28636F6E6669672E636F6E664974656D292E656E61626C6528293B0A090909097D20656C7365207B0A0909090909617065782E6974656D28636F6E6669672E636F6E664974656D292E6469736162';
wwv_flow_api.g_varchar2_table(125) := '6C6528293B0A090909097D0A0909097D0A09097D293B0A0A0909636F6E664974656D2E6F6E2827666F637573696E272C66756E6374696F6E2865297B0A090909636F6E6649636F6E456C2E72656D6F7665436C61737328464F535F41505F48494444454E';
wwv_flow_api.g_varchar2_table(126) := '5F434C415353293B0A090909617065782E6D6573736167652E636C6561724572726F727328636F6E6669672E636F6E664974656D293B0A09097D293B0A0A09096C657420636F6E6649636F6E456C203D2024282723272B636F6E6669672E636F6E664974';
wwv_flow_api.g_varchar2_table(127) := '656D2B275F726567696F6E207370616E2E666F732D61702D696E6C696E652D636865636B27293B0A0909636F6E664974656D2E6F6E2827696E707574272C2066756E6374696F6E2865297B0A0909096C6574206974656D56616C7565203D20696E707574';
wwv_flow_api.g_varchar2_table(128) := '4669656C642E76616C28293B0A090909696628652E7461726765742E76616C756520213D206974656D56616C7565297B0A09090909746F67676C65496E6C696E6549636F6E28636F6E6649636F6E456C2C2066616C7365293B0A09090909736574497465';
wwv_flow_api.g_varchar2_table(129) := '6D735374617465282764697361626C6527293B0A0909097D20656C7365207B0A09090909746F67676C65496E6C696E6549636F6E28636F6E6649636F6E456C2C2074727565293B0A090909097365744974656D7353746174652827656E61626C6527293B';
wwv_flow_api.g_varchar2_table(130) := '0A0909097D0A09097D293B0A0A0909636F6E664974656D2E6F6E2827666F6375736F7574272C2066756E6374696F6E2865297B0A0909096C6574206974656D56616C7565203D20696E7075744669656C642E76616C28293B0A090909696628652E746172';
wwv_flow_api.g_varchar2_table(131) := '6765742E76616C756520213D206974656D56616C7565297B0A09090909696628636F6E6669672E73686F774572726F724966496E63297B0A0909090909617065782E6D6573736167652E73686F774572726F7273287B0A090909090909747970653A2022';
wwv_flow_api.g_varchar2_table(132) := '6572726F72222C0A0909090909096C6F636174696F6E3A2022696E6C696E65222C0A090909090909706167654974656D3A20636F6E6669672E636F6E664974656D2C0A0909090909096D6573736167653A20636F6E6669672E636F6E664974656D457272';
wwv_flow_api.g_varchar2_table(133) := '6F724D6573736167650A09090909097D293B0A090909097D0A090909097365744974656D735374617465282764697361626C6527293B0A0909097D20656C7365207B0A090909097365744974656D7353746174652827656E61626C6527293B0A0909097D';
wwv_flow_api.g_varchar2_table(134) := '0A09097D293B0A097D0A090A0966756E6374696F6E2076616C696461746528696E707574297B0A09096C6574206E657756616C7565203D2020696E7075742E7461726765742E76616C75653B0A09096C657420746573745265733B0A0A09092F2F206C65';
wwv_flow_api.g_varchar2_table(135) := '6E6774680A090969662872756C65732E7077644C656E677468297B0A09090974657374526573203D206E657756616C75652E6C656E677468203C2072756C65732E7077644C656E6774682E617474726962757465732E6C656E6774683B0A090909696620';
wwv_flow_api.g_varchar2_table(136) := '2874657374526573202626207465737453746174652E7077644C656E67746829207B0A090909097465737453746174652E7077644C656E677468203D2066616C73653B0A09090909736574546F4661696C6564286C656E456C293B0A0909097D20656C73';
wwv_flow_api.g_varchar2_table(137) := '6520696628217465737452657320262620217465737453746174652E7077644C656E67746829207B0A090909097465737453746174652E7077644C656E677468203D20747275653B0A09090909736574546F436F6D706C65746564286C656E456C293B0A';
wwv_flow_api.g_varchar2_table(138) := '0909097D0A09097D0A0A09092F2F206E756D626572730A090969662872756C65732E7077644E756D7329207B0A09090974657374526573203D20636F6E7461696E734E756D62657273286E657756616C7565293B0A090909696620287465737452657320';
wwv_flow_api.g_varchar2_table(139) := '262620217465737453746174652E7077644E756D7329207B0A090909097465737453746174652E7077644E756D73203D20747275653B0A09090909736574546F436F6D706C65746564286E756D456C293B0A0909097D20656C7365206966282174657374';
wwv_flow_api.g_varchar2_table(140) := '526573202626207465737453746174652E7077644E756D73297B0A090909097465737453746174652E7077644E756D73203D2066616C73653B0A09090909736574546F4661696C6564286E756D456C293B0A0909097D0A09097D0A0A09092F2F20636170';
wwv_flow_api.g_varchar2_table(141) := '6974616C206C6574746572730A090969662872756C65732E7077644361706974616C7329207B0A09090974657374526573203D20636F6E7461696E734361706974616C4C657474657273286E657756616C7565293B0A0909096966202874657374526573';
wwv_flow_api.g_varchar2_table(142) := '20262620217465737453746174652E7077644361706974616C7329207B0A090909097465737453746174652E7077644361706974616C73203D20747275653B0A09090909736574546F436F6D706C6574656428636170456C293B0A0909097D20656C7365';
wwv_flow_api.g_varchar2_table(143) := '206966282174657374526573202626207465737453746174652E7077644361706974616C7329207B0A090909097465737453746174652E7077644361706974616C73203D2066616C73653B0A09090909736574546F4661696C656428636170456C293B0A';
wwv_flow_api.g_varchar2_table(144) := '0909097D0A09097D0A0A09092F2F207370656369616C20636861726163746572730A090969662872756C65732E70776453706563436861727329207B0A09090974657374526573203D20636F6E7461696E735370656369616C4368617261637465727328';
wwv_flow_api.g_varchar2_table(145) := '6E657756616C7565293B0A090909696620287465737452657320262620217465737453746174652E70776453706563436861727329207B0A090909097465737453746174652E707764537065634368617273203D20747275653B0A09090909736574546F';
wwv_flow_api.g_varchar2_table(146) := '436F6D706C657465642873706563456C293B0A0909097D20656C7365206966282174657374526573202626207465737453746174652E707764537065634368617273297B0A090909097465737453746174652E707764537065634368617273203D206661';
wwv_flow_api.g_varchar2_table(147) := '6C73653B0A09090909736574546F4661696C65642873706563456C293B0A0909097D0A09097D0A0A09092F2F206869646520616E642073686F772066756E6374696F6E616C697479206F662074686520636F6C6C61707369626C652072756C6520726567';
wwv_flow_api.g_varchar2_table(148) := '696F6E0A0909696628636F6E6669672E72756C6573436F6E7461696E6572203D3D2027636F6C6C61707369626C6527297B0A0909096C6574207469746C65456C5370616E203D206974656D526567696F6E2E66696E6428272E666F732D61702D636F6E73';
wwv_flow_api.g_varchar2_table(149) := '747261696E74732D7469746C65202E666F732D70776427293B0A0909096C657420646F6E65203D20747275653B0A0909096973457665727952756C655061737365642866756E6374696F6E28297B0A09090909646F6E65203D2066616C73653B0A090909';
wwv_flow_api.g_varchar2_table(150) := '7D293B0A0909096C6574207469746C654E616D65203D207469746C65456C2E6174747228276E616D6527293B0A090909696628646F6E65202626207469746C654E616D6520213D27646F6E6527297B0A09090909617065782E6D6573736167652E636C65';
wwv_flow_api.g_varchar2_table(151) := '61724572726F7273286974656D4E616D65293B0A090909096368616E67655469746C6552756C6528636F6E6669672E72756C6573436F6D70546578742C2027646F6E6527293B0A09090909736574546F436F6D706C65746564287469746C65456C537061';
wwv_flow_api.g_varchar2_table(152) := '6E2C66616C7365293B0A090909096C65742072756C6573436F6E456C203D2072756C6573436F6E7461696E6572456C3B0A09090909646F63756D656E742E717565727953656C6563746F72416C6C282723272B6974656D4E616D652B275F726567696F6E';
wwv_flow_api.g_varchar2_table(153) := '202E666F732D61702D72756C6527292E666F72456163682866756E6374696F6E2872756C65297B0A090909090972756C652E7374796C652E646973706C6179203D2027626C6F636B273B0A090909097D293B0A0909090969662872756C6573436F6E456C';
wwv_flow_api.g_varchar2_table(154) := '2E6865696768742829203E2030297B0A090909090972756C6573436F6E456C2E637373287B276D61782D686569676874273A2072756C6573436F6E456C2E70726F7028277363726F6C6C48656967687427292B277078277D293B0A090909097D0A090909';
wwv_flow_api.g_varchar2_table(155) := '7D20656C7365207B0A090909096966287465737453746174655B7469746C654E616D652E7375627374722838295D207C7C207469746C654E616D65203D3D2027646F6E6527297B0A09090909096C6574207469746C65526566726573686564203D206661';
wwv_flow_api.g_varchar2_table(156) := '6C73653B0A0909090909666F72286C65742070726F7020696E20746573745374617465297B0A0909090909096C65742072756C65456C203D20646F63756D656E742E717565727953656C6563746F72282723272B6974656D4E616D652B275F726567696F';
wwv_flow_api.g_varchar2_table(157) := '6E202E666F732D61702D72756C655B6E616D653D22464F53272B70726F702B27225D27293B0A090909090909696628217465737453746174655B70726F705D297B0A09090909090909696628217469746C65526566726573686564297B0A090909090909';
wwv_flow_api.g_varchar2_table(158) := '090972756C65456C2E7374796C652E646973706C6179203D20276E6F6E65273B0A09090909090909096966287469746C654E616D6520213D2027646F6E6527297B0A090909090909090909736574546F436F6D706C65746564287469746C65456C537061';
wwv_flow_api.g_varchar2_table(159) := '6E2C66616C7365293B0A09090909090909097D0A09090909090909096368616E67655469746C6552756C652872756C65456C2E696E6E657248544D4C2C277469746C65464F53272B70726F70293B0A09090909090909097469746C655265667265736865';
wwv_flow_api.g_varchar2_table(160) := '64203D20747275653B0A090909090909097D20656C7365207B0A090909090909090972756C65456C2E7374796C652E646973706C6179203D2027626C6F636B273B0A090909090909097D0A0909090909097D20656C7365207B0A0909090909090972756C';

wwv_flow_api.g_varchar2_table(161) := '65456C2E7374796C652E646973706C6179203D2027626C6F636B273B0A0909090909097D0A09090909097D0A090909097D0A0909097D0A09097D0A097D0A0A092F2F205574696C6974792066756E6374696F6E730A0966756E6374696F6E20736574456C';
wwv_flow_api.g_varchar2_table(162) := '656D656E74576964746828656C2C706374203D2031297B0A0909656C2E63737328277769647468272C20696E7075744669656C642E6F7574657257696474682829202A20706374202B2027707827293B0A097D0A0966756E6374696F6E20636F6E746169';
wwv_flow_api.g_varchar2_table(163) := '6E734E756D626572732873297B0A09096C65742072657175697265644E756D203D2072756C65732E7077644E756D732E617474726962757465732E6C656E6774683B0A09097265676578203D206E6577205265674578702827285B302D395D2E2A297B27';
wwv_flow_api.g_varchar2_table(164) := '2B72657175697265644E756D2B272C7D272C20276727293B0A090972657475726E2072656765782E746573742873293B09090A097D0A0966756E6374696F6E20636F6E7461696E734361706974616C4C6574746572732873297B0A09096C657420726571';
wwv_flow_api.g_varchar2_table(165) := '756972656443617073203D2072756C65732E7077644361706974616C732E617474726962757465732E6C656E6774683B0A09097265676578203D206E6577205265674578702827285B412D5A5D2E2A297B272B7265717569726564436170732B272C7D27';
wwv_flow_api.g_varchar2_table(166) := '2C276727293B0A090972657475726E2072656765782E746573742873293B090A097D0A0966756E6374696F6E20636F6E7461696E735370656369616C436861726163746572732873297B0A09096C657420726571756972656453706563203D2072756C65';
wwv_flow_api.g_varchar2_table(167) := '732E7077645370656343686172732E617474726962757465732E6C6973744F6653706563436861723B0A09096C6574207265717569726564534E756D203D2072756C65732E7077645370656343686172732E617474726962757465732E6C656E6774683B';
wwv_flow_api.g_varchar2_table(168) := '0A09097265676578203D206E6577205265674578702827285B272B7265717569726564537065632B275D2E2A297B272B7265717569726564534E756D2B272C7D272C276727293B0A090972657475726E2072656765782E746573742873293B0A097D0A09';
wwv_flow_api.g_varchar2_table(169) := '66756E6374696F6E20746F67676C655077642829207B0A0909696E7075744669656C642E617474722827747970652729203D3D202770617373776F726427203F2073686F775077642E63616C6C287468697329203A20686964655077642E63616C6C2874';
wwv_flow_api.g_varchar2_table(170) := '686973293B0A097D0A0966756E6374696F6E2073686F7750776428297B0A0909242874686973292E72656D6F7665436C61737328636F6E6669672E7065656B48696464656E49636F6E292E616464436C61737328636F6E6669672E7065656B53686F776E';
wwv_flow_api.g_varchar2_table(171) := '49636F6E293B0A0909696E7075744669656C642E61747472282274797065222C20227465787422293B0A097D0A0966756E6374696F6E206869646550776428297B0A0909242874686973292E72656D6F7665436C61737328636F6E6669672E7065656B53';
wwv_flow_api.g_varchar2_table(172) := '686F776E49636F6E292E616464436C61737328636F6E6669672E7065656B48696464656E49636F6E293B0A0909696E7075744669656C642E61747472282274797065222C202270617373776F726422293B0A097D0A0966756E6374696F6E20746F67676C';
wwv_flow_api.g_varchar2_table(173) := '65496E6C696E6549636F6E28656C2C2074797065297B0A090969662874797065297B0A090909656C2E637373287B27636F6C6F72273A20636F6E6669672E73756363657373436F6C6F727D293B0A090909656C2E72656D6F7665436C61737328636F6E66';
wwv_flow_api.g_varchar2_table(174) := '69672E696E6C696E654661696C49636F6E292E616464436C61737328636F6E6669672E696E6C696E65436865636B49636F6E293B0A09097D20656C7365207B0A090909656C2E637373287B27636F6C6F72273A20636F6E6669672E6572726F72436F6C6F';
wwv_flow_api.g_varchar2_table(175) := '727D293B0A090909656C2E72656D6F7665436C61737328636F6E6669672E696E6C696E65436865636B49636F6E292E616464436C61737328636F6E6669672E696E6C696E654661696C49636F6E293B0A09097D0A097D0A0966756E6374696F6E20736574';
wwv_flow_api.g_varchar2_table(176) := '4974656D7353746174652874797065297B0A090969662821636F6E6669672E64697361626C654974656D73297B0A09090972657475726E3B0A09097D0A0909636F6E6669672E6974656D73546F44697361626C652E666F72456163682866756E6374696F';
wwv_flow_api.g_varchar2_table(177) := '6E286974656D297B0A090909617065782E6D6573736167652E636C6561724572726F7273286974656D293B0A09090969662874797065203D3D2027656E61626C6527297B0A0909090924282723272B6974656D292E72656D6F7665436C61737328276170';
wwv_flow_api.g_varchar2_table(178) := '65785F64697361626C656427293B0A09090909617065782E6974656D286974656D292E656E61626C6528293B0A0909097D20656C7365207B0A0909090924282723272B6974656D292E616464436C6173732827617065785F64697361626C656427293B0A';
wwv_flow_api.g_varchar2_table(179) := '09090909617065782E6974656D286974656D292E64697361626C6528293B0A0909097D0A09097D293B0A097D0A0966756E6374696F6E206368616E67655469746C6552756C6528636F6E74656E742C206E616D65297B0A09097469746C65456C2E637373';
wwv_flow_api.g_varchar2_table(180) := '287B27636F6C6F72273A20636F6E6669672E73756363657373436F6C6F727D293B0A09097469746C65456C2E72656D6F7665436C6173732827666F732D76616C75652D656E74657227293B0A09097469746C65456C2E616464436C6173732827666F732D';
wwv_flow_api.g_varchar2_table(181) := '76616C75652D6C6561766527293B0A090973657454696D656F75742866756E6374696F6E28297B0A0909097469746C65456C2E72656D6F7665436C6173732827666F732D76616C75652D6C6561766527293B0A0909097469746C65456C2E616464436C61';
wwv_flow_api.g_varchar2_table(182) := '73732827666F732D76616C75652D656E74657227293B0A0909096966286E616D6520213D2027646F6E6527297B0A090909097469746C65456C2E637373287B27636F6C6F72273A20636F6E6669672E6572726F72436F6C6F727D293B0A0909097D0A0909';
wwv_flow_api.g_varchar2_table(183) := '097469746C65456C2E68746D6C28636F6E74656E74207C7C202727293B0A0909097469746C65456C2E6174747228276E616D65272C6E616D65293B0A09097D2C333030293B0A097D0A0966756E6374696F6E206973457665727952756C65506173736564';
wwv_flow_api.g_varchar2_table(184) := '286362297B0A0909666F72286C6574206920696E20746573745374617465297B0A090909696628217465737453746174655B695D297B0A09090909636228293B0A09090909627265616B3B0A0909097D0A09097D0A097D0A0966756E6374696F6E207365';
wwv_flow_api.g_varchar2_table(185) := '74546F436F6D706C6574656428656C2C747269676765724576656E74203D2074727565297B0A09096C6574207061737365645465737473203D20303B0A0909666F72286C6574206B657920696E20746573745374617465297B0A09090969662874657374';
wwv_flow_api.g_varchar2_table(186) := '53746174655B6B65795D297B0A0909090970617373656454657374732B2B3B0A0909097D0A09097D0A0909696628636F6E6669672E73686F77537472656E677468426172297B0A0909096C6574206261725769646874203D207061737365645465737473';
wwv_flow_api.g_varchar2_table(187) := '202A20736570506F733B0A0909096261725769646874203D206261725769646874203D3D203939203F20313030203A2062617257696468743B0A090909737472656E677468426172456C2E63737328277769647468272C2062617257696468742B272527';
wwv_flow_api.g_varchar2_table(188) := '293B0A09097D0A0909656C2E706172656E7428292E637373287B27636F6C6F72273A20636F6E6669672E73756363657373436F6C6F727D293B0A0909656C2E616464436C61737328636F6E6669672E72756C6573436865636B49636F6E292E72656D6F76';
wwv_flow_api.g_varchar2_table(189) := '65436C61737328636F6E6669672E72756C65734661696C49636F6E293B0A0909656C2E637373287B27636F6C6F72273A20636F6E6669672E73756363657373436F6C6F727D293B0A09096966287061737365645465737473203D3D20746573744E756D29';
wwv_flow_api.g_varchar2_table(190) := '7B0A090909696628747269676765724576656E74297B0A09090909617065782E6576656E742E74726967676572282723272B6974656D4E616D652C2052554C455F414C4C5F434F4D504C4554455F4556454E542C20746573745374617465293B0A090909';
wwv_flow_api.g_varchar2_table(191) := '7D0A090909696628636F6E6669672E636F6E664974656D297B0A09090909617065782E6974656D28636F6E6669672E636F6E664974656D292E656E61626C6528293B0A0909097D0A090909696628636F6E6669672E64697361626C654974656D73202626';
wwv_flow_api.g_varchar2_table(192) := '2021636F6E6669672E636F6E664974656D297B0A090909097365744974656D7353746174652827656E61626C6527293B0A0909097D0A090909696628636F6E6669672E696E6C696E6549636F6E297B0A09090909746F67676C65496E6C696E6549636F6E';
wwv_flow_api.g_varchar2_table(193) := '28696E6C696E6549636F6E456C2C2074727565293B0A0909097D0A09097D20656C7365207B0A090909696628747269676765724576656E74297B0A09090909617065782E6576656E742E74726967676572282723272B6974656D4E616D652C2052554C45';
wwv_flow_api.g_varchar2_table(194) := '5F434F4D504C4554455F4556454E542C20746573745374617465293B0A0909097D0A09097D0A097D0A0966756E6374696F6E20736574546F4661696C656428656C297B0A0909696628636F6E6669672E73686F77537472656E677468426172297B0A0909';
wwv_flow_api.g_varchar2_table(195) := '096C6574206661696C65645465737473203D20303B0A090909666F72286C6574206B657920696E20746573745374617465297B0A09090909696628217465737453746174655B6B65795D297B0A09090909096661696C656454657374732B2B3B0A090909';
wwv_flow_api.g_varchar2_table(196) := '097D0A0909097D0A0909096C6574206261725769647468203D20313030202D206661696C65645465737473202A20736570506F733B0A0909096261725769647468203D20746573744E756D203D3D2033203F206261725769647468202D2031203A206261';
wwv_flow_api.g_varchar2_table(197) := '7257696474683B0A090909737472656E677468426172456C2E63737328277769647468272C2062617257696474682B272527293B0A09097D0A0909656C2E706172656E7428292E637373287B27636F6C6F72273A20636F6E6669672E6572726F72436F6C';
wwv_flow_api.g_varchar2_table(198) := '6F727D293B0A0909656C2E616464436C61737328636F6E6669672E72756C65734661696C49636F6E292E72656D6F7665436C61737328636F6E6669672E72756C6573436865636B49636F6E293B0A0909656C2E637373287B27636F6C6F72273A20636F6E';
wwv_flow_api.g_varchar2_table(199) := '6669672E6572726F72436F6C6F727D293B0A0909617065782E6576656E742E74726967676572282723272B6974656D4E616D652C2052554C455F4641494C5F4556454E542C20746573745374617465293B0A0909696628636F6E6669672E636F6E664974';
wwv_flow_api.g_varchar2_table(200) := '656D297B0A090909617065782E6974656D28636F6E6669672E636F6E664974656D292E64697361626C6528293B0A09097D0A0909696628636F6E6669672E64697361626C654974656D732026262021636F6E6669672E636F6E664974656D297B0A090909';
wwv_flow_api.g_varchar2_table(201) := '7365744974656D735374617465282764697361626C6527293B0A09097D0A0909696628636F6E6669672E696E6C696E6549636F6E297B0A090909746F67676C65496E6C696E6549636F6E28696E6C696E6549636F6E456C2C2066616C7365293B0A09097D';
wwv_flow_api.g_varchar2_table(202) := '0A097D0A7D3B';
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
wwv_flow_api.g_varchar2_table(7) := '2C6E26266E20696E7374616E63656F662046756E6374696F6E26266E2E63616C6C28746869732C65293B6C657420732C742C6F2C613D652E6974656D4E616D652C693D24282223222B612B225F726567696F6E22292C723D24282223222B61292C6C3D65';
wwv_flow_api.g_varchar2_table(8) := '2E72756C65732C633D4F626A6563742E6B657973286C292E6C656E6774682C643D4D6174682E666C6F6F72283130302F63292C663D7B7D2C703D652E737472656E67746842617257696474685063742F3130302C753D692E66696E6428222E7061737377';
wwv_flow_api.g_varchar2_table(9) := '6F72642D72756C652D6C656E677468202E666F732D70776422292C6D3D692E66696E6428222E70617373776F72642D72756C652D6E756D62657273202E666F732D70776422292C683D692E66696E6428222E70617373776F72642D72756C652D73706563';
wwv_flow_api.g_varchar2_table(10) := '69616C2D63686172616374657273202E666F732D70776422292C673D692E66696E6428222E70617373776F72642D72756C652D6361706974616C2D6C657474657273202E666F732D70776422293B636F6E737420433D22666F732D61702D68696465223B';
wwv_flow_api.g_varchar2_table(11) := '666F72286C6574206520696E206C296C5B655D262628665B655D3D2131293B6C657420772C493D216A51756572792E6973456D7074794F626A656374286629262621652E6973436F6E6669726D6174696F6E4974656D3B696628652E696E6C696E654963';
wwv_flow_api.g_varchar2_table(12) := '6F6E262628773D692E66696E6428227370616E2E666F732D61702D696E6C696E652D636865636B22292C772E616464436C617373285B652E696E6C696E654661696C49636F6E2C435D292C772E637373287B6C6566743A222D2E3272656D222C636F6C6F';
wwv_flow_api.g_varchar2_table(13) := '723A652E6572726F72436F6C6F727D292C497C7C652E6973436F6E6669726D6174696F6E4974656D7C7C28722E6F6E2822666F637573222C2866756E6374696F6E2865297B772E72656D6F7665436C6173732843297D29292C722E6F6E2822696E707574';
wwv_flow_api.g_varchar2_table(14) := '222C2866756E6374696F6E2865297B7828772C652E63757272656E745461726765742E76616C75652E6C656E6774683E30297D292929292C492626722E6F6E28226B65797570206368616E6765222C2866756E6374696F6E286E297B652E696E6C696E65';
wwv_flow_api.g_varchar2_table(15) := '49636F6E262646282866756E6374696F6E28297B7828772C2131297D29292C66756E6374696F6E286E297B6C657420732C723D6E2E7461726765742E76616C75653B6C2E7077644C656E677468262628733D722E6C656E6774683C6C2E7077644C656E67';
wwv_flow_api.g_varchar2_table(16) := '74682E617474726962757465732E6C656E6774682C732626662E7077644C656E6774683F28662E7077644C656E6774683D21312C4F287529293A737C7C662E7077644C656E6774687C7C28662E7077644C656E6774683D21302C4528752929293B6C2E70';
wwv_flow_api.g_varchar2_table(17) := '77644E756D73262628733D66756E6374696F6E2865297B6C6574206E3D6C2E7077644E756D732E617474726962757465732E6C656E6774683B72657475726E2072656765783D6E6577205265674578702822285B302D395D2E2A297B222B6E2B222C7D22';
wwv_flow_api.g_varchar2_table(18) := '2C226722292C72656765782E746573742865297D2872292C73262621662E7077644E756D733F28662E7077644E756D733D21302C45286D29293A21732626662E7077644E756D73262628662E7077644E756D733D21312C4F286D2929293B6C2E70776443';
wwv_flow_api.g_varchar2_table(19) := '61706974616C73262628733D66756E6374696F6E2865297B6C6574206E3D6C2E7077644361706974616C732E617474726962757465732E6C656E6774683B72657475726E2072656765783D6E6577205265674578702822285B412D5A5D2E2A297B222B6E';
wwv_flow_api.g_varchar2_table(20) := '2B222C7D222C226722292C72656765782E746573742865297D2872292C73262621662E7077644361706974616C733F28662E7077644361706974616C733D21302C45286729293A21732626662E7077644361706974616C73262628662E70776443617069';
wwv_flow_api.g_varchar2_table(21) := '74616C733D21312C4F28672929293B6C2E707764537065634368617273262628733D66756E6374696F6E2865297B6C6574206E3D6C2E7077645370656343686172732E617474726962757465732E6C6973744F6653706563436861722C733D6C2E707764';
wwv_flow_api.g_varchar2_table(22) := '5370656343686172732E617474726962757465732E6C656E6774683B72657475726E2072656765783D6E6577205265674578702822285B222B6E2B225D2E2A297B222B732B222C7D222C226722292C72656765782E746573742865297D2872292C732626';
wwv_flow_api.g_varchar2_table(23) := '21662E7077645370656343686172733F28662E7077645370656343686172733D21302C45286829293A21732626662E707764537065634368617273262628662E7077645370656343686172733D21312C4F28682929293B69662822636F6C6C6170736962';
wwv_flow_api.g_varchar2_table(24) := '6C65223D3D652E72756C6573436F6E7461696E6572297B6C6574206E3D692E66696E6428222E666F732D61702D636F6E73747261696E74732D7469746C65202E666F732D70776422292C733D21303B46282866756E6374696F6E28297B733D21317D2929';
wwv_flow_api.g_varchar2_table(25) := '3B6C657420723D742E6174747228226E616D6522293B69662873262622646F6E6522213D72297B617065782E6D6573736167652E636C6561724572726F72732861292C5328652E72756C6573436F6D70546578742C22646F6E6522292C45286E2C213129';
wwv_flow_api.g_varchar2_table(26) := '3B6C657420733D6F3B646F63756D656E742E717565727953656C6563746F72416C6C282223222B612B225F726567696F6E202E666F732D61702D72756C6522292E666F7245616368282866756E6374696F6E2865297B652E7374796C652E646973706C61';
wwv_flow_api.g_varchar2_table(27) := '793D22626C6F636B227D29292C732E68656967687428293E302626732E637373287B226D61782D686569676874223A732E70726F7028227363726F6C6C48656967687422292B227078227D297D656C736520696628665B722E7375627374722838295D7C';
wwv_flow_api.g_varchar2_table(28) := '7C22646F6E65223D3D72297B6C657420653D21313B666F72286C6574207320696E2066297B6C657420743D646F63756D656E742E717565727953656C6563746F72282223222B612B275F726567696F6E202E666F732D61702D72756C655B6E616D653D22';
wwv_flow_api.g_varchar2_table(29) := '464F53272B732B27225D27293B665B735D7C7C653F742E7374796C652E646973706C61793D22626C6F636B223A28742E7374796C652E646973706C61793D226E6F6E65222C22646F6E6522213D72262645286E2C2131292C5328742E696E6E657248544D';
wwv_flow_api.g_varchar2_table(30) := '4C2C227469746C65464F53222B73292C653D2130297D7D7D7D286E297D29292C2264697361626C656422213D652E7077645065656B297B652E7065656B48696464656E49636F6E3D652E7065656B48696464656E49636F6E2E73706C697428222022292C';
wwv_flow_api.g_varchar2_table(31) := '652E7065656B53686F776E49636F6E3D652E7065656B53686F776E49636F6E2E73706C697428222022293B6C6574206E3D692E66696E6428222E61702D70617373776F72642D65796522293B6E2E616464436C61737328652E7065656B48696464656E49';
wwv_flow_api.g_varchar2_table(32) := '636F6E292C722E637373287B2270616464696E672D7269676874223A22332E3372656D227D292C652E696E6C696E6549636F6E2626772E637373287B6C6566743A222D332E3372656D227D292C22656E61626C65642D636C69636B2D7072657373223D3D';
wwv_flow_api.g_varchar2_table(33) := '3D652E7077645065656B3F286E2E6F6E28226D6F7573657570206D6F7573656C6561766520746F756368656E64222C6B292C6E2E6F6E28226D6F757365646F776E222C2866756E6374696F6E2865297B303D3D3D652E627574746F6E2626762E63616C6C';
wwv_flow_api.g_varchar2_table(34) := '286E297D29292C6E2E6F6E2822746F7563687374617274222C2866756E6374696F6E2865297B6C657420733D652E746F75636865735B305D3B646F63756D656E742E656C656D656E7446726F6D506F696E7428732E636C69656E74582C732E636C69656E';
wwv_flow_api.g_varchar2_table(35) := '7459292626762E63616C6C286E297D2929293A22656E61626C65642D746F67676C65223D3D3D652E7077645065656B26266E2E6F6E2822636C69636B222C2866756E6374696F6E28297B2270617373776F7264223D3D722E617474722822747970652229';
wwv_flow_api.g_varchar2_table(36) := '3F762E63616C6C2874686973293A6B2E63616C6C2874686973297D29297D696628652E73686F77436170734C6F636B297B6C6574206E3D692E66696E6428222E61702D636170732D6C6F636B22293B6E2E616464436C617373285B652E636170734C6F63';
wwv_flow_api.g_varchar2_table(37) := '6B49636F6E2C435D293B6C657420733D2264697361626C6564223D3D3D652E7077645065656B3F222D2E3272656D223A222D332E3372656D223B6E2E637373287B6C6566743A737D292C722E6F6E2822666F6375736F7574222C2866756E6374696F6E28';
wwv_flow_api.g_varchar2_table(38) := '73297B652E696E6C696E6549636F6E2626772E72656D6F7665436C6173732843292C6E2E616464436C6173732843297D29292C722E6F6E28226B65797570222C2866756E6374696F6E2873297B732E6F726967696E616C4576656E742E6765744D6F6469';
wwv_flow_api.g_varchar2_table(39) := '6669657253746174652822436170734C6F636B22293F28652E696E6C696E6549636F6E2626772E616464436C6173732843292C6E2E72656D6F7665436C617373284329293A28652E696E6C696E6549636F6E2626772E72656D6F7665436C617373284329';
wwv_flow_api.g_varchar2_table(40) := '2C6E2E616464436C617373284329297D29297D6966282268696464656E22213D652E72756C6573436F6E7461696E65722626692E66696E6428222E666F732D70776422292E65616368282866756E6374696F6E28297B6C6574206E3D242874686973293B';
wwv_flow_api.g_varchar2_table(41) := '6E2E616464436C61737328652E72756C65734661696C49636F6E292C6E2E637373287B636F6C6F723A652E6572726F72436F6C6F727D297D29292C2265787465726E616C223D3D652E72756C6573436F6E7461696E65722626652E72756C6573436F6E74';
wwv_flow_api.g_varchar2_table(42) := '61696E65724964297B6C6574206E3D692E66696E6428222E666F732D61702D636F6E7461696E65722D65787465726E616C22292E64657461636828292C733D24282223222B652E72756C6573436F6E7461696E65724964292C743D732E66696E6428222E';
wwv_flow_api.g_varchar2_table(43) := '742D526567696F6E2D626F647922293B313D3D3D742E6C656E6774683F742E617070656E64286E293A732E617070656E64286E297D656C7365206966282268696464656E22213D652E72756C6573436F6E7461696E6572262628743D692E66696E642822';
wwv_flow_api.g_varchar2_table(44) := '2E666F732D61702D636F6E73747261696E74732D7469746C6522292C6F3D692E66696E6428222E666F732D61702D636F6E7461696E657222292C622874292C62286F29292C22636F6C6C61707369626C65223D3D652E72756C6573436F6E7461696E6572';
wwv_flow_api.g_varchar2_table(45) := '262649297B6C657420653D692E66696E6428222E666F732D61702D72756C6522292E666972737428293B742E68746D6C28652E68746D6C2829292C742E6174747228226E616D65222C227469746C65222B652E6174747228226E616D652229292C652E63';
wwv_flow_api.g_varchar2_table(46) := '7373287B646973706C61793A226E6F6E65227D292C742E6F6E2822636C69636B222C2866756E6374696F6E2865297B242874686973292E746F67676C65436C617373282261637469766522293B6C6574206E3D6F3B6E2E68656967687428293E303F6E2E';
wwv_flow_api.g_varchar2_table(47) := '637373287B226D61782D686569676874223A307D293A6E2E637373287B226D61782D686569676874223A6E2E70726F7028227363726F6C6C48656967687422292B227078227D297D29297D696628652E64697361626C654974656D73297B696628652E63';
wwv_flow_api.g_varchar2_table(48) := '6F6E664974656D297B6C6574206E3D652E6974656D73546F44697361626C652E696E6465784F6628652E636F6E664974656D293B6E3E2D312626652E6974656D73546F44697361626C652E73706C696365286E2C31297D79282264697361626C6522297D';
wwv_flow_api.g_varchar2_table(49) := '696628652E73686F774572726F724966496E63262649262628722E6F6E2822666F6375736F7574222C2866756E6374696F6E286E297B46282866756E6374696F6E28297B617065782E6D6573736167652E73686F774572726F7273287B747970653A2265';
wwv_flow_api.g_varchar2_table(50) := '72726F72222C6C6F636174696F6E3A22696E6C696E65222C706167654974656D3A612C6D6573736167653A652E6572726F724D6573736167657D292C617065782E6576656E742E74726967676572282223222B612C22666F732D61702D696E76616C6964';
wwv_flow_api.g_varchar2_table(51) := '2D6669656C64222C66297D29297D29292C722E6F6E2822666F637573696E222C2866756E6374696F6E2865297B617065782E6D6573736167652E636C6561724572726F72732861297D2929292C652E73686F77537472656E677468426172297B733D692E';
wwv_flow_api.g_varchar2_table(52) := '66696E6428222E666F732D737472656E6774682D636F6E7461696E657222293B6C6574206E3D692E66696E6428222E666F732D737472656E6774682D6261722D636F6E7461696E657222293B6E2E66696E6428222E666F732D737472656E6774682D6267';
wwv_flow_api.g_varchar2_table(53) := '22292E637373287B226261636B67726F756E642D636F6C6F72223A652E737472656E6774684261724267436F6C6F727D292C6E2E66696E6428222E666F732D737472656E6774682D636F6E7461696E657222292E637373287B226261636B67726F756E64';
wwv_flow_api.g_varchar2_table(54) := '2D636F6C6F72223A652E73756363657373436F6C6F727D292C77696E646F772E6164644576656E744C697374656E65722822726573697A65222C2866756E6374696F6E2865297B62286E2C70297D29292C617065782E6A5175657279282223745F547265';
wwv_flow_api.g_varchar2_table(55) := '654E617622292E6F6E28227468656D6534326C61796F75746368616E676564222C2866756E6374696F6E28652C73297B73657454696D656F7574282866756E6374696F6E28297B62286E2C70297D292C333030297D29292C62286E2C70292C2264796E61';
wwv_flow_api.g_varchar2_table(56) := '6D6963223D3D652E737472656E6774684261725374796C653F28722E6F6E2822666F637573696E222C2866756E6374696F6E2865297B6E2E616464436C6173732822666F732D6261722D61637469766522297D29292C722E6F6E2822666F6375736F7574';
wwv_flow_api.g_varchar2_table(57) := '222C2866756E6374696F6E2865297B6E2E72656D6F7665436C6173732822666F732D6261722D61637469766522297D2929293A22737461746963223D3D652E737472656E6774684261725374796C6526266E2E616464436C6173732822666F732D626172';
wwv_flow_api.g_varchar2_table(58) := '2D61637469766522293B666F72286C657420653D313B653C633B652B2B296E2E617070656E6428273C646976207374796C653D226C6566743A272B642A652B27252220636C6173733D22666F732D737472656E6774682D73706C6974223E3C2F6469763E';
wwv_flow_api.g_varchar2_table(59) := '27297D696628652E636F6E664974656D297B617065782E6974656D28652E636F6E664974656D292E64697361626C6528293B6C6574206E3D24282223222B652E636F6E664974656D293B722E6F6E2822696E707574222C2866756E6374696F6E286E297B';
wwv_flow_api.g_varchar2_table(60) := '617065782E6974656D28652E636F6E664974656D292E73657456616C7565282222292C7828732C2131292C79282264697361626C6522292C497C7C286E2E63757272656E745461726765742E76616C75652E6C656E6774683E303F617065782E6974656D';
wwv_flow_api.g_varchar2_table(61) := '28652E636F6E664974656D292E656E61626C6528293A617065782E6974656D28652E636F6E664974656D292E64697361626C652829297D29292C6E2E6F6E2822666F637573696E222C2866756E6374696F6E286E297B732E72656D6F7665436C61737328';
wwv_flow_api.g_varchar2_table(62) := '43292C617065782E6D6573736167652E636C6561724572726F727328652E636F6E664974656D297D29293B6C657420733D24282223222B652E636F6E664974656D2B225F726567696F6E207370616E2E666F732D61702D696E6C696E652D636865636B22';
wwv_flow_api.g_varchar2_table(63) := '293B6E2E6F6E2822696E707574222C2866756E6374696F6E2865297B6C6574206E3D722E76616C28293B652E7461726765742E76616C7565213D6E3F287828732C2131292C79282264697361626C652229293A287828732C2130292C792822656E61626C';
wwv_flow_api.g_varchar2_table(64) := '652229297D29292C6E2E6F6E2822666F6375736F7574222C2866756E6374696F6E286E297B6C657420733D722E76616C28293B6E2E7461726765742E76616C7565213D733F28652E73686F774572726F724966496E632626617065782E6D657373616765';
wwv_flow_api.g_varchar2_table(65) := '2E73686F774572726F7273287B747970653A226572726F72222C6C6F636174696F6E3A22696E6C696E65222C706167654974656D3A652E636F6E664974656D2C6D6573736167653A652E636F6E664974656D4572726F724D6573736167657D292C792822';
wwv_flow_api.g_varchar2_table(66) := '64697361626C652229293A792822656E61626C6522297D29297D66756E6374696F6E206228652C6E3D31297B652E63737328227769647468222C722E6F75746572576964746828292A6E2B22707822297D66756E6374696F6E207628297B242874686973';
wwv_flow_api.g_varchar2_table(67) := '292E72656D6F7665436C61737328652E7065656B48696464656E49636F6E292E616464436C61737328652E7065656B53686F776E49636F6E292C722E61747472282274797065222C227465787422297D66756E6374696F6E206B28297B24287468697329';
wwv_flow_api.g_varchar2_table(68) := '2E72656D6F7665436C61737328652E7065656B53686F776E49636F6E292E616464436C61737328652E7065656B48696464656E49636F6E292C722E61747472282274797065222C2270617373776F726422297D66756E6374696F6E2078286E2C73297B73';
wwv_flow_api.g_varchar2_table(69) := '3F286E2E637373287B636F6C6F723A652E73756363657373436F6C6F727D292C6E2E72656D6F7665436C61737328652E696E6C696E654661696C49636F6E292E616464436C61737328652E696E6C696E65436865636B49636F6E29293A286E2E63737328';
wwv_flow_api.g_varchar2_table(70) := '7B636F6C6F723A652E6572726F72436F6C6F727D292C6E2E72656D6F7665436C61737328652E696E6C696E65436865636B49636F6E292E616464436C61737328652E696E6C696E654661696C49636F6E29297D66756E6374696F6E2079286E297B652E64';
wwv_flow_api.g_varchar2_table(71) := '697361626C654974656D732626652E6974656D73546F44697361626C652E666F7245616368282866756E6374696F6E2865297B617065782E6D6573736167652E636C6561724572726F72732865292C22656E61626C65223D3D6E3F2824282223222B6529';
wwv_flow_api.g_varchar2_table(72) := '2E72656D6F7665436C6173732822617065785F64697361626C656422292C617065782E6974656D2865292E656E61626C652829293A2824282223222B65292E616464436C6173732822617065785F64697361626C656422292C617065782E6974656D2865';
wwv_flow_api.g_varchar2_table(73) := '292E64697361626C652829297D29297D66756E6374696F6E2053286E2C73297B742E637373287B636F6C6F723A652E73756363657373436F6C6F727D292C742E72656D6F7665436C6173732822666F732D76616C75652D656E74657222292C742E616464';
wwv_flow_api.g_varchar2_table(74) := '436C6173732822666F732D76616C75652D6C6561766522292C73657454696D656F7574282866756E6374696F6E28297B742E72656D6F7665436C6173732822666F732D76616C75652D6C6561766522292C742E616464436C6173732822666F732D76616C';
wwv_flow_api.g_varchar2_table(75) := '75652D656E74657222292C22646F6E6522213D732626742E637373287B636F6C6F723A652E6572726F72436F6C6F727D292C742E68746D6C286E7C7C2222292C742E6174747228226E616D65222C73297D292C333030297D66756E6374696F6E20462865';
wwv_flow_api.g_varchar2_table(76) := '297B666F72286C6574206E20696E20662969662821665B6E5D297B6528293B627265616B7D7D66756E6374696F6E2045286E2C743D2130297B6C6574206F3D303B666F72286C6574206520696E206629665B655D26266F2B2B3B696628652E73686F7753';
wwv_flow_api.g_varchar2_table(77) := '7472656E677468426172297B6C657420653D6F2A643B653D39393D3D653F3130303A652C732E63737328227769647468222C652B222522297D6E2E706172656E7428292E637373287B636F6C6F723A652E73756363657373436F6C6F727D292C6E2E6164';
wwv_flow_api.g_varchar2_table(78) := '64436C61737328652E72756C6573436865636B49636F6E292E72656D6F7665436C61737328652E72756C65734661696C49636F6E292C6E2E637373287B636F6C6F723A652E73756363657373436F6C6F727D292C6F3D3D633F28742626617065782E6576';
wwv_flow_api.g_varchar2_table(79) := '656E742E74726967676572282223222B612C22666F732D61702D65766572792D72756C652D636F6D706C657465222C66292C652E636F6E664974656D2626617065782E6974656D28652E636F6E664974656D292E656E61626C6528292C652E6469736162';
wwv_flow_api.g_varchar2_table(80) := '6C654974656D73262621652E636F6E664974656D2626792822656E61626C6522292C652E696E6C696E6549636F6E26267828772C213029293A742626617065782E6576656E742E74726967676572282223222B612C22666F732D61702D72756C652D636F';
wwv_flow_api.g_varchar2_table(81) := '6D706C657465222C66297D66756E6374696F6E204F286E297B696628652E73686F77537472656E677468426172297B6C657420653D303B666F72286C6574206E20696E206629665B6E5D7C7C652B2B3B6C6574206E3D3130302D652A643B6E3D333D3D63';
wwv_flow_api.g_varchar2_table(82) := '3F6E2D313A6E2C732E63737328227769647468222C6E2B222522297D6E2E706172656E7428292E637373287B636F6C6F723A652E6572726F72436F6C6F727D292C6E2E616464436C61737328652E72756C65734661696C49636F6E292E72656D6F766543';

wwv_flow_api.g_varchar2_table(83) := '6C61737328652E72756C6573436865636B49636F6E292C6E2E637373287B636F6C6F723A652E6572726F72436F6C6F727D292C617065782E6576656E742E74726967676572282223222B612C22666F732D61702D72756C652D6661696C222C66292C652E';
wwv_flow_api.g_varchar2_table(84) := '636F6E664974656D2626617065782E6974656D28652E636F6E664974656D292E64697361626C6528292C652E64697361626C654974656D73262621652E636F6E664974656D262679282264697361626C6522292C652E696E6C696E6549636F6E26267828';
wwv_flow_api.g_varchar2_table(85) := '772C2131297D7D3B0A2F2F2320736F757263654D617070696E6755524C3D7363726970742E6A732E6D6170';
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
wwv_flow_api.g_varchar2_table(4) := '226572726F72436F6C6F72222C22737472656E6774684261724267436F6C6F72222C22737472656E6774684261725769647468506374222C2246756E6374696F6E222C2263616C6C222C2274686973222C22737472656E677468426172456C222C227469';
wwv_flow_api.g_varchar2_table(5) := '746C65456C222C2272756C6573436F6E7461696E6572456C222C226974656D4E616D65222C226974656D526567696F6E222C2224222C22696E7075744669656C64222C2272756C6573222C22746573744E756D222C224F626A656374222C226B65797322';
wwv_flow_api.g_varchar2_table(6) := '2C226C656E677468222C22736570506F73222C224D617468222C22666C6F6F72222C22746573745374617465222C226C656E456C222C2266696E64222C226E756D456C222C2273706563456C222C22636170456C222C22464F535F41505F48494444454E';
wwv_flow_api.g_varchar2_table(7) := '5F434C415353222C226B6579222C22696E6C696E6549636F6E456C222C2276616C69646174655265717569726564222C226A5175657279222C226973456D7074794F626A656374222C226973436F6E6669726D6174696F6E4974656D222C22696E6C696E';
wwv_flow_api.g_varchar2_table(8) := '6549636F6E222C22616464436C617373222C22637373222C226C656674222C22636F6C6F72222C226F6E222C2265222C2272656D6F7665436C617373222C22746F67676C65496E6C696E6549636F6E222C2263757272656E74546172676574222C227661';
wwv_flow_api.g_varchar2_table(9) := '6C7565222C226973457665727952756C65506173736564222C22696E707574222C2274657374526573222C226E657756616C7565222C22746172676574222C227077644C656E677468222C2261747472696275746573222C22736574546F4661696C6564';
wwv_flow_api.g_varchar2_table(10) := '222C22736574546F436F6D706C65746564222C227077644E756D73222C2273222C2272657175697265644E756D222C227265676578222C22526567457870222C2274657374222C22636F6E7461696E734E756D62657273222C227077644361706974616C';
wwv_flow_api.g_varchar2_table(11) := '73222C22726571756972656443617073222C22636F6E7461696E734361706974616C4C657474657273222C22707764537065634368617273222C22726571756972656453706563222C226C6973744F665370656343686172222C22726571756972656453';
wwv_flow_api.g_varchar2_table(12) := '4E756D222C22636F6E7461696E735370656369616C43686172616374657273222C2272756C6573436F6E7461696E6572222C227469746C65456C5370616E222C22646F6E65222C227469746C654E616D65222C2261747472222C2261706578222C226D65';
wwv_flow_api.g_varchar2_table(13) := '7373616765222C22636C6561724572726F7273222C226368616E67655469746C6552756C65222C2272756C6573436F6D7054657874222C2272756C6573436F6E456C222C22646F63756D656E74222C22717565727953656C6563746F72416C6C222C2266';
wwv_flow_api.g_varchar2_table(14) := '6F7245616368222C2272756C65222C227374796C65222C22646973706C6179222C22686569676874222C226D61782D686569676874222C2270726F70222C22737562737472222C227469746C65526566726573686564222C2272756C65456C222C227175';
wwv_flow_api.g_varchar2_table(15) := '65727953656C6563746F72222C22696E6E657248544D4C222C2276616C6964617465222C227077645065656B222C2273706C6974222C2273686F7749636F6E222C2270616464696E672D7269676874222C2268696465507764222C22627574746F6E222C';
wwv_flow_api.g_varchar2_table(16) := '2273686F77507764222C22746F756368222C22746F7563686573222C22656C656D656E7446726F6D506F696E74222C22636C69656E7458222C22636C69656E7459222C2273686F77436170734C6F636B222C226361707349636F6E222C2269636F6E506F';
wwv_flow_api.g_varchar2_table(17) := '73222C226F726967696E616C4576656E74222C226765744D6F6469666965725374617465222C2265616368222C22656C222C2272756C6573436F6E7461696E65724964222C22726567696F6E456C222C22646574616368222C22746172676574456C222C';
wwv_flow_api.g_varchar2_table(18) := '22657874436F6E7461696E6572426F6479222C22617070656E64222C22736574456C656D656E745769647468222C2266616C736552756C65222C226669727374222C2268746D6C222C22746F67676C65436C617373222C2272756C6573436F6E222C2264';
wwv_flow_api.g_varchar2_table(19) := '697361626C654974656D73222C22636F6E664974656D222C22636F6E664974656D496478222C226974656D73546F44697361626C65222C22696E6465784F66222C2273706C696365222C227365744974656D735374617465222C2273686F774572726F72';
wwv_flow_api.g_varchar2_table(20) := '4966496E63222C2273686F774572726F7273222C2274797065222C226C6F636174696F6E222C22706167654974656D222C226576656E74222C2274726967676572222C2273686F77537472656E677468426172222C22626172436F6E7461696E6572222C';
wwv_flow_api.g_varchar2_table(21) := '226261636B67726F756E642D636F6C6F72222C226164644576656E744C697374656E6572222C226F626A222C2273657454696D656F7574222C2269222C2264697361626C65222C2273657456616C7565222C22636F6E6649636F6E456C222C22656E6162';
wwv_flow_api.g_varchar2_table(22) := '6C65222C226974656D56616C7565222C2276616C222C22706374222C226F757465725769647468222C22636F6E74656E74222C226E616D65222C226362222C22747269676765724576656E74222C227061737365645465737473222C2262617257696468';
wwv_flow_api.g_varchar2_table(23) := '74222C22706172656E74222C226661696C65645465737473222C226261725769647468225D2C226D617070696E6773223A22414145412C49414149412C4941414D432C4F41414F442C4B41414F2C4741437842412C49414149452C4B41414F462C494141';
wwv_flow_api.g_varchar2_table(24) := '49452C4D4141512C4741437642462C49414149452C4B41414B432C694241416D42482C49414149452C4B41414B432C6B42414171422C474169433144482C49414149452C4B41414B432C694241416942432C4B41414F2C53414153432C45414151432C47';
wwv_flow_api.g_varchar2_table(25) := '41456A44442C4541414F452C6341416B422C5341437A42462C4541414F472C6541416D422C6541433142482C4541414F492C6141416D422C6942414331424A2C4541414F4B2C6541416D422C6F42414331424C2C4541414F4D2C6341416B422C6F424143';
wwv_flow_api.g_varchar2_table(26) := '7A424E2C4541414F4F2C674241416F422C6F4241433342502C4541414F512C6541416D422C6F4241433142522C4541414F532C6141416D422C6F4241433142542C4541414F552C7142414177422C304241432F42562C4541414F572C6942414173422C55';
wwv_flow_api.g_varchar2_table(27) := '41433742582C4541414F592C61414171422C55414335425A2C4541414F612C57414167422C5541437642622C4541414F632C6D42414177422C5541432F42642C4541414F652C6F42414175422C4941473342642C47414155412C6141416B42652C554143';
wwv_flow_api.g_varchar2_table(28) := '3942662C4541414F67422C4B41414B432C4B41414B6C422C4741456C422C494161496D422C45414163432C45414151432C4541627442432C4541415774422C4541414F73422C5341436C42432C45414161432C454141452C49414149462C454141532C57';
wwv_flow_api.g_varchar2_table(29) := '41453542472C45414161442C454141452C49414149462C4741456E42492C4541415131422C4541414F30422C4D414566432C45414155432C4F41414F432C4B41414B482C4741414F492C4F41453742432C45414153432C4B41414B432C4D41414D2C4941';
wwv_flow_api.g_varchar2_table(30) := '414D4E2C47414531424F2C454141592C4741495A6E422C4541417342662C4541414F652C6F42414173422C4941456E446F422C454141535A2C45414157612C4B41414B2C6B4341437A42432C45414153642C45414157612C4B41414B2C6D4341437A4245';
wwv_flow_api.g_varchar2_table(31) := '2C45414153662C45414157612C4B41414B2C384341437A42472C4541415368422C45414157612C4B41414B2C3243414537422C4D41414D492C45414173422C63414D35422C494141492C49414149432C4B41414F662C45414358412C4541414D652C4B41';
wwv_flow_api.g_varchar2_table(32) := '4352502C454141554F2C4941414F2C4741496E422C49414749432C45414841432C4741416F42432C4F41414F432C63414163582C4B4141656C432C4541414F38432C6D42412B426E452C474133424739432C4541414F2B432C614143544C2C454141656E';
wwv_flow_api.g_varchar2_table(33) := '422C45414157612C4B41414B2C344241432F424D2C454141614D2C534141532C4341414368442C4541414F512C654141674267432C4941433943452C454141614F2C494141492C43414143432C4B4141512C53414155432C4D4141536E442C4541414F61';
wwv_flow_api.g_varchar2_table(34) := '2C614143684438422C474141714233432C4541414F38432C714241432F4272422C4541415732422C474141472C534141532C53414153432C4741432F42582C45414161592C59414159642C4D41453142662C4541415732422C474141472C534141532C53';
wwv_flow_api.g_varchar2_table(35) := '414153432C4741432F42452C4541416942622C45414163572C45414145472C63414163432C4D41414D33422C4F4141532C51414D3944612C474143466C422C4541415732422C474141472C6742414167422C53414153432C4741436E4372442C4541414F';
wwv_flow_api.g_varchar2_table(36) := '2B432C59414354572C4741416B422C5741436A42482C4541416942622C474141612C4D41304F6C432C5341416B4269422C4741436A422C49414349432C45414441432C45414159462C4541414D472C4F41414F4C2C4D414931422F422C4541414D71432C';
wwv_flow_api.g_varchar2_table(37) := '59414352482C45414155432C454141532F422C4F4141534A2C4541414D71432C55414155432C574141576C432C4F41436E4438422C4741415731422C4541415536422C574143784237422C4541415536422C574141592C4541437442452C454141593942';
wwv_flow_api.g_varchar2_table(38) := '2C4941434679422C4741415931422C4541415536422C594143684337422C4541415536422C574141592C4541437442472C454141652F422C4B414B64542C4541414D79432C55414352502C45416B46462C5341417942512C47414378422C49414149432C';
wwv_flow_api.g_varchar2_table(39) := '4541416333432C4541414D79432C51414151482C574141576C432C4F414533432C4F41444177432C4D4141512C49414149432C4F41414F2C61414161462C454141592C4B41414D2C4B41433343432C4D41414D452C4B41414B4A2C47417246504B2C4341';
wwv_flow_api.g_varchar2_table(40) := '4167425A2C4741437442442C4941415931422C4541415569432C5341437A426A432C4541415569432C534141552C4541437042442C4541416537422C4B41434C75422C4741415731422C4541415569432C5541432F426A432C4541415569432C53414155';
wwv_flow_api.g_varchar2_table(41) := '2C4541437042462C4541415935422C4B414B58582C4541414D67442C63414352642C45413245462C5341416743512C4741432F422C494141494F2C454141656A442C4541414D67442C59414159562C574141576C432C4F414568442C4F41444177432C4D';
wwv_flow_api.g_varchar2_table(42) := '4141512C49414149432C4F41414F2C61414161492C454141612C4B41414B2C4B414333434C2C4D41414D452C4B41414B4A2C4741394550512C4341417542662C4741433742442C4941415931422C4541415577432C6141437A4278432C4541415577432C';
wwv_flow_api.g_varchar2_table(43) := '614141632C4541437842522C4541416533422C4B41434C71422C4741415731422C4541415577432C6341432F4278432C4541415577432C614141632C4541437842542C4541415931422C4B414B58622C4541414D6D442C654143526A422C45416F45462C';
wwv_flow_api.g_varchar2_table(44) := '5341416D43512C4741436C432C49414149552C4541416570442C4541414D6D442C61414161622C57414157652C6541433743432C4541416574442C4541414D6D442C61414161622C574141576C432C4F41456A442C4F41444177432C4D4141512C494141';
wwv_flow_api.g_varchar2_table(45) := '49432C4F41414F2C4B41414B4F2C454141612C51414151452C454141612C4B41414B2C4B41437844562C4D41414D452C4B41414B4A2C4741784550612C434141304270422C4741436843442C4941415931422C4541415532432C6341437A4233432C4541';
wwv_flow_api.g_varchar2_table(46) := '415532432C634141652C4541437A42582C4541416535422C4B41434C73422C4741415731422C4541415532432C6541432F4233432C4541415532432C634141652C4541437A425A2C4541415933422C4B414B642C47414134422C6541417A4274432C4541';
wwv_flow_api.g_varchar2_table(47) := '414F6B462C65414167432C4341437A432C49414149432C4541416335442C45414157612C4B41414B2C73434143394267442C4741414F2C4541435831422C4741416B422C5741436A4230422C4741414F2C4B4145522C49414149432C454141596A452C45';
wwv_flow_api.g_varchar2_table(48) := '4141516B452C4B41414B2C51414337422C47414147462C4741416F422C5141415A432C4541416D422C4341433742452C4B41414B432C51414151432C594141596E452C4741437A426F452C454141674231462C4541414F32462C634141652C5141437443';
wwv_flow_api.g_varchar2_table(49) := '7A422C4541416569422C474141592C47414333422C49414149532C4541416176452C4541436A4277452C53414153432C6942414169422C4941414978452C454141532C77424141774279452C534141512C53414153432C4741432F45412C4541414B432C';
wwv_flow_api.g_varchar2_table(50) := '4D41414D432C514141552C5741456E424E2C454141574F2C534141572C4741437842502C4541415733432C494141492C434141436D442C61414163522C45414157532C4B41414B2C6742414167422C5941472F442C474141476E452C454141556D442C45';
wwv_flow_api.g_varchar2_table(51) := '41415569422C4F41414F2C4B41416F422C514141626A422C4541416F422C43414378442C494141496B422C47414169422C45414372422C494141492C49414149462C4B4141516E452C454141552C4341437A422C4941414973452C45414153582C534141';
wwv_flow_api.g_varchar2_table(52) := '53592C634141632C494141496E462C454141532C6943414169432B452C4541414B2C4D41436E466E452C454141556D452C49414354452C4541574A432C4541414F502C4D41414D432C514141552C53415674424D2C4541414F502C4D41414D432C514141';
wwv_flow_api.g_varchar2_table(53) := '552C4F4143502C51414162622C474143466E422C4541416569422C474141592C47414535424F2C4541416742632C4541414F452C554141552C574141574C2C4741433543452C47414169422C4D4131547442492C4341415374442C4D414B552C5941416C';
wwv_flow_api.g_varchar2_table(54) := '4272442C4541414F34472C51414173422C4341432F4235472C4541414F472C6541416942482C4541414F472C6541416530472C4D41414D2C4B4143704437472C4541414F452C6341416742462C4541414F452C6341416332472C4D41414D2C4B41436C44';
wwv_flow_api.g_varchar2_table(55) := '2C49414149432C4541415776462C45414157612C4B41414B2C6F4241432F4230452C4541415339442C5341415368442C4541414F472C674241457A4273422C4541415777422C494141492C4341414338442C6742414167422C57414537422F472C454141';
wwv_flow_api.g_varchar2_table(56) := '4F2B432C594143544C2C454141614F2C494141492C43414143432C4B4141512C5941474C2C774241416E426C442C4541414F34472C53414354452C4541415331442C474141472C384241412B4234442C4741433343462C4541415331442C474141472C61';
wwv_flow_api.g_varchar2_table(57) := '4141612C53414153432C4741436A422C49414162412C4541414534442C5141434A432C454141516A472C4B41414B36462C4D414766412C4541415331442C474141472C634141632C53414153432C4741436C432C4941414938442C4541415139442C4541';
wwv_flow_api.g_varchar2_table(58) := '41452B442C514141512C4741435676422C5341415377422C694241416942462C4541414D472C51414151482C4541414D492C5541457A444C2C454141516A472C4B41414B36462C4F4147612C6D4241416E4239472C4541414F34472C5341436842452C45';
wwv_flow_api.g_varchar2_table(59) := '41415331442C474141472C53413254642C57414334422C594141334233422C4541415736442C4B41414B2C514141774234422C454141516A472C4B41414B432C4D41415138462C454141512F462C4B41414B432C5341785433452C474141476C422C4541';
wwv_flow_api.g_varchar2_table(60) := '414F77482C614141612C43414374422C49414149432C454141576C472C45414157612C4B41414B2C694241432F4271462C454141537A452C534141532C4341414368442C4541414F492C614141616F432C49414576432C494141496B462C45414136422C';
wwv_flow_api.g_varchar2_table(61) := '6141416E4231482C4541414F34472C51414179422C534141572C5541437A44612C4541415378452C494141492C43414143432C4B41415177452C49414574426A472C4541415732422C474141472C594141592C53414153432C4741432F4272442C454141';
wwv_flow_api.g_varchar2_table(62) := '4F2B432C594143544C2C45414161592C59414159642C474145314269462C454141537A452C53414153522C4D41476E42662C4541415732422C474141472C534141532C53414153432C4741433542412C4541414573452C63414163432C6942414169422C';
wwv_flow_api.g_varchar2_table(63) := '614143684335482C4541414F2B432C594143544C2C454141614D2C53414153522C474145764269462C454141536E452C59414159642C4B41456C4278432C4541414F2B432C594143544C2C45414161592C59414159642C474145314269462C454141537A';
wwv_flow_api.g_varchar2_table(64) := '452C53414153522C4F416172422C47415234422C5541417A4278432C4541414F6B462C674241435433442C45414157612C4B41414B2C5941415979462C4D41414B2C57414368432C49414149432C4541414B74472C454141454E2C4D41435834472C4541';
wwv_flow_api.g_varchar2_table(65) := '414739452C5341415368442C4541414F4D2C6541436E4277482C4541414737452C494141492C43414143452C4D4141536E442C4541414F612C67424149452C5941417A42622C4541414F6B462C6742414167436C462C4541414F2B482C6942414169422C';
wwv_flow_api.g_varchar2_table(66) := '4341436A452C49414149432C454141577A472C45414157612C4B41414B2C38424141384236462C5341437A44432C4541415731472C454141452C4941414978422C4541414F2B482C6B4241437842492C4541416D42442C4541415339462C4B41414B2C6B';
wwv_flow_api.g_varchar2_table(67) := '4241434E2C49414135422B462C454141694272472C4F41436E4271472C4541416942432C4F41414F4A2C4741457842452C45414153452C4F41414F4A2C5141536A422C47414E34422C5541417A4268492C4541414F6B462C694241435439442C45414155';
wwv_flow_api.g_varchar2_table(68) := '472C45414157612C4B41414B2C364241433142662C4541416D42452C45414157612C4B41414B2C714241436E4369472C45414167426A482C474143684269482C454141674268482C494145572C6541417A4272422C4541414F6B462C674241416D437643';
wwv_flow_api.g_varchar2_table(69) := '2C45414169422C43414537442C4941414932462C454141592F472C45414157612C4B41414B2C6742414167426D472C51414568446E482C454141516F482C4B41414B462C45414155452C514143764270482C454141516B452C4B41414B2C4F4141512C51';
wwv_flow_api.g_varchar2_table(70) := '41415167442C4541415568442C4B41414B2C534145354367442C4541415572462C494141492C4341414369442C514141572C534145314239452C4541415167432C474141472C534141532C53414153432C474143354237422C454141454E2C4D41414D75';
wwv_flow_api.g_varchar2_table(71) := '482C594141592C55414370422C49414149432C4541415772482C4541435A71482C4541415376432C534141572C454143744275432C454141537A462C494141492C434141436D442C614141632C494145354273432C454141537A462C494141492C434141';
wwv_flow_api.g_varchar2_table(72) := '436D442C6141416373432C4541415372432C4B41414B2C6742414167422C55414D39442C4741414772472C4541414F32492C614141612C43414574422C4741414733492C4541414F34492C534141532C4341436C422C49414149432C4541416337492C45';
wwv_flow_api.g_varchar2_table(73) := '41414F38492C65414165432C514141512F492C4541414F34492C5541437044432C474141652C4741436A4237492C4541414F38492C65414165452C4F41414F482C454141592C4741473343492C454141632C57417142662C47416A42476A4A2C4541414F';
wwv_flow_api.g_varchar2_table(74) := '6B4A2C674241416B4276472C49414333426C422C4541415732422C474141472C594141592C53414153432C4741436C434B2C4741416B422C5741436A4236422C4B41414B432C5141415132442C574141572C4341437642432C4B41414D2C5141434E432C';
wwv_flow_api.g_varchar2_table(75) := '534141552C53414356432C5341415568492C454143566B452C5141415378462C4541414F532C6541456A4238452C4B41414B67452C4D41414D432C514141512C494141496C492C4541724B452C754241714B3642592C5341477844542C4541415732422C';
wwv_flow_api.g_varchar2_table(76) := '474141472C574141572C53414153432C4741436A436B432C4B41414B432C51414151432C594141596E452C4F4149784274422C4541414F794A2C6742414167422C4341457A4274492C4541416742492C45414157612C4B41414B2C3242414568432C4941';
wwv_flow_api.g_varchar2_table(77) := '414973482C454141656E492C45414157612C4B41414B2C2B4241436E4373482C4541416174482C4B41414B2C6F4241416F42612C494141492C4341414330472C6D4241416F42334A2C4541414F632C71424143744534492C4541416174482C4B41414B2C';
wwv_flow_api.g_varchar2_table(78) := '324241413242612C494141492C4341414330472C6D4241416F42334A2C4541414F592C654147374568422C4F41414F674B2C6942414169422C554141532C5341415376472C4741437A4367462C454141674271422C4541416133492C4D4147394277452C';
wwv_flow_api.g_varchar2_table(79) := '4B41414B33432C4F41414F2C63414163512C474141472C7742414177422C534141536D472C4541414F4D2C4741437045432C594141572C574143567A422C454141674271422C4541416133492C4B414333422C5141474A73482C454141674271422C4541';
wwv_flow_api.g_varchar2_table(80) := '416133492C474145432C5741413342662C4541414F572C6B42414354632C4541415732422C474141472C574141572C53414153432C4741436A4371472C4541416131472C534141532C71424145764276422C4541415732422C474141472C594141592C53';
wwv_flow_api.g_varchar2_table(81) := '414153432C4741436C4371472C4541416170472C594141592C73424145552C554141334274442C4541414F572C6B42414368422B492C4541416131472C534141532C6B42414776422C494141492C494141492B472C454141492C45414147412C45414149';
wwv_flow_api.g_varchar2_table(82) := '70492C454141536F492C49414333424C2C4541416174422C4F41414F2C6F424141714272472C4541415367492C454141452C7743414B74442C474141472F4A2C4541414F34492C534141532C4341456C4272442C4B41414B31462C4B41414B472C454141';
wwv_flow_api.g_varchar2_table(83) := '4F34492C554141556F422C55414533422C4941414970422C4541415770482C454141452C4941414978422C4541414F34492C55414535426E482C4541415732422C474141472C534141532C53414153432C4741432F426B432C4B41414B31462C4B41414B';
wwv_flow_api.g_varchar2_table(84) := '472C4541414F34492C5541415571422C534141532C494143704331472C454141694232472C474141572C47414335426A422C454141632C5741435674472C49414341552C45414145472C63414163432C4D41414D33422C4F4141532C4541436A4379442C';
wwv_flow_api.g_varchar2_table(85) := '4B41414B31462C4B41414B472C4541414F34492C5541415575422C534145334235452C4B41414B31462C4B41414B472C4541414F34492C554141556F422C63414B394270422C4541415378462C474141472C574141552C53414153432C47414339423647';
wwv_flow_api.g_varchar2_table(86) := '2C4541415735472C59414159642C47414376422B432C4B41414B432C51414151432C594141597A462C4541414F34492C6141476A432C4941414973422C4541416131492C454141452C4941414978422C4541414F34492C534141532C6F4341437643412C';
wwv_flow_api.g_varchar2_table(87) := '4541415378462C474141472C534141532C53414153432C47414337422C494141492B472C4541415933492C4541415734492C4D4143784268482C45414145532C4F41414F4C2C4F41415332472C474143704237472C454141694232472C474141592C4741';
wwv_flow_api.g_varchar2_table(88) := '4337426A422C454141632C6141456431462C454141694232472C474141592C47414337426A422C454141632C63414968424C2C4541415378462C474141472C594141592C53414153432C47414368432C494141492B472C4541415933492C454141573449';
wwv_flow_api.g_varchar2_table(89) := '2C4D4143784268482C45414145532C4F41414F4C2C4F41415332472C4741436A42704B2C4541414F6B4A2C674241435433442C4B41414B432C5141415132442C574141572C4341437642432C4B41414D2C5141434E432C534141552C53414356432C5341';
wwv_flow_api.g_varchar2_table(90) := '4155744A2C4541414F34492C5341436A4270442C5141415378462C4541414F552C754241476C4275492C454141632C59414564412C454141632C614173476A422C534141535A2C4541416742502C4541414777432C4541414D2C4741436A4378432C4541';
wwv_flow_api.g_varchar2_table(91) := '414737452C494141492C5141415378422C4541415738492C61414165442C4541414D2C4D4171426A442C5341415370442C4941435231462C454141454E2C4D41414D6F432C5941415974442C4541414F472C67424141674236432C5341415368442C4541';
wwv_flow_api.g_varchar2_table(92) := '414F452C654143334475422C4541415736442C4B41414B2C4F4141512C5141457A422C5341415330422C4941435278462C454141454E2C4D41414D6F432C5941415974442C4541414F452C6541416538432C5341415368442C4541414F472C6742414331';
wwv_flow_api.g_varchar2_table(93) := '4473422C4541415736442C4B41414B2C4F4141512C5941457A422C534141532F422C454141694275452C4541414973422C4741433142412C4741434674422C4541414737452C494141492C43414143452C4D4141536E442C4541414F592C65414378426B';
wwv_flow_api.g_varchar2_table(94) := '482C4541414778452C5941415974442C4541414F512C67424141674277432C5341415368442C4541414F4F2C6D424145744475482C4541414737452C494141492C43414143452C4D4141536E442C4541414F612C614143784269482C4541414778452C59';
wwv_flow_api.g_varchar2_table(95) := '41415974442C4541414F4F2C69424141694279432C5341415368442C4541414F512C694241477A442C5341415379492C45414163472C4741436C42704A2C4541414F32492C6341475833492C4541414F38492C654141652F432C534141512C534141536C';
wwv_flow_api.g_varchar2_table(96) := '472C474143744330462C4B41414B432C51414151432C5941415935462C474143642C55414152754A2C4741434635482C454141452C4941414933422C4741414D79442C594141592C69424143784269432C4B41414B31462C4B41414B412C4741414D734B';
wwv_flow_api.g_varchar2_table(97) := '2C574145684233492C454141452C4941414933422C4741414D6D442C534141532C69424143724275432C4B41414B31462C4B41414B412C4741414D6D4B2C6341496E422C5341415374452C454141674238452C45414153432C4741436A43724A2C454141';
wwv_flow_api.g_varchar2_table(98) := '5136422C494141492C43414143452C4D4141536E442C4541414F592C6541433742512C454141516B432C594141592C6D42414370426C432C4541415134422C534141532C6D4241436A4238472C594141572C5741435631492C454141516B432C59414159';
wwv_flow_api.g_varchar2_table(99) := '2C6D42414370426C432C4541415134422C534141532C6D4241434E2C5141415279482C47414346724A2C4541415136422C494141492C43414143452C4D4141536E442C4541414F612C61414539424F2C454141516F482C4B41414B67432C474141572C49';
wwv_flow_api.g_varchar2_table(100) := '41437842704A2C454141516B452C4B41414B2C4F41414F6D462C4B41436E422C4B4145482C534141532F472C4541416B4267482C47414331422C494141492C49414149582C4B41414B37482C4541435A2C49414149412C4541415536482C474141472C43';
wwv_flow_api.g_varchar2_table(101) := '41436842572C494143412C4F4149482C5341415378472C4541416534442C4541414736432C474141652C4741437A432C49414149432C454141632C4541436C422C494141492C494141496E492C4B41414F502C45414358412C454141554F2C4941435A6D';
wwv_flow_api.g_varchar2_table(102) := '492C494147462C47414147354B2C4541414F794A2C6742414167422C4341437A422C494141496F422C45414157442C4541416337492C454143374238492C45414175422C4941415A412C45414169422C4941414D412C4541436C43314A2C454141633842';
wwv_flow_api.g_varchar2_table(103) := '2C494141492C5141415334482C454141532C4B414572432F432C4541414767442C5341415337482C494141492C43414143452C4D4141536E442C4541414F592C6541436A436B482C4541414739452C5341415368442C4541414F4B2C6742414167426944';
wwv_flow_api.g_varchar2_table(104) := '2C5941415974442C4541414F4D2C654143744477482C4541414737452C494141492C43414143452C4D4141536E442C4541414F592C6541437242674B2C474141656A4A2C47414364674A2C4741434670462C4B41414B67452C4D41414D432C514141512C';
wwv_flow_api.g_varchar2_table(105) := '494141496C492C45417A634D2C36424179633642592C47414578446C432C4541414F34492C5541435472442C4B41414B31462C4B41414B472C4541414F34492C5541415575422C5341457A426E4B2C4541414F32492C654141694233492C4541414F3449';
wwv_flow_api.g_varchar2_table(106) := '2C5541436A434B2C454141632C5541455A6A4A2C4541414F2B432C59414354512C4541416942622C474141632C494147374269492C4741434670462C4B41414B67452C4D41414D432C514141512C494141496C492C45417664452C75424175643642592C';
wwv_flow_api.g_varchar2_table(107) := '4741497A442C534141532B422C4541415936442C47414370422C4741414739482C4541414F794A2C6742414167422C4341437A422C4941414973422C454141632C4541436C422C494141492C4941414974492C4B41414F502C45414356412C454141554F';
wwv_flow_api.g_varchar2_table(108) := '2C4941436273492C494147462C49414149432C454141572C4941414D442C45414163684A2C4541436E43694A2C45414173422C47414158724A2C45414165714A2C454141572C45414149412C4541437A43374A2C4541416338422C494141492C51414153';
wwv_flow_api.g_varchar2_table(109) := '2B482C454141532C4B414572436C442C4541414767442C5341415337482C494141492C43414143452C4D4141536E442C4541414F612C6141436A4369482C4541414739452C5341415368442C4541414F4D2C6541416567442C5941415974442C4541414F';
wwv_flow_api.g_varchar2_table(110) := '4B2C67424143724479482C4541414737452C494141492C43414143452C4D4141536E442C4541414F612C614143784230452C4B41414B67452C4D41414D432C514141512C494141496C492C45417865412C6D424177653242592C4741432F436C432C4541';
wwv_flow_api.g_varchar2_table(111) := '414F34492C5541435472442C4B41414B31462C4B41414B472C4541414F34492C554141556F422C5541457A42684B2C4541414F32492C654141694233492C4541414F34492C5541436A434B2C454141632C5741455A6A4A2C4541414F2B432C5941435451';
wwv_flow_api.g_varchar2_table(112) := '2C4541416942622C47414163222C2266696C65223A227363726970742E6A73227D';
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


