const { existsSync, mkdirSync, readFileSync } = require('fs')
const { join, dirname, resolve, basename } = require('path')
const { Module } = require('module')
const originalRequire = Module._extensions['.js']
let _this

// Purposefully incomplete ContentManager
module.exports = class ContentManager {
  constructor() {
    _this = this
    Module._extensions['.js'] = this.getContentRequire()
  }

  destroy() {
    Module._extensions['.js'] = originalRequire
  }

  get pluginsFolder() {
    const pluginDir = join(__dirname, '..', 'plugins')

    if (!existsSync(pluginDir)) mkdirSync(pluginDir)

    return pluginDir
  }

  get themesFolder() {
    // We'll just pretend it exists.
    return join(ContentManager.pluginsFolder, '..', 'themes')
  }

  extractMeta(content) {
    const firstLine = content.split("\n")[0]
    const hasOldMeta = firstLine.includes("//META")
    if (hasOldMeta) return this.parseOldMeta(content)
    const hasNewMeta = firstLine.includes("/**")
    if (hasNewMeta) return this.parseNewMeta(content)
    throw new Error('META was not found.')
  }

  parseOldMeta(content) {
    const metaLine = content.split('\n')[0]
    const rawMeta = metaLine.substring(metaLine.lastIndexOf('//META') + 6, metaLine.lastIndexOf('*//'))

    if (metaLine.indexOf('META') < 0) throw new Error('META was not found.')
    if (!window.BdApi.testJSON(rawMeta)) throw new Error('META could not be parsed')

    const parsed = JSON.parse(rawMeta)
    if (!parsed.name) throw new Error('META missing name data')
    parsed.format = "json"

    return parsed
  }

  // https://github.com/rauenzi/BetterDiscordApp/blob/master/js/main.js#L1429
  parseNewMeta(content) {
    const block = content.split("/**", 2)[1].split("*/", 1)[0]
    const out = {}
    let field = "", accum = ""
    for (const line of block.split(/[^\S\r\n]*?(?:\r\n|\n)[^\S\r\n]*?\*[^\S\r\n]?/)) {
      if (line.length === 0) continue
      if (line.charAt(0) === "@" && line.charAt(1) !== " ") {
        out[field] = accum
        const l = line.indexOf(" ")
        field = line.substr(1, l - 1)
        accum = line.substr(l + 1)
      } else {
        accum += " " + line.replace("\\n", "\n").replace(escapedAtRegex, "@")
      }
    }
    out[field] = accum.trim()
    delete out[""]
    out.format = "jsdoc"
    return out
  }

  getContentRequire() {
    return function(module, filename) {
      if (!filename.endsWith('.plugin.js') ||
        dirname(filename) !== resolve(bdConfig.dataPath, 'plugins'))
        return originalRequire.apply(this, arguments)

      let content = readFileSync(filename, 'utf8');
      if (content.charCodeAt(0) === 0xFEFF) content = content.slice(1) // Strip BOM
      const meta = _this.extractMeta(content)
      meta.filename = basename(filename)
      module._compile(content, filename)
      if (!module.exports ||
        (typeof module.exports === 'object' &&
        !Object.keys(module.exports).length)) {
        content += `\nmodule.exports = ${JSON.stringify(meta)}; module.exports.type = ${meta.name}`
        module._compile(content, filename)
      } else {
        meta.type = module.exports
        module.exports = meta
      }
    }
  }
}
