const { Plugin } = require('powercord/entities');
const { inject, uninject } = require('powercord/injector');
const { React, getModule } = require('powercord/webpack');
const { findInReactTree } = require('powercord/util');

const Banner = getModule(m => m.default?.displayName == 'UserBanner', false);
const { header, avatar } = getModule(['avatar', 'header', 'nameTag'], false);
const { AnimatedAvatar } = getModule(['AnimatedAvatar'], false);

module.exports = class ProfilePictureLink extends Plugin {
   startPlugin() {
      this.loadStylesheet('style.css');
      this.original = AnimatedAvatar.type;
      AnimatedAvatar.type = (props) => {
         try {
            const node = this.original(props).type(props);
            const className = node.props.className;
            if (className?.includes(avatar)) {
               node.props.className += ' picture-link';
            }

            node.props.onClick = v => {
               if (v.target.parentElement.classList.contains(header)) {
                  open(props.src.replace(/(?:\?size=\d{3,4})?$/, '?size=4096'));
               }
            };

            return node;
         } catch { }
         return React.createElement(this.original, props);
      };

      inject('pfp-link-banner', Banner, 'default', (args, res) => {
         let handler = findInReactTree(res.props.children, p => p.onClick);
         let image = res.props.style?.backgroundImage?.replace('url(', '')?.replace(')', '');
         if (!handler?.children && image) {
            res.props.onClick = () => {
               open(image.replace(/(?:\?size=\d{3,4})?$/, '?size=4096'));
            };
         }

         return res;
      });

      Banner.default.displayName = 'UserBanner';
   }

   pluginWillUnload() {
      AnimatedAvatar.type = this.original;
      uninject('pfp-link-banner');
   }
};