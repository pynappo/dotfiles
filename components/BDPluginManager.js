'use strict'

const electron = require('electron')
const process = require('process')
const path = require('path')
const fs = require('fs')
const { Module } = require('module')

Module.globalPaths.push(path.resolve(electron.remote.app.getAppPath(), 'node_modules'))


class BDPluginManager {
  constructor () {
    this.currentWindow = electron.remote.getCurrentWindow()
    this.currentWindow.webContents.on('did-navigate-in-page', () => this.onSwitchListener())

    // DevilBro's plugins checks whether or not it's running on ED
    // This isn't BetterDiscord, so we'd be better off doing this.
    // eslint-disable-next-line no-process-env
    process.env.injDir = __dirname

    // Wait for jQuery, then load the plugins
    window.BdApi.linkJS('jquery', '//ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js')
      .then(() => {
        this.__log('Loaded jQuery')
        this.loadAllPlugins()
        this.startAllEnabledPlugins()
      })
  }

  get pluginDirectory () {
    const pluginDir = path.join(__dirname, '..', 'plugins/')

    if (!fs.existsSync(pluginDir)) fs.mkdirSync(pluginDir)

    return pluginDir
  }

  destroy () {
    window.BdApi.unlinkJS('jquery')
    this.currentWindow.webContents.off('did-navigate-in-page', () => this.onSwitchListener())

    this.stopAllPlugins()

    // eslint-disable-next-line no-process-env
    process.env.injDir = ''
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
      plugin.start()
      plugin.__started = true
      this.__log(`Started plugin ${plugin.getName()}`)
    } catch (err) {
      this.__error(err, `Could not start ${plugin.getName()}`)
      window.BdApi.saveData('BDCompat-EnabledPlugins', plugin.getName(), false)
    }
  }
  stopPlugin (pluginName) {
    const plugin = window.bdplugins[pluginName]
    if (!plugin) return this.__error(null, `Tried to stop a missing plugin: ${pluginName}`)

    if (!plugin.__started) return

    try {
      plugin.stop()
      plugin.__started = false
      this.__log(`Stopped plugin ${plugin.getName()}`)
    } catch (err) {
      this.__error(err, `Could not stop ${plugin.getName()}`)
      window.BdApi.saveData('BDCompat-EnabledPlugins', plugin.getName(), false)
    }
  }

  enablePlugin (pluginName) {
    const plugin = window.bdplugins[pluginName]
    if (!plugin) return this.__error(null, `Tried to enable a missing plugin: ${pluginName}`)

    window.BdApi.saveData('BDCompat-EnabledPlugins', plugin.getName(), true)
    this.startPlugin(pluginName)
  }
  disablePlugin (pluginName) {
    const plugin = window.bdplugins[pluginName]
    if (!plugin) return this.__error(null, `Tried to disable a missing plugin: ${pluginName}`)

    window.BdApi.saveData('BDCompat-EnabledPlugins', plugin.getName(), false)
    this.stopPlugin(pluginName)
  }

  loadAllPlugins () {
    const plugins = fs.readdirSync(this.pluginDirectory)
      .filter((pluginFile) => pluginFile.endsWith('.plugin.js'))
      .map((pluginFile) => pluginFile.slice(0, -('.plugin.js'.length)))

    plugins.forEach((pluginName) => this.loadPlugin(pluginName))
  }
  loadPlugin (pluginName) {
    const pluginPath = path.join(this.pluginDirectory, `${pluginName}.plugin.js`)
    if (!fs.existsSync(pluginPath)) return this.__error(null, `Tried to load a nonexistant plugin: ${pluginName}`)

    let content = fs.readFileSync(pluginPath, 'utf8')
    if (content.charCodeAt(0) === 0xFEFF) content = content.slice(1)

    const meta = this.extractMeta(content)
    content += `\nmodule.exports = ${meta.name};`

    const tempPluginPath = path.join(this.pluginDirectory, `__${pluginName}.plugin.js`)
    fs.writeFileSync(tempPluginPath, content)

    // eslint-disable-next-line global-require
    const Plugin = require(tempPluginPath)
    const plugin = new Plugin
    plugin.__meta = meta
    plugin.__filePath = pluginPath

    if (window.bdplugins[plugin.getName()]) window.bdplugins[plugin.getName()].stop()
    delete window.bdplugins[plugin.getName()]
    window.bdplugins[plugin.getName()] = plugin

    if (plugin.load && typeof plugin.load === 'function')
      try {
        plugin.load()
      } catch (err) {
        this.__error(err, `Failed to preload ${plugin.getName()}`)
      }


    this.__log(`Loaded ${plugin.getName()} v${plugin.getVersion()} by ${plugin.getAuthor()}`)
    fs.unlinkSync(tempPluginPath)
    delete require.cache[require.resolve(tempPluginPath)]
  }

  extractMeta (content) {
    const metaLine = content.split('\n')[0]
    const rawMeta = metaLine.substring(metaLine.lastIndexOf('//META') + 6, metaLine.lastIndexOf('*//'))

    if (metaLine.indexOf('META') < 0) throw new Error('META was not found.')
    if (!window.BdApi.testJSON(rawMeta)) throw new Error('META could not be parsed')

    const parsed = JSON.parse(rawMeta)
    if (!parsed.name) throw new Error('META missing name data')

    return parsed
  }

  deletePlugin (pluginName) {
    const plugin = window.bdplugins[pluginName]
    if (!plugin) return this.__error(null, `Tried to delete a missing plugin: ${pluginName}`)

    this.disablePlugin(pluginName)
    if (typeof plugin.unload === 'function') plugin.unload()
    delete window.bdplugins[pluginName]

    fs.unlinkSync(plugin.__filePath)
  }


  fireEvent (event, ...args) {
    for (const plug in window.bdplugins) {
      const plugin = window.bdplugins[plug]
      if (!plugin[event] || typeof plugin[event] !== 'function') continue

      try {
        plugin[event](...args)
      } catch (err) {
        this.__error(err, `Could not fire ${event} event for ${plugin.name}`)
      }
    }
  }

  onSwitchListener () {
    this.fireEvent('onSwitch')
  }


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

module.exports = BDPluginManager
