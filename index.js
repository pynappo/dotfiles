const { Plugin } = require('powercord/entities');
const { inject, uninject } = require('powercord/injector');
const { getModuleByDisplayName } = require('powercord/webpack');

module.exports = class DoubleClickVc extends Plugin {
   async startPlugin() {
      const ChannelItem = getModuleByDisplayName('ChannelItem', false);
      inject('double-click-vc', ChannelItem.prototype, 'render', (args, res) => {
         const channel = this.getNestedProp(res, 'props.children.1.props.children.1.props.children.1.props.channel');
         if (channel && channel.type == 2) {
            const props = this.getNestedProp(res, 'props.children.1.props.children.0.props');
            if (props) {
               const onClick = props.onClick;
               props.onDoubleClick = onClick;
               props.onClick = () => { };
            } else {
               this.log('Failed to get nested props.');
            }
         } else if (!channel) {
            this.log('Failed to determine channel type.');
         }

         return res;
      });
   }

   pluginWillUnload() {
      uninject('double-click-vc');
   }

   getNestedProp(obj, path) {
      return path.split('.').reduce(function (obj, prop) {
         return obj && obj[prop];
      }, obj);
   }
};