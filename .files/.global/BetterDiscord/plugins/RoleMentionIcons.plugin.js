/**
 * @name RoleMentionIcons
 * @author Neodymium
 * @version 1.1.0
 * @description Displays icons next to role mentions.
 * @source https://github.com/Neodymium7/BetterDiscordStuff/blob/main/RoleMentionIcons/RoleMentionIcons.plugin.js
 * @updateUrl https://raw.githubusercontent.com/Neodymium7/BetterDiscordStuff/main/RoleMentionIcons/RoleMentionIcons.plugin.js
 */
/*@cc_on
@if (@_jscript)
    
    // Offer to self-install for clueless users that try to run this directly.
    var shell = WScript.CreateObject("WScript.Shell");
    var fs = new ActiveXObject("Scripting.FileSystemObject");
    var pathPlugins = shell.ExpandEnvironmentStrings("%APPDATA%\\BetterDiscord\\plugins");
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
    const config = {
        "info": {
            "name": "RoleMentionIcons",
            "authors": [
                {
                    "name": "Neodymium"
                }
            ],
            "version": "1.1.0",
            "description": "Displays icons next to role mentions.",
            "github": "https://github.com/Neodymium7/BetterDiscordStuff/blob/main/RoleMentionIcons/RoleMentionIcons.plugin.js",
            "github_raw": "https://raw.githubusercontent.com/Neodymium7/BetterDiscordStuff/main/RoleMentionIcons/RoleMentionIcons.plugin.js"
        },
        "changelog": [
            { "title": "Added", "type": "improved", "items": ["Added support for Role Icons (Thanks HypedDomi for the contribution!)"] },
        ],
        "main": "index.js"
    };

    return !global.ZeresPluginLibrary ? class {
        constructor() { this._config = config; }
        getName() { return config.info.name; }
        getAuthor() { return config.info.authors.map(a => a.name).join(", "); }
        getDescription() { return config.info.description; }
        getVersion() { return config.info.version; }
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
        start() { }
        stop() { }
    } : (([Plugin, Api]) => {
        const plugin = (Plugin, Library) => {
            const { DiscordModules, Settings } = Library;
            const { SettingPanel, Switch } = Settings;
            const People = BdApi.findModuleByDisplayName("People");
            const RoleMention = BdApi.findModule(m => m?.default.displayName === "RoleMention");
            const GuildStore = DiscordModules.GuildStore;

            // From https://github.com/rauenzi/BetterDiscordAddons/blob/692abbd1877ff6d837dc8a606767d019e52ebe23/Plugins/RoleMembers/RoleMembers.plugin.js#L60-L61
            const from = arr => arr && arr.length > 0 && Object.assign(...arr.map(([k, v]) => ({ [k]: v })));
            const filter = (obj, predicate) => from(Object.entries(obj).filter((o) => { return predicate(o[1]); }));

            return class RoleMentionIcons extends Plugin {
                constructor() {
                    super();
                    this.defaultSettings = {
                        everyone: true,
                        here: true,
                        showRoleIcons: true
                    };
                }

                onStart() {
                    BdApi.injectCSS("RoleMentionIcons", `
                        .role-mention-icon {
                            position: relative;
                            top: 2px;
                            margin-left: 4px;
                        }`);
                    BdApi.Patcher.after("RoleMentionIcons", RoleMention, "default", (_, [props], ret) => {
                        const isEveryone = props.roleName === "@everyone";
                        const isHere = props.roleName === "@here";
                        let role = filter(GuildStore.getGuild(props.guildId)?.roles, r => r.id === props.roleId);
                        role = role[Object.keys(role)[0]];
                        if (!props.children.some(child => child.props?.class === "role-mention-icon") && (this.settings.everyone || !isEveryone) && (this.settings.here || !isHere)) {
                            if (role?.icon && this.settings.showRoleIcons) props.children.push(BdApi.React.createElement("img", { "class": "role-mention-icon", style: { width: 14, height: 14, borderRadius: "3px", objectFit: "contain" }, src: `https://cdn.discordapp.com/role-icons/${role.id}/${role?.icon}.webp?size=24&quality=lossless` }));
                            else props.children.push(BdApi.React.createElement(People, { "class": "role-mention-icon", width: 14, height: 14 }));
                        }
                    });
                }

                onStop() {
                    BdApi.Patcher.unpatchAll("RoleMentionIcons");
                    BdApi.clearCSS("RoleMentionIcons");
                }

                getSettingsPanel() {
                    return SettingPanel.build(this.saveSettings.bind(this),
                        new Switch("@everyone", "Shows icons on \"@everyone\" mentions.", this.settings.everyone, (i) => { this.settings.everyone = i; }),
                        new Switch("@here", "Shows icons on \"@here\" mentions.", this.settings.here, (i) => { this.settings.here = i; }),
                        new Switch("Role Icons", "Shows Role Icons instead of default icon when applicable.", this.settings.showRoleIcons, (i) => { this.settings.showRoleIcons = i; })
                    );
                }

            };

        };
        return plugin(Plugin, Api);
    })(global.ZeresPluginLibrary.buildPlugin(config));
})();
/*@end@*/
