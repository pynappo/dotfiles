/**
 * @name PinIcon
 * @author Qwerasd
 * @description Add an icon to messages that have been pinned.
 * @version 0.0.6
 * @authorId 140188899585687552
 * @updateUrl https://betterdiscord.app/gh-redirect?id=421
 */
Object.defineProperty(exports, "__esModule", { value: true });
const MessageModule = BdApi.findModule(m => m.default && m.default.toString && m.default.toString().includes('childrenRepliedMessage'));
const { TooltipContainer } = BdApi.findModuleByProps("TooltipContainer");
const Pin = BdApi.findModuleByDisplayName('Pin');
class PinIcon {
    start() {
        BdApi.injectCSS('PinIcon', /*CSS*/ `
        /* Lazy fix for pin icon showing in pinned messages popout '\_(•-•)_/' */
        [data-list-item-id^="pins__"] .plugin_PinIcon {
            display: none;
        }

        span.plugin_PinIcon {
            color: var(--channels-default);
            margin-inline-start: 3px;
        }
        
        span.plugin_PinIcon > div {
            display: inline-block;
        }
        
        span.plugin_PinIcon > div > svg {
            vertical-align: -6px;
        }`);
        BdApi.Patcher.after('PinIcon', MessageModule, 'default', (_, [props]) => {
            // catch a whole bunch of annoying things like images in the upload state and stuff like that
            if (!props.childrenMessageContent?.props?.content?.some)
                return;
            const isPinned = props.childrenMessageContent.props.message.pinned;
            const hasIcon = props.childrenMessageContent.props.content.some(c => c.key === 'PinIcon');
            if (isPinned && !hasIcon) {
                props.childrenMessageContent.props.content.push(BdApi.React.createElement("span", { className: "plugin_PinIcon", key: "PinIcon" },
                    BdApi.React.createElement(TooltipContainer, { text: "Pinned", position: "bottom", key: "PinIcon" },
                        BdApi.React.createElement(Pin, { width: 18 }))));
            }
        });
    }
    stop() {
        BdApi.Patcher.unpatchAll('PinIcon');
        BdApi.clearCSS('PinIcon');
    }
}
exports.default = PinIcon;
