'use strict'

const electron = require('electron')
const path = require('path')
const fs = require('fs')
const { Module } = require('module')

Module.globalPaths.push(path.resolve(electron.remote.app.getAppPath(), 'node_modules'))

module.exports = class BDPluginManager {
  constructor(ContentManger, settings) {
    this.ContentManger = ContentManger
    this.settings = settings

    this.currentWindow = electron.remote.getCurrentWindow()
    this.currentWindow.webContents.on('did-navigate-in-page', this.channelSwitch = () => this.fireEvent('onSwitch'))

    this.observer = new MutationObserver((mutations) => {
        for (let i = 0, mlen = mutations.length; i < mlen; i++) this.fireEvent('observer', mutations[i])
    })
    this.observer.observe(document, { childList: true, subtree: true })

    // Wait for jQuery, then load the plugins
    window.BdApi.linkJS('jquery', '//ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js')
      .then(() => {
        this.__log('Loaded jQuery')
        this.loadAllPlugins()
        this.startAllEnabledPlugins()
      })
  }

  destroy () {
    window.BdApi.unlinkJS('jquery')
    if (this.channelSwitch) this.currentWindow.webContents.off('did-navigate-in-page', this.channelSwitch)

    this.observer.disconnect()
    this.stopAllPlugins()
  }


  startAllEnabledPlugins () {
    const plugins = Object.keys(window.bdplugins)

    plugins.forEach((pluginName) => {
      if (window.BdApi.loadData('BDCompat-EnabledPlugins', pluginName) === true) this.startPlugin(pluginName)
    })
  }

  stopAllPlugins () {
    const plugins = Object.keys(window.bdplugins)

    plugins.forEach((pluginName) => {
      this.stopPlugin(pluginName)
    })
  }


  isEnabled (pluginName) {
    const plugin = window.bdplugins[pluginName]
    if (!plugin) return this.__error(null, `Tried to access a missing plugin: ${pluginName}`)

    return plugin.__started
  }

  startPlugin (pluginName) {
    const plugin = window.bdplugins[pluginName]
    if (!plugin) return this.__error(null, `Tried to start a missing plugin: ${pluginName}`)

    if (plugin.__started) return

    try {
      plugin.plugin.start()
      plugin.__started = true
      this.__log(`Started plugin ${plugin.plugin.getName()}`)
    } catch (err) {
      this.__error(err, `Could not start ${plugin.plugin.getName()}`)
      window.BdApi.saveData('BDCompat-EnabledPlugins', plugin.plugin.getName(), false)
    }
  }
  stopPlugin (pluginName) {
    const plugin = window.bdplugins[pluginName]
    if (!plugin) return this.__error(null, `Tried to stop a missing plugin: ${pluginName}`)

    if (!plugin.__started) return

    try {
      plugin.plugin.stop()
      plugin.__started = false
      this.__log(`Stopped plugin ${plugin.plugin.getName()}`)
    } catch (err) {
      this.__error(err, `Could not stop ${plugin.plugin.getName()}`)
      if (this.settings.get('disableWhenStopFailed'))
        window.BdApi.saveData('BDCompat-EnabledPlugins', plugin.plugin.getName(), false)
    }
  }
  reloadPlugin (pluginName) {
    const plugin = window.bdplugins[pluginName]
    if (!plugin) return this.__error(null, `Tried to reload a missing plugin: ${pluginName}`)

    this.stopPlugin(pluginName)

    delete window.bdplugins[pluginName]
    delete require.cache[plugin.__filePath]

    this.loadPlugin(pluginName)
    this.startPlugin(pluginName)
  }

  enablePlugin (pluginName) {
    const plugin = window.bdplugins[pluginName]
    if (!plugin) return this.__error(null, `Tried to enable a missing plugin: ${pluginName}`)

    window.BdApi.saveData('BDCompat-EnabledPlugins', plugin.plugin.getName(), true)
    this.startPlugin(pluginName)
  }
  disablePlugin (pluginName) {
    const plugin = window.bdplugins[pluginName]
    if (!plugin) return this.__error(null, `Tried to disable a missing plugin: ${pluginName}`)

    window.BdApi.saveData('BDCompat-EnabledPlugins', plugin.plugin.getName(), false)
    this.stopPlugin(pluginName)
  }

  loadAllPlugins () {
    const plugins = fs.readdirSync(this.ContentManger.pluginsFolder)
      .filter((pluginFile) => pluginFile.endsWith('.plugin.js'))
      .map((pluginFile) => pluginFile.slice(0, -('.plugin.js'.length)))

    plugins.forEach((pluginName) => this.loadPlugin(pluginName))
  }

  loadPlugin(pluginName) {
    const pluginPath = path.join(this.ContentManger.pluginsFolder, `${pluginName}.plugin.js`)
    if (!fs.existsSync(pluginPath)) return this.__error(null, `Tried to load a nonexistant plugin: ${pluginName}`)

    // eslint-disable-next-line global-require
    const meta = require(pluginPath)
    try {
      const plugin = new meta.type
      if (window.bdplugins[plugin.getName()]) window.bdplugins[plugin.getName()].plugin.stop()
      delete window.bdplugins[plugin.getName()]
      window.bdplugins[plugin.getName()] = { plugin, __filePath: pluginPath, ...meta }

      if (plugin.load && typeof plugin.load === 'function')
        try {
          plugin.load()
        } catch (err) {
          this.__error(err, `Failed to preload ${plugin.getName()}`)
        }

      this.__log(`Loaded ${plugin.getName()} v${plugin.getVersion()} by ${plugin.getAuthor()}`)
    } catch (e) {
      this.__error(e, meta)
    }
  }

  delete(pluginName) {
    const plugin = window.bdplugins[pluginName]
    if (!plugin) return this.__error(null, `Tried to delete a missing plugin: ${pluginName}`)

    this.disablePlugin(pluginName)
    if (typeof plugin.plugin.unload === 'function') plugin.plugin.unload()
    delete window.bdplugins[pluginName]

    fs.unlinkSync(plugin.__filePath)
  }

  fireEvent (event, ...args) {
    for (const plug in window.bdplugins) {
      const p = window.bdplugins[plug], { plugin } = p
      if (!p.__started || !plugin[event] || typeof plugin[event] !== 'function') continue

      try {
        plugin[event](...args)
      } catch (err) {
        this.__error(err, `Could not fire ${event} event for ${plugin.name}`)
      }
    }
  }

  disable = this.disablePlugin
  enable  = this.enablePlugin
  reload  = this.reloadPlugin
  

  __log (...message) {
    console.log('%c[BDCompat:BDPluginManager]', 'color: #3a71c1;', ...message)
  }

  __warn (...message) {
    console.log('%c[BDCompat:BDPluginManager]', 'color: #e8a400;', ...message)
  }

  __error (error, ...message) {
    console.log('%c[BDCompat:BDPluginManager]', 'color: red;', ...message)

    if (error) {
      console.groupCollapsed(`%cError: ${error.message}`, 'color: red;')
      console.error(error.stack)
      console.groupEnd()
    }
  }
}
