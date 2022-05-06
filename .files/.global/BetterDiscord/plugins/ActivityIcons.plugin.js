/**
 * @name ActivityIcons
 * @author Neodymium
 * @version 1.2.5
 * @description Improves the default icons next to statuses
 * @source https://github.com/Neodymium7/BetterDiscordStuff/blob/main/ActivityIcons/ActivityIcons.plugin.js
 * @updateUrl https://raw.githubusercontent.com/Neodymium7/BetterDiscordStuff/main/ActivityIcons/ActivityIcons.plugin.js
 * @invite fRbsqH87Av
 */

module.exports = (() => {
    const config = {
        "info": {
            "name": "ActivityIcons",
            "authors": [
                {
                    "name": "Neodymium"
                }
            ],
            "version": "1.2.5",
            "description": "Improves the default icons next to statuses",
            "github": "https://github.com/Neodymium7/BetterDiscordStuff/blob/main/ActivityIcons/ActivityIcons.plugin.js",
            "github_raw": " https://raw.githubusercontent.com/Neodymium7/BetterDiscordStuff/main/ActivityIcons/ActivityIcons.plugin.js"
        },
        "changelog": [
            {"title": "Fixed", "type": "fixed", "items": ["Fixed icons not immediately appearing on Discord startup"]},
        ]
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
        start() {}
        stop() {}
    } : (([Plugin, Api]) => {
        const plugin = (Plugin, Library) => {

            const { ReactTools, DiscordSelectors } = Library;
            const { Dropdown, SettingPanel } = Library.Settings;

            const Activity = BdApi.findModuleByDisplayName("Activity");
            const Headset = BdApi.findModuleByDisplayName("Headset");
            const RichActivity = BdApi.findModuleByDisplayName("RichActivity");
            const TooltipContainer = BdApi.findModuleByProps("TooltipContainer").TooltipContainer;

            const bot = ["created_at", "id", "name", "type", "url"];
            const peopleListItem = `.${BdApi.findModuleByProps("peopleListItem").peopleListItem}`;
            const memberListItem = `${DiscordSelectors.MemberList.members} > div > div:not(:first-child)`;
            const privateChannel = `.${BdApi.findModuleByProps("privateChannelsHeaderContainer").scroller} > ul > li`;

            return class ActivityIcons extends Plugin {
                constructor() {
                    super();
                    this.defaultSettings = {
                        normalIconBehavior: 0
                    };
                }
            
                onStart() {
                    BdApi.injectCSS("ActivityIcons", `
                    .activity-icon {
                        width: 16px;
                        height: 16px;
                        margin-left: 4px;
                        -webkit-box-flex: 0;
                        flex: 0 0 auto;
                    }
                    .activity-icon-small {
                        margin: 1px;
                    }
                    .rich-activity-icon {
                        margin-left: 2px;
                        margin-right: -2px;
                    }
                    .activity-icon > div {
                        width: inherit;
                        height: inherit;
                    }`);
                    BdApi.Patcher.after("ActivityIcons", BdApi.findModule(m => "ActivityStatus" === m.default.displayName), "default", (_, [props], ret) => {
                        if (props.activities && ret) {
                            if (props.activities.length === 1 && props.activities[0].type === 0 && Object.keys(props.activities[0]).every((value, i) => value === bot[i])) return;

                            const normalActivities = props.activities.filter(activity => activity.type === 0);
                            const listeningActivity = props.activities.filter(activity => activity.type === 2)[0];
                            const streaming = props.activities.some(activity => activity.type === 1);
                            const customStatus = props.activities.some(activity => activity.type === 4 && activity.state);
                            const hasRP = normalActivities.some(activity => ((activity.assets || activity.details) && !activity.platform));
                            const onPS = normalActivities.some(activity => activity.platform === "ps5" || activity.platform === "ps4");
                            const onXbox = normalActivities.some(activity => activity.platform === "xbox");

                            let tooltip;
                            if (normalActivities.length === 1 && customStatus) {
                                tooltip = BdApi.React.createElement("strong", {}, normalActivities[0].name);
                            } else if (normalActivities.length === 2) {
                                tooltip = [BdApi.React.createElement("strong", {}, normalActivities[0].name), " and ", BdApi.React.createElement("strong", {}, normalActivities[1].name)];
                            } else if (normalActivities.length === 3) {
                                tooltip = [BdApi.React.createElement("strong", {}, normalActivities[0].name), ", ", BdApi.React.createElement("strong", {}, normalActivities[1].name), ", and ", BdApi.React.createElement("strong", {}, normalActivities[2].name)] ;
                            } else if (normalActivities.length > 3) {
                                tooltip = [BdApi.React.createElement("strong", {}, normalActivities[0].name), ", ", BdApi.React.createElement("strong", {}, normalActivities[1].name), `, and ${normalActivities.length - 2} more`];
                            }
                        
                            if (hasRP || listeningActivity || streaming) ret.props.children.splice(2, 1);
                            if (normalActivities.length > 0 && /* Check for settings */ ((this.settings.normalIconBehavior === 0) || (hasRP||onPS||onXbox || (this.settings.normalIconBehavior === 1 && !hasRP && customStatus)) || (this.settings.normalIconBehavior === 2 && (hasRP||onPS||onXbox)))) {
                                let icon = BdApi.React.createElement(Activity, {width: "16", height: "16"});
                                if (onPS) icon = BdApi.React.createElement("svg", {"class": "activity-icon-small", width: "14", height: "14", viewBox: "0 0 24 24", fill: "none", xmlns: "http://www.w3.org/2000/svg"}, BdApi.React.createElement("path", { "fill-rule": "evenodd", "clip-rule": "evenodd", d: "M23.6687 17.1554C23.2046 17.741 22.0675 18.1587 22.0675 18.1587L13.6085 21.1971V18.9563L19.8337 16.7383C20.5402 16.4851 20.6486 16.1273 20.0744 15.9395C19.5013 15.7512 18.4635 15.8052 17.7565 16.0593L13.6085 17.5203V15.1948L13.8476 15.1138C13.8476 15.1138 15.0462 14.6896 16.7317 14.5029C18.4171 14.3173 20.4808 14.5283 22.1009 15.1424C23.9267 15.7193 24.1323 16.5699 23.6687 17.1554ZM14.4137 13.3399V7.60959C14.4137 6.93661 14.2896 6.31705 13.6582 6.14166C13.1746 5.98677 12.8746 6.43578 12.8746 7.10822V21.4583L9.00453 20.23V3.12C10.65 3.42545 13.0473 4.14754 14.336 4.58199C17.6135 5.70722 18.7247 7.10768 18.7247 10.2632C18.7247 13.3388 16.8261 14.5045 14.4137 13.3399ZM1.90344 18.7221C0.0291303 18.1943 -0.282804 17.0944 0.571508 16.4609C1.36106 15.8758 2.70378 15.4355 2.70378 15.4355L8.25276 13.4624V15.7118L4.25967 17.1409C3.55431 17.394 3.44584 17.7523 4.01898 17.9401C4.59266 18.1279 5.631 18.0745 6.33744 17.8209L8.25276 17.1257V19.1382C8.13133 19.1598 7.99587 19.1814 7.87067 19.2024C5.95481 19.5154 3.91428 19.3848 1.90344 18.7221Z", fill: "currentColor" }));
                                if (onXbox) icon = BdApi.React.createElement("svg", {"class": "activity-icon-small", width: "14", height: "14", viewBox: "0 0 24 24", fill: "none", xmlns: "http://www.w3.org/2000/svg"}, BdApi.React.createElement("path", { "fill-rule": "evenodd", "clip-rule": "evenodd", d: "M11.0044 21.9585C9.46481 21.8119 7.90517 21.2589 6.56358 20.3839C5.44002 19.651 5.18638 19.3512 5.18638 18.7493C5.18638 17.5434 6.51463 15.4292 8.784 13.0218C10.0744 11.6537 11.8699 10.0503 12.0635 10.0925C12.4417 10.1769 15.4608 13.1217 16.5911 14.5053C18.3799 16.6995 19.2031 18.4939 18.7848 19.2935C18.4666 19.902 16.4976 21.0901 15.0515 21.5454C13.8589 21.9229 12.2926 22.0828 11.0044 21.9585ZM3.67125 17.4968C2.73903 16.0666 2.26736 14.6563 2.03819 12.6198C1.96255 11.9469 1.98925 11.5627 2.20951 10.1813C2.48317 8.46017 3.46211 6.47029 4.64129 5.24439C5.14411 4.72249 5.18861 4.70916 5.80045 4.9157C6.54355 5.16666 7.33561 5.71299 8.56596 6.82563L9.28459 7.47412L8.89302 7.95604C7.07085 10.1902 5.15079 13.3571 4.4277 15.3159C4.0339 16.3797 3.87594 17.4502 4.04503 17.8943C4.15849 18.1941 4.05393 18.0831 3.67125 17.4968ZM20.0463 17.7389C20.1375 17.2902 20.0218 16.4641 19.7482 15.6313C19.1586 13.828 17.1807 10.47 15.3652 8.18923L14.7934 7.47189L15.4119 6.90336C16.2195 6.1616 16.7802 5.71743 17.3853 5.3421C17.8637 5.04451 18.5445 4.78245 18.8382 4.78245C19.0184 4.78245 19.6547 5.44204 20.1687 6.16382C20.9652 7.27868 21.5503 8.6334 21.8462 10.0414C22.0375 10.952 22.0531 12.8996 21.8774 13.8057C21.7327 14.5497 21.4257 15.5158 21.1276 16.1732C20.9029 16.664 20.3466 17.6167 20.1019 17.9276C19.9773 18.0831 19.9773 18.0831 20.0463 17.7389ZM11.1691 4.44044C10.3303 4.01404 9.03763 3.55877 8.32345 3.4344C8.07204 3.3922 7.64709 3.36777 7.37343 3.3811C6.78384 3.40997 6.81054 3.3811 7.75611 2.93471C8.54149 2.56383 9.19782 2.34618 10.0878 2.15963C11.089 1.94865 12.969 1.94643 13.9546 2.15519C15.0181 2.3795 16.2707 2.84587 16.976 3.27894L17.1851 3.40775L16.7045 3.38332C15.7478 3.33446 14.3551 3.72089 12.8577 4.44932C12.4061 4.66919 12.0145 4.84463 11.9856 4.83797C11.9589 4.83353 11.5896 4.65364 11.1691 4.44044Z", fill: "currentColor" }));
                                if (hasRP) icon = BdApi.React.createElement(RichActivity, {width: "16", height: "16"});
                            
                                let wrapper = BdApi.React.createElement("div", {"class": "activity-icon"}, icon);
                                if (tooltip && hasRP) wrapper = BdApi.React.createElement("div", {"class": "activity-icon rich-activity-icon"}, BdApi.React.createElement(TooltipContainer, {text: tooltip, position: "top"}, icon));
                                else if (hasRP) wrapper = BdApi.React.createElement("div", {"class": "activity-icon rich-activity-icon"}, icon);
                                else if (tooltip) wrapper = BdApi.React.createElement("div", {"class": "activity-icon"}, BdApi.React.createElement(TooltipContainer, {text: tooltip, position: "top"}, icon));
                            
                                ret.props.children.push(wrapper);
                            }
                            if (listeningActivity) {
                                const listeningWrapper = BdApi.React.createElement("div", {"class": "activity-icon"}, BdApi.React.createElement(TooltipContainer, {text: [BdApi.React.createElement("div", {style: {"font-weight": "600"}}, listeningActivity.details), listeningActivity.state && BdApi.React.createElement("div", {style: {"font-weight": "400"}}, `by ${listeningActivity.state.replace(/;/g, ",")}`)], position: "top"}, BdApi.React.createElement(Headset, {"class": "activity-icon-small", width: "14", height: "14"})));
                                ret.props.children.push(listeningWrapper);
                            }
                        }
                    });
                    document.querySelectorAll(memberListItem).forEach(node => ReactTools.getReactInstance(node).return.return.return.return.stateNode.forceUpdate());
                    document.querySelectorAll(peopleListItem).forEach(node => ReactTools.getReactInstance(node).return.return.return.return.stateNode.forceUpdate());
                    document.querySelectorAll(privateChannel).forEach(node => ReactTools.getReactInstance(node).return.return.return.return.stateNode?.forceUpdate());
                };
            
                onStop() {
                    BdApi.Patcher.unpatchAll("ActivityIcons");
                    BdApi.clearCSS("ActivityIcons");
                    document.querySelectorAll(memberListItem).forEach(node => ReactTools.getReactInstance(node).return.return.return.return.stateNode.forceUpdate());
                    document.querySelectorAll(peopleListItem).forEach(node => ReactTools.getReactInstance(node).return.return.return.return.stateNode.forceUpdate());
                    document.querySelectorAll(privateChannel).forEach(node => ReactTools.getReactInstance(node).return.return.return.return.stateNode?.forceUpdate());
                };
            
                getSettingsPanel() {
                    return SettingPanel.build(this.saveSettings.bind(this),
                        new Dropdown("Normal Activity Icon Behavior", "Conditions under which normal activity icon (game controller) will be displayed", this.settings.normalIconBehavior, [
                            {label: "Normal Activity (Default)", value: 0},
                            {label: "Custom Status and Normal Activity", value: 1},
                            {label: "Never", value: 2}
                        ], i => {this.settings.normalIconBehavior = i;}),
	        		);
                }
            
            };

        };
        return plugin(Plugin, Api);
    })(global.ZeresPluginLibrary.buildPlugin(config));
})();
/*@end@*/