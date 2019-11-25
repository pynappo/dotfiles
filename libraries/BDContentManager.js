const path = require('path')

// Purposefully incomplete ContentManager
class ContentManager {
  static get pluginsFolder () {
    return window.powercord.pluginManager.plugins.get('bdCompat').PluginManager.pluginDirectory
  }
  static get themesFolder () {
    // We'll just pretend it exists.
    return path.join(ContentManager.pluginsFolder, '..', 'themes')
  }

  static get extractMeta () {
    return window.powercord.pluginManager.plugins.get('bdCompat').PluginManager.extractMeta
  }
}

module.exports = ContentManager