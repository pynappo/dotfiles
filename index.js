const { Plugin } = require('powercord/entities');
const { React, getModule } = require('powercord/webpack');
const { AnimatedAvatar } = getModule(['AnimatedAvatar'], false);

module.exports = class ProfilePictureLink extends Plugin {
   startPlugin() {
      this.original = AnimatedAvatar.type;
      AnimatedAvatar.type = (props) => {
         try {
            const node = this.original(props).type(props);
            node.props.onClick = v => {
               if (v.target.parentElement.classList.contains("header-QKLPzZ")) {
                  window.open(props.src.replace(/(?:\?size=\d{3,4})?$/, "?size=4096"), "_blank");
               }
            };
            return node;
         } catch { }
         return React.createElement(this.original, props);
      };
   }

   pluginWillUnload() {
      AnimatedAvatar.type = this.original;
   }
};