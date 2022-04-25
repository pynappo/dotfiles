/**
 * @name QuickView
 * @author Qwerasd
 * @description View icons, banners, and custom emojis with alt + click.
 * @version 0.1.4
 * @authorId 140188899585687552
 * @updateUrl https://betterdiscord.app/gh-redirect?id=644
 */
Object.defineProperty(exports, "__esModule", { value: true });
// Bruh Discord cannot decide where to put LazyImageZoomable,
// so I'm just gonna have both methods in case they switch again.
const LazyImageZoomable = BdApi.findModuleByProps('LazyImageZoomable')?.LazyImageZoomable
    ?? BdApi.findModuleByDisplayName('LazyImageZoomable');
// we keep a single LazyImageZoomable around and just change its props whenever
// we need to get it to trigger a specific image modal
const instance = new (LazyImageZoomable.bind({ stateNode: {} }))({ renderLinkComponent: p => BdApi.React.createElement('a', p) });
const UserProfileModalHeader_module = BdApi.findModule(m => m.default?.displayName === 'UserProfileModalHeader');
const UserBanner_module = BdApi.findModule(m => m.default?.displayName === 'UserBanner');
const NavItem_module = BdApi.findModule(m => m.default?.displayName === 'NavItem');
const ConnectedAnimatedEmoji_module = BdApi.findModule(m => m.default?.displayName === 'ConnectedAnimatedEmoji');
const GuildBanner_module = BdApi.findModuleByProps('AnimatedBanner');
const UserPopoutAvatar_module = BdApi.findModuleByProps('UserPopoutAvatar');
const AnimatedAvatar_module = BdApi.findModuleByProps('AnimatedAvatar');
const MessageHeader_module = BdApi.findModule(m => m.default?.displayName === 'MessageHeader');
const Embed_module = BdApi.findModuleByDisplayName('Embed');
const { bannerPremium } = BdApi.findModuleByProps('bannerPremium');
const { hasBanner } = BdApi.findModuleByProps('animatedContainer', 'hasBanner');
const { embedAuthorIcon } = BdApi.findModuleByProps('embedAuthorIcon');
const { bannerImg } = BdApi.findModuleByProps('bannerImg');
const { avatar: chat_avatar } = BdApi.findModuleByProps('avatar', 'username', 'zalgo');
const { avatar: popout_avatar } = BdApi.findModuleByProps('avatar', 'nickname', 'clickable');
const { avatar: modal_avatar } = BdApi.findModuleByProps('avatar', 'header', 'badgeList') ?? { avatar: 'avatar-3QF_VA' }; // REEE discord lazy loading modules now ;-;
const { blobContainer: server } = BdApi.findModuleByProps('blobContainer', 'pill');
const { emojiContainer } = BdApi.findModule(m => m.emojiContainer && Object.keys(m).length === 1);
const { reactionInner } = BdApi.findModuleByProps('reactionInner');
const { getEmojiURL } = BdApi.findModuleByProps('getEmojiURL');
class QuickView {
    start() {
        BdApi.injectCSS('QuickView', /*CSS*/ `
            .${hasBanner} { z-index: 10; }

            .${embedAuthorIcon} { cursor: zoom-in; }
            .${bannerImg}       { cursor: zoom-in; }
            .${bannerPremium}   { cursor: zoom-in; }
            .${modal_avatar}    { cursor: zoom-in; }

            body.quickview-alt-key .${chat_avatar}   { cursor: zoom-in; }
            body.quickview-alt-key .${popout_avatar} { cursor: zoom-in; }
            body.quickview-alt-key .${server} div    { cursor: zoom-in; }

            body.quickview-alt-key :is(.${emojiContainer}, .${reactionInner}) img:not([src^="/"]) { cursor: zoom-in; }
        `);
        this.add_patches();
        document.addEventListener('mousemove', this.alt_tracker);
        document.addEventListener('keydown', this.alt_tracker);
        document.addEventListener('keyup', this.alt_tracker);
    }
    alt_tracker(e) {
        if (e.altKey) {
            document.body.classList.add('quickview-alt-key');
        }
        else {
            document.body.classList.remove('quickview-alt-key');
        }
    }
    add_patches() {
        BdApi.Patcher.after('QuickView', UserProfileModalHeader_module, 'default', (_, [props], ret) => {
            const avatar_container_props = ret.props.children[1].props.children[0].props;
            const avatar_props = avatar_container_props.children.props;
            const max_size = avatar_props.src.slice(0, avatar_props.src.indexOf('?')) + '?size=4096';
            avatar_container_props.onClick = () => {
                this.open_modal(max_size, 4096, 4096, avatar_props.src);
            };
        });
        BdApi.Patcher.after('QuickView', UserBanner_module, 'default', (that, [props], ret) => {
            if (props.user.banner) {
                const banner_url = ret.props.style.backgroundImage.slice(4, -1);
                return (BdApi.React.createElement("span", { onClick: (e) => {
                        if (!e.target.classList.contains(bannerPremium))
                            return;
                        this.open_modal(banner_url.slice(0, banner_url.indexOf('?')) + '?size=4096', 4096, 1638, banner_url);
                    } }, ret));
            }
        });
        BdApi.Patcher.after('QuickView', GuildBanner_module.default, 'type', (that, [props], ret) => {
            if (props.guildBanner) {
                ret.props.children[0].props.children[1] = (BdApi.React.createElement("span", { onClick: (e) => {
                        e.stopPropagation();
                        const el = e.target;
                        const banner_url = el.currentSrc;
                        this.open_modal(banner_url.slice(0, banner_url.indexOf('?')) + '?size=4096', el.naturalWidth, el.naturalHeight, banner_url);
                    } }, ret.props.children[0].props.children[1]));
            }
        });
        BdApi.Patcher.after('QuickView', UserPopoutAvatar_module, 'UserPopoutAvatar', (that, [props], ret) => {
            const original_click = ret.props.children.props.onClick.bind(ret.props.children.props);
            ret.props.children.props.onClick = (e) => {
                if (e.altKey) {
                    const avatar_url = ret.props.children.props.children[0].props.children.props.src;
                    this.open_modal(avatar_url.slice(0, avatar_url.indexOf('?')) + '?size=4096', 4096, 4096, avatar_url);
                }
                else {
                    original_click(e);
                }
            };
        });
        BdApi.Patcher.after('QuickView', AnimatedAvatar_module, 'default', (that, [props], ret) => {
            const original_click = ret.props.onClick?.bind(ret.props) ?? (() => { });
            ret.props.onClick = (e) => {
                if (e.altKey) {
                    e.stopPropagation();
                    const avatar_url = props.src;
                    this.open_modal(avatar_url.slice(0, avatar_url.indexOf('?')) + '?size=4096', 4096, 4096, avatar_url);
                }
                else {
                    original_click(e);
                }
            };
        });
        BdApi.Patcher.after('QuickView', NavItem_module, 'default', (that, [props], ret) => {
            if (!props.icon)
                return;
            const original_mouseDown = ret.props.onMouseDown?.bind(props) ?? (() => { });
            ret.props.onMouseDown = (e) => {
                if (e.altKey) {
                    const icon_url = props.icon;
                    this.open_modal(icon_url.slice(0, icon_url.indexOf('?')) + '?size=4096', 4096, 4096, icon_url);
                }
                else {
                    original_mouseDown(e);
                }
            };
        });
        BdApi.Patcher.before('QuickView', MessageHeader_module, 'default', (that, [props], ret) => {
            const original_click = props.onClickAvatar?.bind(props) ?? (() => { });
            props.onClickAvatar = (e) => {
                if (e.altKey) {
                    e.stopPropagation();
                    const avatar_url = e.target.src;
                    this.open_modal(avatar_url.slice(0, avatar_url.indexOf('?')) + '?size=4096', 4096, 4096, avatar_url);
                }
                else {
                    original_click(e);
                }
            };
        });
        BdApi.Patcher.after('QuickView', ConnectedAnimatedEmoji_module, 'default', (that, [props], ret) => {
            const original_onClick = ret.props.onClick?.bind(ret.props) || (() => { });
            ret.props.onClick = (e) => {
                if (e.altKey) {
                    e.stopPropagation();
                    if (!props.emojiId)
                        return;
                    const emoji_url = getEmojiURL({ id: props.emojiId, animated: props.animated, size: 48 });
                    const { naturalWidth, naturalHeight } = e.target;
                    const maxDimension = Math.max(naturalWidth, naturalHeight);
                    this.open_modal(emoji_url.slice(0, emoji_url.indexOf('?')) + '?size=4096', (naturalWidth / maxDimension) * 4096, (naturalHeight / maxDimension) * 4096, emoji_url);
                }
                else {
                    original_onClick(e);
                }
            };
        });
        BdApi.Patcher.after('QuickView', Embed_module.prototype, 'renderAuthor', (that, [props], ret) => {
            if (!ret)
                return;
            const img = ret.props.children[0];
            if (!img)
                return;
            img.props.onClick = (e) => {
                const el = e.target;
                this.open_modal(el.src, el.naturalWidth, el.naturalHeight, el.src);
            };
        });
    }
    open_modal(src, width, height, placeholder = src, animated = false) {
        Object.assign(instance.props, {
            src, width, height, animated, shouldAnimate: true
        });
        instance.onZoom(new Event(''), { placeholder });
    }
    stop() {
        BdApi.clearCSS('QuickView');
        BdApi.Patcher.unpatchAll('QuickView');
        document.removeEventListener('mousemove', this.alt_tracker);
        document.removeEventListener('keydown', this.alt_tracker);
        document.removeEventListener('keyup', this.alt_tracker);
    }
}
exports.default = QuickView;
