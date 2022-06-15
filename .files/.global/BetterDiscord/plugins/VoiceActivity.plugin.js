/**
 * @name VoiceActivity
 * @version 1.2.3
 * @description Shows icons on the member list and info in User Popouts when someone is in a voice channel.
 * @source https://github.com/Neodymium7/BetterDiscordStuff/blob/main/VoiceActivity/VoiceActivity.plugin.js
 * @updateUrl https://raw.githubusercontent.com/Neodymium7/BetterDiscordStuff/main/VoiceActivity/VoiceActivity.plugin.js
 * @author Neodymium
 * @invite fRbsqH87Av
 */
/*@cc_on
@if (@_jscript)
    
    // Offer to self-install for clueless users that try to run this directly.
    var shell = WScript.CreateObject("WScript.Shell");
    var fs = new ActiveXObject("Scripting.FileSystemObject");
    var pathPlugins = shell.ExpandEnvironmentStrings("%APPDATA%\BetterDiscord\plugins");
    var pathSelf = WScript.ScriptFullName;
    // Put the user at ease by addressing them in the first person
    shell.Popup("It looks like you've mistakenly tried to run me directly. \n(Don't do that!)", 0, "I'm a plugin for BetterDiscord", 0x30);
    if (fs.GetParentFolderName(pathSelf) === fs.GetAbsolutePathName(pathPlugins)) {
        shell.Popup("I'm in the correct folder already.", 0, "I'm already installed", 0x40);
    } else if (!fs.FolderExists(pathPlugins)) {
        shell.Popup("I can't find the BetterDiscord plugins folder.\nAre you sure it's even installed?", 0, "Can't install myself", 0x10);
    } else if (shell.Popup("Should I copy myself to BetterDiscord's plugins folder for you?", 0, "Do you need some help?", 0x34) === 6) {
        fs.CopyFile(pathSelf, fs.BuildPath(pathPlugins, fs.GetFileName(pathSelf)), true);
        // Show the user where to put plugins in the future
        shell.Exec("explorer " + pathPlugins);
        shell.Popup("I'm installed!", 0, "Successfully installed", 0x40);
    }
    WScript.Quit();
@else@*/
/* Generated Code */
const config = {
	"info": {
		"name": "VoiceActivity",
		"version": "1.2.3",
		"description": "Shows icons on the member list and info in User Popouts when someone is in a voice channel.",
		"github": "https://github.com/Neodymium7/BetterDiscordStuff/blob/main/VoiceActivity/VoiceActivity.plugin.js",
		"github_raw": "https://raw.githubusercontent.com/Neodymium7/BetterDiscordStuff/main/VoiceActivity/VoiceActivity.plugin.js",
		"authors": [{
			"name": "Neodymium"
		}],
		"invite": "fRbsqH87Av"
	},
	"changelog": [{
		"title": "Fixed",
		"type": "fixed",
		"items": [
			"Fixed unnecessary margins"
		]
	}],
	"build": {
		"zlibrary": true
	}
};
function buildPlugin([BasePlugin, PluginApi]) {
	const module = {
		exports: {}
	};
	(() => {
		"use strict";
		class StyleLoader {
			static styles = "";
			static element = null;
			static append(module, css) {
				this.styles += `/* ${module} */\n${css}`;
			}
			static inject(name = config.info.name) {
				if (this.element) this.element.remove();
				this.element = document.head.appendChild(Object.assign(document.createElement("style"), {
					id: name,
					textContent: this.styles
				}));
			}
			static remove() {
				if (this.element) {
					this.element.remove();
					this.element = null;
				}
			}
		}
		function ___createMemoize___(instance, name, value) {
			value = value();
			Object.defineProperty(instance, name, {
				value,
				configurable: true
			});
			return value;
		};
		const Modules = {
			get 'react-spring'() {
				return ___createMemoize___(this, 'react-spring', () => BdApi.findModuleByProps('useSpring'))
			},
			'@discord/utils': {
				get 'joinClassNames'() {
					return ___createMemoize___(this, 'joinClassNames', () => BdApi.findModule(e => e.toString().indexOf('return e.join(" ")') > 200))
				},
				get 'useForceUpdate'() {
					return ___createMemoize___(this, 'useForceUpdate', () => BdApi.findModuleByProps('useForceUpdate')?.useForceUpdate)
				},
				get 'Logger'() {
					return ___createMemoize___(this, 'Logger', () => BdApi.findModuleByProps('setLogFn')?.default)
				},
				get 'Navigation'() {
					return ___createMemoize___(this, 'Navigation', () => BdApi.findModuleByProps('replaceWith', 'currentRouteIsPeekView'))
				}
			},
			'@discord/components': {
				get 'Tooltip'() {
					return ___createMemoize___(this, 'Tooltip', () => BdApi.findModuleByDisplayName('Tooltip'))
				},
				get 'TooltipContainer'() {
					return ___createMemoize___(this, 'TooltipContainer', () => BdApi.findModuleByProps('TooltipContainer')?.TooltipContainer)
				},
				get 'TextInput'() {
					return ___createMemoize___(this, 'TextInput', () => BdApi.findModuleByDisplayName('TextInput'))
				},
				get 'SlideIn'() {
					return ___createMemoize___(this, 'SlideIn', () => BdApi.findModuleByDisplayName('SlideIn'))
				},
				get 'SettingsNotice'() {
					return ___createMemoize___(this, 'SettingsNotice', () => BdApi.findModuleByDisplayName('SettingsNotice'))
				},
				get 'TransitionGroup'() {
					return ___createMemoize___(this, 'TransitionGroup', () => BdApi.findModuleByDisplayName('TransitionGroup'))
				},
				get 'Button'() {
					return ___createMemoize___(this, 'Button', () => BdApi.findModule(m => 'DropdownSizes' in m && typeof(m) === 'function'))
				},
				get 'Popout'() {
					return ___createMemoize___(this, 'Popout', () => BdApi.findModuleByDisplayName('Popout'))
				},
				get 'Flex'() {
					return ___createMemoize___(this, 'Flex', () => BdApi.findModuleByDisplayName('Flex'))
				},
				get 'Text'() {
					return ___createMemoize___(this, 'Text', () => BdApi.findModuleByDisplayName('Text'))
				},
				get 'Card'() {
					return ___createMemoize___(this, 'Card', () => BdApi.findModuleByDisplayName('Card'))
				}
			},
			'@discord/modules': {
				get 'Dispatcher'() {
					return ___createMemoize___(this, 'Dispatcher', () => BdApi.findModuleByProps('dirtyDispatch', 'subscribe'))
				},
				get 'ComponentDispatcher'() {
					return ___createMemoize___(this, 'ComponentDispatcher', () => BdApi.findModuleByProps('ComponentDispatch')?.ComponentDispatch)
				},
				get 'EmojiUtils'() {
					return ___createMemoize___(this, 'EmojiUtils', () => BdApi.findModuleByProps('uploadEmoji'))
				},
				get 'PermissionUtils'() {
					return ___createMemoize___(this, 'PermissionUtils', () => BdApi.findModuleByProps('computePermissions', 'canManageUser'))
				},
				get 'DMUtils'() {
					return ___createMemoize___(this, 'DMUtils', () => BdApi.findModuleByProps('openPrivateChannel'))
				}
			},
			'@discord/stores': {
				get 'Messages'() {
					return ___createMemoize___(this, 'Messages', () => BdApi.findModuleByProps('getMessage', 'getMessages'))
				},
				get 'Channels'() {
					return ___createMemoize___(this, 'Channels', () => BdApi.findModuleByProps('getChannel', 'getDMFromUserId'))
				},
				get 'Guilds'() {
					return ___createMemoize___(this, 'Guilds', () => BdApi.findModuleByProps('getGuild'))
				},
				get 'SelectedGuilds'() {
					return ___createMemoize___(this, 'SelectedGuilds', () => BdApi.findModuleByProps('getGuildId', 'getLastSelectedGuildId'))
				},
				get 'SelectedChannels'() {
					return ___createMemoize___(this, 'SelectedChannels', () => BdApi.findModuleByProps('getChannelId', 'getLastSelectedChannelId'))
				},
				get 'Info'() {
					return ___createMemoize___(this, 'Info', () => BdApi.findModuleByProps('getSessionId'))
				},
				get 'Status'() {
					return ___createMemoize___(this, 'Status', () => BdApi.findModuleByProps('getStatus', 'getActivities', 'getState'))
				},
				get 'Users'() {
					return ___createMemoize___(this, 'Users', () => BdApi.findModuleByProps('getUser', 'getCurrentUser'))
				},
				get 'SettingsStore'() {
					return ___createMemoize___(this, 'SettingsStore', () => BdApi.findModuleByProps('afkTimeout', 'status'))
				},
				get 'UserProfile'() {
					return ___createMemoize___(this, 'UserProfile', () => BdApi.findModuleByProps('getUserProfile'))
				},
				get 'Members'() {
					return ___createMemoize___(this, 'Members', () => BdApi.findModuleByProps('getMember'))
				},
				get 'Activities'() {
					return ___createMemoize___(this, 'Activities', () => BdApi.findModuleByProps('getActivities'))
				},
				get 'Games'() {
					return ___createMemoize___(this, 'Games', () => BdApi.findModuleByProps('getGame', 'games'))
				},
				get 'Auth'() {
					return ___createMemoize___(this, 'Auth', () => BdApi.findModuleByProps('getId', 'isGuest'))
				},
				get 'TypingUsers'() {
					return ___createMemoize___(this, 'TypingUsers', () => BdApi.findModuleByProps('isTyping'))
				}
			},
			'@discord/actions': {
				get 'ProfileActions'() {
					return ___createMemoize___(this, 'ProfileActions', () => BdApi.findModuleByProps('fetchProfile'))
				},
				get 'GuildActions'() {
					return ___createMemoize___(this, 'GuildActions', () => BdApi.findModuleByProps('requestMembersById'))
				}
			},
			get '@discord/i18n'() {
				return ___createMemoize___(this, '@discord/i18n', () => BdApi.findModule(m => m.Messages?.CLOSE && typeof(m.getLocale) === 'function'))
			},
			get '@discord/constants'() {
				return ___createMemoize___(this, '@discord/constants', () => BdApi.findModuleByProps('API_HOST'))
			},
			get '@discord/contextmenu'() {
				return ___createMemoize___(this, '@discord/contextmenu', () => {
					const ctx = Object.assign({}, BdApi.findModuleByProps('openContextMenu'), BdApi.findModuleByProps('MenuItem'));
					ctx.Menu = ctx.default;
					return ctx;
				})
			},
			get '@discord/forms'() {
				return ___createMemoize___(this, '@discord/forms', () => BdApi.findModuleByProps('FormItem'))
			},
			get '@discord/scrollbars'() {
				return ___createMemoize___(this, '@discord/scrollbars', () => BdApi.findModuleByProps('ScrollerAuto'))
			},
			get '@discord/native'() {
				return ___createMemoize___(this, '@discord/native', () => BdApi.findModuleByProps('requireModule'))
			},
			get '@discord/flux'() {
				return ___createMemoize___(this, '@discord/flux', () => Object.assign({}, BdApi.findModuleByProps('useStateFromStores').default, BdApi.findModuleByProps('useStateFromStores')))
			},
			get '@discord/modal'() {
				return ___createMemoize___(this, '@discord/modal', () => Object.assign({}, BdApi.findModuleByProps('ModalRoot'), BdApi.findModuleByProps('openModal', 'closeAllModals')))
			},
			get '@discord/connections'() {
				return ___createMemoize___(this, '@discord/connections', () => BdApi.findModuleByProps('get', 'isSupported', 'map'))
			},
			get '@discord/sanitize'() {
				return ___createMemoize___(this, '@discord/sanitize', () => BdApi.findModuleByProps('stringify', 'parse', 'encode'))
			},
			get '@discord/icons'() {
				return ___createMemoize___(this, '@discord/icons', () => BdApi.findAllModules(m => m.displayName && ~m.toString().indexOf('currentColor')).reduce((icons, icon) => (icons[icon.displayName] = icon, icons), {}))
			},
			'@discord/classes': {
				get 'Timestamp'() {
					return ___createMemoize___(this, 'Timestamp', () => BdApi.findModuleByPrototypes('toDate', 'month'))
				},
				get 'Message'() {
					return ___createMemoize___(this, 'Message', () => BdApi.findModuleByPrototypes('getReaction', 'isSystemDM'))
				},
				get 'User'() {
					return ___createMemoize___(this, 'User', () => BdApi.findModuleByPrototypes('tag'))
				},
				get 'Channel'() {
					return ___createMemoize___(this, 'Channel', () => BdApi.findModuleByPrototypes('isOwner', 'isCategory'))
				}
			}
		};
		var __webpack_modules__ = {
			142: (module, __webpack_exports__, __webpack_require__) => {
				__webpack_require__.d(__webpack_exports__, {
					Z: () => __WEBPACK_DEFAULT_EXPORT__
				});
				var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(645);
				var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default = __webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__);
				var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default()((function(i) {
					return i[1];
				}));
				___CSS_LOADER_EXPORT___.push([module.id, ".VoiceActivity-guildimage-defaultIcon{display:flex;align-items:center;justify-content:center;font-weight:500;line-height:1.2em;white-space:nowrap;background-color:var(--background-primary);color:var(--text-normal);min-width:48px;width:48px;height:48px;border-radius:16px;cursor:pointer;white-space:nowrap;overflow:hidden}", ""]);
				___CSS_LOADER_EXPORT___.locals = {
					defaultIcon: "VoiceActivity-guildimage-defaultIcon"
				};
				StyleLoader.append(module.id, ___CSS_LOADER_EXPORT___.toString());
				const __WEBPACK_DEFAULT_EXPORT__ = Object.assign(___CSS_LOADER_EXPORT___, ___CSS_LOADER_EXPORT___.locals);
			},
			476: (module, __webpack_exports__, __webpack_require__) => {
				__webpack_require__.d(__webpack_exports__, {
					Z: () => __WEBPACK_DEFAULT_EXPORT__
				});
				var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(645);
				var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default = __webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__);
				var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default()((function(i) {
					return i[1];
				}));
				___CSS_LOADER_EXPORT___.push([module.id, ".VoiceActivity-voiceicon-icon{height:20px;width:20px;min-width:20px;border-radius:50%;background-color:var(--background-floating);cursor:pointer}.VoiceActivity-voiceicon-icon:hover{background-color:var(--background-tertiary)}.VoiceActivity-voiceicon-icon svg{padding:3px;color:var(--interactive-normal)}.VoiceActivity-voiceicon-iconCurrentCall{background-color:var(--status-positive)}.VoiceActivity-voiceicon-iconCurrentCall:hover{background-color:var(--button-positive-background)}.VoiceActivity-voiceicon-iconCurrentCall svg{color:#fff}.VoiceActivity-voiceicon-iconLive{height:16px;border-radius:16px;background-color:var(--status-danger);color:#fff;font-size:12px;line-height:16px;font-weight:600;font-family:var(--font-display);text-transform:uppercase}.VoiceActivity-voiceicon-iconLive:hover{background-color:var(--button-danger-background)}.VoiceActivity-voiceicon-iconLive>div{padding:0 6px}.VoiceActivity-voiceicon-tooltip .VoiceActivity-voiceicon-header{display:block;overflow:hidden;white-space:nowrap;text-overflow:ellipsis}.VoiceActivity-voiceicon-tooltip .VoiceActivity-voiceicon-subtext{display:flex;flex-direction:row;margin-top:3px}.VoiceActivity-voiceicon-tooltip .VoiceActivity-voiceicon-subtext>div{overflow:hidden;white-space:nowrap;text-overflow:ellipsis}.VoiceActivity-voiceicon-tooltip .VoiceActivity-voiceicon-tooltipIcon{min-width:16px;margin-right:3px;color:var(--interactive-normal)}.VoiceActivity-voiceicon-iconContainer{margin-left:auto}.VoiceActivity-voiceicon-iconContainer .VoiceActivity-voiceicon-icon{margin-right:8px}.VoiceActivity-voiceicon-iconContainer .VoiceActivity-voiceicon-iconLive{margin-right:8px}", ""]);
				___CSS_LOADER_EXPORT___.locals = {
					icon: "VoiceActivity-voiceicon-icon",
					iconCurrentCall: "VoiceActivity-voiceicon-iconCurrentCall",
					iconLive: "VoiceActivity-voiceicon-iconLive",
					tooltip: "VoiceActivity-voiceicon-tooltip",
					header: "VoiceActivity-voiceicon-header",
					subtext: "VoiceActivity-voiceicon-subtext",
					tooltipIcon: "VoiceActivity-voiceicon-tooltipIcon",
					iconContainer: "VoiceActivity-voiceicon-iconContainer"
				};
				StyleLoader.append(module.id, ___CSS_LOADER_EXPORT___.toString());
				const __WEBPACK_DEFAULT_EXPORT__ = Object.assign(___CSS_LOADER_EXPORT___, ___CSS_LOADER_EXPORT___.locals);
			},
			746: (module, __webpack_exports__, __webpack_require__) => {
				__webpack_require__.d(__webpack_exports__, {
					Z: () => __WEBPACK_DEFAULT_EXPORT__
				});
				var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(645);
				var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default = __webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__);
				var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default()((function(i) {
					return i[1];
				}));
				___CSS_LOADER_EXPORT___.push([module.id, ".VoiceActivity-voicepopoutsection-popoutSection{margin-bottom:16px}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-header{margin-bottom:8px;color:var(--header-secondary);font-size:12px;line-height:16px;font-family:var(--font-display);font-weight:700;text-transform:uppercase}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-body{display:flex;flex-direction:row}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-body .VoiceActivity-voicepopoutsection-text{padding-top:8px;margin:0 10px;color:var(--text-normal);font-size:16px;line-height:18px;font-family:var(--font-primary);overflow:hidden}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-body .VoiceActivity-voicepopoutsection-text>div{overflow:hidden;white-space:nowrap;text-overflow:ellipsis}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-body .VoiceActivity-voicepopoutsection-textPrivate{padding-top:16px}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-body>:last-child{padding:12px 0;margin-left:auto}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-hasOverflow>:last-child>div>:last-child{background-color:var(--background-tertiary)}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper{display:flex;flex:0 1 auto;flex-direction:row;flex-wrap:nowrap;justify-content:flex-start;align-items:stretch;margin-top:12px}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper .VoiceActivity-voicepopoutsection-button{height:32px;min-height:32px;width:100%;display:flex;justify-content:center;align-items:center;padding:2px 16px;border-radius:3px;background-color:var(--button-secondary-background);transition:background-color .17s ease,color .17s ease;color:#fff;font-size:14px;line-height:16px;font-weight:500;user-select:none}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper .VoiceActivity-voicepopoutsection-button:hover{background-color:var(--button-secondary-background-hover)}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper .VoiceActivity-voicepopoutsection-button:active{background-color:var(--button-secondary-background-active)}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper .VoiceActivity-voicepopoutsection-button:disabled{background-color:var(--button-secondary-background-disabled);opacity:.5;cursor:not-allowed}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper>div[aria-label]{width:32px;margin-left:8px}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper .VoiceActivity-voicepopoutsection-joinWrapper .VoiceActivity-voicepopoutsection-joinButton{min-width:32px;max-width:32px;padding:0}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper .VoiceActivity-voicepopoutsection-joinWrapper .VoiceActivity-voicepopoutsection-joinButton:disabled{pointer-events:none}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper .VoiceActivity-voicepopoutsection-joinWrapperDisabled{cursor:not-allowed}", ""]);
				___CSS_LOADER_EXPORT___.locals = {
					popoutSection: "VoiceActivity-voicepopoutsection-popoutSection",
					header: "VoiceActivity-voicepopoutsection-header",
					body: "VoiceActivity-voicepopoutsection-body",
					text: "VoiceActivity-voicepopoutsection-text",
					textPrivate: "VoiceActivity-voicepopoutsection-textPrivate",
					hasOverflow: "VoiceActivity-voicepopoutsection-hasOverflow",
					buttonWrapper: "VoiceActivity-voicepopoutsection-buttonWrapper",
					button: "VoiceActivity-voicepopoutsection-button",
					joinWrapper: "VoiceActivity-voicepopoutsection-joinWrapper",
					joinButton: "VoiceActivity-voicepopoutsection-joinButton",
					joinWrapperDisabled: "VoiceActivity-voicepopoutsection-joinWrapperDisabled"
				};
				StyleLoader.append(module.id, ___CSS_LOADER_EXPORT___.toString());
				const __WEBPACK_DEFAULT_EXPORT__ = Object.assign(___CSS_LOADER_EXPORT___, ___CSS_LOADER_EXPORT___.locals);
			},
			645: module => {
				module.exports = function(cssWithMappingToString) {
					var list = [];
					list.toString = function toString() {
						return this.map((function(item) {
							var content = cssWithMappingToString(item);
							if (item[2]) return "@media ".concat(item[2], " {").concat(content, "}");
							return content;
						})).join("");
					};
					list.i = function(modules, mediaQuery, dedupe) {
						if ("string" === typeof modules) modules = [
							[null, modules, ""]
						];
						var alreadyImportedModules = {};
						if (dedupe)
							for (var i = 0; i < this.length; i++) {
								var id = this[i][0];
								if (null != id) alreadyImportedModules[id] = true;
							}
						for (var _i = 0; _i < modules.length; _i++) {
							var item = [].concat(modules[_i]);
							if (dedupe && alreadyImportedModules[item[0]]) continue;
							if (mediaQuery)
								if (!item[2]) item[2] = mediaQuery;
								else item[2] = "".concat(mediaQuery, " and ").concat(item[2]);
							list.push(item);
						}
					};
					return list;
				};
			},
			113: module => {
				module.exports = BdApi.React;
			}
		};
		var __webpack_module_cache__ = {};
		function __webpack_require__(moduleId) {
			var cachedModule = __webpack_module_cache__[moduleId];
			if (void 0 !== cachedModule) return cachedModule.exports;
			var module = __webpack_module_cache__[moduleId] = {
				id: moduleId,
				exports: {}
			};
			__webpack_modules__[moduleId](module, module.exports, __webpack_require__);
			return module.exports;
		}
		(() => {
			__webpack_require__.n = module => {
				var getter = module && module.__esModule ? () => module["default"] : () => module;
				__webpack_require__.d(getter, {
					a: getter
				});
				return getter;
			};
		})();
		(() => {
			__webpack_require__.d = (exports, definition) => {
				for (var key in definition)
					if (__webpack_require__.o(definition, key) && !__webpack_require__.o(exports, key)) Object.defineProperty(exports, key, {
						enumerable: true,
						get: definition[key]
					});
			};
		})();
		(() => {
			__webpack_require__.o = (obj, prop) => Object.prototype.hasOwnProperty.call(obj, prop);
		})();
		(() => {
			__webpack_require__.r = exports => {
				if ("undefined" !== typeof Symbol && Symbol.toStringTag) Object.defineProperty(exports, Symbol.toStringTag, {
					value: "Module"
				});
				Object.defineProperty(exports, "__esModule", {
					value: true
				});
			};
		})();
		var __webpack_exports__ = {};
		(() => {
			__webpack_require__.r(__webpack_exports__);
			__webpack_require__.d(__webpack_exports__, {
				default: () => VoiceActivity
			});
			const external_BasePlugin_namespaceObject = BasePlugin;
			var external_BasePlugin_default = __webpack_require__.n(external_BasePlugin_namespaceObject);
			var external_BdApi_React_ = __webpack_require__(113);
			var external_BdApi_React_default = __webpack_require__.n(external_BdApi_React_);
			const external_StyleLoader_namespaceObject = StyleLoader;
			var external_StyleLoader_default = __webpack_require__.n(external_StyleLoader_namespaceObject);
			const flux_namespaceObject = Modules["@discord/flux"];
			const external_PluginApi_namespaceObject = PluginApi;
			const modules_namespaceObject = Modules["@discord/modules"];
			function _defineProperty(obj, key, value) {
				if (key in obj) Object.defineProperty(obj, key, {
					value,
					enumerable: true,
					configurable: true,
					writable: true
				});
				else obj[key] = value;
				return obj;
			}
			class SettingsManager extends flux_namespaceObject.Store {
				constructor(pluginName, defaultSettings = {}) {
					super(modules_namespaceObject.Dispatcher, {});
					_defineProperty(this, "settings", void 0);
					_defineProperty(this, "pluginName", void 0);
					_defineProperty(this, "get", ((key, defaultValue) => this.settings[key] ?? defaultValue));
					_defineProperty(this, "set", ((key, value) => {
						this.settings[key] = value;
						external_PluginApi_namespaceObject.PluginUtilities.saveSettings(this.pluginName, this.settings);
						this.emitChange();
						return value;
					}));
					this.pluginName = pluginName;
					this.settings = external_PluginApi_namespaceObject.PluginUtilities.loadSettings(pluginName, defaultSettings);
				}
			}
			const package_namespaceObject = JSON.parse('{"um":{"u2":"VoiceActivity"}}');
			const Settings = new SettingsManager(package_namespaceObject.um.u2);
			const settings = Settings;
			const i18n_namespaceObject = Modules["@discord/i18n"];
			var i18n_default = __webpack_require__.n(i18n_namespaceObject);
			const locales_namespaceObject = JSON.parse('{"en-US":{"SETTINGS_ICONS":"Member List Icons","SETTINGS_ICONS_NOTE":"Shows icons on the member list when someone is in a voice channel.","SETTINGS_DM_ICONS":"DM Icons","SETTINGS_DM_ICONS_NOTE":"Shows icons on the DM list when someone is in a voice channel.","SETTINGS_PEOPLE_ICONS":"Friends List Icons","SETTINGS_PEOPLE_ICONS_NOTE":"Shows icons on the DM list when someone is in a voice channel.","SETTINGS_COLOR":"Current Channel Icon Color","SETTINGS_COLOR_NOTE":"Makes the Member List icons green when the user is in your current voice channel.","SETTINGS_IGNORE":"Ignore","SETTINGS_IGNORE_NOTE":"Adds an option on Voice Channel and Guild context menus to ignore that channel/guild in Member List Icons and User Popouts.","CONTEXT_IGNORE":"Ignore in Voice Activity","VOICE_CALL":"Voice Call","PRIVATE_CALL":"Private Call","GROUP_CALL":"Group Call","LIVE":"Live","HEADER":"In a Voice Channel","HEADER_VOICE":"In a Voice Call","HEADER_PRIVATE":"In a Private Call","HEADER_GROUP":"In a Group Call","HEADER_STAGE":"In a Stage Channel","VIEW":"View Channel","VIEW_CALL":"View Call","JOIN":"Join Channel","JOIN_CALL":"Join Call","JOIN_DISABLED":"Already in Channel","JOIN_DISABLED_CALL":"Already in Call","JOIN_VIDEO":"Join With Video"}}');
			function strings_defineProperty(obj, key, value) {
				if (key in obj) Object.defineProperty(obj, key, {
					value,
					enumerable: true,
					configurable: true,
					writable: true
				});
				else obj[key] = value;
				return obj;
			}
			class Strings {
				static subscribe() {
					this.setStrings();
					modules_namespaceObject.Dispatcher.subscribe("I18N_LOAD_SUCCESS", this.setStrings);
				}
				static setStrings() {
					this.strings = locales_namespaceObject[i18n_default().getLocale()] ?? locales_namespaceObject["en-US"];
				}
				static get(key) {
					return this.strings[key] ?? locales_namespaceObject["en-US"][key];
				}
				static unsubscribe() {
					modules_namespaceObject.Dispatcher.unsubscribe("I18N_LOAD_SUCCESS", this.setStrings);
				}
			}
			strings_defineProperty(Strings, "strings", {});
			const stores_namespaceObject = Modules["@discord/stores"];
			const {
				Permissions,
				DiscordPermissions
			} = external_PluginApi_namespaceObject.DiscordModules;
			const getSHCBlacklist = BdApi.Plugins.get("ShowHiddenChannels")?.exports.prototype.getBlackList?.bind(BdApi.Plugins.get("ShowHiddenChannels"));
			function checkPermissions(guild, channel) {
				const onBlacklist = BdApi.Plugins.isEnabled("ShowHiddenChannels") && getSHCBlacklist && getSHCBlacklist().includes(guild?.id);
				const showVoiceUsers = BdApi.Plugins.get("ShowHiddenChannels")?.instance.settings?.general.showVoiceUsers;
				const hasPermissions = Permissions.can({
					permission: DiscordPermissions.VIEW_CHANNEL,
					user: stores_namespaceObject.Users.getCurrentUser(),
					context: channel
				});
				return !onBlacklist && showVoiceUsers || hasPermissions;
			}
			function forceUpdateAll(selector) {
				document.querySelectorAll(selector).forEach((node => external_PluginApi_namespaceObject.ReactTools.getReactInstance(node).return.return.return.return.stateNode?.forceUpdate()));
			}
			function getIconFontSize(name) {
				const words = name.split(" ");
				if (words.length > 7) return 10;
				else if (6 === words.length) return 12;
				else if (5 === words.length) return 14;
				else return 16;
			}
			function getImageLink(guild, channel) {
				let image;
				if (guild && guild.icon) image = `https://cdn.discordapp.com/icons/${guild.id}/${guild.icon}.webp?size=96`;
				else if (channel.icon) image = `https://cdn.discordapp.com/channel-icons/${channel.id}/${channel.icon}.webp?size=32`;
				else if (3 === channel.type) image = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGAAAABgCAMAAADVRocKAAABgmlDQ1BJQ0MgUHJvZmlsZQAAKM+VkTtIw1AYhb9WxQcVBzuIOGSoThZERRyliiIolFrB12CS2io0sSQtLo6Cq+DgY7Hq4OKsq4OrIAg+QBydnBRdROJ/U6FFqOCFcD/OzTnce34IFrOm5db2gGXnncRYTJuZndPqn6mlBmikTzfd3OTUaJKq6+OWgNpvoiqL/63m1JJrQkATHjJzTl54UXhgLZ9TvCscNpf1lPCpcLcjFxS+V7pR4hfFGZ+DKjPsJBPDwmFhLVPBRgWby44l3C8cSVm25AdnSpxSvK7YyhbMn3uqF4aW7OkppcvXwRjjTBJHw6DAClnyRGW3RXFJyHmsir/d98fFZYhrBVMcI6xioft+1Ax+d+um+3pLSaEY1D153lsn1G/D15bnfR563tcR1DzChV32rxZh8F30rbIWOYCWDTi7LGvGDpxvQttDTnd0X1LzD6bT8HoiY5qF1mtomi/19nPO8R0kpauJK9jbh66MZC9UeXdDZW9//uP3R+wbNjlyjzeozyoAAABgUExURVhl8oGK9LW7+erq/f///97i+7/F+mx38qGo92Ft8mFv8ujs/IuW9PP2/Wx384GM9Kux+MDF+urs/d/i+7S9+Jae9uDj/Jad9srO+tXY+4yU9aqy+MDE+qGn9/T1/neC9Liz/RcAAAAJcEhZcwAACxMAAAsTAQCanBgAAATqaVRYdFhNTDpjb20uYWRvYmUueG1wAAAAAAA8P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCI/Pg0KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNC40LjAtRXhpdjIiPg0KICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPg0KICAgIDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtbG5zOkdJTVA9Imh0dHA6Ly93d3cuZ2ltcC5vcmcveG1wLyIgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIgeG1wTU06RG9jdW1lbnRJRD0iZ2ltcDpkb2NpZDpnaW1wOmIzMjk5M2JmLTliZTUtNGJmMy04ZWEwLWY3ZDkzNTMyMTY2YiIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDowNjhkOWE3MS1lYWU3LTRmZjAtYmMxZS04MGUwYmMxMTFkZDUiIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDplZjU1ZGE0YS0wZTBhLTRjNTctODdmOC1lMmFmMGUyZGEzOGUiIGRjOkZvcm1hdD0iaW1hZ2UvcG5nIiBHSU1QOkFQST0iMi4wIiBHSU1QOlBsYXRmb3JtPSJXaW5kb3dzIiBHSU1QOlRpbWVTdGFtcD0iMTY0ODk0NDg1NjM4ODc5MSIgR0lNUDpWZXJzaW9uPSIyLjEwLjI0IiB0aWZmOk9yaWVudGF0aW9uPSIxIiB4bXA6Q3JlYXRvclRvb2w9IkdJTVAgMi4xMCI+DQogICAgICA8eG1wTU06SGlzdG9yeT4NCiAgICAgICAgPHJkZjpTZXE+DQogICAgICAgICAgPHJkZjpsaSBzdEV2dDphY3Rpb249InNhdmVkIiBzdEV2dDpjaGFuZ2VkPSIvIiBzdEV2dDppbnN0YW5jZUlEPSJ4bXAuaWlkOjQ3NmFhOGE3LTVhNGEtNDcyNS05YTBjLWU1NzVmMzE1MzFmOCIgc3RFdnQ6c29mdHdhcmVBZ2VudD0iR2ltcCAyLjEwIChXaW5kb3dzKSIgc3RFdnQ6d2hlbj0iMjAyMi0wNC0wMlQxNzoxNDoxNiIgLz4NCiAgICAgICAgPC9yZGY6U2VxPg0KICAgICAgPC94bXBNTTpIaXN0b3J5Pg0KICAgIDwvcmRmOkRlc2NyaXB0aW9uPg0KICA8L3JkZjpSREY+DQo8L3g6eG1wbWV0YT4NCjw/eHBhY2tldCBlbmQ9InIiPz6JoorbAAABV0lEQVRoQ+3W23KDIBAGYIOYBk20prWNPb7/W3Z3WQ9lGmeKe/l/N/+IzAYDggUAAAAAAMB/HVzpfXV8kIuTpp3gvHJ8WTcx7VRanlSBrs+aVubxMxn7RdNGq6VVR02Pmjb6WHjCQ+80baxmgDXUxA/FaSPWXUxtctOCVF2Z2uSmhauUnT1RU61p49cq9b6npoOmDV4yK7xN8G8abhfPsXIkq7MxfdGKOt0qBuOtoqjnZ3BcN9BmZ1qftP2L91cXt4ezJszCq7uVtENfytEN1ocZLZlRJ1iNQ2zvNHd6oyWfamLpd809wofWTBxllY6a+UJyFCzkPWsve9+35N9fG/k+nZySufjkveuTOvCuzZmp/WN+F1/859AjSuahLW0LD/2kmWdjBtiNunxr5kmOyhR/VfAk5H9dxDr3TX2kcw6psmHqI51zSJUNUx/pDAAAAAAAsKkofgB06RBbh+d86AAAAABJRU5ErkJggg==";
				return image;
			}
			function groupDMName(members) {
				if (1 === members.length) return stores_namespaceObject.Users.getUser(members[0]).username;
				else if (members.length > 1) {
					let name = "";
					for (let i = 0; i < members.length; i++)
						if (i === members.length - 1) name += stores_namespaceObject.Users.getUser(members[i]).username;
						else name += stores_namespaceObject.Users.getUser(members[i]).username + ", ";
					return name;
				}
				return "Unnamed";
			}
			var voiceicon = __webpack_require__(476);
			const CallJoin = external_PluginApi_namespaceObject.WebpackModules.getByDisplayName("CallJoin");
			const People = external_PluginApi_namespaceObject.WebpackModules.getByDisplayName("People");
			const Speaker = external_PluginApi_namespaceObject.WebpackModules.getByDisplayName("Speaker");
			const Stage = external_PluginApi_namespaceObject.WebpackModules.getByDisplayName("Stage");
			const {
				NavigationUtils
			} = external_PluginApi_namespaceObject.DiscordModules;
			const VoiceStates = external_PluginApi_namespaceObject.WebpackModules.getByProps("getVoiceStateForUser");
			const {
				TooltipContainer
			} = external_PluginApi_namespaceObject.WebpackModules.getByProps("TooltipContainer");
			function VoiceIcon(props) {
				const showMemberListIcons = (0, flux_namespaceObject.useStateFromStores)([settings], (() => settings.get("showMemberListIcons", true)));
				const showDMListIcons = (0, flux_namespaceObject.useStateFromStores)([settings], (() => settings.get("showDMListIcons", true)));
				const showPeopleListIcons = (0, flux_namespaceObject.useStateFromStores)([settings], (() => settings.get("showPeopleListIcons", true)));
				const currentChannelColor = (0, flux_namespaceObject.useStateFromStores)([settings], (() => settings.get("currentChannelColor", true)));
				const ignoreEnabled = (0, flux_namespaceObject.useStateFromStores)([settings], (() => settings.get("ignoreEnabled", false)));
				const ignoredChannels = (0, flux_namespaceObject.useStateFromStores)([settings], (() => settings.get("ignoredChannels", [])));
				const ignoredGuilds = (0, flux_namespaceObject.useStateFromStores)([settings], (() => settings.get("ignoredGuilds", [])));
				const voiceState = (0, flux_namespaceObject.useStateFromStores)([VoiceStates], (() => VoiceStates.getVoiceStateForUser(props.userId)));
				const currentUserVoiceState = (0, flux_namespaceObject.useStateFromStores)([VoiceStates], (() => VoiceStates.getVoiceStateForUser(stores_namespaceObject.Users.getCurrentUser()?.id)));
				if ("memberlist" === props.context && !showMemberListIcons) return null;
				if ("dmlist" === props.context && !showDMListIcons) return null;
				if ("peoplelist" === props.context && !showPeopleListIcons) return null;
				if (!voiceState) return null;
				const channel = stores_namespaceObject.Channels.getChannel(voiceState.channelId);
				if (!channel) return null;
				const guild = stores_namespaceObject.Guilds.getGuild(channel.guild_id);
				if (guild && !checkPermissions(guild, channel)) return null;
				if (ignoreEnabled && (ignoredChannels.includes(channel.id) || ignoredGuilds.includes(guild?.id))) return null;
				let text, subtext, Icon, channelPath;
				let className = voiceicon.Z.icon;
				if (channel.id === currentUserVoiceState?.channelId && currentChannelColor) className = `${voiceicon.Z.icon} ${voiceicon.Z.iconCurrentCall}`;
				if (voiceState.selfStream) className = voiceicon.Z.iconLive;
				if (guild) {
					text = guild.name;
					subtext = channel.name;
					Icon = Speaker;
					channelPath = `/channels/${guild.id}/${channel.id}`;
				} else {
					text = channel.name;
					subtext = Strings.get("VOICE_CALL");
					Icon = CallJoin;
					channelPath = `/channels/@me/${channel.id}`;
				}
				switch (channel.type) {
					case 1:
						text = stores_namespaceObject.Users.getUser(channel.recipients[0]).username;
						subtext = Strings.get("PRIVATE_CALL");
						break;
					case 3:
						text = channel.name ?? groupDMName(channel.recipients);
						subtext = Strings.get("GROUP_CALL");
						Icon = People;
						break;
					case 13:
						Icon = Stage;
				}
				return external_BdApi_React_default().createElement("div", {
					className,
					onClick: e => {
						e.stopPropagation();
						e.preventDefault();
						if (channelPath) NavigationUtils.transitionTo(channelPath);
					}
				}, external_BdApi_React_default().createElement(TooltipContainer, {
					text: external_BdApi_React_default().createElement("div", {
						className: voiceicon.Z.tooltip
					}, external_BdApi_React_default().createElement("div", {
						className: voiceicon.Z.header,
						style: {
							"font-weight": "600"
						}
					}, text), external_BdApi_React_default().createElement("div", {
						className: voiceicon.Z.subtext
					}, external_BdApi_React_default().createElement(Icon, {
						className: voiceicon.Z.tooltipIcon,
						width: "16",
						height: "16"
					}), external_BdApi_React_default().createElement("div", {
						style: {
							"font-weight": "400"
						}
					}, subtext)))
				}, !voiceState.selfStream ? external_BdApi_React_default().createElement(Speaker, {
					width: "14",
					height: "14"
				}) : Strings.get("LIVE")));
			}
			var voicepopoutsection = __webpack_require__(746);
			const actions_namespaceObject = Modules["@discord/actions"];
			var guildimage = __webpack_require__(142);
			var React = __webpack_require__(113);
			const {
				NavigationUtils: GuildImage_NavigationUtils
			} = external_PluginApi_namespaceObject.DiscordModules;
			const {
				getAcronym
			} = external_PluginApi_namespaceObject.WebpackModules.getByProps("getAcronym");
			function GuildImage(props) {
				const image = getImageLink(props.guild, props.channel);
				if (image) return React.createElement("img", {
					className: guildimage.Z.icon,
					src: image,
					width: "48",
					height: "48",
					style: {
						"border-radius": "16px",
						cursor: "pointer"
					},
					onClick: () => {
						if (props.guild) actions_namespaceObject.GuildActions.transitionToGuildSync(props.guild.id);
						else if (props.channelPath) GuildImage_NavigationUtils.transitionTo(props.channelPath);
					}
				});
				else return React.createElement("div", {
					className: guildimage.Z.defaultIcon,
					onClick: () => {
						if (props.guild) actions_namespaceObject.GuildActions.transitionToGuildSync(props.guild.id);
						else if (props.channelPath) GuildImage_NavigationUtils.transitionTo(props.channelPath);
					},
					style: {
						"font-size": `${getIconFontSize(props.guild ? props.guild.name : props.channel.name)}px`
					}
				}, getAcronym(props.guild ? props.guild.name : props.guild.id));
			}
			var WrappedPartyAvatars_React = __webpack_require__(113);
			const PartyAvatars = external_PluginApi_namespaceObject.WebpackModules.getByDisplayName("PartyAvatars");
			function WrappedPartyAvatars(props) {
				if (props.guild) return WrappedPartyAvatars_React.createElement(PartyAvatars, {
					guildId: props.guild.id,
					members: props.members,
					partySize: {
						knownSize: props.members.length,
						totalSize: props.members.length,
						unknownSize: 0
					}
				});
				else if (3 === props.channel.type) return WrappedPartyAvatars_React.createElement(PartyAvatars, {
					members: props.members,
					partySize: {
						knownSize: props.members.length,
						totalSize: props.members.length,
						unknownSize: 0
					}
				});
				else return null;
			}
			const {
				NavigationUtils: VoicePopoutSection_NavigationUtils,
				ChannelActions
			} = external_PluginApi_namespaceObject.DiscordModules;
			const VoicePopoutSection_VoiceStates = external_PluginApi_namespaceObject.WebpackModules.getByProps("getVoiceStateForUser");
			const {
				TooltipContainer: VoicePopoutSection_TooltipContainer
			} = external_PluginApi_namespaceObject.WebpackModules.getByProps("TooltipContainer");
			function VoicePopoutSection(props) {
				const ignoreEnabled = (0, flux_namespaceObject.useStateFromStores)([settings], (() => settings.get("ignoreEnabled", false)));
				const ignoredChannels = (0, flux_namespaceObject.useStateFromStores)([settings], (() => settings.get("ignoredChannels", [])));
				const ignoredGuilds = (0, flux_namespaceObject.useStateFromStores)([settings], (() => settings.get("ignoredGuilds", [])));
				const voiceState = (0, flux_namespaceObject.useStateFromStores)([VoicePopoutSection_VoiceStates], (() => VoicePopoutSection_VoiceStates.getVoiceStateForUser(props.userId)));
				if (!voiceState) return null;
				const channel = stores_namespaceObject.Channels.getChannel(voiceState.channelId);
				if (!channel) return null;
				const guild = stores_namespaceObject.Guilds.getGuild(channel.guild_id);
				if (guild && !checkPermissions(guild, channel)) return null;
				if (ignoreEnabled && (ignoredChannels.includes(channel.id) || ignoredGuilds.includes(guild?.id))) return null;
				let headerText, text, viewButton, joinButton, Icon, channelPath;
				const members = Object.keys(VoicePopoutSection_VoiceStates.getVoiceStatesForChannel(channel.id)).map((id => stores_namespaceObject.Users.getUser(id)));
				const hasOverflow = members.length > 3;
				const inCurrentChannel = channel.id === VoicePopoutSection_VoiceStates.getVoiceStateForUser(stores_namespaceObject.Users.getCurrentUser().id)?.channelId;
				const channelSelected = channel.id === stores_namespaceObject.SelectedChannels.getChannelId();
				const isCurrentUser = props.userId === stores_namespaceObject.Users.getCurrentUser().id;
				if (guild) {
					headerText = Strings.get("HEADER");
					text = [external_BdApi_React_default().createElement("div", {
						style: {
							"font-weight": 600
						}
					}, guild.name), external_BdApi_React_default().createElement("div", {
						style: {
							"font-weight": 400
						}
					}, channel.name)];
					viewButton = Strings.get("VIEW");
					joinButton = inCurrentChannel ? Strings.get("JOIN_DISABLED") : Strings.get("JOIN");
					Icon = Speaker;
					channelPath = `/channels/${guild.id}/${channel.id}`;
				} else {
					headerText = Strings.get("HEADER_VOICE");
					text = external_BdApi_React_default().createElement("div", {
						style: {
							"font-weight": 600
						}
					}, channel.name);
					viewButton = Strings.get("VIEW_CALL");
					joinButton = inCurrentChannel ? Strings.get("JOIN_DISABLED_CALL") : Strings.get("JOIN_CALL");
					Icon = CallJoin;
					channelPath = `/channels/@me/${channel.id}`;
				}
				switch (channel.type) {
					case 1:
						headerText = Strings.get("HEADER_PRIVATE");
						break;
					case 3:
						headerText = Strings.get("HEADER_GROUP");
						text = external_BdApi_React_default().createElement("div", {
							style: {
								"font-weight": 600
							}
						}, channel.name ?? groupDMName(channel.recipients));
						break;
					case 13:
						headerText = Strings.get("HEADER_STAGE");
						Icon = Stage;
				}
				return external_BdApi_React_default().createElement("div", {
					className: voicepopoutsection.Z.popoutSection
				}, external_BdApi_React_default().createElement("h3", {
					className: voicepopoutsection.Z.header
				}, headerText), !(1 === channel.type) && external_BdApi_React_default().createElement("div", {
					className: hasOverflow ? `${voicepopoutsection.Z.body} ${voicepopoutsection.Z.hasOverflow}` : voicepopoutsection.Z.body
				}, external_BdApi_React_default().createElement(GuildImage, {
					guild,
					channel,
					channelPath
				}), external_BdApi_React_default().createElement("div", {
					className: guild ? voicepopoutsection.Z.text : `${voicepopoutsection.Z.text} ${voicepopoutsection.Z.textPrivate}`
				}, text), external_BdApi_React_default().createElement(WrappedPartyAvatars, {
					guild,
					channel,
					members
				})), external_BdApi_React_default().createElement("div", {
					className: voicepopoutsection.Z.buttonWrapper
				}, external_BdApi_React_default().createElement("button", {
					className: `${voicepopoutsection.Z.button} ${voicepopoutsection.Z.viewButton}`,
					disabled: channelSelected,
					onClick: () => {
						if (channelPath) VoicePopoutSection_NavigationUtils.transitionTo(channelPath);
					}
				}, viewButton), !isCurrentUser && external_BdApi_React_default().createElement(VoicePopoutSection_TooltipContainer, {
					text: joinButton,
					position: "top",
					className: inCurrentChannel ? `${voicepopoutsection.Z.joinWrapper} ${voicepopoutsection.Z.joinWrapperDisabled}` : voicepopoutsection.Z.joinWrapper
				}, external_BdApi_React_default().createElement("button", {
					className: `${voicepopoutsection.Z.button} ${voicepopoutsection.Z.joinButton}`,
					disabled: inCurrentChannel,
					onClick: () => {
						if (channel.id) ChannelActions.selectVoiceChannel(channel.id);
					},
					onContextMenu: e => {
						if (13 === channel.type) return;
						external_PluginApi_namespaceObject.ContextMenu.openContextMenu(e, external_PluginApi_namespaceObject.ContextMenu.buildMenu([{
							label: Strings.get("JOIN_VIDEO"),
							id: "voice-activity-join-with-video",
							action: () => {
								if (channel.id) ChannelActions.selectVoiceChannel(channel.id, true);
							}
						}]));
					}
				}, external_BdApi_React_default().createElement(Icon, {
					width: "18",
					height: "18"
				})))));
			}
			var createUpdateWrapper_React = __webpack_require__(113);
			function _extends() {
				_extends = Object.assign || function(target) {
					for (var i = 1; i < arguments.length; i++) {
						var source = arguments[i];
						for (var key in source)
							if (Object.prototype.hasOwnProperty.call(source, key)) target[key] = source[key];
					}
					return target;
				};
				return _extends.apply(this, arguments);
			}
			const createUpdateWrapper = (Component, valueProp = "value", changeProp = "onChange", valueIndex = 0) => props => {
				const [value, setValue] = createUpdateWrapper_React.useState(props[valueProp]);
				return createUpdateWrapper_React.createElement(Component, _extends({}, props, {
					[valueProp]: value,
					[changeProp]: (...args) => {
						const value = args[valueIndex];
						if ("function" === typeof props[changeProp]) props[changeProp](value);
						setValue(value);
					}
				}));
			};
			const hooks_createUpdateWrapper = createUpdateWrapper;
			var SettingsPanel_React = __webpack_require__(113);
			const SwitchItem = hooks_createUpdateWrapper(external_PluginApi_namespaceObject.WebpackModules.getByDisplayName("SwitchItem"));
			const SettingsPanel_settings = {
				showMemberListIcons: {
					name: Strings.get("SETTINGS_ICONS"),
					value: true,
					note: Strings.get("SETTINGS_ICONS_NOTE")
				},
				showDMListIcons: {
					name: Strings.get("SETTINGS_DM_ICONS"),
					value: false,
					note: Strings.get("SETTINGS_DM_ICONS_NOTE")
				},
				showPeopleListIcons: {
					name: Strings.get("SETTINGS_PEOPLE_ICONS"),
					value: false,
					note: Strings.get("SETTINGS_PEOPLE_ICONS_NOTE")
				},
				currentChannelColor: {
					name: Strings.get("SETTINGS_COLOR"),
					value: true,
					note: Strings.get("SETTINGS_COLOR_NOTE")
				},
				ignoreEnabled: {
					name: Strings.get("SETTINGS_IGNORE"),
					value: false,
					note: Strings.get("SETTINGS_IGNORE_NOTE")
				}
			};
			function SettingsPanel() {
				return SettingsPanel_React.createElement(SettingsPanel_React.Fragment, null, Object.keys(SettingsPanel_settings).map((key => {
					const {
						name,
						value,
						note
					} = SettingsPanel_settings[key];
					return SettingsPanel_React.createElement(SwitchItem, {
						children: name,
						note,
						value: settings.get(key, value),
						onChange: v => settings.set(key, v)
					});
				})));
			}
			const memberItemSelector = `.${external_PluginApi_namespaceObject.WebpackModules.getByProps("member", "activity").member}`;
			const privateChannelSelector = `.${external_PluginApi_namespaceObject.WebpackModules.getByProps("channel", "activity").channel}`;
			const peopleItemSelector = `.${external_PluginApi_namespaceObject.WebpackModules.getByProps("peopleListItem").peopleListItem}`;
			class VoiceActivity extends(external_BasePlugin_default()) {
				onStart() {
					external_StyleLoader_default().inject();
					Strings.subscribe();
					this.patchUserPopoutBody();
					this.patchMemberListItem();
					this.patchPrivateChannel();
					this.patchPeopleListItem();
					this.patchContextMenu();
					BdApi.injectCSS("VoiceActivity", `.${external_PluginApi_namespaceObject.WebpackModules.getByProps("avatar", "children").children}:empty{margin-left: 0}`);
				}
				async patchMemberListItem() {
					const MemberListItem = await external_PluginApi_namespaceObject.ReactComponents.getComponentByName("MemberListItem", memberItemSelector);
					external_PluginApi_namespaceObject.Patcher.after(MemberListItem.component.prototype, "render", ((thisObject, _, ret) => {
						if (thisObject.props.user) ret.props.children ? ret.props.children = external_BdApi_React_default().createElement("div", {
							style: {
								display: "flex",
								gap: "8px"
							}
						}, ret.props.children, external_BdApi_React_default().createElement(VoiceIcon, {
							userId: thisObject.props.user.id,
							context: "memberlist"
						})) : ret.props.children = external_BdApi_React_default().createElement(VoiceIcon, {
							userId: thisObject.props.user.id,
							context: "memberlist"
						});
					}));
					forceUpdateAll(memberItemSelector);
				}
				async patchPrivateChannel() {
					const PrivateChannel = await external_PluginApi_namespaceObject.ReactComponents.getComponentByName("PrivateChannel", privateChannelSelector);
					external_PluginApi_namespaceObject.Patcher.after(PrivateChannel.component.prototype, "render", ((thisObject, _, ret) => {
						if (!thisObject.props.user) return;
						const props = external_PluginApi_namespaceObject.Utilities.findInTree(ret, (e => e?.children && e?.id), {
							walkable: ["children", "props"]
						});
						const children = props.children;
						props.children = childrenProps => {
							const childrenRet = children(childrenProps);
							const privateChannel = external_PluginApi_namespaceObject.Utilities.findInTree(childrenRet, (e => e?.children?.props?.avatar), {
								walkable: ["children", "props"]
							});
							privateChannel.children = [privateChannel.children, external_BdApi_React_default().createElement("div", {
								className: voiceicon.Z.iconContainer
							}, external_BdApi_React_default().createElement(VoiceIcon, {
								userId: thisObject.props.user.id,
								context: "dmlist"
							}))];
							return childrenRet;
						};
					}));
					forceUpdateAll(privateChannelSelector);
				}
				async patchPeopleListItem() {
					const PeopleListItem = await external_PluginApi_namespaceObject.ReactComponents.getComponentByName("PeopleListItem", peopleItemSelector);
					external_PluginApi_namespaceObject.Patcher.after(PeopleListItem.component.prototype, "render", ((thisObject, _, ret) => {
						if (!thisObject.props.user) return;
						const children = ret.props.children;
						ret.props.children = childrenProps => {
							const childrenRet = children(childrenProps);
							childrenRet.props.children.props.children.props.children.splice(1, 0, external_BdApi_React_default().createElement("div", {
								className: voiceicon.Z.iconContainer
							}, external_BdApi_React_default().createElement(VoiceIcon, {
								userId: thisObject.props.user.id,
								context: "peoplelist"
							})));
							return childrenRet;
						};
					}));
					forceUpdateAll(peopleItemSelector);
				}
				patchUserPopoutBody() {
					const UserPopoutBody = external_PluginApi_namespaceObject.WebpackModules.getModule((m => "UserPopoutBody" === m.default.displayName));
					external_PluginApi_namespaceObject.Patcher.after(UserPopoutBody, "default", ((_, [props], ret) => {
						ret?.props.children.unshift(external_BdApi_React_default().createElement(VoicePopoutSection, {
							userId: props.user.id
						}));
					}));
				}
				async patchContextMenu() {
					const HideNamesItem = await external_PluginApi_namespaceObject.ContextMenu.getDiscordMenu("useChannelHideNamesItem");
					external_PluginApi_namespaceObject.Patcher.after(HideNamesItem, "default", ((_, [channel], ret) => {
						if (!settings.get("ignoreEnabled", false)) return ret;
						const ignoredChannels = (0, flux_namespaceObject.useStateFromStores)([settings], (() => settings.get("ignoredChannels", [])));
						const ignored = ignoredChannels.includes(channel.id);
						const menuItem = external_PluginApi_namespaceObject.ContextMenu.buildMenuItem({
							type: "toggle",
							label: Strings.get("CONTEXT_IGNORE"),
							id: "voiceactivity-ignore",
							checked: ignored,
							action: () => {
								if (ignored) settings.set("ignoredChannels", ignoredChannels.filter((id => id !== channel.id)));
								else settings.set("ignoredChannels", [...ignoredChannels, channel.id]);
							}
						});
						return [ret, menuItem];
					}));
					const GuildContextMenu = await external_PluginApi_namespaceObject.ContextMenu.getDiscordMenu("GuildContextMenu");
					external_PluginApi_namespaceObject.Patcher.after(GuildContextMenu, "default", ((_, [props], ret) => {
						if (!settings.get("ignoreEnabled", false)) return ret;
						const ignoredGuilds = (0, flux_namespaceObject.useStateFromStores)([settings], (() => settings.get("ignoredGuilds", [])));
						const ignored = ignoredGuilds.includes(props.guild.id);
						const menuItem = external_PluginApi_namespaceObject.ContextMenu.buildMenuItem({
							type: "toggle",
							label: Strings.get("CONTEXT_IGNORE"),
							id: "voiceactivity-ignore",
							checked: ignored,
							action: () => {
								if (ignored) settings.set("ignoredGuilds", ignoredGuilds.filter((id => id !== props.guild.id)));
								else settings.set("ignoredGuilds", [...ignoredGuilds, props.guild.id]);
							}
						});
						ret.props.children[2].props.children.push(menuItem);
					}));
				}
				onStop() {
					external_PluginApi_namespaceObject.Patcher.unpatchAll();
					external_StyleLoader_default().remove();
					Strings.unsubscribe();
					forceUpdateAll(memberItemSelector);
					forceUpdateAll(privateChannelSelector);
					forceUpdateAll(peopleItemSelector);
					BdApi.clearCSS("VoiceActivity");
				}
				getSettingsPanel() {
					return external_BdApi_React_default().createElement(SettingsPanel, null);
				}
			}
		})();
		module.exports.LibraryPluginHack = __webpack_exports__;
	})();
	const PluginExports = module.exports.LibraryPluginHack;
	return PluginExports?.__esModule ? PluginExports.default : PluginExports;
}
module.exports = window.hasOwnProperty("ZeresPluginLibrary") ?
	buildPlugin(window.ZeresPluginLibrary.buildPlugin(config)) :
	class {
		getName() {
			return config.info.name;
		}
		getAuthor() {
			return config.info.authors.map(a => a.name).join(", ");
		}
		getDescription() {
			return `${config.info.description}. __**ZeresPluginLibrary was not found! This plugin will not work!**__`;
		}
		getVersion() {
			return config.info.version;
		}
		load() {
			BdApi.showConfirmationModal(
				"Library plugin is needed",
				[`The library plugin needed for ${config.info.name} is missing. Please click Download to install it.`], {
					confirmText: "Download",
					cancelText: "Cancel",
					onConfirm: () => {
						require("request").get("https://rauenzi.github.io/BDPluginLibrary/release/0PluginLibrary.plugin.js", async (error, response, body) => {
							if (error) return require("electron").shell.openExternal("https://betterdiscord.net/ghdl?url=https://raw.githubusercontent.com/rauenzi/BDPluginLibrary/master/release/0PluginLibrary.plugin.js");
							await new Promise(r => require("fs").writeFile(require("path").join(BdApi.Plugins.folder, "0PluginLibrary.plugin.js"), body, r));
						});
					}
				}
			);
		}
		start() {}
		stop() {}
	};
/*@end@*/