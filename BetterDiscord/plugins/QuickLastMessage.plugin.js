/**
 * @name QuickLastMessage
 * @invite undefined
 * @authorLink undefined
 * @donate undefined
 * @patreon undefined
 * @website https://github.com/vBread/bd-contributions/tree/master/QuickLastMessage
 * @source https://github.com/vBread/bd-contributions/blob/master/QuickLastMessage/QuickLastMessage.plugin.js
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

module.exports = (() => {
    const config = {"main":"index.js","info":{"name":"QuickLastMessage","authors":[{"name":"Bread","discord_id":"304260051915374603","github_username":"vBread"}],"version":"1.0.2","description":"Quickly access your last message by pressing the down arrow","github":"https://github.com/vBread/bd-contributions/tree/master/QuickLastMessage","github_raw":"https://github.com/vBread/bd-contributions/blob/master/QuickLastMessage/QuickLastMessage.plugin.js"},"changelog":[{"title":"Fix","type":"fixed","items":["Disable the ALT key from triggering the plugin"]}]};

    return !global.ZeresPluginLibrary ? class {
        constructor() {this._config = config;}
        getName() {return config.info.name;}
        getAuthor() {return config.info.authors.map(a => a.name).join(", ");}
        getDescription() {return config.info.description;}
        getVersion() {return config.info.version;}
        load() {
            BdApi.showConfirmationModal("Library Missing", `The library plugin needed for ${config.info.name} is missing. Please click Download Now to install it.`, {
                confirmText: "Download Now",
                cancelText: "Cancel",
                onConfirm: () => {
                    require("request").get("https://rauenzi.github.io/BDPluginLibrary/release/0PluginLibrary.plugin.js", async (error, response, body) => {
                        if (error) return require("electron").shell.openExternal("https://betterdiscord.net/ghdl?url=https://raw.githubusercontent.com/rauenzi/BDPluginLibrary/master/release/0PluginLibrary.plugin.js");
                        await new Promise(r => require("fs").writeFile(require("path").join(BdApi.Plugins.folder, "0PluginLibrary.plugin.js"), body, r));
                    });
                }
            });
        }
        start() {}
        stop() {}
    } : (([Plugin, Api]) => {
        const plugin = (Plugin, Library) => {
	const { WebpackModules, DiscordModules } = Library

	return class QuickLastMessage extends Plugin {
		constructor() {
			super()

			this.active = true
		}

		onStart() {
			const { getMessages } = DiscordModules.MessageStore
			const { getCurrentUser } = DiscordModules.UserStore

			const { getChannelId } = WebpackModules.getByProps('getChannelId')
			const { ComponentDispatch } = WebpackModules.getByProps('ComponentDispatch')

			document.addEventListener('keydown', (event) => {
				if (!this.active || event.ctrlKey || event.altKey) return;

				if (event.key === 'ArrowDown') {
					let message;

					getMessages(getChannelId()).toArray().map((msg) => {
						if (msg.content.trim() && msg.author.id === getCurrentUser().id) {
							message = msg
						}
					})

					const { textContent } = document.querySelector("div[class*='slateTextArea']").childNodes[0].childNodes[0]
					const role = document.activeElement.getAttribute('role')

					if (!textContent.trim().length && message && role === 'textbox') {
						ComponentDispatch.dispatchToLastSubscribed('INSERT_TEXT', {
							content: message.content.trim()
						})
					}
				}
			})
		}

		onStop() {
			this.active = false
		}
	}
};
        return plugin(Plugin, Api);
    })(global.ZeresPluginLibrary.buildPlugin(config));
})();
/*@end@*/