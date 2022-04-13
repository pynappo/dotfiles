const { inject, uninject } = require('powercord/injector');
const { findInReactTree } = require('powercord/util');
const { getModule } = require('powercord/webpack');
const { Plugin } = require('powercord/entities');

module.exports = class DoubleClickVc extends Plugin {
   async startPlugin() {
      const ChannelItem = getModule(m => m.default?.displayName === 'ChannelItem', false);
      inject('double-click-vc', ChannelItem, 'default', ([{ channel }], res) => {
         if (channel.type !== 2) return res;

         const clickable = findInReactTree(res, r => r?.onClick);
         if (clickable) {
            const onClick = clickable.onClick;
            clickable.onDoubleClick = onClick;
            clickable.onClick = () => { };
         }

         return res;
      });

      ChannelItem.default.displayName = 'ChannelItem';

      const Mention = getModule(m => m.default?.displayName === 'Mention', false);
      inject('double-click-vc-mention', Mention, 'default', ([{ iconType }], res) => {
         if (iconType === 'voice') {
            const onClick = res.props.onClick;
            res.props.onClick = () => { };
            res.props.onDoubleClick = onClick;
         }

         return res;
      });

      Mention.default.displayName = 'Mention';
   }

   pluginWillUnload() {
      uninject('double-click-vc');
      uninject('double-click-vc-mention');
   }
};