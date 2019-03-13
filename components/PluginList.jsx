'use strict'

const { shell: { openItem } } = require('electron')

const { React } = require('powercord/webpack')
const { Button } = require('powercord/components')
const { TextInput } = require('powercord/components/settings')

const Plugin = require('./Plugin.jsx')


class PluginList extends React.Component {
  constructor (props) {
    super(props)
    
    this.state = {
      search: '',
    }
  }
  render () {
    const plugins = this.__getPlugins()

    return (
      <div className='powercord-plugins'>
        <div className='powercord-plugins-topbar'>
          <TextInput
            value={this.state.search}
            onChange={(val) => this.setState({ search: val })}
            placeholder='What are you looking for?'
          >
            Search plugins
          </TextInput>

          <Button
            onClick={() => openItem(this.props.pluginManager.pluginDirectory)}
            size={Button.Sizes.SMALL}
          >
            Open Plugin Folder
          </Button>
        </div>

        <div className='powercord-plugins-container'>
          {plugins.map((plugin) =>
            <Plugin
              plugin={plugin}
              meta={plugin.__meta}

              onEnable={() => this.props.pluginManager.enablePlugin(plugin.getName())}
              onDisable={() => this.props.pluginManager.disablePlugin(plugin.getName())}
              onDelete={() => this.__deletePlugin(plugin.getName())}
            />
          )}
        </div>
      </div>
    )
  }

  __getPlugins () {
    let plugins = Object.keys(window.bdplugins)
      .map((plugin) => window.bdplugins[plugin])

    if (this.state.search !== '') {
      const search = this.state.search.toLowerCase()

      plugins = plugins.filter((plugin) =>
        plugin.getName().toLowerCase().includes(search) ||
        plugin.getAuthor().toLowerCase().includes(search) ||
        plugin.getDescription().toLowerCase().includes(search)
      )
    }

    return plugins.sort((a, b) => {
      const nameA = a.getName().toLowerCase()
      const nameB = b.getName().toLowerCase()

      if (nameA < nameB) return -1
      if (nameA > nameB) return 1

      return 0
    })
  }

  __deletePlugin (pluginName) {
    this.props.pluginManager.deletePlugin(pluginName)

    this.forceUpdate()
  }
}

module.exports = PluginList
