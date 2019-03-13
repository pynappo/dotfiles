# Notes on incompatibiltiies

- Regarding monkey patching
  - Some plugins, especially those that uses their own plugin library, patches Discord's functions, and if it's not done through BD's API for monkey patching then it can lead to breakages.
  - One notable note is with [DevilBro's plugins](https://github.com/mwittrien/BetterDiscordAddons), the library used in his plugins tries to patch method responsible for handling the guild header, and thus it breaks some plugins like Powercord's Badges plugin (`pc-badges`)

- Plugins that enhances BetterDiscord's emotes feature
  - Affects plugins like EmoteSearch
  - No, they don't work. Why? Go figure.
