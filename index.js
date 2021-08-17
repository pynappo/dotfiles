const { React, getModule, contextMenu: { openContextMenu, closeContextMenu } } = require('powercord/webpack');
const { inject, uninject } = require('powercord/injector');
const { findInReactTree } = require('powercord/util');
const { Plugin } = require('powercord/entities');
const { clipboard } = require('electron');

const ContextMenu = getModule(['MenuGroup', 'MenuItem'], false);
const Banner = getModule(m => m.default?.displayName == 'UserBanner', false);
const { header, avatar } = getModule(['discriminator', 'header'], false);
const Avatar = getModule(['AnimatedAvatar'], false);

module.exports = class ProfilePictureLink extends Plugin {
   startPlugin() {
      this.loadStylesheet('style.css');
      inject('pfp-link-profile', Avatar, 'default', (args, res) => {
         if (res.props?.className?.includes?.(avatar)) {
            res.props.className = [res.props.className, 'picture-link'].join(' ');

            res.props.onClick = (v) => {
               if (v.target.parentElement.classList.contains(header)) {
                  open(args[0].src?.replace(/(?:\?size=\d{3,4})?$/, '?size=4096'));
               }
            };

            res.props.onContextMenu = (e) => {
               return openContextMenu(e, () =>
                  React.createElement(ContextMenu.default, { onClose: closeContextMenu },
                     React.createElement(ContextMenu.MenuItem, {
                        label: 'Copy Avatar URL',
                        id: 'copy-avatar-url',
                        action: () => clipboard.writeText(args[0].src?.replace(/(?:\?size=\d{3,4})?$/, '?size=4096'))
                     })
                  )
               );
            };
         }

         return res;
      });

      inject('pfp-link-banner', Banner, 'default', (args, res) => {
         let handler = findInReactTree(res.props.children, p => p.onClick);
         let image = args[0].user?.bannerURL;
         if (!handler?.children && image) {
            res.props.onClick = () => {
               open(image.replace(/(?:\?size=\d{3,4})?$/, '?size=4096'));
            };

            res.props.onContextMenu = (e) => {
               return openContextMenu(e, () =>
                  React.createElement(ContextMenu.default, { onClose: closeContextMenu },
                     React.createElement(ContextMenu.MenuItem, {
                        label: 'Copy Banner URL',
                        id: 'copy-banner-url',
                        action: () => clipboard.writeText(image.replace(/(?:\?size=\d{3,4})?$/, '?size=4096'))
                     })
                  )
               );
            };

            res.props.className = [res.props.className, 'picture-link'].join(' ');
         }

         return res;
      });

      Banner.default.displayName = 'UserBanner';
   }

   pluginWillUnload() {
      uninject('pfp-link-banner');
      uninject('pfp-link-profile');
   }
};