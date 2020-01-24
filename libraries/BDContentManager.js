const { existsSync, mkdirSync } = require('fs')
const { join } = require('path')

// Purposefully incomplete ContentManager
module.exports = class ContentManager {
  static get pluginsFolder() {
    const pluginDir = join(__dirname, '..', 'plugins')

    if (!existsSync(pluginDir)) mkdirSync(pluginDir)

    return pluginDir
  }

  static get themesFolder() {
    // We'll just pretend it exists.
    return join(ContentManager.pluginsFolder, '..', 'themes')
  }

  static extractMeta(content) {
    const firstLine = content.split("\n")[0]
    const hasOldMeta = firstLine.includes("//META")
    if (hasOldMeta) return this.parseOldMeta(content)
    const hasNewMeta = firstLine.includes("/**")
    if (hasNewMeta) return this.parseNewMeta(content)
    throw new Error('META was not found.')
  }

  static parseOldMeta(content) {
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
  static parseNewMeta(content) {
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
}
