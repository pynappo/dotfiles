/**
 * @name VoiceActivity
 * @author Neodymium
 * @description Shows icons and info in popouts, the member list, and more when someone is in a voice channel.
 * @version 1.3.4
 * @source https://github.com/Neodymium7/BetterDiscordStuff/blob/main/VoiceActivity/VoiceActivity.plugin.js
 * @updateUrl https://raw.githubusercontent.com/Neodymium7/BetterDiscordStuff/main/VoiceActivity/VoiceActivity.plugin.js
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

const config = {
	info: {
		name: "VoiceActivity",
		authors: [{
			name: "Neodymium",
		}],
		version: "1.3.4",
		description: "Shows icons and info in popouts, the member list, and more when someone is in a voice channel.",
		github: "https://github.com/Neodymium7/BetterDiscordStuff/blob/main/VoiceActivity/VoiceActivity.plugin.js",
		github_raw: "https://raw.githubusercontent.com/Neodymium7/BetterDiscordStuff/main/VoiceActivity/VoiceActivity.plugin.js"
	},
	changelog: [{
		title: "Fixed",
		type: "fixed",
		items: ["Fixed crashing on startup"]
	}]
};

function buildPlugin([BasePlugin, Library]) {
	let Plugin;

	(() => {
		const meta = {
			name: "VoiceActivity",
			author: "Neodymium",
			description: "Shows icons and info in popouts, the member list, and more when someone is in a voice channel.",
			version: "1.3.4",
			source: "https://github.com/Neodymium7/BetterDiscordStuff/blob/main/VoiceActivity/VoiceActivity.plugin.js",
			updateUrl: "https://raw.githubusercontent.com/Neodymium7/BetterDiscordStuff/main/VoiceActivity/VoiceActivity.plugin.js",
			invite: "fRbsqH87Av"
		};
		var __webpack_modules__ = {
			507: (module, __webpack_exports__, __webpack_require__) => {
				"use strict";
				__webpack_require__.d(__webpack_exports__, {
					Z: () => __WEBPACK_DEFAULT_EXPORT__
				});
				var bundlebd_styles__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(209);
				var _node_modules_css_loader_dist_runtime_noSourceMaps_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(882);
				var _node_modules_css_loader_dist_runtime_noSourceMaps_js__WEBPACK_IMPORTED_MODULE_1___default = __webpack_require__.n(_node_modules_css_loader_dist_runtime_noSourceMaps_js__WEBPACK_IMPORTED_MODULE_1__);
				var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(268);
				var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_2___default = __webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_2__);
				var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_2___default()(_node_modules_css_loader_dist_runtime_noSourceMaps_js__WEBPACK_IMPORTED_MODULE_1___default());
				___CSS_LOADER_EXPORT___.push([module.id, ".VoiceActivity-guildimage-defaultIcon{display:flex;align-items:center;justify-content:center;font-weight:500;line-height:1.2em;white-space:nowrap;background-color:var(--background-primary);color:var(--text-normal);min-width:48px;width:48px;height:48px;border-radius:16px;cursor:pointer;white-space:nowrap;overflow:hidden}", ""]);
				___CSS_LOADER_EXPORT___.locals = {
					defaultIcon: "VoiceActivity-guildimage-defaultIcon"
				};
				bundlebd_styles__WEBPACK_IMPORTED_MODULE_0__.Z._load(___CSS_LOADER_EXPORT___.toString());
				const __WEBPACK_DEFAULT_EXPORT__ = Object.assign(___CSS_LOADER_EXPORT___.locals, {
					_content: ___CSS_LOADER_EXPORT___.toString()
				})
			},
			252: (module, __webpack_exports__, __webpack_require__) => {
				"use strict";
				__webpack_require__.d(__webpack_exports__, {
					Z: () => __WEBPACK_DEFAULT_EXPORT__
				});
				var bundlebd_styles__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(209);
				var _node_modules_css_loader_dist_runtime_noSourceMaps_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(882);
				var _node_modules_css_loader_dist_runtime_noSourceMaps_js__WEBPACK_IMPORTED_MODULE_1___default = __webpack_require__.n(_node_modules_css_loader_dist_runtime_noSourceMaps_js__WEBPACK_IMPORTED_MODULE_1__);
				var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(268);
				var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_2___default = __webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_2__);
				var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_2___default()(_node_modules_css_loader_dist_runtime_noSourceMaps_js__WEBPACK_IMPORTED_MODULE_1___default());
				___CSS_LOADER_EXPORT___.push([module.id, ".VoiceActivity-modalactivityitem-modalActivity{padding:16px}.VoiceActivity-modalactivityitem-modalActivity .VoiceActivity-modalactivityitem-header{width:100%;min-width:0;margin-bottom:8px;display:flex;justify-content:space-between;color:var(--header-secondary);font-weight:700;text-transform:uppercase;font-family:var(--font-display);font-size:12px;line-height:16px}.VoiceActivity-modalactivityitem-modalActivity .VoiceActivity-modalactivityitem-body{display:flex;align-items:center}.VoiceActivity-modalactivityitem-modalActivity .VoiceActivity-modalactivityitem-body .VoiceActivity-modalactivityitem-text{margin-left:10px;color:var(--text-normal);font-size:14px;line-height:18px;overflow:hidden;flex:1 1 auto}.VoiceActivity-modalactivityitem-modalActivity .VoiceActivity-modalactivityitem-body .VoiceActivity-modalactivityitem-text>div,.VoiceActivity-modalactivityitem-modalActivity .VoiceActivity-modalactivityitem-body .VoiceActivity-modalactivityitem-text>h3{overflow:hidden;white-space:nowrap;text-overflow:ellipsis}.VoiceActivity-modalactivityitem-modalActivity .VoiceActivity-modalactivityitem-body .VoiceActivity-modalactivityitem-text>h3{font-weight:500;font-family:var(--font-display)}.VoiceActivity-modalactivityitem-modalActivity .VoiceActivity-modalactivityitem-body .VoiceActivity-modalactivityitem-buttonContainer{margin-left:20px;display:flex}.VoiceActivity-modalactivityitem-modalActivity .VoiceActivity-modalactivityitem-body .VoiceActivity-modalactivityitem-buttonContainer .VoiceActivity-modalactivityitem-button{height:32px;min-height:32px;width:100%;display:flex;justify-content:center;align-items:center;padding:2px 16px;border-radius:3px;background-color:var(--button-secondary-background);transition:background-color .17s ease,color .17s ease;color:#fff;font-size:14px;line-height:16px;font-weight:500;user-select:none}.VoiceActivity-modalactivityitem-modalActivity .VoiceActivity-modalactivityitem-body .VoiceActivity-modalactivityitem-buttonContainer .VoiceActivity-modalactivityitem-button:hover{background-color:var(--button-secondary-background-hover)}.VoiceActivity-modalactivityitem-modalActivity .VoiceActivity-modalactivityitem-body .VoiceActivity-modalactivityitem-buttonContainer .VoiceActivity-modalactivityitem-button:active{background-color:var(--button-secondary-background-active)}.VoiceActivity-modalactivityitem-modalActivity .VoiceActivity-modalactivityitem-body .VoiceActivity-modalactivityitem-buttonContainer .VoiceActivity-modalactivityitem-button:disabled{background-color:var(--button-secondary-background-disabled);opacity:.5;cursor:not-allowed}.VoiceActivity-modalactivityitem-modalActivity .VoiceActivity-modalactivityitem-body .VoiceActivity-modalactivityitem-buttonContainer>div[aria-label]{width:32px;margin-left:8px}.VoiceActivity-modalactivityitem-modalActivity .VoiceActivity-modalactivityitem-body .VoiceActivity-modalactivityitem-buttonContainer .VoiceActivity-modalactivityitem-joinWrapper .VoiceActivity-modalactivityitem-joinButton{min-width:32px;max-width:32px;padding:0}.VoiceActivity-modalactivityitem-modalActivity .VoiceActivity-modalactivityitem-body .VoiceActivity-modalactivityitem-buttonContainer .VoiceActivity-modalactivityitem-joinWrapper .VoiceActivity-modalactivityitem-joinButton:disabled{pointer-events:none}.VoiceActivity-modalactivityitem-modalActivity .VoiceActivity-modalactivityitem-body .VoiceActivity-modalactivityitem-buttonContainer .VoiceActivity-modalactivityitem-joinWrapperDisabled{cursor:not-allowed}.VoiceActivity-modalactivityitem-modalActivity .VoiceActivity-modalactivityitem-members{display:block;position:absolute;top:20px;right:16px}.VoiceActivity-modalactivityitem-modalActivity .VoiceActivity-modalactivityitem-hasOverflow :nth-child(3){background-color:var(--background-tertiary)}", ""]);
				___CSS_LOADER_EXPORT___.locals = {
					modalActivity: "VoiceActivity-modalactivityitem-modalActivity",
					header: "VoiceActivity-modalactivityitem-header",
					body: "VoiceActivity-modalactivityitem-body",
					text: "VoiceActivity-modalactivityitem-text",
					buttonContainer: "VoiceActivity-modalactivityitem-buttonContainer",
					button: "VoiceActivity-modalactivityitem-button",
					joinWrapper: "VoiceActivity-modalactivityitem-joinWrapper",
					joinButton: "VoiceActivity-modalactivityitem-joinButton",
					joinWrapperDisabled: "VoiceActivity-modalactivityitem-joinWrapperDisabled",
					members: "VoiceActivity-modalactivityitem-members",
					hasOverflow: "VoiceActivity-modalactivityitem-hasOverflow"
				};
				bundlebd_styles__WEBPACK_IMPORTED_MODULE_0__.Z._load(___CSS_LOADER_EXPORT___.toString());
				const __WEBPACK_DEFAULT_EXPORT__ = Object.assign(___CSS_LOADER_EXPORT___.locals, {
					_content: ___CSS_LOADER_EXPORT___.toString()
				})
			},
			806: (module, __webpack_exports__, __webpack_require__) => {
				"use strict";
				__webpack_require__.d(__webpack_exports__, {
					Z: () => __WEBPACK_DEFAULT_EXPORT__
				});
				var bundlebd_styles__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(209);
				var _node_modules_css_loader_dist_runtime_noSourceMaps_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(882);
				var _node_modules_css_loader_dist_runtime_noSourceMaps_js__WEBPACK_IMPORTED_MODULE_1___default = __webpack_require__.n(_node_modules_css_loader_dist_runtime_noSourceMaps_js__WEBPACK_IMPORTED_MODULE_1__);
				var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(268);
				var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_2___default = __webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_2__);
				var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_2___default()(_node_modules_css_loader_dist_runtime_noSourceMaps_js__WEBPACK_IMPORTED_MODULE_1___default());
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
				bundlebd_styles__WEBPACK_IMPORTED_MODULE_0__.Z._load(___CSS_LOADER_EXPORT___.toString());
				const __WEBPACK_DEFAULT_EXPORT__ = Object.assign(___CSS_LOADER_EXPORT___.locals, {
					_content: ___CSS_LOADER_EXPORT___.toString()
				})
			},
			701: (module, __webpack_exports__, __webpack_require__) => {
				"use strict";
				__webpack_require__.d(__webpack_exports__, {
					Z: () => __WEBPACK_DEFAULT_EXPORT__
				});
				var bundlebd_styles__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(209);
				var _node_modules_css_loader_dist_runtime_noSourceMaps_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(882);
				var _node_modules_css_loader_dist_runtime_noSourceMaps_js__WEBPACK_IMPORTED_MODULE_1___default = __webpack_require__.n(_node_modules_css_loader_dist_runtime_noSourceMaps_js__WEBPACK_IMPORTED_MODULE_1__);
				var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(268);
				var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_2___default = __webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_2__);
				var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_2___default()(_node_modules_css_loader_dist_runtime_noSourceMaps_js__WEBPACK_IMPORTED_MODULE_1___default());
				___CSS_LOADER_EXPORT___.push([module.id, ".VoiceActivity-voicepopoutsection-popoutSection{margin-bottom:16px}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-header{margin-bottom:8px;color:var(--header-secondary);font-size:12px;line-height:16px;font-family:var(--font-display);font-weight:700;text-transform:uppercase}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-body{display:flex;flex-direction:row}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-body .VoiceActivity-voicepopoutsection-text{margin:auto 10px;color:var(--text-normal);font-size:14px;line-height:18px;overflow:hidden}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-body .VoiceActivity-voicepopoutsection-text>div,.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-body .VoiceActivity-voicepopoutsection-text>h3{overflow:hidden;white-space:nowrap;text-overflow:ellipsis}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-body .VoiceActivity-voicepopoutsection-text>h3{font-family:var(--font-display);font-weight:500}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-body>:last-child{padding:12px 0;margin-left:auto}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-hasOverflow>:last-child>div>:last-child{background-color:var(--background-tertiary)}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper{display:flex;flex:0 1 auto;flex-direction:row;flex-wrap:nowrap;justify-content:flex-start;align-items:stretch;margin-top:12px}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper .VoiceActivity-voicepopoutsection-button{height:32px;min-height:32px;width:100%;display:flex;justify-content:center;align-items:center;padding:2px 16px;border-radius:3px;background-color:var(--button-secondary-background);transition:background-color .17s ease,color .17s ease;color:#fff;font-size:14px;line-height:16px;font-weight:500;user-select:none}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper .VoiceActivity-voicepopoutsection-button:hover{background-color:var(--button-secondary-background-hover)}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper .VoiceActivity-voicepopoutsection-button:active{background-color:var(--button-secondary-background-active)}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper .VoiceActivity-voicepopoutsection-button:disabled{background-color:var(--button-secondary-background-disabled);opacity:.5;cursor:not-allowed}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper>div[aria-label]{width:32px;margin-left:8px}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper .VoiceActivity-voicepopoutsection-joinWrapper .VoiceActivity-voicepopoutsection-joinButton{min-width:32px;max-width:32px;padding:0}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper .VoiceActivity-voicepopoutsection-joinWrapper .VoiceActivity-voicepopoutsection-joinButton:disabled{pointer-events:none}.VoiceActivity-voicepopoutsection-popoutSection .VoiceActivity-voicepopoutsection-buttonWrapper .VoiceActivity-voicepopoutsection-joinWrapperDisabled{cursor:not-allowed}", ""]);
				___CSS_LOADER_EXPORT___.locals = {
					popoutSection: "VoiceActivity-voicepopoutsection-popoutSection",
					header: "VoiceActivity-voicepopoutsection-header",
					body: "VoiceActivity-voicepopoutsection-body",
					text: "VoiceActivity-voicepopoutsection-text",
					hasOverflow: "VoiceActivity-voicepopoutsection-hasOverflow",
					buttonWrapper: "VoiceActivity-voicepopoutsection-buttonWrapper",
					button: "VoiceActivity-voicepopoutsection-button",
					joinWrapper: "VoiceActivity-voicepopoutsection-joinWrapper",
					joinButton: "VoiceActivity-voicepopoutsection-joinButton",
					joinWrapperDisabled: "VoiceActivity-voicepopoutsection-joinWrapperDisabled"
				};
				bundlebd_styles__WEBPACK_IMPORTED_MODULE_0__.Z._load(___CSS_LOADER_EXPORT___.toString());
				const __WEBPACK_DEFAULT_EXPORT__ = Object.assign(___CSS_LOADER_EXPORT___.locals, {
					_content: ___CSS_LOADER_EXPORT___.toString()
				})
			},
			268: module => {
				"use strict";
				module.exports = function(cssWithMappingToString) {
					var list = [];
					list.toString = function toString() {
						return this.map((function(item) {
							var content = "";
							var needLayer = "undefined" !== typeof item[5];
							if (item[4]) content += "@supports (".concat(item[4], ") {");
							if (item[2]) content += "@media ".concat(item[2], " {");
							if (needLayer) content += "@layer".concat(item[5].length > 0 ? " ".concat(item[5]) : "", " {");
							content += cssWithMappingToString(item);
							if (needLayer) content += "}";
							if (item[2]) content += "}";
							if (item[4]) content += "}";
							return content
						})).join("")
					};
					list.i = function i(modules, media, dedupe, supports, layer) {
						if ("string" === typeof modules) modules = [
							[null, modules, void 0]
						];
						var alreadyImportedModules = {};
						if (dedupe)
							for (var k = 0; k < this.length; k++) {
								var id = this[k][0];
								if (null != id) alreadyImportedModules[id] = true
							}
						for (var _k = 0; _k < modules.length; _k++) {
							var item = [].concat(modules[_k]);
							if (dedupe && alreadyImportedModules[item[0]]) continue;
							if ("undefined" !== typeof layer)
								if ("undefined" === typeof item[5]) item[5] = layer;
								else {
									item[1] = "@layer".concat(item[5].length > 0 ? " ".concat(item[5]) : "", " {").concat(item[1], "}");
									item[5] = layer
								} if (media)
								if (!item[2]) item[2] = media;
								else {
									item[1] = "@media ".concat(item[2], " {").concat(item[1], "}");
									item[2] = media
								} if (supports)
								if (!item[4]) item[4] = "".concat(supports);
								else {
									item[1] = "@supports (".concat(item[4], ") {").concat(item[1], "}");
									item[4] = supports
								} list.push(item)
						}
					};
					return list
				}
			},
			882: module => {
				"use strict";
				module.exports = function(i) {
					return i[1]
				}
			},
			209: (__unused_webpack_module, __webpack_exports__, __webpack_require__) => {
				"use strict";
				__webpack_require__.d(__webpack_exports__, {
					Z: () => Styles
				});
				class Styles {
					static _load(css) {
						this.styles += css + "\n"
					}
					static inject() {
						BdApi.injectCSS(meta.name, this.styles)
					}
					static add(css) {
						this.added.push(css);
						BdApi.injectCSS(meta.name, this.styles + this.added.join("\n"))
					}
					static remove(css) {
						this.added = this.added.filter((c => c !== css));
						BdApi.injectCSS(meta.name, this.styles + this.added.join("\n"))
					}
					static clear() {
						BdApi.clearCSS(meta.name);
						this.added = []
					}
				}
				Styles.styles = "";
				Styles.added = []
			},
			113: module => {
				"use strict";
				module.exports = BdApi.React
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
			return module.exports
		}(() => {
			__webpack_require__.n = module => {
				var getter = module && module.__esModule ? () => module["default"] : () => module;
				__webpack_require__.d(getter, {
					a: getter
				});
				return getter
			}
		})();
		(() => {
			__webpack_require__.d = (exports, definition) => {
				for (var key in definition)
					if (__webpack_require__.o(definition, key) && !__webpack_require__.o(exports, key)) Object.defineProperty(exports, key, {
						enumerable: true,
						get: definition[key]
					})
			}
		})();
		(() => {
			__webpack_require__.o = (obj, prop) => Object.prototype.hasOwnProperty.call(obj, prop)
		})();
		(() => {
			__webpack_require__.r = exports => {
				if ("undefined" !== typeof Symbol && Symbol.toStringTag) Object.defineProperty(exports, Symbol.toStringTag, {
					value: "Module"
				});
				Object.defineProperty(exports, "__esModule", {
					value: true
				})
			}
		})();
		var __webpack_exports__ = {};
		(() => {
			"use strict";
			__webpack_require__.r(__webpack_exports__);
			__webpack_require__.d(__webpack_exports__, {
				default: () => VoiceActivity
			});
			const external_BasePlugin_namespaceObject = BasePlugin;
			var external_BasePlugin_default = __webpack_require__.n(external_BasePlugin_namespaceObject);
			var external_BdApi_React_ = __webpack_require__(113);
			var external_BdApi_React_default = __webpack_require__.n(external_BdApi_React_);
			var styles = __webpack_require__(209);
			const external_Library_namespaceObject = Library;
			class Settings {
				static setDefaults(settings) {
					this.defaultSettings = settings
				}
				static get(key, defaultValue) {
					return this.settings?.[key] ?? defaultValue ?? this.defaultSettings?.[key]
				}
				static set(key, value) {
					this.settings[key] = value;
					BdApi.saveData(meta.name, "settings", this.settings);
					this.listeners.forEach((listener => listener(key, value)))
				}
				static addListener(listener) {
					this.listeners.add(listener);
					return () => {
						this.listeners.delete(listener)
					}
				}
				static clearListeners() {
					this.listeners.clear()
				}
				static useSettingState(key, defaultValue) {
					const [setting, setSetting] = (0, external_BdApi_React_.useState)(this.get(key, defaultValue));
					(0, external_BdApi_React_.useEffect)((() => this.addListener(((changedKey, value) => {
						if (changedKey === key) setSetting(value)
					}))), []);
					return setting
				}
			}
			Settings.settings = BdApi.loadData(meta.name, "settings") || {};
			Settings.listeners = new Set;
			const Dispatcher = Library ? Library.DiscordModules.Dispatcher : BdApi.findModuleByProps("dirtyDispatch");
			const LocaleManager = Library ? Library.DiscordModules.LocaleManager : BdApi.findModule((m => m.Messages.CLOSE));
			class Strings {
				static setLocale() {
					this.strings = this.locales[LocaleManager.getLocale()] || this.locales[this.defaultLocale]
				}
				static setDefaultLocale(locale) {
					this.defaultLocale = locale
				}
				static initialize(locales) {
					this.locales = locales;
					this.setLocale();
					Dispatcher.subscribe("I18N_LOAD_SUCCESS", this.setLocale)
				}
				static get(key) {
					return this.strings[key] || this.locales[this.defaultLocale][key]
				}
				static unsubscribe() {
					Dispatcher.unsubscribe("I18N_LOAD_SUCCESS", this.setLocale)
				}
			}
			Strings.defaultLocale = "en-US";
			const locales_namespaceObject = JSON.parse('{"en-US":{"SETTINGS_ICONS":"Member List Icons","SETTINGS_ICONS_NOTE":"Shows icons on the member list when someone is in a voice channel.","SETTINGS_DM_ICONS":"DM Icons","SETTINGS_DM_ICONS_NOTE":"Shows icons on the DM list when someone is in a voice channel.","SETTINGS_PEOPLE_ICONS":"Friends List Icons","SETTINGS_PEOPLE_ICONS_NOTE":"Shows icons on the DM list when someone is in a voice channel.","SETTINGS_COLOR":"Current Channel Icon Color","SETTINGS_COLOR_NOTE":"Makes the Member List icons green when the user is in your current voice channel.","SETTINGS_IGNORE":"Ignore","SETTINGS_IGNORE_NOTE":"Adds an option on Voice Channel and Guild context menus to ignore that channel/guild in Member List Icons and User Popouts.","CONTEXT_IGNORE":"Ignore in Voice Activity","VOICE_CALL":"Voice Call","PRIVATE_CALL":"Private Call","GROUP_CALL":"Group Call","LIVE":"Live","HEADER":"In a Voice Channel","HEADER_VOICE":"In a Voice Call","HEADER_PRIVATE":"In a Private Call","HEADER_GROUP":"In a Group Call","HEADER_STAGE":"In a Stage Channel","VIEW":"View Channel","VIEW_CALL":"View Call","JOIN":"Join Channel","JOIN_CALL":"Join Call","JOIN_DISABLED":"Already in Channel","JOIN_DISABLED_CALL":"Already in Call","JOIN_VIDEO":"Join With Video"}}');
			const {
				Permissions,
				DiscordPermissions,
				UserStore
			} = external_Library_namespaceObject.DiscordModules;
			const getSHCBlacklist = BdApi.Plugins.get("ShowHiddenChannels")?.exports.prototype.getBlackList?.bind(BdApi.Plugins.get("ShowHiddenChannels"));

			function checkPermissions(guild, channel) {
				const onBlacklist = BdApi.Plugins.isEnabled("ShowHiddenChannels") && getSHCBlacklist && getSHCBlacklist().includes(guild?.id);
				const showVoiceUsers = BdApi.Plugins.get("ShowHiddenChannels")?.instance.settings?.general.showVoiceUsers;
				const showHiddenUsers = !onBlacklist && showVoiceUsers;
				const hasPermissions = Permissions.can({
					permission: DiscordPermissions.VIEW_CHANNEL,
					user: UserStore.getCurrentUser(),
					context: channel
				});
				return showHiddenUsers || hasPermissions
			}

			function forceUpdateAll(selector) {
				document.querySelectorAll(selector).forEach((node => external_Library_namespaceObject.ReactTools.getReactInstance(node).return.return.return.return.stateNode?.forceUpdate()))
			}

			function getIconFontSize(name) {
				const words = name.split(" ");
				if (words.length > 7) return 10;
				else if (6 === words.length) return 12;
				else if (5 === words.length) return 14;
				else return 16
			}

			function getImageLink(guild, channel) {
				let image;
				if (guild && guild.icon) image = `https://cdn.discordapp.com/icons/${guild.id}/${guild.icon}.webp?size=96`;
				else if (channel.icon) image = `https://cdn.discordapp.com/channel-icons/${channel.id}/${channel.icon}.webp?size=32`;
				else if (3 === channel.type) image = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGAAAABgCAMAAADVRocKAAABgmlDQ1BJQ0MgUHJvZmlsZQAAKM+VkTtIw1AYhb9WxQcVBzuIOGSoThZERRyliiIolFrB12CS2io0sSQtLo6Cq+DgY7Hq4OKsq4OrIAg+QBydnBRdROJ/U6FFqOCFcD/OzTnce34IFrOm5db2gGXnncRYTJuZndPqn6mlBmikTzfd3OTUaJKq6+OWgNpvoiqL/63m1JJrQkATHjJzTl54UXhgLZ9TvCscNpf1lPCpcLcjFxS+V7pR4hfFGZ+DKjPsJBPDwmFhLVPBRgWby44l3C8cSVm25AdnSpxSvK7YyhbMn3uqF4aW7OkppcvXwRjjTBJHw6DAClnyRGW3RXFJyHmsir/d98fFZYhrBVMcI6xioft+1Ax+d+um+3pLSaEY1D153lsn1G/D15bnfR563tcR1DzChV32rxZh8F30rbIWOYCWDTi7LGvGDpxvQttDTnd0X1LzD6bT8HoiY5qF1mtomi/19nPO8R0kpauJK9jbh66MZC9UeXdDZW9//uP3R+wbNjlyjzeozyoAAABgUExURVhl8oGK9LW7+erq/f///97i+7/F+mx38qGo92Ft8mFv8ujs/IuW9PP2/Wx384GM9Kux+MDF+urs/d/i+7S9+Jae9uDj/Jad9srO+tXY+4yU9aqy+MDE+qGn9/T1/neC9Liz/RcAAAAJcEhZcwAACxMAAAsTAQCanBgAAATqaVRYdFhNTDpjb20uYWRvYmUueG1wAAAAAAA8P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCI/Pg0KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNC40LjAtRXhpdjIiPg0KICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPg0KICAgIDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtbG5zOkdJTVA9Imh0dHA6Ly93d3cuZ2ltcC5vcmcveG1wLyIgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIgeG1wTU06RG9jdW1lbnRJRD0iZ2ltcDpkb2NpZDpnaW1wOmIzMjk5M2JmLTliZTUtNGJmMy04ZWEwLWY3ZDkzNTMyMTY2YiIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDowNjhkOWE3MS1lYWU3LTRmZjAtYmMxZS04MGUwYmMxMTFkZDUiIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDplZjU1ZGE0YS0wZTBhLTRjNTctODdmOC1lMmFmMGUyZGEzOGUiIGRjOkZvcm1hdD0iaW1hZ2UvcG5nIiBHSU1QOkFQST0iMi4wIiBHSU1QOlBsYXRmb3JtPSJXaW5kb3dzIiBHSU1QOlRpbWVTdGFtcD0iMTY0ODk0NDg1NjM4ODc5MSIgR0lNUDpWZXJzaW9uPSIyLjEwLjI0IiB0aWZmOk9yaWVudGF0aW9uPSIxIiB4bXA6Q3JlYXRvclRvb2w9IkdJTVAgMi4xMCI+DQogICAgICA8eG1wTU06SGlzdG9yeT4NCiAgICAgICAgPHJkZjpTZXE+DQogICAgICAgICAgPHJkZjpsaSBzdEV2dDphY3Rpb249InNhdmVkIiBzdEV2dDpjaGFuZ2VkPSIvIiBzdEV2dDppbnN0YW5jZUlEPSJ4bXAuaWlkOjQ3NmFhOGE3LTVhNGEtNDcyNS05YTBjLWU1NzVmMzE1MzFmOCIgc3RFdnQ6c29mdHdhcmVBZ2VudD0iR2ltcCAyLjEwIChXaW5kb3dzKSIgc3RFdnQ6d2hlbj0iMjAyMi0wNC0wMlQxNzoxNDoxNiIgLz4NCiAgICAgICAgPC9yZGY6U2VxPg0KICAgICAgPC94bXBNTTpIaXN0b3J5Pg0KICAgIDwvcmRmOkRlc2NyaXB0aW9uPg0KICA8L3JkZjpSREY+DQo8L3g6eG1wbWV0YT4NCjw/eHBhY2tldCBlbmQ9InIiPz6JoorbAAABV0lEQVRoQ+3W23KDIBAGYIOYBk20prWNPb7/W3Z3WQ9lGmeKe/l/N/+IzAYDggUAAAAAAMB/HVzpfXV8kIuTpp3gvHJ8WTcx7VRanlSBrs+aVubxMxn7RdNGq6VVR02Pmjb6WHjCQ+80baxmgDXUxA/FaSPWXUxtctOCVF2Z2uSmhauUnT1RU61p49cq9b6npoOmDV4yK7xN8G8abhfPsXIkq7MxfdGKOt0qBuOtoqjnZ3BcN9BmZ1qftP2L91cXt4ezJszCq7uVtENfytEN1ocZLZlRJ1iNQ2zvNHd6oyWfamLpd809wofWTBxllY6a+UJyFCzkPWsve9+35N9fG/k+nZySufjkveuTOvCuzZmp/WN+F1/859AjSuahLW0LD/2kmWdjBtiNunxr5kmOyhR/VfAk5H9dxDr3TX2kcw6psmHqI51zSJUNUx/pDAAAAAAAsKkofgB06RBbh+d86AAAAABJRU5ErkJggg==";
				return image
			}

			function getLazyModule(filter) {
				const cached = external_Library_namespaceObject.WebpackModules.getModule(filter);
				if (cached) return Promise.resolve(cached);
				return new Promise((resolve => {
					const removeListener = external_Library_namespaceObject.WebpackModules.addListener((m => {
						if (filter(m)) {
							resolve(m);
							removeListener()
						}
					}))
				}))
			}

			function groupDMName(members) {
				if (1 === members.length) return UserStore.getUser(members[0]).username;
				else if (members.length > 1) {
					let name = "";
					for (let i = 0; i < members.length; i++)
						if (i === members.length - 1) name += UserStore.getUser(members[i]).username;
						else name += UserStore.getUser(members[i]).username + ", ";
					return name
				}
				return "Unnamed"
			}
			var voiceiconmodule = __webpack_require__(806);
			const CallJoin = external_Library_namespaceObject.WebpackModules.getByDisplayName("CallJoin");
			const People = external_Library_namespaceObject.WebpackModules.getByDisplayName("People");
			const Speaker = external_Library_namespaceObject.WebpackModules.getByDisplayName("Speaker");
			const Stage = external_Library_namespaceObject.WebpackModules.getByDisplayName("Stage");
			const {
				NavigationUtils,
				ChannelStore,
				GuildStore,
				UserStore: VoiceIcon_UserStore
			} = external_Library_namespaceObject.DiscordModules;
			const {
				useStateFromStores
			} = external_Library_namespaceObject.WebpackModules.getByProps("useStateFromStores");
			const VoiceStates = external_Library_namespaceObject.WebpackModules.getByProps("getVoiceStateForUser");
			const {
				TooltipContainer
			} = external_Library_namespaceObject.WebpackModules.getByProps("TooltipContainer");

			function VoiceIcon(props) {
				const showMemberListIcons = Settings.useSettingState("showMemberListIcons");
				const showDMListIcons = Settings.useSettingState("showDMListIcons");
				const showPeopleListIcons = Settings.useSettingState("showPeopleListIcons");
				const currentChannelColor = Settings.useSettingState("currentChannelColor");
				const ignoreEnabled = Settings.useSettingState("ignoreEnabled");
				const ignoredChannels = Settings.useSettingState("ignoredChannels");
				const ignoredGuilds = Settings.useSettingState("ignoredGuilds");
				const voiceState = useStateFromStores([VoiceStates], (() => VoiceStates.getVoiceStateForUser(props.userId)));
				const currentUserVoiceState = useStateFromStores([VoiceStates], (() => VoiceStates.getVoiceStateForUser(VoiceIcon_UserStore.getCurrentUser()?.id)));
				if ("memberlist" === props.context && !showMemberListIcons) return null;
				if ("dmlist" === props.context && !showDMListIcons) return null;
				if ("peoplelist" === props.context && !showPeopleListIcons) return null;
				if (!voiceState) return null;
				const channel = ChannelStore.getChannel(voiceState.channelId);
				if (!channel) return null;
				const guild = GuildStore.getGuild(channel.guild_id);
				if (guild && !checkPermissions(guild, channel)) return null;
				if (ignoreEnabled && (ignoredChannels.includes(channel.id) || ignoredGuilds.includes(guild?.id))) return null;
				let text, subtext, Icon, channelPath;
				let className = voiceiconmodule.Z.icon;
				if (channel.id === currentUserVoiceState?.channelId && currentChannelColor) className = `${voiceiconmodule.Z.icon} ${voiceiconmodule.Z.iconCurrentCall}`;
				if (voiceState.selfStream) className = voiceiconmodule.Z.iconLive;
				if (guild) {
					text = guild.name;
					subtext = channel.name;
					Icon = Speaker;
					channelPath = `/channels/${guild.id}/${channel.id}`
				} else {
					text = channel.name;
					subtext = Strings.get("VOICE_CALL");
					Icon = CallJoin;
					channelPath = `/channels/@me/${channel.id}`
				}
				switch (channel.type) {
					case 1:
						text = VoiceIcon_UserStore.getUser(channel.recipients[0]).username;
						subtext = Strings.get("PRIVATE_CALL");
						break;
					case 3:
						text = channel.name ?? groupDMName(channel.recipients);
						subtext = Strings.get("GROUP_CALL");
						Icon = People;
						break;
					case 13:
						Icon = Stage
				}
				return external_BdApi_React_default().createElement("div", {
					className,
					onClick: e => {
						e.stopPropagation();
						e.preventDefault();
						if (channelPath) NavigationUtils.transitionTo(channelPath)
					}
				}, external_BdApi_React_default().createElement(TooltipContainer, {
					text: external_BdApi_React_default().createElement("div", {
						className: voiceiconmodule.Z.tooltip
					}, external_BdApi_React_default().createElement("div", {
						className: voiceiconmodule.Z.header,
						style: {
							fontWeight: "600"
						}
					}, text), external_BdApi_React_default().createElement("div", {
						className: voiceiconmodule.Z.subtext
					}, external_BdApi_React_default().createElement(Icon, {
						className: voiceiconmodule.Z.tooltipIcon,
						width: "16",
						height: "16"
					}), external_BdApi_React_default().createElement("div", {
						style: {
							fontWeight: "400"
						}
					}, subtext)))
				}, !voiceState.selfStream ? external_BdApi_React_default().createElement(Speaker, {
					width: "14",
					height: "14"
				}) : Strings.get("LIVE")))
			}
			var voicepopoutsectionmodule = __webpack_require__(701);
			var guildimagemodule = __webpack_require__(507);
			var React = __webpack_require__(113);
			const {
				NavigationUtils: GuildImage_NavigationUtils,
				GuildActions
			} = external_Library_namespaceObject.DiscordModules;
			const {
				getAcronym
			} = external_Library_namespaceObject.WebpackModules.getByProps("getAcronym");

			function GuildImage(props) {
				const image = getImageLink(props.guild, props.channel);
				if (image) return React.createElement("img", {
					className: guildimagemodule.Z.icon,
					src: image,
					width: "48",
					height: "48",
					style: {
						borderRadius: "16px",
						cursor: "pointer"
					},
					onClick: () => {
						if (props.guild) GuildActions.transitionToGuildSync(props.guild.id);
						else if (props.channelPath) GuildImage_NavigationUtils.transitionTo(props.channelPath)
					}
				});
				else return React.createElement("div", {
					className: guildimagemodule.Z.defaultIcon,
					onClick: () => {
						if (props.guild) GuildActions.transitionToGuildSync(props.guild.id);
						else if (props.channelPath) GuildImage_NavigationUtils.transitionTo(props.channelPath)
					},
					style: {
						fontSize: `${getIconFontSize(props.guild?props.guild.name:props.channel.name)}px`
					}
				}, getAcronym(props.guild ? props.guild.name : props.guild.id))
			}
			var WrappedPartyAvatars_React = __webpack_require__(113);
			const PartyAvatars = external_Library_namespaceObject.WebpackModules.getByDisplayName("PartyAvatars");

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
				else return null
			}
			const {
				NavigationUtils: VoicePopoutSection_NavigationUtils,
				ChannelActions,
				ChannelStore: VoicePopoutSection_ChannelStore,
				GuildStore: VoicePopoutSection_GuildStore,
				SelectedChannelStore,
				UserStore: VoicePopoutSection_UserStore
			} = external_Library_namespaceObject.DiscordModules;
			const {
				useStateFromStores: VoicePopoutSection_useStateFromStores
			} = external_Library_namespaceObject.WebpackModules.getByProps("useStateFromStores");
			const VoicePopoutSection_VoiceStates = external_Library_namespaceObject.WebpackModules.getByProps("getVoiceStateForUser");
			const {
				TooltipContainer: VoicePopoutSection_TooltipContainer
			} = external_Library_namespaceObject.WebpackModules.getByProps("TooltipContainer");

			function VoicePopoutSection(props) {
				const ignoreEnabled = Settings.useSettingState("ignoreEnabled");
				const ignoredChannels = Settings.useSettingState("ignoredChannels");
				const ignoredGuilds = Settings.useSettingState("ignoredGuilds");
				const voiceState = VoicePopoutSection_useStateFromStores([VoicePopoutSection_VoiceStates], (() => VoicePopoutSection_VoiceStates.getVoiceStateForUser(props.userId)));
				const currentUserVoiceState = VoicePopoutSection_useStateFromStores([VoicePopoutSection_VoiceStates], (() => VoicePopoutSection_VoiceStates.getVoiceStateForUser(VoicePopoutSection_UserStore.getCurrentUser()?.id)));
				if (!voiceState) return null;
				const channel = VoicePopoutSection_ChannelStore.getChannel(voiceState.channelId);
				if (!channel) return null;
				const guild = VoicePopoutSection_GuildStore.getGuild(channel.guild_id);
				if (guild && !checkPermissions(guild, channel)) return null;
				if (ignoreEnabled && (ignoredChannels.includes(channel.id) || ignoredGuilds.includes(guild?.id))) return null;
				let headerText, text, viewButton, joinButton, Icon, channelPath;
				const members = Object.keys(VoicePopoutSection_VoiceStates.getVoiceStatesForChannel(channel.id)).map((id => VoicePopoutSection_UserStore.getUser(id)));
				const hasOverflow = members.length > 3;
				const inCurrentChannel = channel.id === currentUserVoiceState?.channelId;
				const channelSelected = channel.id === SelectedChannelStore.getChannelId();
				const isCurrentUser = props.userId === VoicePopoutSection_UserStore.getCurrentUser().id;
				if (guild) {
					headerText = Strings.get("HEADER");
					text = [external_BdApi_React_default().createElement("h3", null, guild.name), external_BdApi_React_default().createElement("div", null, channel.name)];
					viewButton = Strings.get("VIEW");
					joinButton = inCurrentChannel ? Strings.get("JOIN_DISABLED") : Strings.get("JOIN");
					Icon = Speaker;
					channelPath = `/channels/${guild.id}/${channel.id}`
				} else {
					headerText = Strings.get("HEADER_VOICE");
					text = external_BdApi_React_default().createElement("h3", null, channel.name);
					viewButton = Strings.get("VIEW_CALL");
					joinButton = inCurrentChannel ? Strings.get("JOIN_DISABLED_CALL") : Strings.get("JOIN_CALL");
					Icon = CallJoin;
					channelPath = `/channels/@me/${channel.id}`
				}
				switch (channel.type) {
					case 1:
						headerText = Strings.get("HEADER_PRIVATE");
						break;
					case 3:
						headerText = Strings.get("HEADER_GROUP");
						text = external_BdApi_React_default().createElement("h3", null, channel.name ?? groupDMName(channel.recipients));
						break;
					case 13:
						headerText = Strings.get("HEADER_STAGE");
						Icon = Stage
				}
				return external_BdApi_React_default().createElement("div", {
					className: voicepopoutsectionmodule.Z.popoutSection
				}, external_BdApi_React_default().createElement("h3", {
					className: voicepopoutsectionmodule.Z.header
				}, headerText), !(1 === channel.type) && external_BdApi_React_default().createElement("div", {
					className: hasOverflow ? `${voicepopoutsectionmodule.Z.body} ${voicepopoutsectionmodule.Z.hasOverflow}` : voicepopoutsectionmodule.Z.body
				}, external_BdApi_React_default().createElement(GuildImage, {
					guild,
					channel,
					channelPath
				}), external_BdApi_React_default().createElement("div", {
					className: voicepopoutsectionmodule.Z.text
				}, text), external_BdApi_React_default().createElement(WrappedPartyAvatars, {
					guild,
					channel,
					members
				})), external_BdApi_React_default().createElement("div", {
					className: voicepopoutsectionmodule.Z.buttonWrapper
				}, external_BdApi_React_default().createElement("button", {
					className: `${voicepopoutsectionmodule.Z.button} ${voicepopoutsectionmodule.Z.viewButton}`,
					disabled: channelSelected,
					onClick: () => {
						if (channelPath) VoicePopoutSection_NavigationUtils.transitionTo(channelPath)
					}
				}, viewButton), !isCurrentUser && external_BdApi_React_default().createElement(VoicePopoutSection_TooltipContainer, {
					text: joinButton,
					position: "top",
					className: inCurrentChannel ? `${voicepopoutsectionmodule.Z.joinWrapper} ${voicepopoutsectionmodule.Z.joinWrapperDisabled}` : voicepopoutsectionmodule.Z.joinWrapper
				}, external_BdApi_React_default().createElement("button", {
					className: `${voicepopoutsectionmodule.Z.button} ${voicepopoutsectionmodule.Z.joinButton}`,
					disabled: inCurrentChannel,
					onClick: () => {
						if (channel.id) ChannelActions.selectVoiceChannel(channel.id)
					},
					onContextMenu: e => {
						if (13 === channel.type) return;
						external_Library_namespaceObject.ContextMenu.openContextMenu(e, external_Library_namespaceObject.ContextMenu.buildMenu([{
							label: Strings.get("JOIN_VIDEO"),
							id: "voice-activity-join-with-video",
							action: () => {
								if (channel.id) ChannelActions.selectVoiceChannel(channel.id, true)
							}
						}]))
					}
				}, external_BdApi_React_default().createElement(Icon, {
					width: "18",
					height: "18"
				})))))
			}
			var SettingsPanel_React = __webpack_require__(113);
			const SwitchItem = external_Library_namespaceObject.WebpackModules.getByDisplayName("SwitchItem");
			const SettingsSwitchItem = props => {
				const [value, setValue] = (0, external_BdApi_React_.useState)(Settings.get(props.setting));
				return SettingsPanel_React.createElement(SwitchItem, {
					children: props.name,
					note: props.note,
					value,
					onChange: v => {
						setValue(v);
						Settings.set(props.setting, v)
					}
				})
			};

			function SettingsPanel() {
				const settings = {
					showMemberListIcons: {
						name: Strings.get("SETTINGS_ICONS"),
						note: Strings.get("SETTINGS_ICONS_NOTE")
					},
					showDMListIcons: {
						name: Strings.get("SETTINGS_DM_ICONS"),
						note: Strings.get("SETTINGS_DM_ICONS_NOTE")
					},
					showPeopleListIcons: {
						name: Strings.get("SETTINGS_PEOPLE_ICONS"),
						note: Strings.get("SETTINGS_PEOPLE_ICONS_NOTE")
					},
					currentChannelColor: {
						name: Strings.get("SETTINGS_COLOR"),
						note: Strings.get("SETTINGS_COLOR_NOTE")
					},
					ignoreEnabled: {
						name: Strings.get("SETTINGS_IGNORE"),
						note: Strings.get("SETTINGS_IGNORE_NOTE")
					}
				};
				return SettingsPanel_React.createElement(SettingsPanel_React.Fragment, null, Object.keys(settings).map((key => {
					const {
						name,
						note
					} = settings[key];
					return SettingsPanel_React.createElement(SettingsSwitchItem, {
						setting: key,
						name,
						note
					})
				})))
			}
			var modalactivityitemmodule = __webpack_require__(252);
			const {
				NavigationUtils: ModalActivityItem_NavigationUtils,
				ChannelActions: ModalActivityItem_ChannelActions,
				ChannelStore: ModalActivityItem_ChannelStore,
				GuildStore: ModalActivityItem_GuildStore,
				UserStore: ModalActivityItem_UserStore
			} = external_Library_namespaceObject.DiscordModules;
			const {
				useStateFromStores: ModalActivityItem_useStateFromStores
			} = external_Library_namespaceObject.WebpackModules.getByProps("useStateFromStores");
			const ModalActivityItem_VoiceStates = external_Library_namespaceObject.WebpackModules.getByProps("getVoiceStateForUser");
			const ComponentDispatcher = external_Library_namespaceObject.WebpackModules.getByProps("ComponentDispatch")?.ComponentDispatch;
			const {
				TooltipContainer: ModalActivityItem_TooltipContainer
			} = external_Library_namespaceObject.WebpackModules.getByProps("TooltipContainer");

			function ModalActivityItem(props) {
				const ignoreEnabled = Settings.useSettingState("ignoreEnabled");
				const ignoredChannels = Settings.useSettingState("ignoredChannels");
				const ignoredGuilds = Settings.useSettingState("ignoredGuilds");
				const voiceState = ModalActivityItem_useStateFromStores([ModalActivityItem_VoiceStates], (() => ModalActivityItem_VoiceStates.getVoiceStateForUser(props.userId)));
				const currentUserVoiceState = ModalActivityItem_useStateFromStores([ModalActivityItem_VoiceStates], (() => ModalActivityItem_VoiceStates.getVoiceStateForUser(ModalActivityItem_UserStore.getCurrentUser()?.id)));
				if (!voiceState) return null;
				const channel = ModalActivityItem_ChannelStore.getChannel(voiceState.channelId);
				if (!channel) return null;
				const guild = ModalActivityItem_GuildStore.getGuild(channel.guild_id);
				if (guild && !checkPermissions(guild, channel)) return null;
				if (ignoreEnabled && (ignoredChannels.includes(channel.id) || ignoredGuilds.includes(guild?.id))) return null;
				let headerText, text, viewButton, joinButton, Icon, channelPath;
				const members = Object.keys(ModalActivityItem_VoiceStates.getVoiceStatesForChannel(channel.id)).map((id => ModalActivityItem_UserStore.getUser(id)));
				const hasOverflow = members.length > 3;
				const inCurrentChannel = channel.id === currentUserVoiceState?.channelId;
				const isCurrentUser = props.userId === ModalActivityItem_UserStore.getCurrentUser().id;
				if (guild) {
					headerText = Strings.get("HEADER");
					text = [external_BdApi_React_default().createElement("h3", null, guild.name), external_BdApi_React_default().createElement("div", null, channel.name)];
					viewButton = Strings.get("VIEW");
					joinButton = inCurrentChannel ? Strings.get("JOIN_DISABLED") : Strings.get("JOIN");
					Icon = Speaker;
					channelPath = `/channels/${guild.id}/${channel.id}`
				} else {
					headerText = Strings.get("HEADER_VOICE");
					text = external_BdApi_React_default().createElement("h3", null, channel.name);
					viewButton = Strings.get("VIEW_CALL");
					joinButton = inCurrentChannel ? Strings.get("JOIN_DISABLED_CALL") : Strings.get("JOIN_CALL");
					Icon = CallJoin;
					channelPath = `/channels/@me/${channel.id}`
				}
				switch (channel.type) {
					case 1:
						headerText = Strings.get("HEADER_PRIVATE");
						break;
					case 3:
						headerText = Strings.get("HEADER_GROUP");
						text = external_BdApi_React_default().createElement("h3", null, channel.name ?? groupDMName(channel.recipients));
						break;
					case 13:
						headerText = Strings.get("HEADER_STAGE");
						Icon = Stage
				}
				return external_BdApi_React_default().createElement("div", {
					className: modalactivityitemmodule.Z.modalActivity
				}, external_BdApi_React_default().createElement("h3", {
					className: modalactivityitemmodule.Z.header
				}, headerText), external_BdApi_React_default().createElement("div", {
					className: modalactivityitemmodule.Z.body
				}, !(1 === channel.type) && external_BdApi_React_default().createElement(external_BdApi_React_default().Fragment, null, external_BdApi_React_default().createElement(GuildImage, {
					guild,
					channel,
					channelPath
				}), external_BdApi_React_default().createElement("div", {
					className: modalactivityitemmodule.Z.text
				}, text)), external_BdApi_React_default().createElement("div", {
					className: modalactivityitemmodule.Z.buttonContainer
				}, external_BdApi_React_default().createElement("button", {
					className: modalactivityitemmodule.Z.button,
					onClick: () => {
						if (channelPath) {
							ModalActivityItem_NavigationUtils.transitionTo(channelPath);
							ComponentDispatcher.dispatch("MODAL_CLOSE")
						}
					}
				}, viewButton), !isCurrentUser && external_BdApi_React_default().createElement(ModalActivityItem_TooltipContainer, {
					text: joinButton,
					position: "top",
					className: inCurrentChannel ? `${modalactivityitemmodule.Z.joinWrapper} ${modalactivityitemmodule.Z.joinWrapperDisabled}` : modalactivityitemmodule.Z.joinWrapper
				}, external_BdApi_React_default().createElement("button", {
					className: `${modalactivityitemmodule.Z.button} ${modalactivityitemmodule.Z.joinButton}`,
					disabled: inCurrentChannel,
					onClick: () => {
						if (channel.id) ModalActivityItem_ChannelActions.selectVoiceChannel(channel.id)
					},
					onContextMenu: e => {
						if (13 === channel.type) return;
						external_Library_namespaceObject.ContextMenu.openContextMenu(e, external_Library_namespaceObject.ContextMenu.buildMenu([{
							label: Strings.get("JOIN_VIDEO"),
							id: "voice-activity-join-with-video",
							action: () => {
								if (channel.id) ModalActivityItem_ChannelActions.selectVoiceChannel(channel.id, true)
							}
						}]))
					}
				}, external_BdApi_React_default().createElement(Icon, {
					width: "18",
					height: "18"
				}))))), !(1 === channel.type) && external_BdApi_React_default().createElement("div", {
					className: hasOverflow ? `${modalactivityitemmodule.Z.members} ${modalactivityitemmodule.Z.hasOverflow}` : modalactivityitemmodule.Z.members
				}, external_BdApi_React_default().createElement(WrappedPartyAvatars, {
					guild,
					channel,
					members
				})))
			}
			const {
				UserStore: src_UserStore
			} = external_Library_namespaceObject.DiscordModules;
			const {
				useStateFromStores: src_useStateFromStores
			} = external_Library_namespaceObject.WebpackModules.getByProps("useStateFromStores");
			const memberItemSelector = `.${external_Library_namespaceObject.WebpackModules.getByProps("member","activity").member}`;
			const privateChannelSelector = `.${external_Library_namespaceObject.WebpackModules.getByProps("channel","activity").channel}`;
			const peopleItemSelector = `.${external_Library_namespaceObject.WebpackModules.getByProps("peopleListItem").peopleListItem}`;
			const children = external_Library_namespaceObject.WebpackModules.getByProps("avatar", "children").children;
			const src_VoiceStates = external_Library_namespaceObject.WebpackModules.getByProps("getVoiceStateForUser");
			class VoiceActivity extends(external_BasePlugin_default()) {
				onStart() {
					styles.Z.inject();
					styles.Z.add(`.${children}:empty { margin-left: 0; } .${children} { display: flex; gap: 8px; }`);
					Strings.initialize(locales_namespaceObject);
					Settings.setDefaults({
						showMemberListIcons: true,
						showDMListIcons: true,
						showPeopleListIcons: true,
						currentChannelColor: true,
						ignoreEnabled: false,
						ignoredChannels: [],
						ignoredGuilds: []
					});
					this.patchUserPopoutBody();
					this.patchUserProfileModal();
					this.patchMemberListItem();
					this.patchPrivateChannel();
					this.patchPeopleListItem();
					this.patchContextMenu()
				}
				patchUserPopoutBody() {
					const UserPopoutBody = external_Library_namespaceObject.WebpackModules.getModule((m => "UserPopoutBody" === m.default.displayName));
					external_Library_namespaceObject.Patcher.after(UserPopoutBody, "default", ((_, [props], ret) => {
						ret?.props.children.splice(1, 0, external_BdApi_React_default().createElement(VoicePopoutSection, {
							userId: props.user.id
						}))
					}))
				}
				async patchUserProfileModal() {
					const UserProfileModal = await getLazyModule((m => "UserProfileModal" === m.default?.displayName));
					const UserProfileBody = external_Library_namespaceObject.WebpackModules.getModule((m => m.default?.toString() && /case .\.UserProfileSections/.test(m.default.toString())));
					const UserProfileActivity = external_Library_namespaceObject.WebpackModules.getModule((m => "UserProfileActivity" === m.default?.displayName));
					const tabBarItem = external_Library_namespaceObject.WebpackModules.getByProps("tabBarContainer").tabBarItem;
					external_Library_namespaceObject.Patcher.after(UserProfileModal, "default", ((_, [modalProps], modalRet) => {
						if (modalProps.user.id !== src_UserStore.getCurrentUser().id) {
							const tabBar = external_Library_namespaceObject.Utilities.findInTree(modalRet, (e => e.props?.section && e.props?.user), {
								walkable: ["props", "children"]
							});
							const type = tabBar.type;
							tabBar.type = props => {
								const voiceState = src_useStateFromStores([src_VoiceStates], (() => src_VoiceStates.getVoiceStateForUser(props.user.id)));
								const ret = type(props);
								if (!props.hasActivity && voiceState) {
									const items = external_Library_namespaceObject.Utilities.findInTree(ret, (e => Array.isArray(e)), {
										walkable: ["props", "children"]
									});
									const Item = items[0].type;
									items[1] = external_BdApi_React_default().createElement(Item, {
										className: tabBarItem,
										id: "VOICE_ACTIVITY"
									}, "Activity")
								}
								if (props.hasActivity && "VOICE_ACTIVITY" === props.section) props.setSection("ACTIVITY");
								return ret
							}
						}
					}));
					external_Library_namespaceObject.Patcher.instead(UserProfileBody, "default", ((_, [props], original) => {
						if ("VOICE_ACTIVITY" === props.selectedSection) return external_BdApi_React_default().createElement(UserProfileActivity.default, {
							user: props.user
						});
						return original(props)
					}));
					external_Library_namespaceObject.Patcher.after(UserProfileActivity, "default", ((_, [props], ret) => {
						ret.props.children[1].unshift(external_BdApi_React_default().createElement(ModalActivityItem, {
							userId: props.user.id
						}))
					}))
				}
				async patchMemberListItem() {
					const MemberListItem = await external_Library_namespaceObject.ReactComponents.getComponentByName("MemberListItem", memberItemSelector);
					external_Library_namespaceObject.Patcher.after(MemberListItem.component.prototype, "render", ((thisObject, _, ret) => {
						if (thisObject.props.user) Array.isArray(ret.props.children) ? ret.props.children.unshift(external_BdApi_React_default().createElement(VoiceIcon, {
							userId: thisObject.props.user.id,
							context: "memberlist"
						})) : ret.props.children = [external_BdApi_React_default().createElement(VoiceIcon, {
							userId: thisObject.props.user.id,
							context: "memberlist"
						})]
					}));
					forceUpdateAll(memberItemSelector)
				}
				async patchPrivateChannel() {
					const PrivateChannel = await external_Library_namespaceObject.ReactComponents.getComponentByName("PrivateChannel", privateChannelSelector);
					external_Library_namespaceObject.Patcher.after(PrivateChannel.component.prototype, "render", ((thisObject, _, ret) => {
						if (!thisObject.props.user) return;
						const props = external_Library_namespaceObject.Utilities.findInTree(ret, (e => e?.children && e?.id), {
							walkable: ["children", "props"]
						});
						const children2 = props.children;
						props.children = childrenProps => {
							const childrenRet = children2(childrenProps);
							const privateChannel = external_Library_namespaceObject.Utilities.findInTree(childrenRet, (e => e?.children?.props?.avatar), {
								walkable: ["children", "props"]
							});
							privateChannel.children = [privateChannel.children, external_BdApi_React_default().createElement("div", {
								className: voiceiconmodule.Z.iconContainer
							}, external_BdApi_React_default().createElement(VoiceIcon, {
								userId: thisObject.props.user.id,
								context: "dmlist"
							}))];
							return childrenRet
						}
					}));
					forceUpdateAll(privateChannelSelector)
				}
				async patchPeopleListItem() {
					const PeopleListItem = await external_Library_namespaceObject.ReactComponents.getComponentByName("PeopleListItem", peopleItemSelector);
					external_Library_namespaceObject.Patcher.after(PeopleListItem.component.prototype, "render", ((thisObject, _, ret) => {
						if (!thisObject.props.user) return;
						const children2 = ret.props.children;
						ret.props.children = childrenProps => {
							const childrenRet = children2(childrenProps);
							childrenRet.props.children.props.children.props.children.splice(1, 0, external_BdApi_React_default().createElement("div", {
								className: voiceiconmodule.Z.iconContainer
							}, external_BdApi_React_default().createElement(VoiceIcon, {
								userId: thisObject.props.user.id,
								context: "peoplelist"
							})));
							return childrenRet
						}
					}));
					forceUpdateAll(peopleItemSelector)
				}
				async patchContextMenu() {
					const HideNamesItem = await external_Library_namespaceObject.ContextMenu.getDiscordMenu("useChannelHideNamesItem");
					external_Library_namespaceObject.Patcher.after(HideNamesItem, "default", ((_, [channel], ret) => {
						if (!Settings.get("ignoreEnabled")) return ret;
						const ignoredChannels = Settings.useSettingState("ignoredChannels");
						const ignored = ignoredChannels.includes(channel.id);
						const menuItem = external_Library_namespaceObject.ContextMenu.buildMenuItem({
							type: "toggle",
							label: Strings.get("CONTEXT_IGNORE"),
							id: "voiceactivity-ignore",
							checked: ignored,
							action: () => {
								if (ignored) {
									const newIgnoredChannels = ignoredChannels.filter((id => id !== channel.id));
									Settings.set("ignoredChannels", newIgnoredChannels)
								} else {
									const newIgnoredChannels = [...ignoredChannels, channel.id];
									Settings.set("ignoredChannels", newIgnoredChannels)
								}
							}
						});
						return [ret, menuItem]
					}));
					const GuildContextMenu = await external_Library_namespaceObject.ContextMenu.getDiscordMenu("GuildContextMenu");
					external_Library_namespaceObject.Patcher.after(GuildContextMenu, "default", ((_, [props], ret) => {
						if (!Settings.get("ignoreEnabled")) return ret;
						const ignoredGuilds = Settings.useSettingState("ignoredGuilds");
						const ignored = ignoredGuilds.includes(props.guild.id);
						const menuItem = external_Library_namespaceObject.ContextMenu.buildMenuItem({
							type: "toggle",
							label: Strings.get("CONTEXT_IGNORE"),
							id: "voiceactivity-ignore",
							checked: ignored,
							action: () => {
								if (ignored) {
									const newIgnoredGuilds = ignoredGuilds.filter((id => id !== props.guild.id));
									Settings.set("ignoredGuilds", newIgnoredGuilds)
								} else {
									const newIgnoredGuilds = [...ignoredGuilds, props.guild.id];
									Settings.set("ignoredGuilds", newIgnoredGuilds)
								}
							}
						});
						ret.props.children[2].props.children.push(menuItem)
					}))
				}
				onStop() {
					external_Library_namespaceObject.Patcher.unpatchAll();
					styles.Z.clear();
					Strings.unsubscribe();
					forceUpdateAll(memberItemSelector);
					forceUpdateAll(privateChannelSelector);
					forceUpdateAll(peopleItemSelector)
				}
				getSettingsPanel() {
					return external_BdApi_React_default().createElement(SettingsPanel, null)
				}
			}
		})();
		Plugin = __webpack_exports__
	})();

	return Plugin;
}

module.exports = window.hasOwnProperty("ZeresPluginLibrary") ? buildPlugin(window.ZeresPluginLibrary.buildPlugin(config)) : class {
	getName() {
		return config.info.name;
	}
	getAuthor() {
		return config.info.authors.map(a => a.name).join(", ");
	}
	getDescription() {
		return config.info.description;
	}
	getVersion() {
		return config.info.version;
	}
	load() {
		BdApi.showConfirmationModal("Library Missing", `The library plugin needed for ${config.info.name} is missing. Please click Download Now to install it.`, {
			confirmText: "Download Now",
			cancelText: "Cancel",
			onConfirm: () => {
				require("request").get("https://rauenzi.github.io/BDPluginLibrary/release/0PluginLibrary.plugin.js", async (error, response, body) => {
					if (error) return require("electron").shell.openExternal("https://betterdiscord.app/Download?id=9");
					await new Promise(r => require("fs").writeFile(require("path").join(BdApi.Plugins.folder, "0PluginLibrary.plugin.js"), body, r));
				});
			}
		});
	}
	start() {}
	stop() {}
};

/*@end@*/