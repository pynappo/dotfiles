'use strict'

const { React } = require('powercord/webpack')
const { SwitchItem } = require('powercord/components/settings')

const PluginList = require('./PluginList.jsx')

class Settings extends React.Component {
  constructor (props) {
    super(props)

    this.pluginManager = powercord.pluginManager.plugins.get('bdCompat').PluginManager
  }

  render () {
    return (
      <div>
        <SwitchItem value={this.props.getSetting('disableWhenStopFailed')}
        onChange={() => this.props.toggleSetting('disableWhenStopFailed')}>
          Disable plugin when failed to stop
        </SwitchItem>
        <PluginList pluginManager={this.pluginManager} />
      </div>
    )
  }
}

module.exports = Settings
