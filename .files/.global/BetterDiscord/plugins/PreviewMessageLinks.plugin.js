/**
 * @name PreviewMessageLinks
 * @author dylan-dang
 * @description Shows a embedded message preview for message links in chat
 * @version 0.0.2
 * @authorId 316707214075101196
 */

const {
    findModule,
    findModuleByProps,
    findModuleByDisplayName,
    Patcher,
    saveData,
    loadData,
    injectCSS,
    clearCSS,
    React,
} = BdApi;
const ChannelStore = findModuleByProps('getChannel', 'getDMFromUserId');
const MessageStore = findModuleByProps('getMessages');
const UserStore = findModuleByProps('getSessionId');
const Dispatcher = ChannelStore._dispatcher;
const { EventEmitter } = findModuleByProps('EventEmitter');

const { createElement, useState, useEffect, Fragment, memo } = React;
const MessagePlaceHolder = findModuleByProps('HEIGHT_COZY_MESSAGE_START').default;
const MessageComponent = findModuleByProps('getElementFromMessageId').default;
const MessageContent = findModule((m) => m.default?.type?.displayName === 'MessageContent').default;
const ChannelMessage = findModule((m) => m.default?.type?.displayName == 'ChannelMessage').default;
const Anchor = findModuleByDisplayName('Anchor');
const Clickable = findModuleByDisplayName('Clickable');
const Slider = findModuleByDisplayName('Slider');
const FormSection = findModuleByDisplayName('FormSection');
const FormTitle = findModuleByDisplayName('FormTitle');
const FormText = findModuleByDisplayName('FormText');
const SwitchItem = findModuleByDisplayName('SwitchItem');
const SystemMessageContextMenu = findModuleByDisplayName('SystemMessageContextMenu');
//lazy hotfix to deal with MessageContextMenu module being lazy loaded
let MessageContextMenu;
const { default: HelpMessage, HelpMessageTypes } = findModuleByProps('HelpMessageTypes');
const {
    MessageAccessories: { prototype: MessageAccessoriesRenderer },
    default: MessageAccessories,
} = findModuleByProps('MessageAccessories');

const { openContextMenu } = findModuleByProps('openContextMenu');
const MessageParser = findModuleByProps('renderMessageMarkupToAST');
const { renderMessageMarkupToAST } = MessageParser;
const { transitionToGuild } = findModuleByProps('transitionTo', 'replaceWith', 'getHistory');
const { jumpToMessage } = findModuleByProps('jumpToMessage');

const { Messages } = findModule((m) => m.default?.Messages?.REPLY_QUOTE_MESSAGE_NOT_LOADED).default;
const { Endpoints, RPCEvents, EmbedTypes, USER_MESSAGE_TYPES } = findModuleByProps('Endpoints');
const RequestModule = findModuleByProps('getAPIBaseURL');
const linkRegex = /^^https?:\/\/([\w-\.]+\.)?discord(app)?\.com(:\d+)?\/channels\/(\d+|@me)\/(\d+)\/(\d+)(\/.*)?$/i;
const { createMessageRecord, updateMessageRecord } = findModuleByProps('createMessageRecord');

const Styles = {
    ...findModuleByProps('marginBottom20', 'marginBottom8', 'marginReset'),
    ...findModuleByProps('searchResult', 'button'),
    ...findModuleByProps('attachmentContainer', 'wrapper'),
    ...findModuleByProps('hasThread', 'compact'),
    messageEmbed: 'message-embed',
    jumpButton: 'jump-button',
    disableInteraction: 'disable-interaction',
};
const Enum = (...values) => Object.fromEntries(values.map((value) => [value, Symbol(value)]));
const PLUGIN_ID = 'PreviewMessageLinks';
const MessageStatus = Enum('FETCHING', 'RECEIVED', 'ERROR');

const PluginStore = new (class EmbeddedMessagesStore extends EventEmitter {
    Event = Enum('MESSAGE_UPDATE', 'SETTINGS_UPDATE');

    defaultSettings = {
        hideLinks: true,
        disableInteraction: false,
        maxDepth: 3,
    };

    #embeddedMessages = {
        get(channelId, messageId) {
            return this[channelId + messageId];
        },

        set(channelId, messageId, message) {
            this[channelId + messageId] = message;
        },
    };

    constructor() {
        super();
        this.setMaxListeners(Infinity);
        this._settings = {
            ...this.defaultSettings,
            ...(loadData(PLUGIN_ID, 'settings') ?? {}),
        };
    }

    async fetchMessage(channelId, messageId) {
        const { WARNING, ERROR } = HelpMessageTypes;
        const { REPLY_QUOTE_MESSAGE_DELETED, REPLY_QUOTE_MESSAGE_NOT_LOADED } = Messages;
        if (this.#embeddedMessages.get(channelId, messageId)?.status === MessageStatus.FETCHING) return;
        this.#embeddedMessages.set(channelId, messageId, {
            status: MessageStatus.FETCHING,
        });

        try {
            const response = await RequestModule.get({
                url: Endpoints.MESSAGES(channelId),
                query: {
                    limit: 1,
                    around: messageId,
                },
                retries: 2,
            }).catch((response) => response);

            if (!response.ok) {
                throw {
                    messageType: WARNING,
                    name: REPLY_QUOTE_MESSAGE_NOT_LOADED,
                    message: response.body?.message ?? `Status ${response.status}`,
                };
            }

            const message = response.body?.[0];

            if (!message || message.id !== messageId)
                throw {
                    messageType: ERROR,
                    name: REPLY_QUOTE_MESSAGE_DELETED,
                };

            if (!ChannelStore.hasChannel(message.channel_id))
                throw {
                    messageType: WARNING,
                    name: REPLY_QUOTE_MESSAGE_NOT_LOADED,
                    message: 'Channel not in store',
                };

            this.updateMessage(channelId, messageId, {
                status: MessageStatus.RECEIVED,
                message: createMessageRecord(message),
            });
        } catch ({ messageType = ERROR, name = REPLY_QUOTE_MESSAGE_NOT_LOADED, message }) {
            this.updateMessage(channelId, messageId, {
                status: MessageStatus.ERROR,
                message: {
                    messageType,
                    reason: name,
                    info: message,
                },
            });
        }
    }

    getMessage(channelId, messageId) {
        const loadedMessage = MessageStore?.getMessage(channelId, messageId);
        if (loadedMessage)
            this.#embeddedMessages.set(channelId, messageId, {
                status: MessageStatus.RECEIVED,
                message: loadedMessage,
            });

        const message = this.#embeddedMessages.get(channelId, messageId);
        if (message) return message;

        this.fetchMessage(channelId, messageId);
        return { status: MessageStatus.FETCHING };
    }

    updateMessage(channelId, messageId, updatedMessage) {
        this.#embeddedMessages.set(channelId, messageId, updatedMessage);
        this.emit(this.Event.MESSAGE_UPDATE);
    }

    hasMessage(channelId, messageId) {
        const message = this.#embeddedMessages.get(channelId, messageId);
        return !!message && message.status !== MessageStatus.FETCHING && message.status !== MessageStatus.ERROR;
    }

    setSettings(settings) {
        this._settings = { ...this._settings, ...settings };
        saveData(PLUGIN_ID, 'settings', this._settings);
        this.emit(this.Event.SETTINGS_UPDATE);
    }

    getSettings() {
        return this._settings;
    }
})();

const useStore = (event, callback) =>
    useEffect(() => {
        PluginStore.on(event, callback);
        return () => PluginStore.removeListener(event, callback);
    }, []);

const useMessage = (channelId, messageId) => {
    const [messageObject, setMessageObject] = useState(PluginStore.getMessage(channelId, messageId));
    useStore(PluginStore.Event.MESSAGE_UPDATE, () => setMessageObject(PluginStore.getMessage(channelId, messageId)));
    return messageObject;
};

const useSettings = (...settingNames) => {
    const settings = PluginStore.getSettings();
    const state = settingNames.map((settingName) => [settingName, ...useState(settings[settingName])]);

    useStore(PluginStore.Event.SETTINGS_UPDATE, () => {
        const settings = PluginStore.getSettings();
        for ([settingName, setting, setSetting] of state) setSetting(settings[settingName]);
    });

    return Object.fromEntries(state);
};

const MessageEmbed = memo(({ className, channelId, messageId, depth, href, compact }) => {
    const { maxDepth } = useSettings('maxDepth');
    const { message, status } = useMessage(channelId, messageId);
    const channel = ChannelStore.getChannel(channelId);

    if (status === MessageStatus.FETCHING) {
        return createElement(MessageEmbedPlaceHolder, { className, compact });
    }

    if (status === MessageStatus.ERROR) {
        return createElement(MessageEmbedError, { className, href, ...(message ?? {}) });
    }

    if (!channel) {
        return createElement(MessageEmbedError, {
            messageType: HelpMessageTypes.WARNING,
            reason: Messages.REPLY_QUOTE_MESSAGE_NOT_LOADED,
            info: 'Channel could not be found',
            className,
            href,
        });
    }

    if (depth > maxDepth) {
        return createElement(MessageEmbedError, {
            messageType: HelpMessageTypes.WARNING,
            reason: 'Maximum depth exceeded',
            className,
            href,
        });
    }

    return createElement(MessageEmbedPreview, {
        className,
        channel,
        message,
        compact,
        depth,
        href,
    });
});

const MessageEmbedPlaceHolder = memo(({ className, compact }) => {
    return createElement('div', {
        className,
        children: createElement(MessagePlaceHolder, {
            attachmentSpecs: { width: 0, height: 0 },
            messages: 1,
            compact,
        }),
    });
});

const MessageEmbedError = ({
    messageType = HelpMessageTypes.WARNING,
    reason = Messages.REPLY_QUOTE_MESSAGE_NOT_LOADED,
    info,
    className,
    href,
}) => {
    const reasonFragment = reason.endsWith('.') ? reason.slice(0, -1) : reason;
    const children = info ? `${reasonFragment}: ${info}` : reasonFragment;
    return createElement(Anchor, {
        children: createElement(HelpMessage, { messageType, children }),
        className,
        href,
    });
};

const MessageEmbedPreview = memo(({ className, channel, message, compact, depth }) => {
    const [hovered, setHovered] = useState(false);
    const { disableInteraction } = useSettings('disableInteraction');

    const { childrenHeader, childrenRepliedMessage } = MessageComponent.type({
        channel,
        message,
        compact,
        groupId: message.id,
        flashKey: true,
    }).props.children.props.children.props.children.props;

    const fromSameContainer = ({ target, relatedTarget }) =>
        target?.closest?.(`div.${className}`) === relatedTarget?.closest?.(`div.${className}`);

    return createElement('div', {
        className,
        onMouseOver: (event) => {
            event.stopPropagation();
            if (fromSameContainer(event)) return;
            setHovered(true);
        },
        onMouseOut: (event) => {
            if (fromSameContainer(event)) return;
            setHovered(false);
        },
        onContextMenu: disableInteraction
            ? undefined
            : (event, attachment) =>
                  openContextMenu(event, (props) =>
                      createElement(MessageEmbedContextMenu, { ...props, channel, message, attachment })
                  ),
        children: createElement(ChannelMessage, {
            ...(disableInteraction
                ? { className: Styles.disableInteraction }
                : { childrenHeader, childrenRepliedMessage }),
            channel,
            message,
            compact,
            renderThreadAccessory: true,
            childrenButtons: hovered
                ? createElement(
                      Clickable,
                      {
                          className: `${Styles.jumpButton} ${Styles.button}`,
                          onClick: () => transitionToGuild(channel.guild_id, message.channel_id, message.id),
                      },
                      Messages.JUMP
                  )
                : undefined,
            childrenAccessories: createElement(MessageAccessories, {
                compact,
                channel,
                message,
                depth,
            }),
        }),
    });
});

const MessageEmbedContextMenu = (props) => {
    const { channel, message } = props;
    if (!USER_MESSAGE_TYPES.has(message.type) && (!message.isCommandType() || message.interaction == null)) {
        return createElement(SystemMessageContextMenu, props);
    }
    const contextMenu = MessageContextMenu(props);
    const actions = new Set(['edit', 'reply', 'pin']);
    contextMenu.props.children[2].props.children
        .filter((menuItem) => actions.has(menuItem?.props?.id))
        .forEach(({ props }) => {
            const { action } = props;
            props.action = (...args) => {
                transitionToGuild(channel.guild_id, message.channel_id);
                jumpToMessage({
                    channelId: message.channel_id,
                    messageId: message.id,
                    flash: false,
                });
                action(...args);
            };
        });
    return contextMenu;
};

const SettingSwitch = ({ setting, name, note, hideBorder }) => {
    const settings = useSettings(setting);
    return createElement(SwitchItem, {
        children: name,
        className: Styles.marginReset,
        onChange: () => PluginStore.setSettings({ [setting]: !settings[setting] }),
        value: settings[setting],
        hideBorder,
        note,
    });
};

const SettingIntegerSlider = ({ setting, name, note, minValue, maxValue }) => {
    const settings = useSettings(setting);
    return createElement(Fragment, {
        children: [
            createElement(FormTitle, { className: Styles.marginBottom8, children: name }),
            note &&
                createElement(FormText, {
                    className: Styles.marginBottom20,
                    children: note,
                    type: FormText.DESCRIPTION,
                }),
            createElement(Slider, {
                stickToMarkers: true,
                markers: [...Array(maxValue - minValue + 1).keys()].map((i) => i + minValue),
                handleSize: 10,
                initialValue: settings[setting],
                keyboardStep: 1,
                minValue,
                maxValue,
                equidistant: true,
                onValueChange: (value) => PluginStore.setSettings({ [setting]: value }),
            }),
        ],
    });
};

const patchEmbeds = ({ props: { message, depth, compact } }, _, accessories) => {
    const { content } = renderMessageMarkupToAST(message);
    const createEmbed = (link) => {
        if (link.type !== EmbedTypes.LINK) return;
        const path = link.target?.match?.(linkRegex);
        if (!path) return;
        return [
            createElement(MessageEmbed, {
                className: Styles.messageEmbed,
                channelId: path[5],
                messageId: path[6],
                href: link.target,
                depth: (depth || 0) + 1,
                compact,
            }),
            createElement('br'),
        ];
    };
    const messageEmbeds = content.map(createEmbed).flat().filter(Boolean).slice(0, -1);
    return [messageEmbeds, accessories];
};

const patchMessageContent = (_, [props], MessageContent) => {
    const PatchedMessageContent = (props) => {
        const { hideLinks } = useSettings('hideLinks');
        if (!hideLinks) return MessageContent(props);
        const content = props?.content?.reduce?.(
            (content, part) => {
                if (part?.props?.href?.match?.(linkRegex)) return content;
                const lastPart = content.pop();
                if (typeof lastPart === 'string' && typeof part === 'string') return [...content, lastPart + part];
                return [...content, lastPart, part];
            },
            ['']
        );
        if (!content) return MessageContent(props);
        if (typeof content[0] === 'string') content.unshift(content.shift().trimStart());
        if (typeof content[content.length - 1] === 'string') content.push(content.pop().trimEnd());
        return MessageContent({ ...props, content });
    };

    return createElement(PatchedMessageContent, props);
};

const css = /*css*/ `
.${Styles.messageEmbed} {
    background: var(--background-secondary);
    color: var(--text-normal);
    display: inline-block;
    pointer-events: auto;
    position: relative;
    border-radius: 4px;
    max-width: 100%;
    margin: 2px 0;
}

.${Styles.messageEmbed} > * {
    --background-secondary: rgba(0, 0, 0, 0.1);
    --background-secondary-alt: rgba(0, 0, 0, 0.1);
    padding-right: 48px;
    background: none;
    border: none;
}

.${Styles.messageEmbed} .${Styles.wrapper} {
    background: none;
}

.${Styles.jumpButton} {
    pointer-events: auto;
    background: rgba(0, 0, 0, .2);
    position: absolute;
    right: 4px;
    top: 4px;
}

${Styles.compact}.${Styles.hasThread} > .${Styles.messageEmbed}:before {
    background-color: var(--background-accent);
    position: absolute;
    content: "";
    top: -2px;
    bottom: -2px;
    left: -2.5rem;
    width: 2px;
}

.${Styles.disableInteraction} {
    pointer-events: none;
}

.${Styles.disableInteraction} a {
    pointer-events: auto;
}
`;

const subscriptions = {
    [RPCEvents.MESSAGE_CREATE]: ({ message }) => {
        if (!PluginStore.hasMessage(message.channel_id, message.id)) return;

        PluginStore.updateMessage(message.channel_id, message.id, {
            status: MessageStatus.RECEIVED,
            message: createMessageRecord(message),
        });
    },
    [RPCEvents.MESSAGE_UPDATE]: ({ message }) => {
        if (!PluginStore.hasMessage(message.channel_id, message.id)) return;

        PluginStore.updateMessage(message.channel_id, message.id, {
            status: MessageStatus.RECEIVED,
            message: updateMessageRecord(PluginStore.getMessage(message.channel_id, message.id).message, message),
        });
    },
    [RPCEvents.MESSAGE_DELETE]: ({ channelId, id }) => {
        if (!PluginStore.hasMessage(channelId, id)) return;

        PluginStore.updateMessage(channelId, id, {
            status: MessageStatus.ERROR,
            message: {
                messageType: HelpMessageTypes.ERROR,
                reason: Messages.REPLY_QUOTE_MESSAGE_DELETED,
            },
        });
    },
    [RPCEvents.MESSAGE_REACTION_ADD]: ({ channelId, messageId, userId, emoji, optimistic }) => {
        const self = userId === UserStore.getId();
        if (!optimistic && self) return;
        if (!PluginStore.hasMessage(channelId, messageId)) return;

        PluginStore.updateMessage(channelId, messageId, {
            status: MessageStatus.RECEIVED,
            message: PluginStore.getMessage(channelId, messageId).message.addReaction(emoji, self),
        });
    },
    [RPCEvents.MESSAGE_REACTION_REMOVE]: ({ channelId, messageId, userId, emoji, optimistic }) => {
        const self = userId === UserStore.getId();
        if (!optimistic && self) return;
        if (!PluginStore.hasMessage(channelId, messageId)) return;

        PluginStore.updateMessage(channelId, messageId, {
            status: MessageStatus.RECEIVED,
            message: PluginStore.getMessage(channelId, messageId).message.removeReaction(emoji, self),
        });
    },
    [RPCEvents.MESSAGE_REACTION_REMOVE_ALL]: ({ channelId, messageId }) => {
        if (!PluginStore.hasMessage(channelId, messageId)) return;
        PluginStore.updateMessage(channelId, messageId, {
            status: MessageStatus.RECEIVED,
            message: PluginStore.getMessage(channelId, messageId).message.set('reactions', []),
        });
    },
    [RPCEvents.MESSAGE_REACTION_REMOVE_EMOJI]: ({ channelId, messageId, emoji }) => {
        if (!PluginStore.hasMessage(channelId, messageId)) return;
        PluginStore.updateMessage(channelId, messageId, {
            status: MessageStatus.RECEIVED,
            message: PluginStore.getMessage(channelId, messageId).removeReactionsForEmoji(emoji),
        });
    },
};

module.exports = class {
    start() {
        MessageContextMenu = findModuleByDisplayName('MessageContextMenu');
        Object.entries(subscriptions).forEach(([action, callback]) => Dispatcher.subscribe(action, callback));
        Patcher.instead(PLUGIN_ID, MessageContent, 'type', patchMessageContent);
        Patcher.after(PLUGIN_ID, MessageAccessoriesRenderer, 'render', patchEmbeds);
        window?.BDFDB?.MessageUtils?.rerenderAll(true);
        injectCSS(PLUGIN_ID, css);
    }

    stop() {
        Object.entries(subscriptions).forEach(([action, callback]) => Dispatcher.unsubscribe(action, callback));
        Patcher.unpatchAll(PLUGIN_ID);
        clearCSS(PLUGIN_ID);
    }

    getSettingsPanel() {
        return createElement(FormSection, {
            children: [
                createElement(SettingSwitch, {
                    setting: 'hideLinks',
                    name: 'Hide Message Links',
                    note: 'Hide the link an embedded message was referred from when it is embedded.',
                }),
                createElement(SettingSwitch, {
                    setting: 'disableInteraction',
                    name: 'Disable Interaction',
                    note: 'Disables the ability to interact with embedded messages.',
                }),
                createElement(SettingIntegerSlider, {
                    setting: 'maxDepth',
                    name: 'Maximum Depth',
                    note: 'The maximum depth that embedded messages links can be nested within each other.',
                    minValue: 1,
                    maxValue: 10,
                }),
            ],
        });
    }
};
