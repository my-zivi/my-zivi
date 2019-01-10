import * as React from 'react';
import { inject, observer } from 'mobx-react';
import { MainStore } from '../stores/mainStore';

interface Props {
  children: React.ReactNode;
  isSubmitting: boolean;
  isValid: boolean;
  mainStore?: MainStore;
}

@inject('mainStore')
@observer
export class FormikSubmitDetector extends React.Component<Props> {
  // SOURCE: https://github.com/jaredpalmer/formik/issues/1019
  public componentDidUpdate(prevProps: Props) {
    if (prevProps.isSubmitting && !this.props.isSubmitting && !this.props.isValid) {
      this.props.mainStore!.displayError('Die Daten konnten nicht gespeichert werden, da das Formular ungültige Angaben enthält.');
    }
  }

  public render() {
    return <>{this.props.children}</>;
  }
}
