/**
 * @name UrbanDictionary
 * @author AGreenPig
 * @updateUrl https://raw.githubusercontent.com/TheGreenPig/BetterDiscordPlugins/main/UrbanDictionary/UrbanDictionary.plugin.js
 * @authorLink https://github.com/TheGreenPig
 * @source https://github.com/TheGreenPig/BetterDiscordPlugins/main/UrbanDictionary/UrbanDictionary.plugin.js
 */
const config = {
	"info": {
		"name": "UrbanDictionary",
		"authors": [{
			"name": "AGreenPig",
			"discord_id": "427179231164760066",
			"github_username": "TheGreenPig"
		}],
		"version": "1.1.0",
		"description": "Display word definitions  by Urban Dictionary. Select a word, right click and press Urban Dictionary to see its definition!",
		"github_raw": "https://raw.githubusercontent.com/TheGreenPig/BetterDiscordPlugins/main/UrbanDictionary/UrbanDictionary.plugin.js"
	},
	"changelog": [
		{
			"title": "Fixed",
			"type": "fixed",
			"items": [
				"Fixed context menu",
			]
		},
	],
}
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
	const customCSS = `
	.UrbanD-Word {
		clear: left;
		color: var(--header-primary);
		font-size: 1.3em;
		text-align: center;
		font-weight: bold;
		text-decoration: underline;
	}
	.UrbanD-Title {
		font-weight: 600;
		color: var(--text-normal);
		font-size: 1.1em;
	}
	.UrbanD-Text {
		color: var(--text-normal);
		padding-bottom: 15px;
	}
	.UrbanD-Image {
		float: left;
		margin-bottom: 30;
	}
	.UrbanD-Info {
		color: var(--text-normal);
		font-size: 0.9em;
		padding-top: 15px;
	}
	.UrbanD-Likes {
		font-weight: bold;
	}
	.UrbanD-Author {
		font-weight: bold;
	}
	.UrbanD-Date {
		color: var(--text-muted);
		font-size: 0.8em;
	}
	.UrbanD-Wrapper {
		-webkit-user-select: text;
	}
	.UrbanD-Definition {
		background-color: var(--background-secondary);
		border-radius: 15px;
		padding: 10px;
		margin-top: 20px;
	}
	`
	const { Toasts, WebpackModules, DCM, Patcher, React, Settings,Logger } = { ...Library, ...BdApi };
	const { SettingPanel, Switch, Slider, RadioGroup } = Settings;

	const MessageContextMenu = lazyLoadingSmasher9000("MessageContextMenu");
	const SlateTextAreaContextMenu = lazyLoadingSmasher9000("SlateTextAreaContextMenu");

	//credits to Strencher
	function lazyLoadingSmasher9000(displayName) {
		return new Promise(resolve => {
			const cached = WebpackModules.getModule(m => m && m.default && m.default.displayName === displayName);
			if (cached) return resolve(cached);
			const unsubscribe = WebpackModules.addListener(module => {
			  if (!module.default || module.default.displayName !== displayName) return;
			  unsubscribe();
			  resolve(module);
			});
		  });
	}
	let profanityArray = [];

	const profanityOptions = [
		{
			name: 'None',
			desc: 'No profanity filter.',
			value: 0
		},
		{
			name: 'Small',
			desc: 'About 450 words from https://raw.githubusercontent.com/web-mech/badwords/master/lib/lang.json',
			value: 1
		},
		{
			name: 'Large',
			desc: '(Recommended) About 2800 words from https://raw.githubusercontent.com/zacanger/profane-words/master/words.json',
			value: 2
		},
		{
			name: 'External Api',
			desc: `Uses the https://www.purgomalum.com/ api. Probably the best filter, but is not local and rather slow. This filter is not local, I do not have any control over this Api, use it carefully.`,
			value: 3
		}
	]
	return class UrbanDictionary extends Plugin {
		async onStart() {
			this.settings = this.loadSettings({ profanity: true, showAmount: 4, filter: 2 });
			profanityArray = await this.updateProfanityArray(this.settings.filter);

			BdApi.injectCSS(config.info.name, customCSS)

			Patcher.after(config.info.name, await MessageContextMenu, "default", (_, __, ret) => {
				console.log(ret);
				ret.props.children.push(this.getContextMenuItem())
			})

			Patcher.after(config.info.name, await SlateTextAreaContextMenu, "default", (_, __, ret) => {
				ret.props.children.push(this.getContextMenuItem())
			})
		}
		getContextMenuItem() {
			let selection = window.getSelection().toString().trim();
			if (selection === "") { return; }
			let word = selection.charAt(0).toUpperCase() + selection.slice(1);
			let obj = {};
			let ContextMenuItem = DCM.buildMenuItem({
				label: "Urban Dictionary",
				type: "text",
				action: () => {
					Logger.log(`Fetching "${word}"...`);
					fetch(`https://api.urbandictionary.com/v0/define?term=${word.toLocaleLowerCase()}`)
						.then(data => { return data.json() })
						.then(res => {
							Logger.log(`Denifitions of "${word}" fetched.`)
							this.processDefinitions(word, res);
						})
				}
			})
			return ContextMenuItem;

		}
		async processDefinitions(word, res) {
			if (this.settings.filter !== 0) {
				let wordHasProfanity = await this.containsProfanity(word);
				if (wordHasProfanity) {
					BdApi.alert("That's a bad word!", "Turn off your profanity filter to view this words definition!");
					return;
				}
			}

			if (res?.list?.length === 0) {
				BdApi.alert("No definiton found!", React.createElement("div", { class: "markdown-19oyJN paragraph-9M861H" }, `Couldn't find `, React.createElement("span", { style: { fontWeight: "bold" } }, `"${word}"`), ` on Urban dictionary.`));//
				return;
			}

			let definitionElement = [];
			res.list.sort(function (a, b) {
				return b.thumbs_up - a.thumbs_up;
			})
			for (let i = 0; i < res.list.length && i < this.settings.showAmount; i++) {
				let definitionBlob = res.list[i];

				let definition = definitionBlob.definition.replace(/[\[\]]/g, "");
				let example = definitionBlob.example.replace(/[\[\]]/g, "");
				let likes = definitionBlob.thumbs_up.toString();
				let dislikes = definitionBlob.thumbs_down.toString();
				let author = definitionBlob.author;
				let date = new Date(definitionBlob.written_on).toLocaleString();
				if (this.settings.filter !== 0) {
					definition = await this.filterText(definition);
					example = await this.filterText(example);
				}

				definitionElement.push(React.createElement("div", { class: "UrbanD-Definition" },
					React.createElement("div", { class: "UrbanD-Title" }, "Definition:"),
					React.createElement("div", { class: "UrbanD-Text" }, definition),
					React.createElement("div", { class: "UrbanD-Title" }, "Example:"),
					React.createElement("div", { class: "UrbanD-Text" }, example),
					React.createElement("div", { class: "UrbanD-Info" },
						"Likes: ", React.createElement("span", { class: "UrbanD-Likes" }, likes),
						", Dislikes: ", React.createElement("span", { class: "UrbanD-Likes" }, dislikes),
						", written by ", React.createElement("span", { class: "UrbanD-Author" }, author)),
					React.createElement("div", { class: "UrbanD-Date" }, date),
				))
			}

			BdApi.alert("",
				React.createElement("div", { class: "UrbanD-Wrapper" },
					React.createElement("a", { href: "https://www.urbandictionary.com/", target: "_blank" }, React.createElement("img", { class: "UrbanD-Image", src: "https://raw.githubusercontent.com/TheGreenPig/BetterDiscordPlugins/main/UrbanDictionary/UD_logo.svg", width: "100" }),),
					React.createElement("a", { href: `https://www.urbandictionary.com/define.php?term=${word}`, target: "_blank" }, React.createElement("div", { class: "UrbanD-Word" }, word)),
					definitionElement
				)
			)
		}
		async containsProfanity(text) {
			if (this.settings.filter === 3) {
				return await fetch(`https://www.purgomalum.com/service/containsprofanity?text=${text}`)
					.then(data => {
						return data.json()
					})
					.then(res => {
						return res;
					})
			}

			text = text.toLowerCase()
			let wordArray = text.match(/\w+/gi);
			let hasProfanity = false;
			wordArray.forEach(word => {
				if(profanityArray.includes(word)) {
					hasProfanity = true;
				}
			})
			return hasProfanity;
		}
		async filterText(text) {
			if (this.settings.filter === 3) {
				return await fetch(`https://www.purgomalum.com/service/plain?text=${text}`)
					.then(data => {
						return data.text()
					})
					.then(res => {
						return res;
					})
			}
			let wordArray = text.match(/\w+/gi);
			let newText = text;
			wordArray.forEach(word => {
				if(profanityArray.includes(word.toLowerCase())) {
					newText = newText.replace(word, "*".repeat(word.length));
				}
			})
			return newText;
		}
		async updateProfanityArray(option) {
			let url;
			switch (option) {
				case 3: case 0:
					profanityArray = [];
					return;
				case 1:
					url = "https://raw.githubusercontent.com/web-mech/badwords/master/lib/lang.json";
					break;
				case 2:
					url = "https://raw.githubusercontent.com/zacanger/profane-words/master/words.json";
					break;
			}
			fetch(url)
				.then(data => {
					return data.json()
				})
				.then(res => {
					profanityArray = res.words ? res.words : res;
				})
		}
		getSettingsPanel() {
			return SettingPanel.build(() => this.saveSettings(this.settings),
				new RadioGroup('Filter', `Choose if you want to turn on a profanity filter. The pop-up might take longer until it's displayed. Not all filters are perfect, you might still see text that is NSFW.`, this.settings.filter || 0, profanityOptions, (i) => {
					this.settings.filter = i;
					profanityArray = this.updateProfanityArray(i);
				}),
				new Slider("Amount of definitions", "Defines how many definitions of the word you want to get displayed. More definitions will take longer to load (especially with the Profanity Filter turned on).", 1, 10, this.settings.showAmount, (i) => {
					this.settings.showAmount = i;
				}, { markers: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], stickToMarkers: true }),
			)

		}
		onStop() {
			BdApi.clearCSS(config.info.name)
			Patcher.unpatchAll(config.info.name);
		}

	}
})(global.ZeresPluginLibrary.buildPlugin(config));
