/**
 * @name ShowBadgesInChat
 * @author DevilBro
 * @authorId 278543574059057154
 * @version 1.9.0
 * @description Displays Badges (Nitro, Hypesquad, etc...) in the Chat/MemberList/DMList
 * @invite Jx3TjNS
 * @donate https://www.paypal.me/MircoWittrien
 * @patreon https://www.patreon.com/MircoWittrien
 * @website https://mwittrien.github.io/
 * @source https://github.com/mwittrien/BetterDiscordAddons/tree/master/Plugins/ShowBadgesInChat/
 * @updateUrl https://mwittrien.github.io/BetterDiscordAddons/Plugins/ShowBadgesInChat/ShowBadgesInChat.plugin.js
 */

module.exports = (_ => {
	const config = {
		"info": {
			"name": "ShowBadgesInChat",
			"author": "DevilBro",
			"version": "1.9.0",
			"description": "Displays Badges (Nitro, Hypesquad, etc...) in the Chat/MemberList/DMList"
		},
		"changeLog": {
			"improved": {
				"More Specific Settings": "You can now select more specifically where which Badges will be shown"
			}
		}
	};
	
	return !window.BDFDB_Global || (!window.BDFDB_Global.loaded && !window.BDFDB_Global.started) ? class {
		getName () {return config.info.name;}
		getAuthor () {return config.info.author;}
		getVersion () {return config.info.version;}
		getDescription () {return `The Library Plugin needed for ${config.info.name} is missing. Open the Plugin Settings to download it. \n\n${config.info.description}`;}
		
		downloadLibrary () {
			require("request").get("https://mwittrien.github.io/BetterDiscordAddons/Library/0BDFDB.plugin.js", (e, r, b) => {
				if (!e && b && r.statusCode == 200) require("fs").writeFile(require("path").join(BdApi.Plugins.folder, "0BDFDB.plugin.js"), b, _ => BdApi.showToast("Finished downloading BDFDB Library", {type: "success"}));
				else BdApi.alert("Error", "Could not download BDFDB Library Plugin. Try again later or download it manually from GitHub: https://mwittrien.github.io/downloader/?library");
			});
		}
		
		load () {
			if (!window.BDFDB_Global || !Array.isArray(window.BDFDB_Global.pluginQueue)) window.BDFDB_Global = Object.assign({}, window.BDFDB_Global, {pluginQueue: []});
			if (!window.BDFDB_Global.downloadModal) {
				window.BDFDB_Global.downloadModal = true;
				BdApi.showConfirmationModal("Library Missing", `The Library Plugin needed for ${config.info.name} is missing. Please click "Download Now" to install it.`, {
					confirmText: "Download Now",
					cancelText: "Cancel",
					onCancel: _ => {delete window.BDFDB_Global.downloadModal;},
					onConfirm: _ => {
						delete window.BDFDB_Global.downloadModal;
						this.downloadLibrary();
					}
				});
			}
			if (!window.BDFDB_Global.pluginQueue.includes(config.info.name)) window.BDFDB_Global.pluginQueue.push(config.info.name);
		}
		start () {this.load();}
		stop () {}
		getSettingsPanel () {
			let template = document.createElement("template");
			template.innerHTML = `<div style="color: var(--header-primary); font-size: 16px; font-weight: 300; white-space: pre; line-height: 22px;">The Library Plugin needed for ${config.info.name} is missing.\nPlease click <a style="font-weight: 500;">Download Now</a> to install it.</div>`;
			template.content.firstElementChild.querySelector("a").addEventListener("click", this.downloadLibrary);
			return template.content.firstElementChild;
		}
	} : (([Plugin, BDFDB]) => {
		var _this;
		var badgeConfigs = {}, loadedUsers = {}, queuedInstances = {}, requestQueue = {queue: [], timeout: null, id: null}, cacheTimeout;
		var specialFlag;
		
		const places = ["chat", "memberList", "dmsList"];
		
		const badges = {};
		
		const indicators = {
			CURRENT_GUILD_BOOST: {value: true}
		};
		
		return class ShowBadgesInChat extends Plugin {
			onLoad () {
				_this = this;
				
				specialFlag = BDFDB.NumberUtils.generateId() + "SPECIALFLAG";
		
				this.patchedModules = {
					after: {
						MessageUsername: "default",
						MemberListItem: "render",
						PrivateChannel: "render",
						UserProfileBadgeList: "default"
					}
				};
				
				for (let key of Object.keys(BDFDB.LibraryComponents.UserBadgeKeys).filter(n => isNaN(parseInt(n)))) {
					let basicKey = key.replace(/_LEVEL_\d+/g, "");
					if (!badges[basicKey]) badges[basicKey] = {value: true, keys: []};
					badges[basicKey].keys.push(BDFDB.LibraryComponents.UserBadgeKeys[key]);
				}
				
				this.css = `
					${BDFDB.dotCN._showbadgesinchatbadges} {
						display: inline-flex !important;
						justify-content: center;
						align-items: center;
						flex-wrap: nowrap;
						position: relative;
						margin: 0 0 0 4px;
						user-select: none;
					}
					${BDFDB.dotCN._showbadgesinchatbadges} > * {
						margin: 0;
					}
					${BDFDB.dotCN._showbadgesinchatbadges} > * + * {
						margin-left: 4px;
					}
					${BDFDB.dotCNS._showbadgesinchatbadges + BDFDB.dotCN.userbadge} {
						display: flex;
						justify-content: center;
						align-items: center;
					}
					${BDFDB.dotCNS._showbadgesinchatbadges + BDFDB.dotCN.userbadge + BDFDB.dotCN._showbadgesinchatindicator}::before {
						display: none;
					}
					${BDFDB.dotCNS._showbadgesinchatbadgessettings + BDFDB.dotCN.userbadge} {
						width: 24px !important;
						height: 20px !important;
					}
					${BDFDB.dotCN.memberpremiumicon} {
						display: none;
					}
					${BDFDB.dotCNS._showbadgesinchatbadges + BDFDB.dotCN.memberpremiumicon} {
						display: block;
						position: static;
						margin: 0;
					}
					${BDFDB.dotCN._showbadgesinchatbadgeschat} {
						position: relative;
						top: 4px;
					}
					${BDFDB.dotCNS.messagerepliedmessage + BDFDB.dotCN._showbadgesinchatbadgeschat} {
						top: 0;
					}
					${BDFDB.dotCNS.messagecompact + BDFDB.dotCN.messageusername} ~ ${BDFDB.dotCN._showbadgesinchatbadges},
					${BDFDB.dotCNS.messagerepliedmessage + BDFDB.dotCN.messageusername} ~ ${BDFDB.dotCN._showbadgesinchatbadges} {
						margin-right: .25rem;
						text-indent: 0;
					}
					${BDFDB.dotCNS.messagerepliedmessage + BDFDB.dotCN.messageusername} ~ ${BDFDB.dotCN._showbadgesinchatbadges} {
						margin-left: 0;
					}
					
					${BDFDB.dotCN._showbadgesinchatbadgessettings} {
						color: var(--header-primary);
					}
					${BDFDB.dotCN._showbadgesinchatbadgessettings} * {
						cursor: default;
					}
					${BDFDB.dotCN._showbadgesinchatbadgessettings}:last-child {
						margin-right: 8px;
					}
				`;
			}
			
			onStart () {
				queuedInstances = {}, loadedUsers = {};
				requestQueue = {queue: [], timeout: null, id: null};
				
				badgeConfigs = BDFDB.DataUtils.load(this, "badgeConfigs");
				for (let key in badges) {
					if (!badgeConfigs[key]) badgeConfigs[key] = {};
					for (let key2 of places) if (badgeConfigs[key][key2] == undefined) badgeConfigs[key][key2] = true;
					badgeConfigs[key].key = key;
				}
				for (let key in indicators) {
					if (!badgeConfigs[key]) badgeConfigs[key] = {};
					for (let key2 of places) if (badgeConfigs[key][key2] == undefined) badgeConfigs[key][key2] = true;
					badgeConfigs[key].key = key;
				}
				
				// REMOVE 15.06.2022
				let oldPlaces = BDFDB.DataUtils.load(this, "places");
				let oldBadges = BDFDB.DataUtils.load(this, "badges");
				let oldIndicators = BDFDB.DataUtils.load(this, "indicators");
				if (Object.keys(oldBadges).length && Object.keys(oldIndicators).length && Object.keys(oldPlaces).length) {
					for (let key in oldBadges) {
						if (!badgeConfigs[key]) badgeConfigs[key] = {};
						for (let key2 in oldPlaces) badgeConfigs[key][key2] = oldBadges[key] && oldPlaces[key2];
					}
					for (let key in oldIndicators) {
						if (!badgeConfigs[key]) badgeConfigs[key] = {};
						for (let key2 in oldPlaces) badgeConfigs[key][key2] = oldIndicators[key] && oldPlaces[key2];
					}
					BDFDB.DataUtils.remove(this, "general");
					BDFDB.DataUtils.remove(this, "settings");
					BDFDB.DataUtils.remove(this, "places");
					BDFDB.DataUtils.remove(this, "badges");
					BDFDB.DataUtils.remove(this, "indicators");
					BDFDB.DataUtils.save(badgeConfigs, this, "badgeConfigs");
				}
				
				let badgeCache = BDFDB.DataUtils.load(this, "badgeCache");
				if (badgeCache) {
					let now = (new Date()).getTime(), month = 1000*60*60*24*30;
					for (let id in badgeCache) {
						if (now - badgeCache[id].date > month) delete badgeCache[id];
						else loadedUsers[id] = badgeCache[id];
					}
					BDFDB.DataUtils.save(badgeCache, this, "badgeCache");
				}
				
				const processUser = (id, data) => {
					let userCopy = Object.assign({}, data.user);
					userCopy.premium_since = data.premium_since;
					userCopy.premium_guild_since = data.premium_guild_since;
					loadedUsers[id] = BDFDB.ObjectUtils.extract(userCopy, "flags", "premium_since", "premium_guild_since");
					loadedUsers[id].date = (new Date()).getTime();
					
					BDFDB.TimeUtils.clear(cacheTimeout);
					cacheTimeout = BDFDB.TimeUtils.timeout(_ => BDFDB.DataUtils.save(loadedUsers, this, "badgeCache"), 5000);
					
					if (requestQueue.id && requestQueue.id == id) {
						BDFDB.ReactUtils.forceUpdate(queuedInstances[requestQueue.id]);
						delete queuedInstances[requestQueue.id];
						requestQueue.id = null;
						BDFDB.TimeUtils.timeout(_ => this.runQueue(), 1000);
					}
				};
				BDFDB.PatchUtils.patch(this, BDFDB.LibraryModules.DispatchApiUtils, "dispatch", {after: e => {
					if (BDFDB.ObjectUtils.is(e.methodArguments[0]) && e.methodArguments[0].type == BDFDB.DiscordConstants.ActionTypes.USER_PROFILE_FETCH_FAILURE && e.methodArguments[0].userId) {
						const user = BDFDB.LibraryModules.UserStore.getUser(e.methodArguments[0].userId);
						processUser(e.methodArguments[0].userId, {user: user || {}, flags: user ? user.publicFlags : 0});
					}
					else if (BDFDB.ObjectUtils.is(e.methodArguments[0]) && e.methodArguments[0].type == BDFDB.DiscordConstants.ActionTypes.USER_PROFILE_FETCH_SUCCESS && e.methodArguments[0].user) processUser(e.methodArguments[0].user.id, e.methodArguments[0])
				}});

				this.forceUpdateAll();
			}
			
			onStop () {
				BDFDB.TimeUtils.clear(requestQueue.timeout);

				this.forceUpdateAll();
			}

			getSettingsPanel (collapseStates = {}) {
				let settingsPanel;
				return settingsPanel = BDFDB.PluginUtils.createSettingsPanel(this, {
					collapseStates: collapseStates,
					children: _ => {
						let settingsItems = [];
						settingsItems.push(BDFDB.ReactUtils.createElement(BDFDB.LibraryComponents.FormComponents.FormTitle, {
							className: BDFDB.disCN.marginbottom4,
							tag: BDFDB.LibraryComponents.FormComponents.FormTitle.Tags.H3,
							children: "Show Badges in"
						}));
						settingsItems.push(BDFDB.ReactUtils.createElement(BDFDB.LibraryComponents.SettingsList, {
							settings: places,
							data: Object.keys(badges).concat(Object.keys(indicators)).map(key => badgeConfigs[key]),
							noRemove: true,
							renderLabel: (cardData, instance) => BDFDB.ReactUtils.createElement(BDFDB.LibraryComponents.Flex, {
								children: [
									BDFDB.ReactUtils.createElement(BDFDB.LibraryComponents.Flex.Child, {
										children: BDFDB.ReactUtils.createElement(BDFDB.LibraryComponents.Clickable, {
											onClick: _ => {
												for (let settingId of places) badgeConfigs[cardData.key][settingId] = true;
												BDFDB.DataUtils.save(badgeConfigs, this, "badgeConfigs");
												BDFDB.ReactUtils.forceUpdate(instance);
												this.SettingsUpdated = true;
											},
											onContextMenu: _ => {
												for (let settingId of places) badgeConfigs[cardData.key][settingId] = false;
												BDFDB.DataUtils.save(badgeConfigs, this, "badgeConfigs");
												BDFDB.ReactUtils.forceUpdate(instance);
												this.SettingsUpdated = true;
											},
											children: cardData.key.split("_").map(n => BDFDB.LibraryModules.StringUtils.upperCaseFirstChar(n.toLowerCase())).join(" ")
										})
									}),
									this.createSettingsBadges(cardData.key)
								]
							}),
							onHeaderClick: (settingId, instance) => {
								for (let key in badgeConfigs) badgeConfigs[key][settingId] = true;
								BDFDB.DataUtils.save(badgeConfigs, this, "badgeConfigs");
								BDFDB.ReactUtils.forceUpdate(instance);
								this.SettingsUpdated = true;
							},
							onHeaderContextMenu: (settingId, instance) => {
								for (let key in badgeConfigs) badgeConfigs[key][settingId] = false;
								BDFDB.DataUtils.save(badgeConfigs, this, "badgeConfigs");
								BDFDB.ReactUtils.forceUpdate(instance);
								this.SettingsUpdated = true;
							},
							onCheckboxChange: (value, instance) => {
								badgeConfigs[instance.props.cardId][instance.props.settingId] = value;
								BDFDB.DataUtils.save(badgeConfigs, this, "badgeConfigs");
								this.SettingsUpdated = true;
							}
						}));
						
						settingsItems.push(BDFDB.ReactUtils.createElement(BDFDB.LibraryComponents.SettingsItem, {
							type: "Button",
							color: BDFDB.LibraryComponents.Button.Colors.RED,
							label: "Reset cached Badge Data",
							onClick: _ => BDFDB.ModalUtils.confirm(this, "Are you sure you want to reset the Badge Cache? This will force all Badges to rerender.", _ => {
								BDFDB.DataUtils.remove(this, "badgeCache");
								this.SettingsUpdated = true;
							}),
							children: BDFDB.LanguageUtils.LanguageStrings.RESET
						}));
						
						return settingsItems;
					}
				});
			}

			onSettingsClosed () {
				if (this.SettingsUpdated) {
					delete this.SettingsUpdated;
					this.forceUpdateAll();
				}
			}
			
			forceUpdateAll () {				
				BDFDB.PatchUtils.forceAllUpdates(this);
				BDFDB.MessageUtils.rerenderAll();
			}

			processMessageUsername (e) {
				if (!e.instance.props.message) return;
				let [children, index] = BDFDB.ReactUtils.findParent(e.returnvalue, {name: "Popout"});
				if (index == -1) return;
				const author = e.instance.props.userOverride || e.instance.props.message.author;
				this.injectBadges(children, author, (BDFDB.LibraryModules.ChannelStore.getChannel(e.instance.props.message.channel_id) || {}).guild_id, "chat");
			}

			processMemberListItem (e) {
				if (!e.instance.props.user) return;
				this.injectBadges(BDFDB.ObjectUtils.get(e.returnvalue, "props.decorators.props.children"), e.instance.props.user, e.instance.props.channel.guild_id, "memberList");
			}

			processPrivateChannel (e) {
				if (!e.instance.props.user) return;
				let wrapper = e.returnvalue && e.returnvalue.props.children && e.returnvalue.props.children.props && typeof e.returnvalue.props.children.props.children == "function" ? e.returnvalue.props.children : e.returnvalue;
				if (typeof wrapper.props.children == "function") {
					let childrenRender = wrapper.props.children;
					wrapper.props.children = BDFDB.TimeUtils.suppress((...args) => {
						let children = childrenRender(...args);
						this._processPrivateChannel(e.instance, children);
						return children;
					}, "Error in Children Render of PrivateChannel!", this);
				}
				else this._processPrivateChannel(e.instance, wrapper);
			}

			_processPrivateChannel (instance, returnvalue, a) {
				const wrapper = returnvalue.props.decorators ? returnvalue : BDFDB.ReactUtils.findChild(returnvalue, {props: ["decorators"]}) || returnvalue;
				if (!wrapper) return;
				wrapper.props.decorators = [wrapper.props.decorators].flat(10);
				this.injectBadges(wrapper.props.decorators, instance.props.user, null, "dmsList");
			}
			
			processUserProfileBadgeList (e) {
				if (e.instance.props.custom) {
					let filter = e.instance.props.place != "settings";
					for (let i in e.returnvalue.props.children) if (e.returnvalue.props.children[i]) {
						let key = parseInt(e.returnvalue.props.children[i].key);
						let keyName = filter && Object.keys(badges).find(n => badges[n].keys.includes(key));
						if (keyName && badgeConfigs[keyName] && !badgeConfigs[keyName][e.instance.props.place]) e.returnvalue.props.children[i] = null;
						else if (e.returnvalue.props.children[i].type.displayName == "TooltipContainer" || e.returnvalue.props.children[i].type.displayName == "Tooltip") {
							const childrenRender = e.returnvalue.props.children[i].props.children;
							e.returnvalue.props.children[i].props.children = (...args) => {
								const children = childrenRender(...args);
								delete children.props.onClick;
								return children;
							};
							e.returnvalue.props.children[i] = BDFDB.ReactUtils.createElement(BDFDB.LibraryComponents.TooltipContainer, e.returnvalue.props.children[i].props);
						}
					}
					if (e.instance.props.premiumCurrentGuildSince && !(filter && badgeConfigs.CURRENT_GUILD_BOOST && !badgeConfigs.CURRENT_GUILD_BOOST[e.instance.props.place])) e.returnvalue.props.children.push(BDFDB.ReactUtils.createElement(BDFDB.LibraryComponents.TooltipContainer, {
						text: BDFDB.LanguageUtils.LanguageStringsFormat("PREMIUM_GUILD_SUBSCRIPTION_TOOLTIP", e.instance.props.premiumCurrentGuildSince),
						children: BDFDB.ReactUtils.createElement(BDFDB.LibraryComponents.Clickable, {
							className: BDFDB.disCN.userbadgeouter,
							children: BDFDB.ReactUtils.createElement("div", {
								className: BDFDB.disCNS.userbadge + BDFDB.disCN._showbadgesinchatindicator,
								children: BDFDB.ReactUtils.createElement(BDFDB.LibraryComponents.SvgIcon, {
									className: BDFDB.disCN.memberpremiumicon,
									name: BDFDB.LibraryComponents.SvgIcon.Names.BOOST
								})
							})
						})
					}));
					if (!e.returnvalue.props.children.filter(n => n).length) return null;
				}
			}

			injectBadges (children, user, guildId, place) {
				if (!BDFDB.ArrayUtils.is(children) || !user || user.isNonUserBot()) return;
				if (!loadedUsers[user.id] || ((new Date()).getTime() - loadedUsers[user.id].date >= 1000*60*60*24*7)) {
					queuedInstances[user.id] = [].concat(queuedInstances[user.id]).filter(n => n);
					if (requestQueue.queue.indexOf(user.id) == -1) requestQueue.queue.push(user.id);
					this.runQueue();
				}
				children.push(BDFDB.ReactUtils.createElement(class extends BDFDB.ReactUtils.Component {
					render() {
						if (!loadedUsers[user.id] || ((new Date()).getTime() - loadedUsers[user.id].date >= 1000*60*60*24*7)) {
							if (queuedInstances[user.id].indexOf(this) == -1) queuedInstances[user.id].push(this);
							return null;
						}
						else return _this.createBadges(user, guildId, place);
					}
				}, {}, true));
			}
			
			runQueue () {
				if (!requestQueue.id) {
					let id = requestQueue.queue.shift();
					if (id) {
						requestQueue.id = id;
						BDFDB.TimeUtils.clear(requestQueue.timeout);
						requestQueue.timeout = BDFDB.TimeUtils.timeout(_ => {
							requestQueue.id = null;
							this.runQueue();
						}, 30000);
						BDFDB.LibraryModules.UserProfileUtils.fetchProfile(id);
					}
				}
			}

			createBadges (user, guildId, place) {
				let fakeGuildBoostDate;
				if (typeof user.id == "string" && user.id.startsWith(specialFlag + "GB")) {
					let level = parseInt(user.id.split("_").pop());
					for (let i = 0; i < 100 && !fakeGuildBoostDate; i++) {
						let date = new Date() - 1000*60*60*24*15 * i;
						if (level == BDFDB.LibraryModules.GuildBoostUtils.getUserLevel(date)) fakeGuildBoostDate = date;
					}
				}
				let member = guildId && BDFDB.LibraryModules.MemberStore.getMember(guildId, user.id);
				return BDFDB.ReactUtils.createElement(BDFDB.LibraryComponents.UserBadges.default, {
					className: BDFDB.DOMUtils.formatClassName(BDFDB.disCN._showbadgesinchatbadges, BDFDB.disCN[`_showbadgesinchatbadges${place.toLowerCase()}`]),
					user: user,
					size: BDFDB.LibraryComponents.UserBadges.BadgeSizes.SIZE_18,
					custom: true,
					place: place,
					premiumSince: loadedUsers[user.id] && loadedUsers[user.id].premium_since ? new Date(loadedUsers[user.id].premium_since) : (user.id == (specialFlag + "NITRO") ? new Date() : null),
					premiumGuildSince: fakeGuildBoostDate || (loadedUsers[user.id] && loadedUsers[user.id].premium_guild_since ? new Date(loadedUsers[user.id].premium_guild_since) : null),
					premiumCurrentGuildSince: member && member.premiumSince && new Date(member.premiumSince) || user.id == (specialFlag + "CGB") && new Date()
				});
			}
			
			createSettingsBadges (flag) {
				let wrappers = [];
				if (indicators[flag]) {
					let id = flag == "CURRENT_GUILD_BOOST" ? (specialFlag + "CGB") : null;
					let user = new BDFDB.DiscordObjects.User({flags: 0, id: id});
					wrappers.push(this.createBadges(user, null, "settings"));
				}
				else for (let key of badges[flag].keys) {
					let userFlag = flag == "PREMIUM" || flag == "GUILD_BOOSTER" ? 0 : BDFDB.DiscordConstants.UserFlags[flag];
					let keyName = BDFDB.LibraryComponents.UserBadgeKeys[key];
					if (userFlag == null && keyName) userFlag = BDFDB.DiscordConstants.UserFlags[keyName] != null ? BDFDB.DiscordConstants.UserFlags[keyName] : BDFDB.DiscordConstants.UserFlags[Object.keys(BDFDB.DiscordConstants.UserFlags).find(f => f.indexOf(keyName) > -1 || keyName.indexOf(f) > -1)];
					if (userFlag != null) {
						let id;
						if (flag == "PREMIUM") id = specialFlag + "NITRO";
						else if (keyName && keyName.startsWith("GUILD_BOOSTER")) id = specialFlag + "GB_" + keyName.split("_").pop();
						let user = new BDFDB.DiscordObjects.User({flags: userFlag, id: id});
						wrappers.push(this.createBadges(user, null, "settings"));
					}
				}
				return wrappers;
			}
		};
	})(window.BDFDB_Global.PluginUtils.buildPlugin(config));
})();
