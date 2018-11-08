import * as React from 'react';
import { Link } from 'react-router-dom';

export const UserFeedbackFinish = () => (
  <div>
    <p>Dein Feedback wurde erfolgreich erfasst. Nochmals besten Dank für deine Mitarbeit.</p>
    <Link className={'btn btn-primary'} to="/profile">
      Zurück zum Profil
    </Link>
  </div>
);
