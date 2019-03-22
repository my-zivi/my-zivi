import * as React from 'react';
import Button from 'reactstrap/lib/Button';
import ConfirmationDialog from './ConfirmationDialog';

interface DeleteButtonProps {
  onConfirm: () => void;
  message?: string;
  disabled?: boolean;
}

interface DeleteButtonState {
  open: boolean;
}

export class DeleteButton extends React.Component<DeleteButtonProps, DeleteButtonState> {
  state = {
    open: false,
  };

  handleOpen = () => {
    this.setState({ open: true });
  }

  handleClose = () => {
    this.setState({ open: false });
  }

  handleConfirm = () => {
    this.props.onConfirm();
    this.handleClose();
  }

  render = () => {
    return (
      <>
        <ConfirmationDialog onClose={this.handleClose} onConfirm={this.handleConfirm} open={this.state.open} title={'Löschen'}>
          {this.props.message ? this.props.message : 'Wirklich löschen?'}
        </ConfirmationDialog>
        <Button disabled={this.props.disabled} onClick={this.handleOpen} color={'danger'} type={'button'}>
          {this.props.children}
        </Button>
      </>
    );
  }
}
