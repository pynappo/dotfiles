'use strict'

const { React }  = require('powercord/webpack')
const { Modal } = require('powercord/components/modal')
const { getModuleByDisplayName } = require('powercord/webpack')
const { close: closeModal } = require('powercord/modal')

const FormTitle = getModuleByDisplayName('FormTitle')

class PluginSettings extends React.Component {
  constructor (props) {
    super(props)
  }

  render () {
    const plugin = this.props.plugin

    return (
      <Modal size={Modal.Sizes.MEDIUM}>
        <Modal.Header>
          <FormTitle tag={FormTitle.Tags.H4}>{plugin.getName()} Settings</FormTitle>
          <Modal.CloseButton onClick={closeModal}/>
        </Modal.Header>
        <Modal.Content>
          <div id="bdc-plugin-settings" ref={(node) => this.PluginSettingsContainer = node}></div>
        </Modal.Content>
      </Modal>
    )
  }

  componentDidMount () {
    if (!this.PluginSettingsContainer) return
    this.PluginSettingsContainer.appendChild(this.props.plugin.getSettingsPanel())
  }
}

module.exports = PluginSettings
