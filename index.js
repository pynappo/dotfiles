const { React, getModule, contextMenu: { openContextMenu, closeContextMenu } } = require('powercord/webpack');
const { inject, uninject } = require('powercord/injector');
const { findInReactTree } = require('powercord/util');
const { Menu } = require('powercord/components');
const { Plugin } = require('powercord/entities');
const { clipboard } = require('electron');

const SizeRegex = /(?:\?size=\d{3,4})?$/;

module.exports = class PictureLink extends Plugin {
   startPlugin() {
      this.loadStylesheet('style.css');
      this.promises = { cancelled: false };

      this.patchAvatars();
      this.patchBanners();
   }

   async patchAvatars() {
      const ProfileModalHeader = await this.findLazy(m => m.default?.displayName == 'UserProfileModalHeader');
      const classes = getModule(['relationshipButtons'], false);
      if (this.promises.cancelled) return;

      inject('pfp-link-profile', ProfileModalHeader, 'default', (args, res) => {
         const avatar = findInReactTree(res, m => m?.props?.className == classes.avatar);
         const image = args[0].user?.getAvatarURL?.(false, 4096, true)?.replace('.webp', '.png');

         if (avatar && image) {
            avatar.props.onClick = () => open(image);

            avatar.props.onContextMenu = (e) => openContextMenu(e, () =>
               React.createElement(Menu.Menu, { onClose: closeContextMenu },
                  React.createElement(Menu.MenuItem, {
                     label: 'Copy Avatar URL',
                     id: 'copy-avatar-url',
                     action: () => clipboard.writeText(image)
                  })
               )
            );
         }

         return res;
      });

      ProfileModalHeader.default.displayName = 'UserProfileModalHeader';
   }

   async patchBanners() {
      const Banner = getModule(m => m.default?.displayName == 'UserBanner', false);
      const Banners = getModule(['getUserBannerURL'], false);

      inject('pfp-link-banner', Banner, 'default', (args, res) => {
         const handler = findInReactTree(res.props.children, p => p?.onClick);
         const image = Banners.getUserBannerURL({
            ...args[0].user,
            canAnimate: true
         })?.replace(SizeRegex, '?size=4096')?.replace('.webp', '.png');

         if (!handler?.children && image) {
            res.props.onClick = () => {
               open(image);
            };

            res.props.onContextMenu = (e) => openContextMenu(e, () =>
               React.createElement(Menu.Menu, { onClose: closeContextMenu },
                  React.createElement(Menu.MenuItem, {
                     label: 'Copy Banner URL',
                     id: 'copy-banner-url',
                     action: () => clipboard.writeText(image)
                  })
               )
            );

            res.props.className = [res.props.className, 'picture-link'].join(' ');
         }

         return res;
      });

      Banner.default.displayName = 'UserBanner';
   }

   findLazy(filter) {
      const direct = getModule(filter, false);
      if (direct) return direct;

      const oldPush = window.webpackChunkdiscord_app.push;

      return new Promise(resolve => {
         Object.defineProperty(window.webpackChunkdiscord_app, 'push', {
            configurable: true,
            writable: true,
            value: (chunk) => {
               const [, modules] = chunk;

               for (const id in modules) {
                  const orig = modules[id];

                  modules[id] = (module, exports, require) => {
                     Reflect.apply(orig, null, [module, exports, require]);

                     try {
                        const res = filter(exports);

                        if (res) {
                           window.webpackChunkdiscord_app.push = oldPush;
                           resolve(exports);
                        }
                     } catch { }
                  };

                  Object.assign(modules[id], orig, {
                     toString: () => orig.toString()
                  });
               }

               return Reflect.apply(oldPush, window.webpackChunkdiscord_app, [chunk]);
            }
         });
      });
   }

   pluginWillUnload() {
      this.promises.cancelled = false;
      uninject('pfp-link-banner');
      uninject('pfp-link-profile');
   }
};
