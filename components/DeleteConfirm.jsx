'use strict'

const { React } = require('powercord/webpack')
const { Confirm: ConfirmModal } = require('powercord/components/modal')
const { close: closeModal } = require('powercord/modal')

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
        <div className='powercord-plugins-modal'>
          <span>Are you sure you want to delete ${this.props.plugin.getName()}? This can't be undone!</span>
        </div>
      </ConfirmModal>
    )
  }
}

module.exports = DeleteConfirm
