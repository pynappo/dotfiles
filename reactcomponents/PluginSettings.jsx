'use strict'

const { React } = require('powercord/webpack')
const { Modal } = require('powercord/components/modal')
const { getModuleByDisplayName } = require('powercord/webpack')
const { close: closeModal } = require('powercord/modal')

const FormTitle = getModuleByDisplayName('FormTitle', false)

module.exports = class PluginSettings extends React.Component {
  constructor (props) {
    super(props)
  }

  render () {
    const { plugin } = this.props

    return (
      <Modal size={Modal.Sizes.MEDIUM}>
        <Modal.Header>
          <FormTitle tag={FormTitle.Tags.H4}>{plugin.getName()} Settings</FormTitle>
          <Modal.CloseButton onClick={closeModal}/>
        </Modal.Header>
        <Modal.Content>
          <div class='plugin-settings' id={'plugin-settings-' + plugin.getName()}></div>
        </Modal.Content>
      </Modal>
    )
  }

  componentDidMount () {
    setTimeout(() => {
      const { plugin } = this.props
      const el = document.getElementById(`plugin-settings-${plugin.getName()}`)
      if(!el) return
      const panel = plugin.getSettingsPanel()
      if(typeof panel == 'string') el.innerHTML = panel
      else el.append(panel)
    })
  }
}
