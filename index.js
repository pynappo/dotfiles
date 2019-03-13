'use strict'

const Plugin = require('powercord/Plugin')
const path = require('path')

const BDApi = require('./BDApi.js')
const BDPluginManager = require('./BDPluginManager.js')
const Settings = require('./components/Settings.jsx')


class BDCompat extends Plugin {
  start () {
    this.loadCSS(path.join(__dirname, 'style.css'))
    this.defineGlobals()

    this.PluginManager = new BDPluginManager

    powercord.pluginManager
      .get('pc-settings')
      .register('pc-bdCompat', 'BetterDiscord Plugins', Settings)
  }

  unload () {
    this.PluginManager.destroy()

    this.unloadCSS()
    this.destroyGlobals()

    powercord.pluginManager
      .get('pc-settings')
      .unregister('pc-bdCompat')
  }

  defineGlobals () {
    window.bdConfig = { dataPath: __dirname }
    window.settingsCookie = {}

    window.bdplugins = {}
    window.pluginCookie = {}
    window.bdpluginErrors = []

    window.bdthemes = {}
    window.themeCookie = {}
    window.bdthemeErrors = []

    window.BdApi = BDApi
    window.bdPluginStorage = { get: BDApi.getData, set: BDApi.setData }
    window.Utils = { monkeyPatch: BDApi.monkeyPatch, suppressErrors: BDApi.suppressErrors, escapeID: BDApi.escapeID }

    window.BDV2 = class V2 {
      static get WebpackModules () {
        return {
          find: BDApi.findModule,
          findAll: BDApi.findAllModules,
          findByUniqueProperties: BDApi.findModuleByProps,
          findByDisplayName: BDApi.findModuleByDisplayName,
        }
      }
      static get react () {
        return BDApi.React
      }
      static get reactDom () {
        return BDApi.ReactDOM
      }
      static getInternalInstance (node) {
        return BDApi.getInternalInstance(node)
      }
    }

    this.log('Defined BetterDiscord globals')
  }

  destroyGlobals () {
    delete window.bdConfig
    delete window.settingsCookie
    delete window.bdplugins
    delete window.pluginCookie
    delete window.bdpluginErrors
    delete window.bdthemes
    delete window.themeCookie
    delete window.bdthemeErrors
    delete window.BdApi
    delete window.bdPluginStorage
    delete window.Utils
    delete window.BDV2

    this.log('Destroyed BetterDiscord globals')
  }
}

module.exports = BDCompat
