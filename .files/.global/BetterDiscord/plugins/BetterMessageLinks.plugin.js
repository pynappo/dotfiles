/**
 * @name BetterMessageLinks
 * @author AGreenPig
 * @updateUrl https://raw.githubusercontent.com/TheGreenPig/BetterDiscordPlugins/main/BetterMessageLinks/BetterMessageLinks.plugin.js
 * @authorLink https://github.com/TheGreenPig
 * @source https://github.com/TheGreenPig/BetterDiscordPlugins/blob/main/BetterMessageLinks/BetterMessageLinks.plugin.js
 * @invite JsqBVSCugb
 */
 const config = {
	"info": {
		"name": "BetterMessageLinks",
		"authors": [{
			"name": "AGreenPig",
			"discord_id": "427179231164760066",
			"github_username": "TheGreenPig"
		}],
		"version": "1.4.12",
		"description": "Instead of just showing the long and useless discord message link, make it smaller and add a preview. Thanks a ton Strencher for helping me refactor my code and Juby for making the message queueing system. ",
		"github_raw": "https://raw.githubusercontent.com/TheGreenPig/BetterDiscordPlugins/main/BetterMessageLinks/BetterMessageLinks.plugin.js",
	},
	"changelog": [
		{
			"title": "Fixed",
			"type": "fixed",
			"items": [
				"Fixed crashing issue",
			]
		},
	],
}

/* ----Useful links----
 * 
 * BetterDiscord BdApi documentation:
 *   https://github.com/BetterDiscord/BetterDiscord/wiki/Creating-Plugins
 * 
 * Zere's Plugin Library documentation:
 * 	 https://rauenzi.github.io/BDPluginLibrary/docs/
*/


// This plugin was only made possible by the generous help of Strencher and the MessageLinkEmbed plugin by him and Juby210! They definitely deserve all the credit

module.exports = !global.ZeresPluginLibrary ? class {
	constructor() { this._config = config; }
	getName() { return config.info.name; }
	getAuthor() { return config.info.authors.map(a => a.name).join(", "); }
	getDescription() { return config.info.description; }
	getVersion() { return config.info.version; }
	load() {
		BdApi.showConfirmationModal("Library Missing", `The library plugin needed for **${config.info.name}** is missing. Please click Download Now to install it.`, {
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
	start() { }
	stop() { }
} : (([Plugin, Library]) => {
	//Custom css
	const customCSS = `
	.betterMessageLinks.Popout {
		max-width: 280px;
		font-size: 14px;
		width: fit-content; 
	  	max-height: 450px;
		overflow: auto;  
		-webkit-user-select: text;
		background: var(--background-floating);
		border-radius: 4px;
		padding: 1em;
		color: var(--text-normal);
		overflow-wrap: break-word;
		word-wrap: break-word;
		-webkit-box-shadow: var(--elevation-high);
		box-shadow: var(--elevation-high);
	}
	.betterMessageLinks em {
		font-style: italic;
	}
	.betterMessageLinks.Settings.Spinner div.info-2FZci4 {
		display: flex;
	}
	.betterMessageLinks.Settings.Spinner div.size14-3fJ-ot:not(.description-30xx7u){
		margin-left: auto;
	}
	.betterMessageLinks.Loading {
		display: flex;
		align-items: center;
	}
	.betterMessageLinks.Loading.Spinner {
		padding-left: 1.5em;
	}
	.betterMessageLinks.Loading.Text {
		vertical-align: middle;
	}
	.betterMessageLinks strong {
		font-weight: bold;
	}
	.betterMessageLinks code {
		white-space: pre-wrap;
	}
	.betterMessageLinks blockquote  {
		max-width: calc(100% - 4px);
	}
	
	.betterMessageLinks.Author{
		font-weight: bold;
	}
	.betterMessageLinks.Image {
		border-radius: 10px;
		max-width: 250px;
		padding-top: 5px;
	}
	.betterMessageLinks.AlignMiddle{
		vertical-align: middle;
	}
	.betterMessageLinks.Icon{
		width: 25px;
		height: 25px;
	}
	.betterMessageLinks.Footer{
		color: var(--text-muted);
		font-size: 0.6rem;
		padding-top: 8px;
	}
	.betterMessageLinks.BotTag{
		padding-left: 5px;
		padding-right: 5px;
	}
	.betterMessageLinks.List{
		padding-left: 20px;
		-webkit-user-select: text;
		padding-top: 3px;
	}
	.betterMessageLinks.ListElement{
		font-weight: bold;
	}
	.betterMessageLinks.ListElement.Symbol{
		font-size: 1.1em;
		padding-right: 3px;
	}
	`


	const defaultSettings = {
		ignoreMessage: false,
		ignoreAttachment: false,
		messageReplaceText: "<Message>",
		attachmentReplaceText: "<Attachment>",
		showAuthorIcon: true,
		showGuildIcon: true,
		noDisplayIfSameGuild: true,
		progressBar: true,
		spinner: 0,
		mentionStyle: true,
		animationType: "TRANSLATE",
		advancedFooter: `$guildName, $channelName at $timestamp`,
	};
	const validFooterValues = ["authorName", "guildName", "guildId", "channelName", "channelId", "messageId", "timestamp", "nsfw"]

	//Settings and imports
	const { WebpackModules, Patcher, Settings, DiscordModules } = { ...BdApi, ...Library };
	const { SettingPanel, Switch, Slider, RadioGroup, Textbox, SettingGroup } = Settings;
	/**@type {typeof import("react")} */
	const React = DiscordModules.React;
	//Modules
	const MessageStore = WebpackModules.getByProps("hasCurrentUserSentMessage", "getMessage");
	const GetGuildModule = DiscordModules.GuildStore;
	const GetChannelModule = DiscordModules.ChannelStore;
	const User = WebpackModules.find(m => m.prototype && m.prototype.tag);
	const Timestamp = WebpackModules.find(m => m.prototype && m.prototype.toDate && m.prototype.month)
	const { stringify } = WebpackModules.getByProps('stringify', 'parse', 'encode');
	const ImagePlaceHolder = WebpackModules.findByDisplayName("ImagePlaceholder");
	const BotTag = WebpackModules.getByProps("BotTagTypes").default;
	const Popout = WebpackModules.getByDisplayName("Popout");
	const RenderMessageMarkupToASTModule = WebpackModules.getByProps("renderMessageMarkupToAST");
	const RepliedMessage = WebpackModules.getModule(m => m && m.default && m.default.displayName == "RepliedMessage");
	const MarkdownModule = WebpackModules.getByProps("parseTopic");
	const Anchor = WebpackModules.findByDisplayName("Anchor");
	let cache = {};
	let lastFetch = 0;
	let linkQueue = [];
	const spinnerTypes = Object.values(DiscordModules.Spinner.Type);

	let spinnerSetting = [];
	spinnerTypes.forEach((spinnerType, i) => {
		let name = spinnerType.replace(/([A-Z])/g, " $1");
		name = name.charAt(0).toUpperCase() + name.slice(1);
		spinnerSetting.push({
			name: name,
			desc: React.createElement(DiscordModules.Spinner, { type: spinnerType },),
			value: i
		})
	})

	const popoutAnimationTypes = Object.keys(Popout.Animation);

	let animationSetting = [];
	popoutAnimationTypes.forEach((animationType, i) => {
		let name = animationType.toLowerCase();
		name = name.charAt(0).toUpperCase() + name.slice(1);
		animationSetting.push({
			name: name,
			desc: "",
			value: animationType
		})
	})



	async function getMsg(channelId, messageId) {
		let message = MessageStore.getMessage(channelId, messageId) || cache[messageId]

		if (!message) {
			if (lastFetch > Date.now() - 2500) await new Promise(r => setTimeout(r, 2500))
			const data = await DiscordModules.APIModule.get({
				url: DiscordModules.DiscordConstants.Endpoints.MESSAGES(channelId),
				query: stringify({
					limit: 1,
					around: messageId
				}),
				retries: 2
			}).catch((error) => {
				return error;
			})
			lastFetch = Date.now()
			if (data.ok) {
				message = data.body[0]

				if (!message) return

				message.author = new User(message.author)
				message.timestamp = new Timestamp(message.timestamp)
			} else {
				cache[messageId] = data;
				return data;
			}

		}
		cache[messageId] = message
		return message;
	}
	const getMsgWithQueue = (() => {
		let pending = Promise.resolve()

		const run = async (channelId, messageId, component) => {
			try {
				await pending
			} finally {
				linkQueue.shift()
				linkQueue.forEach(c => {
					c.setState({ queue: linkQueue })
				})

				return getMsg(channelId, messageId)
			}
		}

		return (channelId, messageId, component) => (pending = run(channelId, messageId, component))
	})()

	class BetterLink extends React.Component {
		constructor(props) {
			super(props)
			this.state = { loaded: false, message: null };
		}
		async componentDidMount() {
			if (!this.state.loaded) {
				let numberMatches = this.props.original.split("/").filter((e) => /^\d+$/.test(e));
				let messageId = numberMatches[numberMatches.length - 1];
				let channelId = numberMatches[numberMatches.length - 2];
				let guildId = numberMatches.length > 2 ? numberMatches[numberMatches.length - 3] : undefined;

				linkQueue.push(this)
				this.setState({ originalIndex: linkQueue.length, queue: linkQueue })
				let message = await getMsgWithQueue(channelId, messageId, this)

				if (!message) return
				message.guild = guildId ? GetGuildModule.getGuild(guildId) : "@me";
				this.setState({ loaded: true, message });

			}
		}

		renderLoading() {
			let loadedPercent = Math.max(Math.min(Math.round(((this.state.originalIndex - this.state.queue.indexOf(this)) / this.state.originalIndex) * 100), 100), 0);
			return React.createElement("div", { className: "betterMessageLinks AlignMiddle Loading" },
				React.createElement("span", { className: "betterMessageLinks AlignMiddle Loading Text" }, `Loading ... ${loadedPercent}%`),
				React.createElement("span", { className: "betterMessageLinks AlignMiddle Loading Spinner" },
					React.createElement(DiscordModules.Spinner, { type: spinnerTypes[this.props.settings.spinner] })
				),
			)

		}

		renderError(message) {
			let content = "Unknown Error while trying to fetch message."
			if (message.body?.message) {
				content = `Error: ${message.body?.message}`;
			}
			return React.createElement("div", { className: "betterMessageLinks AlignMiddle Error" },
				React.createElement("span", { className: "betterMessageLinks AlignMiddle Loading Text" }, content),
			)

		}

		renderHeader(message, hasAttachments) {
			const { settings } = this.props;

			return React.createElement("div", {
				className: "betterMessageLinks-header",
				children: [
					settings.showGuildIcon && message.guild?.id && (message.guild?.id !== DiscordModules.SelectedGuildStore.getGuildId() || !settings.noDisplayIfSameGuild)
						? React.createElement("img", { src: `https://cdn.discordapp.com/icons/${message.guild.id}/${message.guild.icon}.webp`, className: "replyAvatar-sHd2sU betterMessageLinks AlignMiddle Icon" })
						: null,
					settings.showAuthorIcon
						? React.createElement("img", { src: message.author.getAvatarURL(), className: "replyAvatar-sHd2sU betterMessageLinks AlignMiddle Icon" })
						: null,
					React.createElement("span", { className: "betterMessageLinks Author AlignMiddle" }, message.author.username),
					settings.showAuthorIcon && message.author.bot
						? React.createElement("span", { className: "betterMessageLinks AlignMiddle BotTag" }, React.createElement(BotTag, {}))
						: null,
					React.createElement("span", { className: "betterMessageLinks Author AlignMiddle", style: { paddingLeft: "0px" } }, ":"),
					hasAttachments
						? React.createElement(ImagePlaceHolder, { width: "20px", height: "20px", class: "betterMessageLinks AlignMiddle" })
						: null
				]
			})
		}

		renderContent(message) {
			let content = null;

			if (this.props.attachmentLink) {
				content = this.props.original.split("/").pop();
			} else {
				content = this.processNewLines(RenderMessageMarkupToASTModule.default(Object.assign({}, message), { renderMediaEmbeds: true, formatInline: false, isInteracting: true }).content);
			}

			return React.createElement("span", {
				className: "betterMessageLinks AlignMiddle"
			}, content);
		}

		renderAttachment(message) {
			if (message.attachments?.length > 0 || message.embeds?.length > 0 || message.sticker_items?.length > 0) {
				let isVideo = false;
				let url = "";

				if (message.attachments[0]?.content_type?.startsWith("video") || message.embeds[0]?.video) {
					isVideo = true;
				}

				if (message.attachments?.length > 0) {
					url = message.attachments[0].url
				}
				else if (message.embeds?.length > 0) {
					if (message.embeds[0]?.video) {
						url = message.embeds[0].video.url
					}
					else if (message.embeds[0]?.image) {
						url = message.embeds[0]?.image.proxyURL;
					}
				} else if (message.sticker_items?.length > 0) {
					url = `https://media.discordapp.net/stickers/${message.sticker_items[0].id}.png`;
				}
				if (!url) return null;

				return isVideo ?
					React.createElement("video", {
						className: "betterMessageLinks AlignMiddle Image",
						src: url,
						loop: true, autoPlay: true, muted: true,
					})
					: React.createElement("img", {
						className: "betterMessageLinks AlignMiddle Image",
						src: url,
					})
			}
			return null;
		}

		renderBetterFooter(advancedFooter, message) {
			if (advancedFooter === "") return;
			let channel = GetChannelModule.getChannel(message.channel_id);
			let author = message?.author;
			let authorName = author.username;
			let authorId = author.id;
			let guildName, guildId = "";
			let channelName = "";
			let channelId = channel?.id;
			let messageId = message.id;
			let timestamp = new Date(message.timestamp).toLocaleString();
			let nsfw = channel?.nsfw;

			if (channel) {
				if (channel?.type === DiscordModules.DiscordConstants.ChannelTypes.DM) {
					guildName = "DM";
					guildId = "@me";
					channelName = channel.rawRecipients[0].username;
				}
				else if (channel?.type === DiscordModules.DiscordConstants.ChannelTypes.GROUP_DM) {
					guildName = "DMs"
					guildId = "@me";
					channelName = channel.rawRecipients.map((e) => e.username).slice(0, 3).join("-");
				}
				else {
					if (message.guild) {
						guildName = message.guild.name;
						guildId = message.guild.id;
					}
					channelName = "#" + channel.name;
				}
			}

			//not the prettiest solution, but the best I could come up with currently without using eval or writing data.channel, data.guild, etc. 🤷‍♂️ should be ok for now, maybe I can rework it later
			const data = {
				authorName: authorName,
				authorId: authorId,
				guildName: guildName,
				guildId: guildId,
				channelName: channelName,
				channelId: channelId,
				messageId: messageId,
				timestamp: timestamp,
				nsfw: nsfw
			};

			let footer = advancedFooter;
			validFooterValues.forEach((value) => {
				footer = footer.replace("$" + value, data[value])
			})
			if (footer.includes("$")) footer = "Invalid variables set! Make sure you don't use $ unless it's a valid variable."
			return React.createElement("div", {
				className: "betterMessageLinks Footer"
			}, footer);
		}
		renderAttachmentLink(link) {
			let validImageExtensions = ["jpg", "jpeg", "png", "gif", "gifv", "apng", "avif", "jfif", "pjpeg", "pjp", "svg", "webp"]
			let validVideoExtensions = ["mp4", "webm", "ogg"];
			let extension = link.split(".").pop();

			let preview = null;
			if (validVideoExtensions.includes(extension)) {
				preview = React.createElement("video", {
					className: "betterMessageLinks AlignMiddle Image",
					src: link,
					loop: true, autoPlay: true, muted: true,
				})
			}
			else if (validImageExtensions.includes(extension)) {
				preview = React.createElement("img", {
					className: "betterMessageLinks AlignMiddle Image",
					src: link,
				})
			}
			return React.createElement("div", { className: "betterMessageLinks Author AlignMiddle" },
				link.split("/").pop(),
				preview
			)
		}

		renderMessage() {
			if (this.props.attachmentLink) {
				return React.createElement("div", {
					className: "betterMessageLinks AlignMiddle Container",
					children: [
						this.renderAttachmentLink(this.props.original)
					]
				});
			}
			const { message } = this.state;
			if (!message.ok && !message.id) return this.renderError(message);
			let hasAttachments = message.attachments?.length > 0 || message.embeds?.length > 0 || message.sticker_items?.length > 0;
			return React.createElement("div", {
				className: "betterMessageLinks AlignMiddle Container",
				children: [
					this.renderHeader(message, hasAttachments),
					this.renderContent(message),
					this.renderAttachment(message),
					this.renderBetterFooter(this.props.settings.advancedFooter, message)
				]
			});
		}

		render() {
			let { settings } = this.props;
			let attachmentLink = this.props.attachmentLink;

			let messageReplace = this.props.original;
			if (!this.props.replaceOverride) {
				if (settings.messageReplaceText !== "" && !attachmentLink) {
					messageReplace = settings.messageReplaceText;
				} else if (settings.attachmentReplaceText !== "" && attachmentLink) {
					messageReplace = settings.attachmentReplaceText;
				}
			} else {
				messageReplace = this.props.replaceOverride;
			}

			return React.createElement(Popout, {
				shouldShow: this.state.showPopout,
				position: Popout.Positions.TOP,
				align: Popout.Align.CENTER,
				animation: Popout.Animation[this.props.settings.animationType],
				spacing: 0,
				renderPopout: () => {
					return React.createElement("div", {
						className: "thin-31rlnD scrollerBase-_bVAAt betterMessageLinks Popout",
						onMouseEnter: () => this.setState({ showPopout: true }),
						onMouseLeave: () => this.setState({ showPopout: false })
					}, this.state.loaded || this.props.attachmentLink ? this.renderMessage() : this.renderLoading())
				}
			}, () => React.createElement(Anchor, {
				className: `betterMessageLinks Link${this.props.settings.mentionStyle ? " wrapper-1ZcZW- mention interactive" : ""}`,

				href: this.props.original,
				children: [messageReplace],
				onMouseEnter: () => this.setState({ showPopout: true }),
				onMouseLeave: () => this.setState({ showPopout: false })
			}))
		}
		processNewLines(array) {
			let processedArray = [];
			let tempArray = [];
			array.forEach((messageElement) => {
				if (!messageElement.type && messageElement.includes("\n")) {
					//replaces \n in text with actual newline elements
					let split = messageElement.split("\n");
					let newLine = React.createElement("br", {});
					processedArray.push([newLine].concat(...split.map(e => [e, newLine])).slice(1, -1))
				}
				else {
					processedArray.push(messageElement)
				}
			})
			if (processedArray.length === 0) return array;
			return processedArray;
		}
	}
	return class BetterMessageLinks extends Plugin {
		async onStart() {
			//inject css
			BdApi.injectCSS(config.info.name, customCSS)
			this.settings = this.loadSettings(defaultSettings);

			Patcher.after(MarkdownModule.defaultRules.link, "react", (_, [props], ret) => {
				return this.handleLink(ret);
			})

			//replied messages get checked extra. This isn't really nice code, but it works I guess.
			Patcher.after(RepliedMessage, "default", (_, [props], ret) => {
				if (props.content?.length > 0) {
					props.content.forEach((element, i) => {
						if (element.type?.displayName === "MaskedLink") {
							props.content[i] = this.handleLink(element);
						}
					});
				}
			})

		}
		handleLink(ret) {
			//check if it already is a masked link (the href and content aren't the same), if so, we don't want to change the text. (Can happen in embeds for example)
			let isMaskedLink = ret.props.children[0] !== ret.props.href;

			if (/^https:\/\/(ptb.|canary.)?discord(app)?.com\/channels\/(\d+|@me)\/\d+\/\d+$/gi.test(ret.props.href) && !this.settings.ignoreMessage) {
				return React.createElement(BetterLink, { original: ret.props.href, settings: this.settings, key: config.info.name, replaceOverride: isMaskedLink && ret.props.children[0]})
			} else if (/^https:\/\/(media|cdn).discordapp.(com|net)\/attachments\/\d+\/\d+\/.+$/gi.test(ret.props.href) && !this.settings.ignoreAttachment) {
				return React.createElement(BetterLink, { original: ret.props.href.split("?")[0], settings: this.settings, attachmentLink: true, key: config.info.name, replaceOverride: isMaskedLink && ret.props.children[0] });
			}
			return ret;
		}

		getSettingsPanel() {
			let listArray = [];
			validFooterValues.forEach((value) => {
				listArray.push(React.createElement("li", { class: "betterMessageLinks ListElement" },
					React.createElement("span", { class: "betterMessageLinks ListElement Symbol" }, "$"),
					value));
			})
			let unorderedList = React.createElement("ul", {
				children: listArray,
				class: "betterMessageLinks List"
			});

			let messageReplaceGroup = new SettingGroup("Message Replace").append(
				new Textbox("", "Replace all Discord message links with the following text. Leave empty to not change the Discord Link at all.", this.settings.messageReplaceText, (i) => {
					this.settings.messageReplaceText = i;
				}, { placeholder: "<Message>" }),
			)

			let attachmentReplaceGroup = new SettingGroup("Attachment Replace").append(
				new Textbox("", "Replace all Discord Attachment links with the following text. Leave empty to not change the Discord Link at all.", this.settings.attachmentReplaceText, (i) => {
					this.settings.attachmentReplaceText = i;
				}, { placeholder: "<Attachment>" }),
			)

			let noDisplayIfSameGuildSwitch = new Switch("Don't display Guild icon, if in same Guild", "If you are currently in the same Guild as the message from the link, the icon of the Guild will not be displayed.", this.settings.noDisplayIfSameGuild, (i) => {
				this.settings.noDisplayIfSameGuild = i;
			})
			noDisplayIfSameGuildSwitch.inputWrapper.className += " betterMessageLinks Settings noDisplayIfSameGuildSwitch"



			let spinnerRadio = new RadioGroup('Spinner', "Choose the spinner that gets displayed when the message is loading", this.settings.spinner || 0, spinnerSetting, (i) => {
				this.settings.spinner = i;
			})
			spinnerRadio.inputWrapper.className += " betterMessageLinks Settings Spinner";

			let animationRadio = new RadioGroup('Popup Animation', "Choose the animation type when the popoup get's opened.", this.settings.animationType || "TRANSLATE", animationSetting, (i) => {
				this.settings.animationType = i;
			})
			animationRadio.inputWrapper.className += " betterMessageLinks Settings Animation";

			let appearanceSettingsGroup = new SettingGroup("Appearance").append(
				new Switch("Show Author icon", "Display the icon of the Message Author.", this.settings.showAuthorIcon, (i) => {
					this.settings.showAuthorIcon = i;
				}),
				new Switch("Show Guild icon", "Display the guild icon of the message next to the author icon if you aren't in the same guild as the linked message.", this.settings.showGuildIcon, (i) => {
					this.settings.showGuildIcon = i;
					this.updateSettingsCSS();
				}),
				noDisplayIfSameGuildSwitch,
				new Switch("Show progress bar", "Display a circular progress bar when loading a message.", this.settings.progressBar, (i) => {
					this.settings.progressBar = i;
				}),
				new Switch("Style as mention", "Choose if the link should be styled like a mention (Otherwhise it will be styled like a link).", this.settings.mentionStyle, (i) => {
					this.settings.mentionStyle = i;
				}),
				spinnerRadio,
				animationRadio,
				new Textbox("Advanced link footer", React.createElement("div", {}, "Add a footer to the popout containing information about the message. Use $value to display specific values. Valid values: ", unorderedList), this.settings.advancedFooter, (i) => {
					this.settings.advancedFooter = i;
				}),
			)

			messageReplaceGroup.group.className += " betterMessageLinks SettingsGroup Message";
			attachmentReplaceGroup.group.className += " betterMessageLinks SettingsGroup Attachment";
			appearanceSettingsGroup.group.className += " betterMessageLinks SettingsGroup Appearance";

			this.updateSettingsCSS()
			//build the settings panel
			return SettingPanel.build(() => this.saveSettings(this.settings),
				new Switch("Ignore message links", "Message links will not get replaced or have a preview.", this.settings.ignoreMessage, (i) => {
					this.settings.ignoreMessage = i;
					this.updateSettingsCSS()
				}),
				new Switch("Ignore attachment links", "Attachment links will not get replaced or have a preview. (Recommended when using HideEmbedLink for example)", this.settings.ignoreAttachment, (i) => {
					this.settings.ignoreAttachment = i;
					this.updateSettingsCSS()
				}),
				messageReplaceGroup,
				attachmentReplaceGroup,
				appearanceSettingsGroup,
			)

		}
		updateSettingsCSS() {
			let hideArray = [];
			if (this.settings.ignoreMessage && this.settings.ignoreAttachment) {
				hideArray.push("SettingsGroup");
			}
			else if (this.settings.ignoreMessage) {
				hideArray.push("SettingsGroup.Message");
			}
			else if (this.settings.ignoreAttachment) {
				hideArray.push("SettingsGroup.Attachment");
			}
			if (!this.settings.showGuildIcon) {
				hideArray.push("Settings.noDisplayIfSameGuildSwitch");
			}
			let hideCss = hideArray.length > 0 ? hideArray.map(e => `.betterMessageLinks.${e}`).join(", ") + " {display:none;}" : "";
			BdApi.injectCSS(config.info.name, customCSS + hideCss)
		}


		onStop() {
			BdApi.clearCSS(config.info.name)
			Patcher.unpatchAll(config.info.name);
		}

	}
})(global.ZeresPluginLibrary.buildPlugin(config));
