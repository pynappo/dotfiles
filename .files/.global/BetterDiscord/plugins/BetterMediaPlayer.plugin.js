/**
 * @name BetterMediaPlayer
 * @displayName BetterMediaPlayer
 * @author unknown81311_&_Doggybootsy
 * @authorLink https://betterdiscord.app/plugin?id=377
 * @source https://github.com/unknown81311/BetterMediaPlayer
 * @updateUrl https://raw.githubusercontent.com/unknown81311/BetterMediaPlayer/main/BetterMediaPlayer.plugin.js
 * @invite yYJA3qQE5F
 */

/*@cc_on
@if (@_jscript)
    // Offer to self-install for clueless users that try to run this directly.
    var shell = WScript.CreateObject("WScript.Shell")
    var fs = new ActiveXObject("Scripting.FileSystemObject")
    var pathPlugins = shell.ExpandEnvironmentStrings("%APPDATA%\BetterDiscord\plugins")
    var pathSelf = WScript.ScriptFullName
    // Put the user at ease by addressing them in the first person
    shell.Popup("It looks like you've mistakenly tried to run me directly. \n(Don't do that!)", 0, "I'm a plugin for BetterDiscord", 0x30)
    if (fs.GetParentFolderName(pathSelf) === fs.GetAbsolutePathName(pathPlugins)) {
        shell.Popup("I'm in the correct folder already.", 0, "I'm already installed", 0x40)
    } else if (!fs.FolderExists(pathPlugins)) {
        shell.Popup("I can't find the BetterDiscord plugins folder.\nAre you sure it's even installed?", 0, "Can't install myself", 0x10)
    } else if (shell.Popup("Should I copy myself to BetterDiscord's plugins folder for you?", 0, "Do you need some help?", 0x34) === 6) {
        fs.CopyFile(pathSelf, fs.BuildPath(pathPlugins, fs.GetFileName(pathSelf)), true)
        // Show the user where to put plugins in the future
        shell.Exec("explorer " + pathPlugins)
        shell.Popup("I'm installed!", 0, "Successfully installed", 0x40)
    }
    WScript.Quit()
@else@*/
module.exports = (() => {
    const config = {
        info: {
            name: "Better  Media Player",
            authors: [
                {
                    name: "unknown81311",
                    discord_id: "359174224809689089",
                    github_username: "unknown81311"
                },
                {
                    name: "Doggybootsy",
                    discord_id: "515780151791976453",
                    github_username: "Doggybootsy"
                }
            ],
            version: "1.2.4",
            description: "Add more features to the media player in discord",
            github: "https://github.com/unknown81311/BetterMediaPlayer",
            github_raw: "https://raw.githubusercontent.com/unknown81311/BetterMediaPlayer/main/BetterMediaPlayer.plugin.js"
        },
        changelog: [
            {
                title: "Removed",
                type: "improved",
                items: ["Observer has been fully removed", "They attempt to add a way to skip videos"]
            },
            {
                title: "Added",
                type: "added",
                items: ["A slider to change the darkness of the videos control bar", "A button to refresh the video in settings"]
            }
        ],
        defaultConfig: [
            {
                type: "video", 
                name: "Preview",
                note: "If the demo doesnt update just click the button saying \"Change video\""
            },
            {
                type: "category",
                id: "category_Loop",
                name: "Loop button",
                collapsible: true,
                shown: false,
                settings: [
                    {
                        type: "switch",
                        id: "button_loop",
                        name: "Add a Loop button",
                        note: "Loop videos in a simple click",
                        value: true,
                    },
                    {
                        type: "slider",
                        id: "position_loop",
                        name: "Position for loop",
                        note: "Move the loop button to different spots",
                        value: 1,
                        markers: [0, 1, 2, 3, 4, 5],
                        stickToMarkers: true
                    },
                    {
                        type: "switch",
                        id: "auto_loop",
                        name: "Automatically loop videos",
                        note: "Loop videos w/o clicking a button",
                        value: true
                    }
                ]
            },
            {
                type: "category",
                id: "category_PIP",
                name: "Picture In Picture button",
                collapsible: true,
                shown: false,
                settings: [
                    {
                        type: "switch",
                        id: "PIP",
                        name: "Add a PIP button",
                        note: "Picture In Picture in a simple click",
                        value: true
                    },
                    {
                        type: "slider",
                        id: "position_PIP",
                        name: "Position for PIP",
                        note: "Move the PIP button to different spots",
                        value: 1,
                        markers: [0, 1, 2, 3, 4, 5],
                        stickToMarkers: true
                    },
                    {
                        type: "switch",
                        id: "top_mid_PIP",
                        name: "Move the PIP to the middle",
                        note: "Breaks audio until the player is reloaded",
                        value: false
                    },
                ]
            },
            {
                type: "category",
                id: "category_MISC",
                name: "Misc",
                collapsible: true,
                shown: false,
                settings: [
                    {
                        type: "switch",
                        id: "MinWidth",
                        name: "Minimum width",
                        note: "Set minimum width on videos, to make them look better",
                        value: true
                    },
                    {
                        type: "switch",
                        id: "HideCursor",
                        name: "Hide cursor",
                        note: "Hides the cursor when controls are hidden",
                        value: true
                    },
                    {
                        type: "slider",
                        id: "controlsDarkness",
                        name: "Controls darkness",
                        note: "Control the darkness of the controls",
                        value: 6,
                        markers: [0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1],
                        stickToMarkers: true
                    }
                ]
            }
        ]
    }
    return !global.ZeresPluginLibrary ? class {
        constructor() { this._config = config }
        load() {
            // Let Lightcord users still use but with warning
            if(window.Lightcord || window.LightCord && !BdApi.loadData(config.info.name.replace(" ",""), "ShownLightcordWarning")) {
                BdApi.alert("Attention!", "By using LightCord you are risking your Discord Account, due to using a 3rd Party Client. Switch to an official Discord Client (https://discord.com/) with the proper BD Injection (https://betterdiscord.app/)")
                BdApi.saveData(config.info.name.replace(" ",""), "ShownLightcordWarning", true)
            }
            BdApi.showConfirmationModal("Library plugin is needed", [`The library plugin neede∂d for ${config.info.name} is missing. Please click Download Now to install it.`], {
                confirmText: "Download",
                cancelText: "Cancel",
                onConfirm: () => {
                    require("request").get("https://rauenzi.github.io/BDPluginLibrary/release/0PluginLibrary.plugin.js", async (error, response, body) => {
                    if (error) return require("electron").shell.openExternal("https://betterdiscord.app/Download?id=9")
                    await new Promise(r => require("fs").writeFile(require("path").join(BdApi.Plugins.folder, "0PluginLibrary.plugin.js"), body, r))})
                }
            })
        }
        start() {}
        stop() {}
    } : (([Plugin, Api]) => {
        const plugin = (Plugin, Api) => {
            const {WebpackModules, Settings, Patcher: {after, before, unpatchAll}, DiscordModules: {React}} = Api
            const controls = WebpackModules.getByProps("video","videoControls")
            const Controls = WebpackModules.getByProps("Controls").Controls
            const MediaPlayer = WebpackModules.findByDisplayName("MediaPlayer")
            const LazyVideo = WebpackModules.findByDisplayName("LazyVideo")
            const videoControls = WebpackModules.getByProps("videoControls").videoControls
            const wrapperControlsHidden = WebpackModules.getByProps("wrapperControlsHidden").wrapperControlsHidden.replace(" ", ".")
            const demo_urls = [
                "credit to whoever posted these",
                {
                    filename: "ae.mp4",
                    id:         "870091678302744586",
                    url:        "https://cdn.discordapp.com/attachments/620279569265721381/870091678302744586/video0_21.mp4",
                    proxy_url:  "https://media.discordapp.net/attachments/620279569265721381/870091678302744586/video0_21.mp4",
                    height:     480,
                    width:      480
                },
                {
                    filename: "Arch user speedrun.mp4",
                    id:         "872790856120287232",
                    proxy_url:  "https://media.discordapp.net/attachments/754981916402515969/872790856120287232/video0-68.mp4",
                    url:        "https://cdn.discordapp.com/attachments/754981916402515969/872790856120287232/video0-68.mp4",
                    height:     225,
                    width:      400
                },
                {
                    filename: "Dancing duck.mp4",
                    id:         "866825574100762624",
                    proxy_url:  "https://media.discordapp.net/attachments/86004744966914048/866825574100762624/duck.mp4",
                    url:        "https://cdn.discordapp.com/attachments/86004744966914048/866825574100762624/duck.mp4",
                    height:     300,
                    width:      209
                },
                {
                    filename: "BD Changelog video concept.mp4",
                    id:         "862043845989761024",
                    proxy_url:  "https://media.discordapp.net/attachments/86004744966914048/862043845989761024/b0cs2x.mp4",
                    url:        "https://cdn.discordapp.com/attachments/86004744966914048/862043845989761024/b0cs2x.mp4",
                    height:     225,
                    width:      400
                },
                {
                    filename: "Not a rick roll.mp4",
                    id:         "873334284814020648",
                    proxy_url:  "https://media.discordapp.net/attachments/800235887149187096/873334284814020648/video0.mov",
                    url:        "https://cdn.discordapp.com/attachments/800235887149187096/873334284814020648/video0.mov",
                    height:     225,
                    width:      400
                },
                {
                    filename: "Try it and see.mp4",
                    id:         "755137518210384013",
                    proxy_url:  "https://media.discordapp.net/attachments/754981916402515969/755137518210384013/try_it_and_see.mp4",
                    url:        "https://cdn.discordapp.com/attachments/754981916402515969/755137518210384013/try_it_and_see.mp4",
                    height:     225,
                    width:      400
                },
                {
                    filename: "Cat dance.mp4",
                    id:         "799802803958448148",
                    proxy_url:  "https://media.discordapp.net/attachments/754981916402515969/799802803958448148/broo.mp4",
                    url:        "https://cdn.discordapp.com/attachments/754981916402515969/799802803958448148/broo.mp4",
                    height:     300,
                    width:      300
                }
            ]
            class FakeMessage extends React.PureComponent {
                constructor(props) {
                    super(props)
                    this.state = { ran: Math.floor(Math.random() * Object.keys(demo_urls).pop() + 1) }
                }
                render() {
                    const Button = WebpackModules.getByProps("ButtonLooks")
                    const TooltipWrapper = BdApi.findModuleByPrototypes("renderTooltip")
                    const ChannelMessage = WebpackModules.find(m => m?.type?.displayName === "ChannelMessage").type
                    const Channel = WebpackModules.getByPrototypes("isGroupDM")
                    const Message = WebpackModules.getByPrototypes("addReaction")
                    const Timestamp = WebpackModules.getByProps("isMoment")
                    const getCurrentUser = WebpackModules.getByProps("getCurrentUser")
                    const SpoofChannel = new Channel({channel_id: "-7",name: "Better Media Player"})
                    const demo_url_num = this.state.ran
                    const SpoofMessage = new Message({
                        author: getCurrentUser.getCurrentUser(),
                        timestamp: Timestamp(),
                        channel_id: "-7",
                        attachments: [
                            {
                                content_type: "video/mp4",
                                size: Math.random().toString().slice(2, 9),
                                filename: demo_urls[demo_url_num].filename,
                                id: demo_urls[demo_url_num].id,
                                url: demo_urls[demo_url_num].url,
                                proxy_url: demo_urls[demo_url_num].proxy_url,
                                height: demo_urls[demo_url_num].height,
                                width: demo_urls[demo_url_num].width
                            }
                        ]
                    })
                    return React.createElement(React.Fragment, {
                        children: [
                            React.createElement(TooltipWrapper, {
                                text: "Video may not change",
                                position: TooltipWrapper.Positions.RIGHT,
                                color: TooltipWrapper.Colors.PRIMARY,
                                children: (tipProps) => {
                                    return React.createElement(Button.default, Object.assign(tipProps, {
                                        onClick: () => this.setState({ ran: Math.floor(Math.random() * Object.keys(demo_urls).pop() + 1) }),
                                        children: "Change video",
                                        style: {marginBottom: "10px"}
                                    }))
                                }
                            }),
                            React.createElement(ChannelMessage, {
                                channel: SpoofChannel, message: SpoofMessage
                            })
                        ]
                    })
                }
            }
            class VideoField extends Settings.SettingField {
                constructor(name, note, onChange) {
                    super(name, note, onChange, props => React.createElement(FakeMessage, props))
                }
            }
            class LoopIcon extends React.PureComponent {
                constructor(props) {
                    super(props)
                    this.state = { active: this.props.active }
                }
                onClick(node) {
                    this.setState({ active: !this.state.active })
                    try {node.loop = !node.loop} 
                    catch (e) {this.props.instance.error(e)}
                }
                render() {
                    return React.createElement("svg", {
                        className: controls.controlIcon,
                        ariaHidden: "false",
                        id: "Loop",
                        width: "16",
                        height: "16",
                        viewBox: "-5 0 459 459.648",
                        xmlns: "http://www.w3.org/2000/svg",
                        onClick: e => this.onClick(e.target.id === "Loop" ? e.target.parentElement.previousSibling : e.target.parentElement.parentElement.previousSibling),
                        children: [
                            React.createElement("path", {
                                fill: this.state.active === true ? "var(--brand-experiment)" : "currentColor",
                                d: "m416.324219 293.824219c0 26.507812-21.492188 48-48 48h-313.375l63.199219-63.199219-22.625-22.625-90.511719 90.511719c-6.246094 6.25-6.246094 16.375 0 22.625l90.511719 90.511719 22.625-22.625-63.199219-63.199219h313.375c44.160156-.054688 79.945312-35.839844 80-80v-64h-32zm0 0"
                            }),
                            React.createElement("path", {
                                fill: this.state.active === true ? "var(--brand-experiment)" : "currentColor",
                                d: "m32.324219 165.824219c0-26.511719 21.488281-48 48-48h313.375l-63.199219 63.199219 22.625 22.625 90.511719-90.511719c6.246093-6.25 6.246093-16.375 0-22.625l-90.511719-90.511719-22.625 22.625 63.199219 63.199219h-313.375c-44.160157.050781-79.949219 35.839843-80 80v64h32zm0 0"
                            })
                        ]
                    })
                }
            }
            class PipIcon extends React.PureComponent {
                constructor(props) {
                    super(props)
                    this.state = { active: false }
                }
                onClick(node) {
                    try {
                        if(document.pictureInPictureElement && (this.state.active === true)) 
                            document.exitPictureInPicture()
                        else {
                            node.requestPictureInPicture()
                            this.setState({ active: true })
                        }
                        const oldThis = this
                        node.addEventListener("leavepictureinpicture", leavepip)
                        function leavepip() {
                            oldThis.setState({ active: false })
                            node.removeEventListener("leavepictureinpicture", leavepip)
                        }
                    } 
                    catch(e){this.props.instance.error(e)}
                }
                render() {
                    return React.createElement("svg", {
                        className: controls.controlIcon,
                        ariaHidden: "false",
                        id: "PIP",
                        width: "16",
                        height: "16",
                        viewBox: "0 0 24 24",
                        xmlns: "http://www.w3.org/2000/svg",
                        onClick: e => this.onClick(this.props.element(e)),
                        children: [
                            React.createElement("path", {
                                fill: "transparent",
                                d: "M0 0h24v24H0V0z"
                            }),
                            React.createElement("path", {
                                fill: this.state.active === true ? "var(--brand-experiment)" : "currentColor",
                                d: "M19 11h-8v6h8v-6zm4 8V4.98C23 3.88 22.1 3 21 3H3c-1.1 0-2 .88-2 1.98V19c0 1.1.9 2 2 2h18c1.1 0 2-.9 2-2zm-2 .02H3V4.97h18v14.05z"
                            })
                        ]
                    })
                }
            }
            return class BetterMediaPlayer extends Plugin {
                constructor(props) {
                    super(props)
                }
                css() {
                    BdApi.clearCSS(this.getName())
                    BdApi.injectCSS(this.getName(), `${this.settings.category_PIP.top_mid_PIP ? `#PIP {
    position: absolute;
    top: 40px;
    left: 50%;
    transform: translatex(-50%);
    z-index: 1;
    background-color: rgba(0,0,0,.6);
    border-radius: 25%;
    opacity: .05;
    transition: opacity linear .15s
}
#PIP:hover {
    opacity: 1
}
` : ""}.${videoControls} {
    background-color: rgba(0,0,0,${this.settings.category_MISC.controlsDarkness});
}${this.settings.category_MISC.HideCursor ? `
.${wrapperControlsHidden} {
    cursor: none;
}` : ""}
`)
                }
                buildSetting(data) {
                    const {name, note, type, onChange} = data
                    if (type == "video") return new VideoField(name, note, onChange, {})
                    return super.buildSetting(data)
                }
                getSettingsPanel() {
                    const panel = this.buildSettingsPanel()
                    panel.addListener(() => this.css())
                    return panel.getElement()
                }
                onStart() {
                    after(Controls.prototype, "render", (thisObject, _, res) => {
                        if (res.props.className === controls.videoControls) {
                            if(this.settings.category_PIP.PIP && this.settings.category_PIP.top_mid_PIP === false) {
                                res.props.children.splice(this.settings.category_PIP.position_PIP, 0, React.createElement(PipIcon, {
                                    instance: this,
                                    element: (e) => e.target.id === "PIP" ? e.target.parentElement.previousSibling : e.target.parentElement.parentElement.previousSibling
                                }))
                            }
                            if(this.settings.category_Loop.button_loop) {
                                res.props.children.splice(this.settings.category_Loop.position_loop, 0, React.createElement(LoopIcon, {
                                    instance: this, 
                                    active: this.settings.category_Loop.auto_loop
                                }))
                            }
                        }
                    })
                    after(MediaPlayer.prototype, "renderVideo", (thisObject, _, res) => {
                        if(this.settings.category_Loop.auto_loop)
                            res.props.loop = true
                    })
                    after(MediaPlayer.prototype, "render", (thisObject, _, res) => {
                        if(res.props.className !== controls.wrapperAudio && this.settings.category_PIP.PIP && this.settings.category_PIP.top_mid_PIP) {
                            res.props.children.splice(1, 0, React.createElement(PipIcon, {
                                instance: this,
                                element: (e) => e.target.id === "PIP" ? e.target.nextSibling : e.target.parentElement.nextSibling
                            }))
                        }
                    })
                    before(LazyVideo.prototype, "render", (that, args, value) => {
                        if (that.props.width < 300 && this.settings.category_MISC.MinWidth)
                            that.props.width = 300
                    })
                    this.css()
                }
                onStop() {
                    BdApi.clearCSS(this.getName())
                    unpatchAll()
                }
                error(e) {
                    console.error(e)
                    BdApi.showConfirmationModal(`An error accord with ${config.info.name}`, 
                        [
                            "Wan\"t to reload discord?",
                            "If this is recurring please make a issue on the github page.",
                            `Join the support server https://discord.gg/${BdApi.Plugins.get("BetterMediaPlayer").invite}`,
                            `\`\`\`js\n${e}\n\`\`\``
                        ], {
                            confirmText: "Reload",
                            cancelText: "Cancel",
                            onConfirm: () => location.reload()
                        }
                    )
                }
            }
        }
        return plugin(Plugin, Api)
    })(global.ZeresPluginLibrary.buildPlugin(config))
})()
/*@end@*/