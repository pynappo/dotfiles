'use strict'

const { React, getModule } = require('powercord/webpack')
const { Confirm: ConfirmModal } = require('powercord/components/modal')
const { close: closeModal } = require('powercord/modal')

const Text = getModule(['Sizes', 'Weights'], false)

class DeleteConfirm extends React.Component {
  constructor (props) {
    super(props)
  }

  render () {
    return (
      <ConfirmModal
        red={true}
        header={`Delete Plugin`}
        confirmText='Delete'
        cancelText='Cancel'
        onConfirm={this.props.onConfirm}
        onCancel={() => closeModal()}
      >
        <Text
          color={Text.Colors.PRIMARY}
          size={Text.Sizes.MEDIUM}
        >
          Are you sure you want to delete <strong>{this.props.plugin.plugin.getName()}</strong>? This can't be undone!
        </Text>
      </ConfirmModal>
    )
  }
}

module.exports = DeleteConfirm
