import * as React from 'react';
import { QuestionTitle, QuestionType1, QuestionType3, QuestionType4, QuestionType5, QuestionType6 } from '../tags/user_questions';

export const UserFeedbackForm = ({ questions, handleChange, handleFieldChange }) =>
  questions.map(question => {
    switch (question.type) {
      case 1:
        return <QuestionType1 key={question.id} onClick={handleChange} {...question} />;
      case 2:
        return <QuestionTitle key={question.id} {...question} />;
      case 3:
        return <QuestionType3 key={question.id} onClick={handleChange} {...question} />;
      case 4:
        return <QuestionType4 key={question.id} onChange={handleFieldChange} {...question} />;
      case 5:
        return <QuestionType5 key={question.id} onClick={handleChange} {...question} />;
      case 6:
        return <QuestionType6 key={question.id} onChange={handleFieldChange} {...question} />;
      default:
        return <p key={question.id}>Unbekannter Fragentyp</p>;
    }
  });
