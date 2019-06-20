import { inject } from 'mobx-react';
import * as React from 'react';
import { RouteComponentProps } from 'react-router';
import { Progress } from 'reactstrap';
import IziviContent from '../../../layout/IziviContent';
import { UserFeedbackStore } from '../../../stores/userFeedbackStore';
import { FeedbackPage } from './FeedbackPage';

interface ServiceFeedbackProps extends RouteComponentProps<{ id?: string }> {
  userFeedbackStore?: UserFeedbackStore;
}

@inject('serviceStore')
export class ServiceFeedback extends React.Component<ServiceFeedbackProps> {
  constructor(props: ServiceFeedbackProps) {
    super(props);
  }

  render() {
    return (
      <IziviContent card loading={false} title={'Feedback zu Einsatz abgeben'}>
        <div>
          <small>
            <strong>Hinweis:</strong> Alle Fragen, welche mit (*) enden, sind erforderlich und müssen ausgefüllt werden.
          </small>

          <Progress max={7} value={1} className={'mt-3'} />
        </div>

        <FeedbackPage />
      </IziviContent>
    );
  }
}
