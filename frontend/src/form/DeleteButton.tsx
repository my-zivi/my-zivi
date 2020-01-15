import * as React from 'react';
import { Tooltip } from 'reactstrap';
import Button from 'reactstrap/lib/Button';
import ConfirmationDialog from './ConfirmationDialog';

interface DeleteButtonProps {
  onConfirm: () => void;
  message?: string;
  disabled?: boolean;
  id?: string;
  tooltip?: string;
}

interface DeleteButtonState {
  open: boolean;
  tooltipOpen: boolean;
}

export class DeleteButton extends React.Component<DeleteButtonProps, DeleteButtonState> {
  state = {
    open: false,
    tooltipOpen: false,
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

  getDeleteButton = () => {
    return (
      <Button
        disabled={this.props.disabled}
        style={this.props.disabled ? { pointerEvents: 'none' } : undefined}
        onClick={this.handleOpen}
        color={'danger'}
        type={'button'}
      >
        {this.props.children}
      </Button>
    );
  }

  getDeleteButtonWithTooltipWrapper = () => {
    if (this.props.id && this.props.tooltip) {
      return (
        <div id={'DeleteButtonWrapper-' + this.props.id} style={{ display: 'inline-block' }}>
          {this.getDeleteButton()}
        </div>
      );
    } else {
      return this.getDeleteButton();
    }
  }

  render = () => {
    const tooltipOpen = this.state.tooltipOpen;
    const toggle = () => this.setState({ tooltipOpen: !tooltipOpen });

    return (
      <>
        <ConfirmationDialog onClose={this.handleClose} onConfirm={this.handleConfirm} open={this.state.open} title={'Löschen'}>
          {this.props.message ? this.props.message : 'Wirklich löschen?'}
        </ConfirmationDialog>
        {this.getDeleteButtonWithTooltipWrapper()}
        {this.props.id && this.props.tooltip && (
          <Tooltip
            trigger={'hover focus'}
            delay={{ show: 100, hide: 100 }}
            placement={'top'}
            isOpen={tooltipOpen}
            target={'DeleteButtonWrapper-' + this.props.id}
            toggle={toggle}
          >
            {this.props.tooltip}
          </Tooltip>
        )}
      </>
    );
  }
}
