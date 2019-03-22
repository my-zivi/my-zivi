import * as React from 'react';
import Button from 'reactstrap/lib/Button';
import Modal from 'reactstrap/lib/Modal';
import ModalBody from 'reactstrap/lib/ModalBody';
import ModalFooter from 'reactstrap/lib/ModalFooter';
import ModalHeader from 'reactstrap/lib/ModalHeader';

interface ConfirmDialogProps {
  onClose: () => void;
  onConfirm: () => void;
  open: boolean;
  title?: string;
  children: React.ReactNode;
}

export default function ConfirmationDialog({ children, title, open, onClose, onConfirm }: ConfirmDialogProps) {
  return (
    <Modal maxwidth="xs" aria-labelledby="confirmation-dialog-title" isOpen={open} onClose={onClose}>
      {title && <ModalHeader id="confirmation-dialog-title">{title}</ModalHeader>}
      <ModalBody>{children}</ModalBody>
      <ModalFooter>
        <Button onClick={onClose} color="primary">Abbrechen</Button>
        <Button onClick={onConfirm} color="danger">Ok</Button>
      </ModalFooter>
    </Modal>
  );
}
