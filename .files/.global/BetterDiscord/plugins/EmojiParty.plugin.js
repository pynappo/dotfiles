/**
 * @name EmojiParty
 * @author An0
 * @version 1.3
 * @description Create a nice image from your emojis! You can include some text optionally too!
 * @source https://github.com/An00nymushun/DiscordEmojiParty
 * @updateUrl https://raw.githubusercontent.com/An00nymushun/DiscordEmojiParty/main/EmojiParty.plugin.js
 */

/*@cc_on
@if (@_jscript)
    var shell = WScript.CreateObject("WScript.Shell");
    var fs = new ActiveXObject("Scripting.FileSystemObject");
    var pathPlugins = shell.ExpandEnvironmentStrings("%APPDATA%\\BetterDiscord\\plugins");
    var pathSelf = WScript.ScriptFullName;
    shell.Popup("It looks like you've mistakenly tried to run me directly. \\n(Don't do that!)", 0, "I'm a plugin for BetterDiscord", 0x30);
    if (fs.GetParentFolderName(pathSelf) === fs.GetAbsolutePathName(pathPlugins)) {
        shell.Popup("I'm in the correct folder already.", 0, "I'm already installed", 0x40);
    } else if (!fs.FolderExists(pathPlugins)) {
        shell.Popup("I can't find the BetterDiscord plugins folder.\\nAre you sure it's even installed?", 0, "Can't install myself", 0x10);
    } else if (shell.Popup("Should I copy myself to BetterDiscord's plugins folder for you?", 0, "Do you need some help?", 0x34) === 6) {
        fs.CopyFile(pathSelf, fs.BuildPath(pathPlugins, fs.GetFileName(pathSelf)), true);
        // Show the user where to put plugins in the future
        shell.Exec("explorer " + pathPlugins);
        shell.Popup("I'm installed!", 0, "Successfully installed", 0x40);
    }
    WScript.Quit();
@else @*/


var EmojiParty = (() => {

'use strict';

const TriggerEmojiCount = 5;
const MaxTextHeight = 10;
const MaxTextWidth = 100;
const EmojiImageSize = 128;
const EmojiUrlRegex = /^https:\/\/cdn\.discordapp\.com\/emojis\/(\d{16,20})/;
const EmojiUrlFormat = (id) => `https://cdn.discordapp.com/emojis/${id}.png?size=${EmojiImageSize}`;
const ImageCacheSize = 50;
const BaseColor = "#f46";

const FontOptions = {
    textAlign: 'center',
    font: "bold 36px Whitney",
    fillStyle: 'white',
    strokeStyle: 'black',
    lineWidth: 6,
    textBaseline: 'middle',
    miterLimit: 2
};

var Discord;
var Utils = {
    Log: (message) => { console.log(`%c[EmojiParty] %c${message}`, `color:${BaseColor};font-weight:bold`, "") },
    Warn: (message) => { console.warn(`%c[EmojiParty] %c${message}`, `color:${BaseColor};font-weight:bold`, "") },
    Error: (message) => { console.error(`%c[EmojiParty] %c${message}`, `color:${BaseColor};font-weight:bold`, "") },
    Webpack: function() {
        if(this.cachedWebpack) return this.cachedWebpack;

        let webpackExports;

        if(typeof BdApi !== "undefined" && BdApi?.findModuleByProps && BdApi?.findModule) {
            return this.cachedWebpack = { findModule: BdApi.findModule, findModuleByUniqueProperties: (props) => BdApi.findModuleByProps.apply(null, props) };
        }
        else if(Discord.window.webpackChunkdiscord_app != null) {
            const ids = ['__extra_id__'];
            Discord.window.webpackChunkdiscord_app.push([
                ids,
                {},
                (req) => {
                    webpackExports = req;
                    ids.length = 0;
                }
            ]);
        }
        else if(Discord.window.webpackJsonp != null) {
            webpackExports = typeof(Discord.window.webpackJsonp) === 'function' ?
            Discord.window.webpackJsonp(
                [],
                { '__extra_id__': (module, _export_, req) => { _export_.default = req } },
                [ '__extra_id__' ]
            ).default :
            Discord.window.webpackJsonp.push([
                [],
                { '__extra_id__': (_module_, exports, req) => { _module_.exports = req } },
                [ [ '__extra_id__' ] ]
            ]);

            delete webpackExports.m['__extra_id__'];
            delete webpackExports.c['__extra_id__'];
        }
        else return null;

        const findModule = (filter) => {
            for(let i in webpackExports.c) {
                if(webpackExports.c.hasOwnProperty(i)) {
                    let m = webpackExports.c[i].exports;

                    if(!m) continue;

                    if(m.__esModule && m.default) m = m.default;

                    if(filter(m)) return m;
                }
            }

            return null;
        };

        const findModuleByUniqueProperties = (propNames) => findModule(module => propNames.every(prop => module[prop] !== undefined));

        return this.cachedWebpack = { findModule, findModuleByUniqueProperties };
    },
    DownloadFile: (()=>{
        let nodeHttps;
        let nodeHttpsOptions;
        if(typeof(require) !== 'undefined') {
            nodeHttps = require('https');
            nodeHttpsOptions = { agent: new nodeHttps.Agent({ keepAlive: true }), timeout: 120000 };
        }

        return(
            (typeof(GM_xmlhttpRequest) !== 'undefined') ? (url) => new Promise((resolve, reject) => {
                GM_xmlhttpRequest({
                    method: 'GET',
                    url,
                    responseType: 'arraybuffer',
                    onload: (result) => resolve(result.response),
                    onerror: reject
                })
            })
            : (nodeHttps != null) ? (url) => { return new Promise((resolve, reject) => {
                nodeHttps.get(String(url), nodeHttpsOptions, (response) => {
                    let data = [];
                    response.on('data', (chunk) => data.push(chunk));
                    response.on('end', () => resolve(Buffer.concat(data)));
                    response.on('aborted', reject);
                }).on('error', reject).on('timeout', function() { this.abort() });
            })}
            : (url) => new Promise((resolve, reject) => {
                let xhr = new XMLHttpRequest();
                xhr.responseType = 'arraybuffer';
                xhr.onload = () => resolve(xhr.response);
                xhr.onerror = reject;
                xhr.open('GET', url);
                xhr.withCredentials = true;
                xhr.send();
            }));
    })(),
    RandomNormal: (start, end, rolls = 2) => {
        let rangeAdjust = (end - start) / rolls;
        let random = Math.random();
        while(--rolls > 0) random += Math.random();
        return random * rangeAdjust + start;
    },
    Random: (start, end) => {
        return Math.random() * (end - start) + start;
    }
};

var Initialized = false;
var sendMessageHook;
var useEmojiSelectHandlerHook;
function Init(final)
{
    Discord = { window: (typeof(unsafeWindow) !== 'undefined') ? unsafeWindow : window };

    const webpackUtil = Utils.Webpack();
    if(webpackUtil == null) { Utils.Error("Webpack not found."); return 0; }
    const { findModuleByUniqueProperties } = webpackUtil;

    function findModules(modules) {
        for (const [name, props] of Object.entries(modules)) {
            const module = findModuleByUniqueProperties(props);
            if(module == undefined) throw new Error("Couldn't find " + name);
            modules[name] = module;
        }
    
        return modules;
    }

    let necessaryModules, optionalModules;
    try {
        necessaryModules = findModules({
            EmojiPicker: ['useEmojiSelectHandler'],
            MessageModule: ['sendMessage', 'sendBotMessage'],
            FileUploader: ['upload', 'cancel', 'instantBatchUpload'],
            ParserModule: ['parseToAST']
        });
    }
    catch (e)
    {
        if(final) Utils.Error(e);
        return 0;
    }

    try {
        optionalModules = findModules({
            PermissionEvaluator: ['can', 'computePermissions', 'canEveryone'],
            ChannelStore: ['getChannel', 'getDMFromUserId'],
            UserStore: ['getCurrentUser'],
            MessageCache: ['getMessage', 'getMessages'],
            PendingReplyDispatcher: ['createPendingReply']
        });
    }
    catch (e)
    {
        Utils.Warn(e);
    }

    Object.assign(Discord, necessaryModules, optionalModules);

    const { MessageModule, EmojiPicker } = Discord;

    sendMessageHook = Discord.original_sendMessage = MessageModule.sendMessage;
    MessageModule.sendMessage = function() { return sendMessageHook.apply(this, arguments); };

    useEmojiSelectHandlerHook = Discord.original_useEmojiSelectHandler = EmojiPicker.useEmojiSelectHandler;
    EmojiPicker.useEmojiSelectHandler = function() { return useEmojiSelectHandlerHook.apply(this, arguments); };

    Utils.Log("initialized");
    Initialized = true;

    return 1;
}

function Start() {
    if(!Initialized && Init(true) !== 1) return;

    const { FileUploader, ParserModule, PermissionEvaluator, ChannelStore, UserStore, MessageCache, PendingReplyDispatcher, original_useEmojiSelectHandler } = Discord;

    const getTextPart = (messagePart) => messagePart.content[0].content;
    function processMessageParts(messageParts, fallthroughParts, textParts, emojiParts) {
        let previousPart;
        for (const messagePart of messageParts) {
            switch (messagePart.type) {
                case 'text': {
                    let content = messagePart.content;
                    if(content !== " " || !previousPart?.type.endsWith("moji")) textParts.push(content);
                    break;
                } case 'link': {
                    const emojiLinkMatch = EmojiUrlRegex.exec(messagePart.target);
                    if(emojiLinkMatch !== null) {
                        emojiParts.push({ type: 'customEmoji', emojiId: emojiLinkMatch[1] });
                    }
                    else {
                        fallthroughParts.push(messagePart.target);
                    }
                    
                } break;
                case 'mention':
                    textParts.push(getTextPart(messagePart));
                    fallthroughParts.push(messagePart.userId ? `<@${messagePart.userId}>` : `<@&${messagePart.roleId}>`);
                break;
                case 'channel':
                    textParts.push("#" + getTextPart(messagePart));
                    fallthroughParts.push(`<#${messagePart.channelId}>`);
                break;

                case 'emoji': {
                    if(messagePart.src) emojiParts.push(messagePart);
                    else textParts.push(messagePart.surrogate);
                } break;
                case 'customEmoji':
                    emojiParts.push(messagePart);
                    break;

                default: {
                    if(Array.isArray(messagePart.content)) {
                        processMessageParts(messagePart.content, fallthroughParts, textParts, emojiParts);
                    }
                    else {
                        fallthroughParts.push(messagePart.content);
                    }
                } break;
            }
            previousPart = messagePart;
        }
    }
    function drawWithRandomTilt(ctx, image, x, y, width, height) {
        ctx.save();
        ctx.translate(x, y);
        ctx.rotate(Utils.RandomNormal(-Math.PI, Math.PI, 4));
        ctx.drawImage(image, -width / 2, -height / 2, width, height);
        ctx.restore();
    }
    function calculateNewSize(desiredSize, width, height) {
        if(width > desiredSize || height > desiredSize) {
            if(width > height) {
                height *= desiredSize / width;
                width = desiredSize;
            }
            else {
                width *= desiredSize / height;
                height = desiredSize;
            }
        }
        const imageSize = Math.max(width, height);
        const halfImageSize = imageSize / 2;
        return [width, height, imageSize, halfImageSize];
    }

    const imageCache = new Map();
    async function renderUploadEmojiParty(channelId, message, messageParts, mentions, callOriginal) {
        let fallthroughParts = [];
        let textParts = [];
        let emojiParts = [];

        processMessageParts(messageParts, fallthroughParts, textParts, emojiParts);

        textParts = textParts.join("").split("\n").map(x => x.trim()).filter(x => x !== "");
        if(textParts.length > MaxTextHeight || Math.max(...textParts.map(x => x.length)) > MaxTextWidth) {
            return await callOriginal();
        }
        
        message.content = fallthroughParts.join(" ");

        const canvas = document.createElement('canvas');
        canvas.width = 600;
        canvas.height = 450;
        const ctx = canvas.getContext('2d');
        Object.assign(ctx, FontOptions);
        
        const uniqueEmojiIds = new Map(emojiParts.filter(x => x.type === 'customEmoji').map(x => [x.emojiId, x]));
        const uniqueEmoteAssets = new Map(emojiParts.filter(x => x.type === 'emoji').map(x => [x.src, x]));

        const decodePromises = [];
        for (const [emojiId, emojiPart] of [...uniqueEmojiIds, ...uniqueEmoteAssets]) {
            let cachedImage = imageCache.get(emojiId);
            if(cachedImage) {
                imageCache.delete(emojiId);
                imageCache.set(emojiId, cachedImage);
            }
            else {
                let imageElement = new Image();
                let decodePromise;
                if(emojiPart.type === 'customEmoji') {
                    let imageBuffer = await Utils.DownloadFile(EmojiUrlFormat(emojiId));
                    let imageUrl = URL.createObjectURL(new Blob([imageBuffer]));
                    imageElement.src = imageUrl;
                    decodePromise = imageElement.decode();
                    decodePromise.finally(URL.revokeObjectURL.bind(URL, imageUrl));
                }
                else {
                    imageElement.src = emojiId;
                    decodePromise = imageElement.decode();
                }
                decodePromises.push({ decodePromise, emojiId, imageElement });
            }
        }

        await Promise.all(decodePromises.map(x => x.decodePromise));

        for (const {emojiId, imageElement} of decodePromises) {
            imageCache.set(emojiId, imageElement);
        }

        if(emojiParts.length > 50) {
            
            for (const emojiPart of emojiParts) {
                const image = imageCache.get(emojiPart.emojiId ?? emojiPart.src);

                const desiredSize = 40 + Math.random() * 10;
                const [width, height, imageSize, halfImageSize] = calculateNewSize(desiredSize, image.width, image.height);

                const x = Utils.Random(halfImageSize, canvas.width - halfImageSize);
                const y = Utils.Random(halfImageSize, canvas.height - halfImageSize);

                drawWithRandomTilt(ctx, image, x, y, width, height);
            }

        }
        else {
            const emojiPlaces = [];
            for (const emojiPart of emojiParts) {
                const image = imageCache.get(emojiPart.emojiId ?? emojiPart.src);
                let desiredSize = 128 - Math.random() * emojiParts.length * 2;

                if(desiredSize < 40) desiredSize = 40;
                const [width, height, imageSize, halfImageSize] = calculateNewSize(desiredSize, image.width, image.height);

                let x, y;
                let biggestNearestNeighborDistance = Number.NEGATIVE_INFINITY;

                while(true) {
                    const generatedX = Utils.Random(halfImageSize, canvas.width - halfImageSize);
                    const generatedY = Utils.Random(halfImageSize, canvas.height - halfImageSize);

                    let closestDistance = Number.POSITIVE_INFINITY;
                    let regenerationChance = 0;
                    for (const [otherX, otherY, otherSize] of emojiPlaces) {
                        let imageSizes = halfImageSize + otherSize;
                        let deltaX = generatedX - otherX;
                        let deltaY = generatedY - otherY;
                        let distance = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
                        let overlapDistance = distance - imageSizes;
                        if(overlapDistance < closestDistance) {
                            closestDistance = overlapDistance;
                            // tested and works with distance 0
                            regenerationChance = Math.min(Math.log((imageSizes * 2) / distance), 0.95);
                        }
                    }

                    if(closestDistance > biggestNearestNeighborDistance) {
                        x = generatedX;
                        y = generatedY;
                        biggestNearestNeighborDistance = closestDistance;
                    }

                    if(regenerationChance <= Math.random()) break;
                }

                emojiPlaces.push([x, y, halfImageSize]);

                drawWithRandomTilt(ctx, image, x, y, width, height);
            }
        }

        while(imageCache.size >= ImageCacheSize) {
            imageCache.delete(imageCache.keys().next().value);
        }

        const centerX = canvas.width / 2;
        const offsetY = canvas.height / 2 - (20 * (textParts.length - 1));
        for (let i = 0; i < textParts.length; i++) {
            const textPart = textParts[i];
            const posY = offsetY + i * 40;
            
            ctx.strokeText(textPart, centerX, posY, canvas.width);
            ctx.fillText(textPart, centerX, posY, canvas.width);
        }

        canvas.toBlob(blob => {
            if(mentions.messageReference) {
                const referencedMessage = MessageCache.getMessage(mentions.messageReference.channel_id, mentions.messageReference.message_id);
                const referencedChannel = ChannelStore.getChannel(mentions.messageReference.channel_id);

                if(referencedMessage && referencedChannel) {
                    PendingReplyDispatcher.createPendingReply({
                        message: referencedMessage,
                        channel: referencedChannel,
                        shouldMention: mentions.allowedMentions?.replied_user != false,
                        showMentionToggle: true
                    });
                }
            }

            FileUploader.upload({ channelId, file: blob, draftType: 0, message, hasSpoiler: false, filename: `${textParts[0] || "EmojiParty"}.png` })
        });
    }

    sendMessageHook = function(channelId, message, waitForReadyState, mentions) {
        let tryToProcess = true;
        if(ChannelStore && UserStore && PermissionEvaluator) {
            let channel = ChannelStore.getChannel(channelId);
            if(channel.type !== /*DM*/1 && channel.type !== /*GROUP_DM*/3) {
                let currentUser = UserStore.getCurrentUser();
                tryToProcess = PermissionEvaluator.can({ permission: 0x8000n/*ATTACH_FILES*/, user: currentUser, context: channel });
            }
        }

        if(tryToProcess) {

            const messageParts = ParserModule.parseToAST(message.content, true, { channelId });
            let emojiCount = 0;
            for (const messagePart of messageParts) {
                const type = messagePart.type;
                if( (type === 'emoji' && messagePart.src) ||
                    type === 'customEmoji' ||
                    (type === 'link' && EmojiUrlRegex.test(messagePart.target))) {

                        emojiCount++;
                    }
            }

            if(emojiCount >= TriggerEmojiCount || message.invalidEmojis.length !== 0 || message.validNonShortcutEmojis.some(x => !x.available)) {

                return new Promise(resolve => {
                    renderUploadEmojiParty(channelId, message, messageParts, mentions, Discord.original_sendMessage.bind(this, ...arguments))
                        .then(resolve)
                        .catch((e) => { Utils.Error(e); resolve(); });
                });
            }
        }

        return Discord.original_sendMessage.apply(this, arguments);
    }

    useEmojiSelectHandlerHook = function(args) {
        const { onSelectEmoji, closePopout } = args;
        const originalHandler = original_useEmojiSelectHandler.apply(this, arguments);

        return function(data, state) {
            if(state.toggleFavorite)
                return originalHandler.apply(this, arguments);

            const emoji = data.emoji;

            if(emoji != null) {
                onSelectEmoji(emoji, state.isFinalSelection);
                if(state.isFinalSelection) closePopout();
            }
        };
    };
}

function Stop() {
    if(!Initialized) return;

    sendMessageHook = Discord.original_sendMessage;
    useEmojiSelectHandlerHook = Discord.original_useEmojiSelectHandler;
}

return function() { return {
    getName: () => "DiscordEmojiParty",
    getShortName: () => "EmojiParty",
    getDescription: () => "Create a nice image from your emojis! You can include some text optionally too!",
    getVersion: () => "1.3",
    getAuthor: () => "An0",

    start: Start,
    stop: Stop
}};

})();

module.exports = EmojiParty;

/*@end @*/
