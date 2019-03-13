'use strict'

const { React } = require('powercord/webpack')

const PluginList = require('./PluginList.jsx')

class Settings extends React.Component {
  constructor (props) {
    super(props)

    this.pluginManager = powercord.pluginManager.plugins.get('pc-bdCompat').PluginManager
  }

  render () {
    return (
      <PluginList pluginManager={this.pluginManager} />
    )
  }
}

module.exports = Settings
