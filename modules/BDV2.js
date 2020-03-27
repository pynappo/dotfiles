'use strict'

// Not to be confused with the actual BDv2's API
class V2 {
  static get WebpackModules () {
    return {
      find: window.BdApi.findModule,
      findAll: window.BdApi.findAll,
      findByUniqueProperties: window.BdApi.findModuleByProps,
      findByDisplayName: window.BdApi.findModuleByDisplayName,
    }
  }

  static get react () {
    return window.BdApi.React
  }
  static get reactDom () {
    return window.BdApi.ReactDOM
  }

  static get getInternalInstance () {
    return window.BdApi.getInternalInstance
  }
}

module.exports = V2
