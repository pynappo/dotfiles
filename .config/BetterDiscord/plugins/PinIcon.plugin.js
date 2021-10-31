/**
 * @name PinIcon
 * @author Qwerasd
 * @description Add an icon to messages that have been pinned.
 * @version 0.0.3
 * @authorId 140188899585687552
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
        //@ts-ignore
        this.unpatch = BdApi.monkeyPatch(MessageModule, 'default', {
            after: (patchData) => {
                const isPinned = patchData.thisObject.props.childrenMessageContent.props.message.pinned;
                const hasIcon = patchData.thisObject.props.childrenMessageContent.props.content.some(c => c.key === 'PinIcon');
                if (isPinned && !hasIcon) {
                    patchData.thisObject.props.childrenMessageContent.props.content.push(BdApi.React.createElement("span", { className: "plugin_PinIcon", key: "PinIcon" },
                        BdApi.React.createElement(TooltipContainer, { text: "Pinned", position: "bottom", key: "PinIcon" },
                            BdApi.React.createElement(Pin, { width: 18 }))));
                }
                return patchData.returnValue;
            }
        });
    }
    stop() {
        if (this.unpatch)
            this.unpatch();
        BdApi.clearCSS('PinIcon');
    }
}
exports.default = PinIcon;
