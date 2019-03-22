import * as React from 'react';
import ListGroup from 'reactstrap/lib/ListGroup';
import ListGroupItem from 'reactstrap/lib/ListGroupItem';
import Progress from 'reactstrap/lib/Progress';
import { UserQuestionWithAnswers } from '../../types';

interface FeedbackTitleProps {
  opt1?: string;
  opt2?: string;
  question: string;
}

interface MultiProgressBarContainerInterface {
  children: React.ReactNode;
}

const MultiProgressBarContainer = ({ children }: MultiProgressBarContainerInterface) => (
  <>
    <Progress multi style={{ height: '1.5rem', fontSize: '1.25rem' }}>
      {children}
    </Progress>
    <br />
  </>
);

const FeedbackTitle = ({ question, opt1, opt2 }: FeedbackTitleProps) => (
  <>
    <h5>{question}</h5>
    {opt1 && opt2 && (
      <p>
        Von {opt1} bis {opt2}
      </p>
    )}
  </>
);

const Type1FeedbackGroup = (question: UserQuestionWithAnswers) => (
  <>
    <FeedbackTitle opt1={question.opt1} opt2={question.opt2} question={question.question} />
    <MultiProgressBars {...question} />
  </>
);

const Type3FeedbackGroup = (question: UserQuestionWithAnswers) => (
  <>
    <FeedbackTitle question={question.question} />
    <MultiProgressBars {...question} />
  </>
);

const Type4FeedbackGroup = (question: UserQuestionWithAnswers) => {
  const arrOfAnswers: string[] = Object.keys(question.answers).map(key => question.answers[key]);

  return (
    <>
      <FeedbackTitle question={question.question} />
      <ListGroup>
        {arrOfAnswers.map((answer: string, index: number) => (
          <ListGroupItem key={index} style={{ whiteSpace: 'pre-wrap' }}>
            {answer}
          </ListGroupItem>
        ))}
      </ListGroup>
      <br />
    </>
  );
};

const Type5FeedbackGroup = (question: UserQuestionWithAnswers) => {
  const total = Object.keys(question.answers)
    .map(key => question.answers[key])
    .reduce((a: number, b: number) => a + b);

  return (
    <>
      <FeedbackTitle question={question.question} />
      <MultiProgressBarContainer>
        <Progress striped bar color="success" value={(question.answers[1] / total) * 100}>
          Nein ({question.answers[1]})
        </Progress>

        <Progress striped bar color="danger" value={(question.answers[2] / total) * 100}>
          Ja ({question.answers[2]})
        </Progress>
      </MultiProgressBarContainer>
    </>
  );
};

const Type6FeedbackGroup = (question: UserQuestionWithAnswers) => {
  const total = Object.keys(question.answers)
    .map(key => question.answers[key])
    .reduce((a: number, b: number) => a + b);

  const customInfo = JSON.parse(question.custom_info);

  return (
    <>
      <FeedbackTitle question={question.question} />

      {Array.from(Array(5).keys()).map((currentIndex: number) => (
        <React.Fragment key={currentIndex}>
          {customInfo.choices[String(currentIndex)].text}
          <Progress striped color="primary" value={(question.answers[currentIndex + 1] / total) * 100}>
            {question.answers[currentIndex + 1]}
          </Progress>
          <br />
        </React.Fragment>
      ))}
    </>
  );
};

const MultiProgressBars = ({ answers }: UserQuestionWithAnswers) => {
  const total = Object.keys(answers)
    .map(key => answers[key])
    .reduce((a: number, b: number) => a + b);
  return (
    <>
      <MultiProgressBarContainer>
        <Progress striped bar color="danger" value={(answers[1] / total) * 100}>
          {answers[1]}
        </Progress>
        <Progress striped bar color="warning" value={(answers[2] / total) * 100}>
          {answers[2]}
        </Progress>
        <Progress striped bar color="info" value={(answers[3] / total) * 100}>
          {answers[3]}
        </Progress>
        <Progress striped bar color="success" value={(answers[4] / total) * 100}>
          {answers[4]}
        </Progress>
      </MultiProgressBarContainer>
      <br />
    </>
  );
};

export { FeedbackTitle, Type1FeedbackGroup, Type3FeedbackGroup, Type4FeedbackGroup, Type5FeedbackGroup, Type6FeedbackGroup };
