/* global apex,$ */

var FOS = window.FOS || {};
FOS.item = FOS.item || {};
FOS.item.advancedPassword = FOS.item.advancedPassword  || {};

/**
 *
 * @param {object}   	config 	                    	Configuration object containing the plugin settings
 * @param {string}   	config.itemName             	The name of the item
 * @param {object}   	config.rules                	Object holding information about the selected validation rules
 * @param {boolean}		config.showCapsLock				When true then an icon will be displayed if the Caps Lock is active
 * @param {string}		config.pwdPeek					The style of the 'peek' functionality
 * @param {string}	    [config.isConfirmationItem]		Must to be true, if the instance is a confirmations(secondary) item
 * @param {string}		[config.peekShownIcon]			Icon to be displayed when the password is revealed
 * @param {string}		[config.peekHiddenIcon]			Icon to be displayed when the password is hidden
 * @param {boolean}		config.showStrengthBar			When true then a bar will be displayed under the item which shows the state of the completed validation rules
 * @param {string}		[config.strengthBarStyle]		Style of the strength bar [dynamic | static]
 * @param {string}		config.rulesContainer			The style of the container which contains the individual rules [collapsible | static | hidden]
 * @param {string}		config.rulesContainerId			The ID of the target external rules container element.
 * @param {string}		[config.rulesCompText]			If the 'rules-container' is collapsible, then a success message can be displayed when all the rules passed
 * @param {string}		[config.rulesCheckIcon]			The icon which will be used when an individual rule is fulfilled
 * @param {string}		[config.rulesFailIcon]			The icon which will be used when an individual rule is failedz
 * @param {string}	    [config.inlineCheckIcon]		If it's provided, then this icon will be displayed in the item when the input field becomes valid
 * @param {string}	    [config.inlineFailIcon]			If it's provided, then this icon will be displayed in the item when the input field is invalid
 * @param {string}		[config.capLockIcon]			The icon which indicates when the CapsLock is turned
 * @param {array}		config.itemsToDisable			Array of page items(/buttons). The elements of this list will disabled as long as all the rules are not completed
 * @param {string}		config.confItem					Confirmation item. If it's provided, then the items in the 'itemsToDisable' array are depending on this element's state
 * @param {string}		[config.confItemErrorMessage]	Error message if the passwords do not match
 * @param {string}		[config.errorMessage]			Error message if the the the rules are not passed
 * @param {string}		[config.errorColor]				Color of the failed icons/rules
 * @param {string}		[config.successColor]			Color of the completed icons/rules/strength-bar
 * @param {string}		[config.strengthBarBgColor]		Background color of the strength bar
 * @param {number}		[config.strengthBarWidthPct]	Width of the strengt bar relative to the input field
 * @param {function}  	initJs  						Optional Initialization JavaScript Code function
 */

FOS.item.advancedPassword.init = function(config, initJs){
	// default values to the attributes that can be set only trough initJs
	config.peekShownIcon		 = 'fa-eye';
	config.peekHiddenIcon		 = 'fa-eye-slash';
	config.capsLockIcon		 	 = 'fa-change-case';
	config.rulesCheckIcon		 = 'fa-check-circle-o';
	config.rulesFailIcon		 = 'fa-times-circle-o';
	config.inlineCheckIcon		 = 'fa-check-circle-o';
	config.inlineFailIcon		 = 'fa-times-circle-o';
	config.errorMessage		 	 = 'Invalid password.';
	config.confItemErrorMessage  = 'Passwords do not match.';
	config.strengthBarStyle	 	 = 'dynamic';
	config.successColor		     = '#5ac240';
	config.errorColor			 = '#eb4034';
	config.strengthBarBgColor    = '#778899';
	config.strengthBarWidthPct	 = 100;

	// execute the initJs function
	if(initJs && initJs instanceof Function){
		initJs.call(this,config);
	}
	let itemName = config.itemName;
	let itemRegion = $('#'+itemName+'_region');
	// the input field itself
	let inputField = $('#'+itemName);
	// required rules
	let rules = config.rules;
	// the number of rules
	let testNum = Object.keys(rules).length;
	// calculate the number of separators in the strength bar
	let sepPos = Math.floor(100 / testNum);
	// we store the state of every rule in an object
	let testState = {};
	// the strengthbar element
	let strengthBarEl,titleEl,rulesContainerEl;
	// show strength bar
	let strengthBarWidthPct = config.strengthBarWidthPct / 100;

	let lenEl  = itemRegion.find('.password-rule-length .fos-pwd');
	let numEl  = itemRegion.find('.password-rule-numbers .fos-pwd');
	let specEl = itemRegion.find('.password-rule-special-characters .fos-pwd');
	let capEl  = itemRegion.find('.password-rule-capital-letters .fos-pwd');

	const FOS_AP_HIDDEN_CLASS = 'fos-ap-hide';
	const RULE_COMPLETE_EVENT = 'fos-ap-rule-complete';
	const RULE_ALL_COMPLETE_EVENT = 'fos-ap-every-rule-complete';
	const RULE_FAIL_EVENT = 'fos-ap-rule-fail';
	const INVALID_FIELD_EVENT = 'fos-ap-invalid-field';

	for(let key in rules){
		if(rules[key]){
			testState[key] = false;
		}
	}
	// check if there's at least one rule added selected
	let validateRequired = !jQuery.isEmptyObject(testState) && !config.isConfirmationItem;

	// inline check icon
	let inlineIconEl;
	if(config.inlineIcon){
		inlineIconEl = itemRegion.find('span.fos-ap-inline-check');
		inlineIconEl.addClass([config.inlineFailIcon, FOS_AP_HIDDEN_CLASS]);
		inlineIconEl.css({'left': '-.2rem', 'color': config.errorColor});
		if(!validateRequired && !config.isConfirmationItem){
			inputField.on('focus', function(e){
				inlineIconEl.removeClass(FOS_AP_HIDDEN_CLASS);
			});
			inputField.on('input', function(e){
				toggleInlineIcon(inlineIconEl, e.currentTarget.value.length > 0);
			});
		}
	}

	// add validation if required
	if(validateRequired){
		inputField.on('keyup change', function(e){
			if(config.inlineIcon){
				isEveryRulePassed(function(){
					toggleInlineIcon(inlineIconEl,false);
				});
			}
			validate(e);
		});
	}

	// the Peek functionality
	if(config.pwdPeek != 'disabled'){
		config.peekHiddenIcon = config.peekHiddenIcon.split(' ');
		config.peekShownIcon = config.peekShownIcon.split(' ');
		let showIcon = itemRegion.find('.ap-password-eye');
		showIcon.addClass(config.peekHiddenIcon);
		// extend the input field
		inputField.css({'padding-right':'3.3rem'});
		// to avoid overlapping, we have to modify the inline icon's position
		if(config.inlineIcon){
			inlineIconEl.css({'left': '-3.3rem'});
		}
		// add the listeners based on the settings
		if(config.pwdPeek === 'enabled-click-press'){
			showIcon.on('mouseup mouseleave touchend', hidePwd);
			showIcon.on('mousedown', function(e){
				if(e.button === 0){
					showPwd.call(showIcon);
				}
			});
			showIcon.on('touchstart', function(e){
				let touch = e.touches[0];
				let sIcon = document.elementFromPoint(touch.clientX,touch.clientY);
				if(sIcon){
					showPwd.call(showIcon);
				}
			});
		} else if(config.pwdPeek === 'enabled-toggle'){
			showIcon.on('click', togglePwd);
		}
	}
	// show capsLock on
	if(config.showCapsLock){
		let capsIcon = itemRegion.find('.ap-caps-lock');
		capsIcon.addClass([config.capsLockIcon,FOS_AP_HIDDEN_CLASS]);
		// to avoid overlapping we have to modify the icon's position
		let iconPos = config.pwdPeek === 'disabled' ? '-.2rem' : '-3.3rem';
		capsIcon.css({'left': iconPos});
		// hide the icon if the field is not active
		inputField.on('focusout', function(e){
			if(config.inlineIcon){
				inlineIconEl.removeClass(FOS_AP_HIDDEN_CLASS);
			}
			capsIcon.addClass(FOS_AP_HIDDEN_CLASS);
		});
		// add the listener on the field
		inputField.on('keyup', function(e){
			if(e.originalEvent.getModifierState('CapsLock')){
				if(config.inlineIcon){
					inlineIconEl.addClass(FOS_AP_HIDDEN_CLASS);
				}
				capsIcon.removeClass(FOS_AP_HIDDEN_CLASS);
			} else {
				if(config.inlineIcon){
					inlineIconEl.removeClass(FOS_AP_HIDDEN_CLASS);
				}
				capsIcon.addClass(FOS_AP_HIDDEN_CLASS);
			}
		 });
	}

	if(config.rulesContainer != 'hidden'){
		itemRegion.find('.fos-pwd').each(function(){
			let el = $(this);
			el.addClass(config.rulesFailIcon);
			el.css({'color': config.errorColor});
		});
	}

	if(config.rulesContainer == 'external' && config.rulesContainerId){
		let regionEl = itemRegion.find('.fos-ap-container-external').detach();
		let targetEl = $('#'+config.rulesContainerId);
		let extContainerBody = targetEl.find('.t-Region-body');
		if(extContainerBody.length === 1){
			extContainerBody.append(regionEl);
		} else {
			targetEl.append(regionEl);
		}
	} else {
		if(config.rulesContainer != 'hidden'){
			titleEl = itemRegion.find('.fos-ap-constraints-title');
			rulesContainerEl = itemRegion.find('.fos-ap-container');
			setElementWidth(titleEl);
			setElementWidth(rulesContainerEl);
		}
		if(config.rulesContainer == 'collapsible' && validateRequired){
			// select the first failed rule
			let falseRule = itemRegion.find('.fos-ap-rule').first();
			// put the content of it into the title element
			titleEl.html(falseRule.html());
			titleEl.attr('name', 'title'+falseRule.attr('name'));
			// and hide it from the container
			falseRule.css({'display': 'none'});
			// add the collapse/expand functionality
			titleEl.on('click', function(e){
				$(this).toggleClass('active');
				let rulesCon = rulesContainerEl;
				if(rulesCon.height() > 0){
					rulesCon.css({'max-height': 0});
				} else {
					rulesCon.css({'max-height': rulesCon.prop('scrollHeight')+'px'});
				}
			});
		}
	}
	// disable items if invalid
	if(config.disableItems){
		// remove the confirmation element from the itemsToDisable array, it's handled in a different way
		if(config.confItem){
			let confItemIdx = config.itemsToDisable.indexOf(config.confItem);
			if(confItemIdx > -1){
				config.itemsToDisable.splice(confItemIdx,1);
			}
		}
		setItemsState('disable');
	}

	// show error if invalid
	if(config.showErrorIfInc && validateRequired){
		inputField.on('focusout', function(e){
			isEveryRulePassed(function(){
				apex.message.showErrors({
					type: 'error',
					location: 'inline',
					pageItem: itemName,
					message: config.errorMessage
				});
				apex.event.trigger('#'+itemName, INVALID_FIELD_EVENT, testState);
			});
		});
		inputField.on('focusin', function(e){
			apex.message.clearErrors(itemName);
		});
	}

	if(config.showStrengthBar){
		//strengthBarWidthPct = config.strengthBarWidthPct / 100;
		strengthBarEl = itemRegion.find('.fos-strength-container');
		// set the color
		let barContainer = itemRegion.find('.fos-strength-bar-container');
		barContainer.find('.fos-strength-bg').css({'background-color': config.strengthBarBgColor});
		barContainer.find('.fos-strength-container').css({'background-color': config.successColor});

		// have to recalculate the width of the bar on window resize
		window.addEventListener('resize',function(e){
			setElementWidth(barContainer,strengthBarWidthPct);
		});
		// and on open and close of the side navbar
		apex.jQuery("#t_TreeNav").on('theme42layoutchanged', function(event, obj) {
			setTimeout(function(){
				setElementWidth(barContainer,strengthBarWidthPct);
			}, 300);
    	});

		setElementWidth(barContainer,strengthBarWidthPct);

		if(config.strengthBarStyle == 'dynamic'){
			inputField.on('focusin', function(e){
				barContainer.addClass('fos-bar-active');
			});
			inputField.on('focusout', function(e){
				barContainer.removeClass('fos-bar-active');
			});
		} else if(config.strengthBarStyle == 'static'){
			barContainer.addClass('fos-bar-active');
		}

		for(let i = 1; i < testNum; i++){
			barContainer.append('<div style="left:'+ sepPos * i+'%" class="fos-strength-split"></div>');
		}
	}

	// confirmation item
	if(config.confItem){
		// set the confirmation item to disabled
		apex.item(config.confItem).disable();
		// get the item
		let confItem = $('#'+config.confItem);
		// on every chage on the plugin field the confirmation item will be set to null
		inputField.on('input', function(e){
			apex.item(config.confItem).setValue('');
			toggleInlineIcon(confIconEl,false);
			setItemsState('disable');
			if(!validateRequired){
				if(e.currentTarget.value.length > 0){
					apex.item(config.confItem).enable();
				} else {
					apex.item(config.confItem).disable();
				}
			}
		});

		confItem.on('focusin',function(e){
			confIconEl.removeClass(FOS_AP_HIDDEN_CLASS);
			apex.message.clearErrors(config.confItem);
		});

		let confIconEl = $('#'+config.confItem+'_region span.fos-ap-inline-check');
		confItem.on('input', function(e){
			let itemValue = inputField.val();
			if(e.target.value != itemValue){
				toggleInlineIcon(confIconEl, false);
				setItemsState('disable');
			} else {
				toggleInlineIcon(confIconEl, true);
				setItemsState('enable');
			}
		});

		confItem.on('focusout', function(e){
			let itemValue = inputField.val();
			if(e.target.value != itemValue){
				if(config.showErrorIfInc){
					apex.message.showErrors({
						type: "error",
						location: "inline",
						pageItem: config.confItem,
						message: config.confItemErrorMessage
					});
				}
				setItemsState('disable');
			} else {
				setItemsState('enable');
			}
		});
	}

	function validate(input){
		let newValue =  input.target.value;
		let testRes;

		// length
		if(rules.pwdLength){
			testRes = newValue.length < rules.pwdLength.attributes.length;
			if (testRes && testState.pwdLength) {
				testState.pwdLength = false;
				setToFailed(lenEl);
			} else if(!testRes && !testState.pwdLength) {
				testState.pwdLength = true;
				setToCompleted(lenEl);
			}
		}

		// numbers
		if(rules.pwdNums) {
			testRes = containsNumbers(newValue);
			if (testRes && !testState.pwdNums) {
				testState.pwdNums = true;
				setToCompleted(numEl);
			} else if(!testRes && testState.pwdNums){
				testState.pwdNums = false;
				setToFailed(numEl);
			}
		}

		// capital letters
		if(rules.pwdCapitals) {
			testRes = containsCapitalLetters(newValue);
			if (testRes && !testState.pwdCapitals) {
				testState.pwdCapitals = true;
				setToCompleted(capEl);
			} else if(!testRes && testState.pwdCapitals) {
				testState.pwdCapitals = false;
				setToFailed(capEl);
			}
		}

		// special characters
		if(rules.pwdSpecChars) {
			testRes = containsSpecialCharacters(newValue);
			if (testRes && !testState.pwdSpecChars) {
				testState.pwdSpecChars = true;
				setToCompleted(specEl);
			} else if(!testRes && testState.pwdSpecChars){
				testState.pwdSpecChars = false;
				setToFailed(specEl);
			}
		}

		// hide and show functionality of the collapsible rule region
		if(config.rulesContainer == 'collapsible'){
			let titleElSpan = itemRegion.find('.fos-ap-constraints-title .fos-pwd');
			let done = true;
			isEveryRulePassed(function(){
				done = false;
			});
			let titleName = titleEl.attr('name');
			if(done && titleName !='done'){
				apex.message.clearErrors(itemName);
				changeTitleRule(config.rulesCompText, 'done');
				setToCompleted(titleElSpan,false);
				let rulesConEl = rulesContainerEl;
				document.querySelectorAll('#'+itemName+'_region .fos-ap-rule').forEach(function(rule){
					rule.style.display = 'block';
				});
				if(rulesConEl.height() > 0){
					rulesConEl.css({'max-height': rulesConEl.prop('scrollHeight')+'px'});
				}
			} else {
				if(testState[titleName.substr(8)] || titleName == 'done'){
					let titleRefreshed = false;
					for(let prop in testState){
						let ruleEl = document.querySelector('#'+itemName+'_region .fos-ap-rule[name="FOS'+prop+'"]');
						if(!testState[prop]){
							if(!titleRefreshed){
								ruleEl.style.display = 'none';
								if(titleName != 'done'){
									setToCompleted(titleElSpan,false);
								}
								changeTitleRule(ruleEl.innerHTML,'titleFOS'+prop);
								titleRefreshed = true;
							} else {
								ruleEl.style.display = 'block';
							}
						} else {
							ruleEl.style.display = 'block';
						}
					}
				}
			}
		}
	}

	// Utility functions
	function setElementWidth(el,pct = 1){
		el.css('width', inputField.outerWidth() * pct + 'px');
	}
	function containsNumbers(s){
		let requiredNum = rules.pwdNums.attributes.length;
		regex = new RegExp('([0-9].*){'+requiredNum+',}', 'g');
		return regex.test(s);
	}
	function containsCapitalLetters(s){
		let requiredCaps = rules.pwdCapitals.attributes.length;
		regex = new RegExp('([A-Z].*){'+requiredCaps+',}','g');
		return regex.test(s);
	}
	function containsSpecialCharacters(s){
		let requiredSpec = rules.pwdSpecChars.attributes.listOfSpecChar;
		let requiredSNum = rules.pwdSpecChars.attributes.length;
		regex = new RegExp('(['+requiredSpec+'].*){'+requiredSNum+',}','g');
		return regex.test(s);
	}
	function togglePwd() {
		inputField.attr('type') == 'password' ? showPwd.call(this) : hidePwd.call(this);
	}
	function showPwd(){
		$(this).removeClass(config.peekHiddenIcon).addClass(config.peekShownIcon);
		inputField.attr("type", "text");
	}
	function hidePwd(){
		$(this).removeClass(config.peekShownIcon).addClass(config.peekHiddenIcon);
		inputField.attr("type", "password");
	}
	function toggleInlineIcon(el, type){
		if(type){
			el.css({'color': config.successColor});
			el.removeClass(config.inlineFailIcon).addClass(config.inlineCheckIcon);
		} else {
			el.css({'color': config.errorColor});
			el.removeClass(config.inlineCheckIcon).addClass(config.inlineFailIcon);
		}
	}
	function setItemsState(type){
		if(!config.disableItems){
			return;
		}
		config.itemsToDisable.forEach(function(item){
			apex.message.clearErrors(item);
			if(type == 'enable'){
				$('#'+item).removeClass('apex_disabled');
				apex.item(item).enable();
			} else {
				$('#'+item).addClass('apex_disabled');
				apex.item(item).disable();
			}
		});
	}
	function changeTitleRule(content, name){
		titleEl.css({'color': config.successColor});
		titleEl.removeClass('fos-value-enter');
		titleEl.addClass('fos-value-leave');
		setTimeout(function(){
			titleEl.removeClass('fos-value-leave');
			titleEl.addClass('fos-value-enter');
			if(name != 'done'){
				titleEl.css({'color': config.errorColor});
			}
			titleEl.html(content || '');
			titleEl.attr('name',name);
		},300);
	}
	function isEveryRulePassed(cb){
		for(let i in testState){
			if(!testState[i]){
				cb();
				break;
			}
		}
	}
	function setToCompleted(el,triggerEvent = true){
		let passedTests = 0;
		for(let key in testState){
			if(testState[key]){
				passedTests++;
			}
		}
		if(config.showStrengthBar){
			let barWidht = passedTests * sepPos;
			barWidht = barWidht == 99 ? 100 : barWidht;
			strengthBarEl.css('width', barWidht+'%');
		}
		el.parent().css({'color': config.successColor});
		el.addClass(config.rulesCheckIcon).removeClass(config.rulesFailIcon);
		el.css({'color': config.successColor});
		if(passedTests == testNum){
			if(triggerEvent){
				apex.event.trigger('#'+itemName, RULE_ALL_COMPLETE_EVENT, testState);
			}
			if(config.confItem){
				apex.item(config.confItem).enable();
			}
			if(config.disableItems && !config.confItem){
				setItemsState('enable');
			}
			if(config.inlineIcon){
				toggleInlineIcon(inlineIconEl, true);
			}
		} else {
			if(triggerEvent){
				apex.event.trigger('#'+itemName, RULE_COMPLETE_EVENT, testState);
			}
		}
	}
	function setToFailed(el){
		if(config.showStrengthBar){
			let failedTests = 0;
			for(let key in testState){
				if(!testState[key]){
					failedTests++;
				}
			}
			let barWidth = 100 - failedTests * sepPos;
			barWidth = testNum == 3 ? barWidth - 1 : barWidth;
			strengthBarEl.css('width', barWidth+'%');
		}
		el.parent().css({'color': config.errorColor});
		el.addClass(config.rulesFailIcon).removeClass(config.rulesCheckIcon);
		el.css({'color': config.errorColor});
		apex.event.trigger('#'+itemName, RULE_FAIL_EVENT, testState);
		if(config.confItem){
			apex.item(config.confItem).disable();
		}
		if(config.disableItems && !config.confItem){
			setItemsState('disable');
		}
		if(config.inlineIcon){
			toggleInlineIcon(inlineIconEl, false);
		}
	}
};

