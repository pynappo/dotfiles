'use strict'

const { Plugin } = require('powercord/entities')
const path = require('path')

const BDApi = require('./libraries/BDApi.js')
const BDV2 = require('./libraries/BDV2.js')
const BDContentManager = require('./libraries/BDContentManager.js')

const BDPluginManager = require('./components/BDPluginManager.js')
const Settings = require('./reactcomponents/Settings.jsx')


module.exports = class BDCompat extends Plugin {
  startPlugin () {
    this.loadCSS(path.join(__dirname, 'style.css'))
    this.defineGlobals()

    this.registerSettings('bdCompat', 'BetterDiscord Plugins', Settings)
  }

  pluginWillUnload () {
    if (window.PluginModule) window.PluginModule.destroy()
    if (window.ContentManager) window.ContentManager.destroy()
    this.destroyGlobals()
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

    // window.BdApi = BDApi

    // Orignally BdApi is an object, not a class
    window.BdApi = {}
    Object.getOwnPropertyNames(BDApi).filter(m => typeof BDApi[m] == 'function' || typeof BDApi[m] == 'object').forEach(m => {
      window.BdApi[m] = BDApi[m]
    })
    window.bdPluginStorage = { get: BDApi.getData, set: BDApi.setData }
    window.Utils = { monkeyPatch: BDApi.monkeyPatch, suppressErrors: BDApi.suppressErrors, escapeID: BDApi.escapeID }

    window.BDV2 = BDV2
    window.ContentManager = new BDContentManager
    window.PluginModule = new BDPluginManager(window.ContentManager, this.settings)

    this.log('Defined BetterDiscord globals')
  }

  destroyGlobals () {
    const globals = ['bdConfig', 'settingsCookie', 'bdplugins', 'pluginCookie', 'bdpluginErrors', 'bdthemes',
      'themeCookie', 'bdthemeErrors', 'BdApi', 'bdPluginStorage', 'Utils', 'BDV2', 'ContentManager', 'PluginModule']

    globals.forEach(g => {
      delete window[g]
    })

    this.log('Destroyed BetterDiscord globals')
  }
}
