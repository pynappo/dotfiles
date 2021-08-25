module.exports = class Patcher {
    static get patches() { return this._patches || (this._patches = []) }

    static getPatchesByCaller(name) {
        if (!name) return []
        const patches = []
        for (const patch of this.patches) {
            for (const childPatch of patch.children)
                if (childPatch.caller === name) patches.push(childPatch)
        }
        return patches
    }

    static unpatchAll(patches) {
        if (typeof patches === 'string') patches = this.getPatchesByCaller(patches)
        for (const patch of patches) patch.unpatch()
    }

    static resolveModule(module) {
        if (!module || typeof module === 'function' || (typeof module === 'object' && !Array.isArray(module))) return module
        if (typeof module === 'string') return DiscordModules[module]
        if (Array.isArray(module)) return BdApi.findModuleByProps(...module)
        return null
    }

    static makePatch(module, functionName, name) {
        const patch = {
            name,
            module,
            functionName,
            originalFunction: module[functionName],
            revert: () => {
                for (const child of patch.children) child.unpatch?.()
                patch.children = []
            },
            counter: 0,
            children: []
        }

        this.patches.push(patch)
        return patch
    }

    static before(caller, module, functionName, callback, options = {}) {
        return this.pushChildPatch(caller, module, functionName, callback, { ...options, type: 'before' })
    }

    static instead(caller, module, functionName, callback, options = {}) {
        return this.pushChildPatch(caller, module, functionName, callback, { ...options, type: 'instead' })
    }

    static after(caller, module, functionName, callback, options = {}) {
        return this.pushChildPatch(caller, module, functionName, callback, { ...options, type: 'after' })
    }

    static pushChildPatch(caller, module, functionName, callback, options = {}) {
        const { type = 'after', forcePatch = true } = options
        const mdl = this.resolveModule(module)   
        if (!mdl) return null
        if (!mdl[functionName] && forcePatch) mdl[functionName] = function () {}
        if (typeof mdl[functionName] !== 'function') return null

        const displayName = options.displayName || module.displayName || module.name || module.constructor.displayName || module.constructor.name

        const patchId = `${displayName}.${functionName}`
        const patch = this.patches.find(p => p.module == module && p.functionName === functionName) || this.makePatch(module, functionName, patchId)

        const child = {
            caller,
            type,
            id: patch.counter,
            callback,
            unpatch: BdApi.monkeyPatch(mdl, functionName, { [type]: data => {
                const r = callback(data.thisObject, data.methodArguments, data.returnValue)
                if (r !== undefined) data.returnValue = r
            } })
        }
        patch.children.push(child)
        patch.counter++
        return child.unpatch
    }
}
