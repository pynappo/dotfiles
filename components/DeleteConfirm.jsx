'use strict'

const { React } = require('powercord/webpack')
const { Text } = require('powercord/components')
const { Confirm: ConfirmModal } = require('powercord/components/modal')
const { close: closeModal } = require('powercord/modal')

module.exports = class DeleteConfirm extends React.Component {
  render() {
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
          Are you sure you want to delete <strong>{this.props.plugin.getName()}</strong>? This can't be undone!
        </Text>
      </ConfirmModal>
    )
  }
}
