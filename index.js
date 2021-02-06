const { Plugin } = require('powercord/entities');
const { React, getModule } = require('powercord/webpack');
const { AnimatedAvatar } = getModule(['AnimatedAvatar'], false);

module.exports = class ProfilePictureLink extends Plugin {
   startPlugin() {
      this.original = AnimatedAvatar.type;
      AnimatedAvatar.type = function (props) {
         try {
            const node = AnimatedAvatar(props).type(props);
            node.props.onClick = v => {
               if (v.target.parentElement.classList.contains("header-QKLPzZ")) {
                  window.open(props.src.replace(/(?:\?size=\d{3,4})?$/, "?size=4096"), "_blank");
               }
            };
            return node;
         } catch { }
         return React.createElement(AnimatedAvatar, props);
      };

      this.cancel = () => AnimatedAvatar.type = this.original;
   }

   pluginWillUnload() {
      this.cancel && this.cancel();
   }
};