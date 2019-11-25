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
      <div className='powercord-entities-manage powercord-text'>
        <div className='powercord-entities-manage-header'>
          <Button
            onClick={() => openItem(this.props.pluginManager.pluginDirectory)}
            size={Button.Sizes.SMALL}
          >
            Open Plugin Folder
          </Button>
        </div>
        <div className='powercord-entities-manage-search'>
          <TextInput
            value={this.state.search}
            onChange={(val) => this.setState({ search: val })}
            placeholder='What are you looking for?'
          >
            Search plugins
          </TextInput>
        </div>

        <div className='powercord-entities-manage-container'>
          {plugins.map((plugin) =>
            <Plugin
              plugin={plugin}
              meta={plugin.plugin.__meta}

              onEnable={() => this.props.pluginManager.enablePlugin(plugin.plugin.getName())}
              onDisable={() => this.props.pluginManager.disablePlugin(plugin.plugin.getName())}
              onDelete={() => this.__deletePlugin(plugin.plugin.getName())}
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

      plugins = plugins.filter(({ plugin }) =>
        plugin.getName().toLowerCase().includes(search) ||
        plugin.getAuthor().toLowerCase().includes(search) ||
        plugin.getDescription().toLowerCase().includes(search)
      )
    }

    return plugins.sort((a, b) => {
      const nameA = a.plugin.getName().toLowerCase()
      const nameB = b.plugin.getName().toLowerCase()

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
