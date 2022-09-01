/**
 * @name ProProfile
 * @author EhsanDavari
 * @authorId 553139953597677568
 * @version 1.0.3
 * @description  with this plugin : You can copy the user banner (banner color and banner photo) You can copy the user's profile picture You can copy About Me to the user You can also copy the user bio
 * @invite xfvHwqXXKs
 * @website https://www.beheshtmarket.com
 * @source https://github.com/iamehsandvr/ProProfile
 * @updateUrl https://raw.githubusercontent.com/iamehsandvr/ProBanner/main/ProProfile.plugin.js
 */

const request = require("request");
const fs = require("fs");
const path = require("path");

const config = {
  info: {
    name: "ProProfile",
    authors: [
      {
        name: "EhsanDavari",
      },
    ],
    version: "1.0.3",
    description:
      " with this plugin : You can copy the user banner (banner color and banner photo) You can copy the user's profile picture You can copy About Me to the user You can also copy the user bio",
    changelog: [
      {
        title: "Cool Update",
        type: "improved",
        items: [
          "Double-click to copy the server profile",
          "Double-click to copy the server banner ",
          "برای کپی کردن پروفایل سرور دوبار کلیک کنید",
          "برای کپی کردن بنر سرور دوبار کلیک کنید",
        ],
      },
    ],
  },
};

module.exports = !global.ZeresPluginLibrary
  ? class {
      constructor() {
        this._config = config;
      }

      load() {
        BdApi.showConfirmationModal(
          "Library plugin is needed",
          `The library plugin needed for AQWERT'sPluginBuilder is missing. Please click Download Now to install it.`,
          {
            confirmText: "Download",
            cancelText: "Cancel",
            onConfirm: () => {
              request.get(
                "https://rauenzi.github.io/BDPluginLibrary/release/0PluginLibrary.plugin.js",
                (error, response, body) => {
                  if (error)
                    return electron.shell.openExternal(
                      "https://betterdiscord.net/ghdl?url=https://raw.githubusercontent.com/rauenzi/BDPluginLibrary/master/release/0PluginLibrary.plugin.js"
                    );

                  fs.writeFileSync(
                    path.join(BdApi.Plugins.folder, "0PluginLibrary.plugin.js"),
                    body
                  );
                }
              );
            },
          }
        );
      }

      start() {}

      stop() {}
    }
  : (([Plugin, Library]) => {
      const {
        DiscordModules,
        WebpackModules,
        Patcher,
        PluginUtilities,
        Toasts,
      } = Library;
      const { ElectronModule, React } = DiscordModules;
      class plugin extends Plugin {
        constructor() {
          super();
        }
        onStart() {
          this.ProProfile();
        }

        onStop() {
          Patcher.unpatchAll();
        }
        ProProfile() {
          const NameTag = WebpackModules.find(
            (m) => m?.default?.displayName === "NameTag"
          );
          const UserBio = WebpackModules.find(
            (m) => m?.default?.displayName === "UserBio"
          );
          const UserBanner = WebpackModules.find(
            (m) => m?.default?.displayName === "UserBanner"
          );
          const CustomStatus = WebpackModules.find(
            (m) => m?.default?.displayName === "CustomStatus"
          );
          document.addEventListener("dblclick", ({ target }) => {
            if (new RegExp(/guild*/).test(target.dataset.listItemId)) {
              global.ZLibrary.DiscordModules.ElectronModule.copy(
                target.children[0].currentSrc.replace(/([0-9]+)$/, "4096")
              );
              return BdApi.showToast(`Server icon link successfully copied`, {
                type: "success",
              });
            } else if (
              new RegExp(/animatedBannerHoverLayer*/).test(target.className)
            ) {
              global.ZLibrary.DiscordModules.ElectronModule.copy(
                `https://cdn.discordapp.com/banners/${target.__reactFiber$.return.memoizedProps.guild.id}/${target.__reactFiber$.return.memoizedProps.guildBanner}.gif?size=4096`
              );
              return BdApi.showToast(`Server banner link successfully copied`, {
                type: "success",
              });
            } else if (new RegExp(/height:*/).test(target.style.cssText)) {
              var strGuildBanner = document.getElementsByClassName(
                "animatedContainer-2laTjx"
              );
              global.ZLibrary.DiscordModules.ElectronModule.copy(
                strGuildBanner[0].children[0].children[0].currentSrc.replace(
                  /([0-9]+)$/,
                  "4096"
                )
              );
              return BdApi.showToast(`Server icon link successfully copied`, {
                type: "success",
              });
            }
          });
          document.addEventListener("click", ({ target }) => {
            if (
              target.ariaLabel &&
              target.style.cssText &&
              new RegExp(/avatar\-3QF_VA/).test(target.className)
            ) {
              let MemberProfileUrl =
                target.__reactProps$.children.props.children[0].props
                  .children[0].props.children.props.src;
              MemberProfileUrl = new RegExp(/assets/).test(MemberProfileUrl)
                ? `https://discord.com${MemberProfileUrl}`
                : MemberProfileUrl.replace(/([0-9]+)$/, "4096");
              global.ZLibrary.DiscordModules.ElectronModule.copy(
                MemberProfileUrl
              );
              return BdApi.showToast(`User profile image link successfully`, {
                type: "success",
              });
            }
          });
          Patcher.after(NameTag, "default", (_, [props], ret) => {
            ret.props.style = {
              cursor: "pointer",
            };
            ret.props.onClick = (_) => {
              ElectronModule.copy(`${props.name}#${props.discriminator}`);
              Toasts.success(
                `Successfully copied username for <strong>${props.name}</strong>!`
              );
            };
          });
          Patcher.after(UserBanner, "default", (_, [props], ret) => {
            ret.props.onClick = (_) => {
              //let ClassBanner = BdApi.findModuleByProps("banner", "bannerOverlay")
              if (
                _.target.classList.contains("banner-1YaD3N") &&
                _.target.style.backgroundImage
              ) {
                let BannerUrl = _.target.style.backgroundImage;
                BannerUrl = BannerUrl.substring(
                  4,
                  BannerUrl.length - 1
                ).replace(/["']/g, "");
                BannerUrl = BannerUrl.replace(
                  /(?:\?size=\d{3,4})?$/,
                  "?size=4096"
                );
                ElectronModule.copy(BannerUrl);
                return Toasts.success("Banner link was successfully copied");
              } else if (_.target.style.backgroundColor) {
                const ColorCode = _.target.style.backgroundColor;
                var RGBColorCode = ColorCode.replaceAll(
                  /[a-z() ]+/gi,
                  ""
                ).split(",");
                const RGB2HEX = {
                  r: Number(RGBColorCode[0]).toString(16),
                  g: Number(RGBColorCode[1]).toString(16),
                  b: Number(RGBColorCode[2]).toString(16),
                };
                const ColorHexCode =
                  "#" +
                  (RGB2HEX.r.length == 1 ? 0 + RGB2HEX.r : RGB2HEX.r) +
                  (RGB2HEX.g.length == 1 ? 0 + RGB2HEX.g : RGB2HEX.g) +
                  (RGB2HEX.b.length == 1 ? 0 + RGB2HEX.b : RGB2HEX.b);
                ElectronModule.copy(ColorHexCode);
                return Toasts.success(
                  `Hex color code : ${ColorHexCode} was successfully copied`
                );
              }
            };
            document.addEventListener("click", (target) => {
              if (target.ariaLabel && target.style.cssText) {
                let MemberProfileUrl =
                  target.__reactProps$.children.props.children[0].props.children
                    .props.src;
                MemberProfileUrl = new RegExp(/assets/).test(MemberProfileUrl)
                  ? `https://discord.com${MemberProfileUrl}`
                  : MemberProfileUrl.replace(/([0-9]+)$/, "4096");
                global.ZLibrary.DiscordModules.ElectronModule.copy(
                  MemberProfileUrl
                );
                return BdApi.showToast(`User profile image link successfully`, {
                  type: "success",
                });
              }
            });
          });
          Patcher.after(UserBio, "default", (_, [props], ret) => {
            ret.props.style = {
              cursor: "pointer",
            };
            ret.props.onClick = (_) => {
              ElectronModule.copy(props.userBio);
              Toasts.success(`Successfully copied <strong>User Bio</strong>! `);
            };
          });
          Patcher.after(CustomStatus, "default", (_, [props], ret) => {
            ret.props.style = {
              cursor: "pointer",
            };
            ret.props.onClick = (_) => {
              "state" in props.activity && !("emoji" in props.activity)
                ? ElectronModule.copy(`${props.activity.state}`)
                : "emoji" in props.activity && "state" in props.activity
                ? ElectronModule.copy(
                    `${props.activity.emoji.name} ${props.activity.state}`
                  )
                : ElectronModule.copy(`${props.activity.emoji.name}`);
              Toasts.success(
                `Successfully copied <strong>User Status</strong>! `
              );
            };
          });
        }
      }

      return plugin;
    })(global.ZeresPluginLibrary.buildPlugin(config));
