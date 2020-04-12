module.exports = class AddonAPI {
    constructor(list, manager) {
        this.list    = list
        this.manager = manager
        this.folder  = manager.folder

        this.enable  = this.manager.enable  || (() => {})
        this.disable = this.manager.disable || (() => {})
        this.reload  = this.manager.reload  || (() => {})
    }

    isEnabled(name) {
        const plugin = this.list[name]
        return plugin ? plugin.__started : false
    }

    toggle(name) {
        if (this.isEnabled(name)) return this.disable(name)
        this.enable(name)
    }

    get(name) {
        if (this.list[name]) {
            if (this.list[name].plugin) return this.list[name].plugin
            return this.list[name]
        }
        return null
    }

    getAll = () => Object.keys(this.list).map(k => this.get(k)).filter(a => a)
}
