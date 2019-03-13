'use strict'

const { shell: { openExternal } } = require('electron')

const { React }  = require('powercord/webpack')
const { Tooltip, Switch, Button } = require('powercord/components')
const { open: openModal } = require('powercord/modal')

const Icons = require('./Icons.jsx')
const SettingsModal = require('./PluginSettings.jsx')
const DeleteConfirm = require('./DeleteConfirm.jsx')

class Plugin extends React.Component {
  constructor (props) {
    super(props)
  }
  
  render () {
    this.props.enabled = this.props.plugin.__started

    // We're reusing Powercord's plugin manager classes
    return (
      <div className='powercord-plugin'>
        <div className='powercord-plugin-header'>
          <h4>{this.props.plugin.getName()}</h4>
          <Tooltip>
            <div>
              <Switch value={this.props.plugin.__started} onChange={() => this.togglePlugin()}/>
            </div>
          </Tooltip>
        </div>

        <div className='powercord-plugin-container'>
          <div className='author'>
            <Tooltip text='Author'>
              <Icons.Author />
            </Tooltip>
            <span>{this.props.plugin.getAuthor()}</span>
          </div>

          <div className='version'>
            <Tooltip text='Version'>
              <Icons.Version />
            </Tooltip>
            <span>v{this.props.plugin.getVersion()}</span>
          </div>

          <div className='description'>
            <Tooltip text='Description'>
              <Icons.Description />
            </Tooltip>
            <span>{this.props.plugin.getDescription()}</span>
          </div>
        </div>

        <div className='powercord-plugin-footer bdc-justifystart'>
          {this.props.meta.source &&
            <Button
              onClick={() => openExternal(this.props.meta.source)}
              look={Button.Looks.LINK}
              size={Button.Sizes.SMALL}
              color={Button.Colors.TRANSPARENT}
            >
              Source code
            </Button>
          }

          {this.props.meta.website &&
            <Button
              onClick={() => openExternal(this.props.meta.website)}
              look={Button.Looks.LINK}
              size={Button.Sizes.SMALL}
              color={Button.Colors.TRANSPARENT}
            >
              Website
            </Button>
          }

          <div class='bdc-spacer'></div>

          <Button
            onClick={() => openModal(() => <DeleteConfirm plugin={this.props.plugin} onConfirm={this.props.onDelete} />)}
            look={Button.Looks.OUTLINED}
            size={Button.Sizes.SMALL}
            color={Button.Colors.RED}
          >
            Delete
          </Button>

          {typeof this.props.plugin.getSettingsPanel === 'function' &&
            <div class='bdc-margin'></div>
          }
          {typeof this.props.plugin.getSettingsPanel === 'function' &&
            <Button
              disabled={!this.props.enabled}
              onClick={() => openModal(() => <SettingsModal plugin={this.props.plugin}/>)}
              size={Button.Sizes.SMALL}
              color={Button.Colors.BRAND}
            >
              Settings
            </Button>
          }
        </div>
      </div>
    )
  }

  togglePlugin () {
    if (this.props.enabled) {
      this.props.onDisable()
    } else {
      this.props.onEnable()
    }

    this.forceUpdate()
  }
}

module.exports = Plugin

