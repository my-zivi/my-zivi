import * as React from 'react';
import Modal from 'reactstrap/lib/Modal';
import ModalBody from 'reactstrap/lib/ModalBody';
import ModalFooter from 'reactstrap/lib/ModalFooter';
import ModalHeader from 'reactstrap/lib/ModalHeader';
import Button from 'reactstrap/lib/Button';

interface ConfirmDialogProps {
  onClose: () => void;
  onConfirm: () => void;
  open: boolean;
  title?: string;
  children: React.ReactNode;
}

export class ConfirmationDialog extends React.Component<ConfirmDialogProps> {
  handleClose = () => {
    this.props.onClose();
  };

  handleOk = () => {
    this.props.onConfirm();
  };

  render() {
    const { children, title, open } = this.props;

    return (
      <Modal maxWidth="xs" aria-labelledby="confirmation-dialog-title" open={open} onClose={this.handleClose}>
        {title && <ModalHeader id="confirmation-dialog-title">{title}</ModalHeader>}
        <ModalBody>{children}</ModalBody>
        <ModalFooter>
          <Button onClick={this.handleClose} color="primary">
            Abbrechen
          </Button>
          <Button onClick={this.handleOk} color="primary">
            Ok
          </Button>
        </ModalFooter>
      </Modal>
    );
  }
}

interface DeleteButtonProps {
  onConfirm: () => void;
  message?: string;
  disabled?: boolean;
}

interface DeleteButtonState {
  open: boolean;
}

export class DeleteButton extends React.Component<DeleteButtonProps, DeleteButtonState> {
  public state = {
    open: false,
  };

  public handleOpen = () => {
    this.setState({ open: true });
  };

  public handleClose = () => {
    this.setState({ open: false });
  };

  public handleConfirm = () => {
    this.props.onConfirm();
    this.handleClose();
  };

  public render = () => {
    const { children } = this.props;

    return (
      <>
        <ConfirmationDialog onClose={this.handleClose} onConfirm={this.handleConfirm} open={this.state.open} title={'Löschen'}>
          {this.props.message ? this.props.message : 'Wirklich löschen?'}
        </ConfirmationDialog>
        <Button disabled={this.props.disabled} onClick={this.handleOpen} color={'danger'} type={'button'}>
          {children}
        </Button>
      </>
    );
  };
}
