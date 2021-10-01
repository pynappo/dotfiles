const { React, getModule, contextMenu: { openContextMenu, closeContextMenu } } = require('powercord/webpack');
const { inject, uninject } = require('powercord/injector');
const { findInReactTree } = require('powercord/util');
const { Plugin } = require('powercord/entities');
const { clipboard } = require('electron');

const ProfileModalHeader = getModule(m => m.default?.displayName == 'UserProfileModalHeader', false);
const Banner = getModule(m => m.default?.displayName == 'UserBanner', false);
const ContextMenu = getModule(['MenuGroup', 'MenuItem'], false);
const classes = getModule(['discriminator', 'header'], false);

module.exports = class PictureLink extends Plugin {
   startPlugin() {
      this.loadStylesheet('style.css');
      inject('pfp-link-profile', ProfileModalHeader, 'default', (args, res) => {
         const avatar = findInReactTree(res, m => m?.props?.className == classes.avatar);
         const image = args[0].user?.getAvatarURL?.(false, 4096, true)?.replace('.webp', '.png');

         if (avatar && image) {
            avatar.props.onClick = () => open(image);

            avatar.props.onContextMenu = (e) => openContextMenu(e, () =>
               React.createElement(ContextMenu.default, { onClose: closeContextMenu },
                  React.createElement(ContextMenu.MenuItem, {
                     label: 'Copy Avatar URL',
                     id: 'copy-avatar-url',
                     action: () => clipboard.writeText(image)
                  })
               )
            );
         }

         return res;
      });

      inject('pfp-link-banner', Banner, 'default', (args, res) => {
         const handler = findInReactTree(res.props.children, p => p.onClick);
         const image = args[0].user?.getBannerURL?.(4096, true)?.replace('.webp', '.png');

         if (!handler?.children && image) {
            res.props.onClick = () => {
               open(image);
            };

            res.props.onContextMenu = (e) => openContextMenu(e, () =>
               React.createElement(ContextMenu.default, { onClose: closeContextMenu },
                  React.createElement(ContextMenu.MenuItem, {
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

   pluginWillUnload() {
      uninject('pfp-link-banner');
      uninject('pfp-link-profile');
   }
};
