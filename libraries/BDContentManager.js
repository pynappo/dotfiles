const path = require('path')

// Purposefully incomplete ContentManager
class ContentManager {
  get pluginsFolder () {
    return window.powercord.pluginManager.plugins.get('pc-bdCompat').PluginManager.pluginDirectory
  }
  get themesFolder () {
    // We'll just pretend it exists.
    return path.join(ContentManager.pluginsFolder, '..', 'themes')
  }

  get extractMeta () {
    return window.powercord.pluginManager.plugins.get('pc-bdCompat').PluginManager.extractMeta
  }
}

module.exports = ContentManager