/**
* @name         OpenInYouTube
* @description  Allows you to search for Spotify songs in YouTube.
* @source       https://github.com/rmkx/Plugins/OpenInYouTube
* @author       rmkx
* @invite       HnGWVQbQBv
* @version      1.0.1
*/

module.exports = class OpenInYoutube {
    getName() { return "Open in YouTube"; }
    load() {
    }
    start() {
        activityPatch();
    }
    stop() {
        BdApi.Patcher.unpatchAll("OpenInYoutube");
    }
    observer(changes) {
    }
}

const UserActivity = BdApi.findModuleByDisplayName("UserActivity");
const activityPatch = () => BdApi.Patcher.after("OpenInYoutube", UserActivity.prototype, "render", (that, args, value) => {
    const instance = that;
    if (instance.props.activity && instance.props.activity.name === "Spotify") {
        const ytButton = {
            className: "openInYouTube",
            style: {
                position: "absolute",
                top: "-3px",
                right: "25px",
                width: "25px",
                height: "25px",
                background: "url(https://i.imgur.com/HFYpFVO.png) center/cover no-repeat"
            },
            dataToggle: "tooltip",
            title: "Search with YouTube",
            onClick: () => {
                let songName = encodeURIComponent(instance.props.activity.details.replace(/;\s/g, " "));
                let songArtist = "+" + encodeURIComponent(instance.props.activity.state.replace(/;\s/g, " "));
                let url = "https://www.youtube.com/results?search_query=" + songName + songArtist;
                window.open(url, '_blank');
            }
        }
        value.props.children.push(BdApi.React.createElement("button", ytButton));
    }
    return value;
});