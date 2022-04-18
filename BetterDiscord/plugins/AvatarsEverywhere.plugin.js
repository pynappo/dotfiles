/**
 * @name AvatarsEverywhere
 * @author A user
 * @version 1.0.4
 * @description Applies users avatar in different places
 * @source https://github.com/abUwUser/BDPlugins/tree/main/plugins/AvatarsEverywhere
 * @updateUrl https://raw.githubusercontent.com/abUwUser/BDPlugins/compiled/AvatarsEverywhere/AvatarsEverywhere.plugin.js
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
		"name": "AvatarsEverywhere",
		"authors": [{
			"name": "A user",
			"discord_id": "264062457448759296",
			"github_username": "abUwUser",
			"twitter_username": "auwuser"
		}],
		"version": "1.0.4",
		"description": "Applies users avatar in different places",
		"github": "https://github.com/abUwUser/BDPlugins/tree/main/plugins/AvatarsEverywhere",
		"github_raw": "https://raw.githubusercontent.com/abUwUser/BDPlugins/compiled/AvatarsEverywhere/AvatarsEverywhere.plugin.js"
	},
	"build": {
		"copy": true,
		"zlibrary": true,
		"watch": true,
		"release": {
			"source": true,
			"public": true
		}
	},
	"changelog": [{
		"type": "fixed",
		"title": "Fixed",
		"items": [
			"AvatarsEverywhere now considers the user's server avatar",
			"Fixed Compact Mode"
		]
	}]
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
					return ___createMemoize___(this, 'Button', () => BdApi.findModuleByProps('DropdownSizes'))
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
			46: (module, __webpack_exports__, __webpack_require__) => {
				__webpack_require__.d(__webpack_exports__, {
					Z: () => __WEBPACK_DEFAULT_EXPORT__
				});
				var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(645);
				var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default = __webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__);
				var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default()((function(i) {
					return i[1];
				}));
				___CSS_LOADER_EXPORT___.push([module.id, '.AvatarsEverywhere-style-align-wrapper{display:inline-flex;flex-direction:row;align-items:center;vertical-align:bottom}.AvatarsEverywhere-style-align-wrapper-icon{margin-right:4px}.AvatarsEverywhere-style-settings-grid{min-height:400px;display:grid;grid-template-columns:repeat(2, 1fr)}.AvatarsEverywhere-style-settings-card{position:relative;overflow:hidden;display:flex;justify-content:center;align-items:center;flex-direction:column;background:linear-gradient(135deg, var(--avatars-card-primary), var(--avatars-card-secondary));border-radius:15px;cursor:pointer;margin:14px;box-shadow:0 0 8px 0 #1a1a1a;transition:box-shadow .2s,transform .2s}.AvatarsEverywhere-style-settings-card::before{content:"";display:block;position:absolute;width:100%;height:100%;background:#000;opacity:0;z-index:1;pointer-events:none;transition:opacity .2s}.AvatarsEverywhere-style-settings-card:hover{box-shadow:0 0 14px 0 #0d0d0d;transform:scale(1.025)}.AvatarsEverywhere-style-settings-card:hover::before{opacity:.15}.AvatarsEverywhere-style-settings-card svg{color:#ebebeb;margin-bottom:10px;width:50px;height:50px}.AvatarsEverywhere-style-settings-card>div{font-weight:600}', ""]);
				___CSS_LOADER_EXPORT___.locals = {
					"align-wrapper": "AvatarsEverywhere-style-align-wrapper",
					"align-wrapper-icon": "AvatarsEverywhere-style-align-wrapper-icon",
					"settings-grid": "AvatarsEverywhere-style-settings-grid",
					"settings-card": "AvatarsEverywhere-style-settings-card"
				};
				StyleLoader.append(module.id, ___CSS_LOADER_EXPORT___.toString());
				const __WEBPACK_DEFAULT_EXPORT__ = Object.assign(___CSS_LOADER_EXPORT___, ___CSS_LOADER_EXPORT___.locals);
			},
			166: (__unused_webpack_module, __webpack_exports__, __webpack_require__) => {
				__webpack_require__.r(__webpack_exports__);
				__webpack_require__.d(__webpack_exports__, {
					default: () => AvatarsEverywhere
				});
				const external_PluginApi_namespaceObject = PluginApi;
				const external_BasePlugin_namespaceObject = BasePlugin;
				var external_BasePlugin_default = __webpack_require__.n(external_BasePlugin_namespaceObject);
				const external_StyleLoader_namespaceObject = StyleLoader;
				var external_StyleLoader_default = __webpack_require__.n(external_StyleLoader_namespaceObject);
				var external_BdApi_React_ = __webpack_require__(113);
				var external_BdApi_React_default = __webpack_require__.n(external_BdApi_React_);
				const icons_namespaceObject = Modules["@discord/icons"];
				const flux_namespaceObject = Modules["@discord/flux"];
				const components_namespaceObject = Modules["@discord/components"];
				var React = __webpack_require__(113);
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
					const [value, setValue] = React.useState(props[valueProp]);
					return React.createElement(Component, _extends({}, props, {
						[valueProp]: value,
						[changeProp]: (...args) => {
							const value = args[valueIndex];
							if ("function" === typeof props[changeProp]) props[changeProp](value);
							setValue(value);
						}
					}));
				};
				const hooks_createUpdateWrapper = createUpdateWrapper;
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
				const package_namespaceObject = JSON.parse('{"um":{"u2":"AvatarsEverywhere"}}');
				const settings = new SettingsManager(package_namespaceObject.um.u2);
				const settingsManager = settings;
				var style = __webpack_require__(46);
				const SwitchItem = hooks_createUpdateWrapper(external_PluginApi_namespaceObject.WebpackModules.getByDisplayName("SwitchItem"));
				const Settings = external_BdApi_React_default().memo((() => {
					const mentionsDisabled = (0, flux_namespaceObject.useStateFromStores)([settingsManager], (() => !settingsManager.get("mentions", true)));
					(0, flux_namespaceObject.useStateFromStores)([settingsManager], (() => !settingsManager.get("compact-message", true)));
					const [tab, setTab] = (0, external_BdApi_React_.useState)("main");
					const SelectCard = ({
						tab,
						children,
						icon: Icon,
						colors
					}) => {
						const {
							primary,
							secondary
						} = colors;
						return external_BdApi_React_default().createElement("div", {
							className: style.Z["settings-card"],
							style: {
								"--avatars-card-primary": primary,
								"--avatars-card-secondary": secondary
							},
							onClick: () => setTab(tab)
						}, external_BdApi_React_default().createElement(Icon, null), external_BdApi_React_default().createElement(components_namespaceObject.Text, {
							size: components_namespaceObject.Text.Sizes.SIZE_16,
							color: components_namespaceObject.Text.Colors.HEADER_PRIMARY
						}, children));
					};
					const MentionsTab = external_BdApi_React_default().createElement(external_BdApi_React_default().Fragment, null, external_BdApi_React_default().createElement(SwitchItem, {
						value: settingsManager.get("mentions", true),
						onChange: value => settingsManager.set("mentions", value)
					}, "Add avatars to mentions"), external_BdApi_React_default().createElement(SwitchItem, {
						value: settingsManager.get("mentions-no-at", false),
						onChange: value => settingsManager.set("mentions-no-at", value),
						disabled: mentionsDisabled
					}, "Remove the @ symbol"));
					const ExtrasTab = external_BdApi_React_default().createElement(external_BdApi_React_default().Fragment, null, external_BdApi_React_default().createElement(SwitchItem, {
						value: settingsManager.get("typing-users", true),
						onChange: value => settingsManager.set("typing-users", value)
					}, "Typing users"));
					const CompactModeTab = external_BdApi_React_default().createElement(external_BdApi_React_default().Fragment, null, external_BdApi_React_default().createElement(SwitchItem, {
						value: settingsManager.get("compact-message", false),
						onChange: value => settingsManager.set("compact-message", value)
					}, "Add avatars to compact messages"), external_BdApi_React_default().createElement(SwitchItem, {
						value: settingsManager.get("compact-message-reply", false),
						onChange: value => settingsManager.set("compact-message-reply", value)
					}, "Add avatars to replies (only with Compact Mode enabled)"));
					const SystemMessagesTab = external_BdApi_React_default().createElement(external_BdApi_React_default().Fragment, null, external_BdApi_React_default().createElement(SwitchItem, {
						value: settingsManager.get("system-messages-join", true),
						onChange: value => settingsManager.set("system-messages-join", value)
					}, "Join messages"), external_BdApi_React_default().createElement(SwitchItem, {
						value: settingsManager.get("system-messages-boost", true),
						onChange: value => settingsManager.set("system-messages-boost", value)
					}, "Boost messages"), external_BdApi_React_default().createElement(SwitchItem, {
						value: settingsManager.get("system-messages-thread-created", true),
						onChange: value => settingsManager.set("system-messages-thread-created", value)
					}, "Thread created"), external_BdApi_React_default().createElement(SwitchItem, {
						value: settingsManager.get("system-messages-thread-member-removed", true),
						onChange: value => settingsManager.set("system-messages-thread-member-removed", value)
					}, "Thread member removed"));
					return external_BdApi_React_default().createElement(external_BdApi_React_default().Fragment, null, "main" === tab ? external_BdApi_React_default().createElement("div", {
						className: style.Z["settings-grid"]
					}, external_BdApi_React_default().createElement(SelectCard, {
						tab: "mentions",
						icon: icons_namespaceObject.At,
						colors: {
							primary: "hsl(356, 100%, 36%)",
							secondary: "hsl(302, 100%, 62%)"
						}
					}, "Mentions"), external_BdApi_React_default().createElement(SelectCard, {
						tab: "compactMode",
						icon: icons_namespaceObject.DoubleStarIcon,
						colors: {
							primary: "hsl(238, 65%, 50%)",
							secondary: "hsl(300, 65%, 50%)"
						}
					}, "Compact mode"), external_BdApi_React_default().createElement(SelectCard, {
						tab: "systemMessages",
						icon: icons_namespaceObject.Robot,
						colors: {
							primary: "hsl(231, 100%, 62%)",
							secondary: "hsl(206, 100%, 62%)"
						}
					}, "System Messages"), external_BdApi_React_default().createElement(SelectCard, {
						tab: "typingUsers",
						icon: icons_namespaceObject.OverflowMenuHorizontal,
						colors: {
							primary: "hsl(195, 65%, 50%)",
							secondary: "hsl(157, 65%, 50%)"
						}
					}, "Extras")) : external_BdApi_React_default().createElement(external_BdApi_React_default().Fragment, null, external_BdApi_React_default().createElement("span", {
						style: {
							display: "block",
							marginBottom: "5px"
						}
					}), "mentions" === tab && MentionsTab, "typingUsers" === tab && ExtrasTab, "compactMode" === tab && CompactModeTab, "systemMessages" === tab && SystemMessagesTab, external_BdApi_React_default().createElement("div", {
						onClick: () => setTab("main"),
						style: {
							display: "flex",
							alignItems: "center"
						}
					}, external_BdApi_React_default().createElement(components_namespaceObject.Button, {
						color: components_namespaceObject.Button.Colors.TRANSPARENT,
						size: components_namespaceObject.Button.Sizes.ICON
					}, external_BdApi_React_default().createElement(icons_namespaceObject.ArrowLeft, null)), external_BdApi_React_default().createElement(components_namespaceObject.Text, {
						style: {
							marginLeft: "10px"
						},
						size: components_namespaceObject.Text.Sizes.SIZE_16,
						color: components_namespaceObject.Text.Colors.STANDARD
					}, "Return"))));
				}));
				const stores_namespaceObject = Modules["@discord/stores"];
				var userMentions_React = __webpack_require__(113);
				const {
					default: Avatar
				} = external_PluginApi_namespaceObject.WebpackModules.getByProps("AnimatedAvatar");
				const userMentions = () => {
					external_PluginApi_namespaceObject.Patcher.after(external_PluginApi_namespaceObject.WebpackModules.getModule((m => "UserMention" === m?.default?.displayName)), "default", ((_this, [props], wrapperRes) => {
						if (!settingsManager.get("mentions", true)) return;
						const _oldFunc = wrapperRes.props.children;
						wrapperRes.props.children = function() {
							let res = _oldFunc.apply(this, arguments);
							let text = res.props.children;
							if (settingsManager.get("mentions-no-at", false)) text = external_PluginApi_namespaceObject.Utilities.findInTree(text, (e => "@" === e?.charAt?.(0))).slice(1);
							const user = stores_namespaceObject.Users.getUser(props.userId);
							res.props.children = [userMentions_React.createElement(Avatar, {
								src: user.getAvatarURL(stores_namespaceObject.SelectedGuilds.getGuildId(), 16),
								className: style.Z["align-wrapper-icon"],
								size: Avatar.Sizes.SIZE_16
							}), text];
							res.props.className += " " + style.Z["align-wrapper"];
							return res;
						};
					}));
				};
				var typingBar_React = __webpack_require__(113);
				const {
					default: typingBar_Avatar
				} = external_PluginApi_namespaceObject.WebpackModules.getByProps("AnimatedAvatar");
				const {
					AvatarDefaults,
					RelationshipStore
				} = external_PluginApi_namespaceObject.DiscordModules;
				const filterTypingUsers = typingUsers => {
					if (!typingUsers) return [];
					return Object.keys(typingUsers).filter((e => e != stores_namespaceObject.Users.getCurrentUser().id)).filter((e => !RelationshipStore.isBlocked(e))).map((e => stores_namespaceObject.Users.getUser(e))).filter((function(e) {
						return null != e;
					}));
				};
				const typingBar = async () => {
					const TypingUsers = await external_PluginApi_namespaceObject.ReactComponents.getComponentByName("TypingUsers", external_PluginApi_namespaceObject.DiscordSelectors.Typing.typing);
					if (!TypingUsers?.component?.prototype) return;
					external_PluginApi_namespaceObject.Patcher.after(TypingUsers.component.prototype, "render", ((_this, [props], res) => {
						if (!settingsManager.get("typing-users", true)) return;
						const userList = filterTypingUsers(Object.assign({}, _this.props.typingUsers));
						if (!userList) return;
						for (let m = 0; m < userList.length; m++) {
							const user = stores_namespaceObject.Users.getUser(userList[m].id);
							if (!user) continue;
							let tree = res?.props?.children?.[1]?.props?.children;
							if (!tree) continue;
							let userChildren = tree[2 * m];
							if (typingBar_React.isValidElement(userChildren?.props?.children?.[0])) continue;
							userChildren.props.children.unshift(typingBar_React.createElement(typingBar_Avatar, {
								src: user.getAvatarURL(stores_namespaceObject.SelectedGuilds.getGuildId(), 16),
								className: style.Z["align-wrapper-icon"],
								size: typingBar_Avatar.Sizes.SIZE_16
							}));
							userChildren.props.className += " " + style.Z["align-wrapper"];
						}
					}));
					TypingUsers.forceUpdateAll();
				};
				const {
					default: compactMessages_Avatar
				} = external_PluginApi_namespaceObject.WebpackModules.getByProps("AnimatedAvatar");
				const {
					AvatarDefaults: compactMessages_AvatarDefaults
				} = external_PluginApi_namespaceObject.DiscordModules;
				const compactMessages = () => {
					external_PluginApi_namespaceObject.Patcher.after(external_PluginApi_namespaceObject.WebpackModules.find((e => e.default?.toString().indexOf("getGuildMemberAvatarURLSimple") > -1)), "default", ((_this, [props], res) => {
						if (!(settingsManager.get("compact-message", true) && stores_namespaceObject.SettingsStore.messageDisplayCompact)) return;
						let header = external_PluginApi_namespaceObject.Utilities.findInReactTree(res, (e => e?.props?.renderPopout));
						const firstOgFunc = header?.type;
						if (!firstOgFunc) return;
						header.type = (...args) => {
							let firstRet = firstOgFunc(...args);
							const secondOgFunc = firstRet.props?.children?.[1]?.props?.children;
							if (!secondOgFunc) return;
							firstRet.props.children[1].props.children = (...args) => {
								let secondRet = secondOgFunc(...args);
								let children = secondRet.props?.children;
								secondRet.props.className += " " + style.Z["align-wrapper"];
								if (external_BdApi_React_default().isValidElement(children?.[0])) return firstRet;
								const url = props.message.author.getAvatarURL(stores_namespaceObject.SelectedGuilds.getGuildId(), 16);
								if (!_.isArray(children)) secondRet.props.children = [children];
								secondRet.props.children.unshift(external_BdApi_React_default().createElement(compactMessages_Avatar, {
									src: url,
									className: style.Z["align-wrapper-icon"],
									size: compactMessages_Avatar.Sizes.SIZE_16
								}));
								return secondRet;
							};
							return firstRet;
						};
					}));
					external_PluginApi_namespaceObject.Patcher.after(external_PluginApi_namespaceObject.WebpackModules.find((m => "Username" === m.default?.displayName)), "default", ((_this, [props], res) => {
						if (!(settingsManager.get("compact-message-reply", true) && stores_namespaceObject.SettingsStore.messageDisplayCompact)) return;
						const firstOgFunc = res.type;
						if (!firstOgFunc) return;
						res.type = (...args) => {
							let firstRet = firstOgFunc(...args);
							console.log("firstRet", firstRet);
							const secondOgFunc = firstRet.props?.children?.[1]?.props?.children;
							if (!secondOgFunc) return;
							firstRet.props.children[1].props.children = (...args) => {
								let secondRet = secondOgFunc(...args);
								let children = secondRet.props?.children;
								secondRet.props.className += " " + style.Z["align-wrapper"];
								if (external_BdApi_React_default().isValidElement(children?.[0])) return firstRet;
								const url = props.message.author.getAvatarURL(stores_namespaceObject.SelectedGuilds.getGuildId(), 16);
								if (!_.isArray(children)) secondRet.props.children = [children];
								secondRet.props.children.unshift(external_BdApi_React_default().createElement(compactMessages_Avatar, {
									src: url,
									className: style.Z["align-wrapper-icon"],
									size: compactMessages_Avatar.Sizes.SIZE_16
								}));
								return secondRet;
							};
							return firstRet;
						};
					}));
				};
				const {
					default: systemMessages_Avatar
				} = external_PluginApi_namespaceObject.WebpackModules.getByProps("AnimatedAvatar");
				const {
					AvatarDefaults: systemMessages_AvatarDefaults
				} = external_PluginApi_namespaceObject.DiscordModules;
				const systemMessages = () => {
					const setupEnv = (element, checkElement) => {
						if (!element) return true;
						element.props.className += " " + style.Z["align-wrapper"];
						if (!checkElement) return;
						return external_BdApi_React_default().isValidElement(checkElement);
					};
					external_PluginApi_namespaceObject.Patcher.after(external_PluginApi_namespaceObject.WebpackModules.find((m => "UserJoin" === m.default?.displayName)), "default", ((_this, [props], res) => {
						if (!settingsManager.get("system-messages-join", true)) return;
						console.log();
						let userName = external_PluginApi_namespaceObject.Utilities.findInReactTree(res, (e => e?.renderPopout));
						const ogFunc = userName?.children;
						if (!ogFunc) return;
						userName.children = (...args) => {
							let ret = ogFunc(...args);
							if (setupEnv(ret, ret.props?.children?.[0])) return ret;
							const url = props.message.author.getAvatarURL(stores_namespaceObject.SelectedGuilds.getGuildId(), 16);
							ret.props.children.unshift(external_BdApi_React_default().createElement(systemMessages_Avatar, {
								src: url,
								className: style.Z["align-wrapper-icon"],
								size: systemMessages_Avatar.Sizes.SIZE_16
							}));
							return ret;
						};
					}));
					external_PluginApi_namespaceObject.Patcher.after(external_PluginApi_namespaceObject.WebpackModules.find((m => "UserPremiumGuildSubscription" === m.default?.displayName)).default.prototype, "render", ((_this, [props], res) => {
						if (!settingsManager.get("system-messages-boost", true)) return;
						let userName = external_PluginApi_namespaceObject.Utilities.findInReactTree(res, (e => e?.props?.renderPopout));
						const ogFunc = userName?.props?.children;
						if (!ogFunc) return;
						userName.props.children = (...args) => {
							let ret = ogFunc(...args);
							if (setupEnv(ret, ret.props?.children?.[0])) return ret;
							const url = _this.props.message.author.getAvatarURL(stores_namespaceObject.SelectedGuilds.getGuildId(), 16);
							ret.props.children.unshift(external_BdApi_React_default().createElement(systemMessages_Avatar, {
								src: url,
								className: style.Z["align-wrapper-icon"],
								size: systemMessages_Avatar.Sizes.SIZE_16
							}));
							return ret;
						};
					}));
					external_PluginApi_namespaceObject.Patcher.after(external_PluginApi_namespaceObject.WebpackModules.find((m => "ThreadCreated" === m.default?.displayName)), "default", ((_this, [props], res) => {
						if (!settingsManager.get("system-messages-thread-created", true)) return;
						const url = props.message.author.getAvatarURL(stores_namespaceObject.SelectedGuilds.getGuildId(), 16);
						res.props.children.unshift(external_BdApi_React_default().createElement(systemMessages_Avatar, {
							src: url,
							className: style.Z["align-wrapper-icon"],
							size: systemMessages_Avatar.Sizes.SIZE_16
						}));
					}));
					external_PluginApi_namespaceObject.Patcher.after(external_PluginApi_namespaceObject.WebpackModules.find((m => "ThreadMemberRemove" === m.default?.displayName)), "default", ((_this, [props], res) => {
						if (!settingsManager.get("system-messages-thread-member-removed", true)) return;
						const personRemoveUser = props.message.author;
						const removedUser = props.targetUser;
						let personRemoveUserElement = external_PluginApi_namespaceObject.Utilities.findInReactTree(res, (e => e?.props?.renderPopout && "0" === e?.key));
						let removedUserElement = external_PluginApi_namespaceObject.Utilities.findInReactTree(res, (e => e?.props?.renderPopout && "2" === e?.key));
						const personRemoveUserElementOgFunc = personRemoveUserElement?.props?.children;
						const removedUserElementOgFunc = removedUserElement?.props?.children;
						if (!(personRemoveUserElementOgFunc && removedUserElementOgFunc)) return;
						personRemoveUserElement.props.children = (...args) => {
							let ret = personRemoveUserElementOgFunc(...args);
							if (setupEnv(ret, ret.props?.children?.[0])) return ret;
							const url = personRemoveUser.getAvatarURL(stores_namespaceObject.SelectedGuilds.getGuildId(), 16);
							ret.props.children.unshift(external_BdApi_React_default().createElement(systemMessages_Avatar, {
								src: url,
								className: style.Z["align-wrapper-icon"],
								size: systemMessages_Avatar.Sizes.SIZE_16
							}));
							return ret;
						};
						removedUserElement.props.children = (...args) => {
							let ret = removedUserElementOgFunc(...args);
							if (setupEnv(ret, ret.props?.children?.[0])) return ret;
							const url = removedUser.getAvatarURL(stores_namespaceObject.SelectedGuilds.getGuildId(), 16);
							ret.props.children.unshift(external_BdApi_React_default().createElement(systemMessages_Avatar, {
								src: url,
								className: style.Z["align-wrapper-icon"],
								size: systemMessages_Avatar.Sizes.SIZE_16
							}));
							return ret;
						};
					}));
				};
				var AvatarsEverywhere_React = __webpack_require__(113);
				class AvatarsEverywhere extends(external_BasePlugin_default()) {
					onStart() {
						external_StyleLoader_default().inject();
						userMentions();
						typingBar();
						compactMessages();
						systemMessages();
					}
					getSettingsPanel() {
						return AvatarsEverywhere_React.createElement(Settings, null);
					}
					onStop() {
						external_PluginApi_namespaceObject.Patcher.unpatchAll();
						external_StyleLoader_default().remove();
					}
				}
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
		var __webpack_exports__ = __webpack_require__(166);
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