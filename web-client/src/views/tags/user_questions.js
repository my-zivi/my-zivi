import * as React from 'react';

export const QuestionTitle = ({ question, opt1, opt2 }) => {
  if (opt1 && opt2) {
    return (
      <div className={'row'}>
        <div className={'col-xs-12 col-md-6'}>
          <h4>{question}</h4>
        </div>
        <div className={'hidden-xs hidden-sm col-md-6'}>
          <h5>
            {opt1} - {opt2}
          </h5>
        </div>
        <div className={'col-xs-12 hidden-md hidden-lg'}>
          <b>
            Bewertung von {opt1} bis {opt2}
          </b>
        </div>
      </div>
    );
  } else {
    return <h4>{question}</h4>;
  }
};

export const QuestionType1 = props => {
  const { custom_info, opt1, opt2 } = props;

  if (custom_info) {
    return (
      <div>
        <QuestionTitle question={custom_info} opt1={opt1} opt2={opt2} />
        <QuestionType3 {...props} />
      </div>
    );
  } else {
    return <QuestionType3 {...props} />;
  }
};

export const QuestionType3 = ({ id, required, question, answer, onClick }) => (
  <QuestionGroup question={question} required={required}>
    <ButtonWithOnClick question_id={id} answer={answer} value={'1'} onClick={onClick} />
    <ButtonWithOnClick question_id={id} answer={answer} value={'2'} onClick={onClick} />
    <ButtonWithOnClick question_id={id} answer={answer} value={'3'} onClick={onClick} />
    <ButtonWithOnClick question_id={id} answer={answer} value={'4'} onClick={onClick} />
  </QuestionGroup>
);

export const QuestionType4 = ({ id, required, question, onChange, answer }) => (
  <QuestionGroup question={question} required={required}>
    <textarea value={answer} onChange={e => onChange(id, e)} rows={'4'} className={'col-xs-12'} />
  </QuestionGroup>
);

export const QuestionType5 = ({ id, required, question, opt1, opt2, answer, onClick }) => (
  <QuestionGroup required={required} question={question}>
    <div className={'btn-group'}>
      <ButtonWithOnClick question_id={id} answer={answer} value={opt1} onClick={onClick} />
      <ButtonWithOnClick question_id={id} answer={answer} value={opt2} onClick={onClick} />
    </div>
  </QuestionGroup>
);

export const QuestionType6 = ({ id, required, question, custom_info, onChange }) => (
  <QuestionGroup required={required} question={question}>
    {JSON.parse('{' + custom_info.replace(/,([^,]*)$/, '$1') + '}').choices.map(choice => (
      <div className="radio" key={choice.value}>
        <label>
          <input type="radio" name={'question_' + id + '_radios'} value={choice.value} onChange={e => onChange(id, e)} />
          {choice.text}
        </label>
      </div>
    ))}
  </QuestionGroup>
);

const QuestionGroup = ({ required, question, children }) => (
  <div className={'row'} style={{ paddingBottom: '15px' }}>
    <div className={'col-xs-12 col-md-6'}>
      <h5>
        {question} {required && ' (*)'}{' '}
      </h5>
    </div>
    <div className={'col-xs-12 col-md-6'}>{children}</div>
  </div>
);

const ButtonWithOnClick = ({ question_id, value, answer, onClick }) => (
  <button
    onClick={() => onClick(question_id, value)}
    className={'btn btn-default' + (answer === value ? 'active' : '')}
    style={{ marginRight: '5px' }}
  >
    {value}
  </button>
);
