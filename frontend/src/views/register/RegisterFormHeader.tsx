import * as React from 'react';

const SAMPLE_MAIL_SUBJECT = 'Einsatzplanung Zivildienst';
const SAMPLE_MAIL_CONTENT = `Guten Tag Herr Pfeuti!
              %0D%0A%0D%0AIch schreibe Ihnen betreffend meiner Einsatzplanung als FELDZIVI / BÜROZIVI (EINS AUSWÄHLEN)
              vom DD.MM.YYYY bis DD.MM.YYYY, wäre dieser Zeitraum möglich?
              %0D%0A%0D%0A
              %0D%0A%0D%0ABesten Dank und freundliche Grüsse`;

const SAMPLE_MAIL_LINK = `mailto:zivildienst@stiftungswo.ch?subject=${SAMPLE_MAIL_SUBJECT}&body=${SAMPLE_MAIL_CONTENT}`;
const MARC_LINK = (
  <>
    <a href="https://stiftungswo.ch/about/meet-the-team#jumptomarc" target="_blank" rel="noopener noreferrer">
      Marc Pfeuti
    </a> {' '}
    (<a href={'tel:+41774385761'}>+41 77 438 57 61</a>)
  </>
);

export const RegisterFormHeader = () => {
  return (
    <div>
      <p>
        Als zukünftiger Zivi musst du dich zuerst erkundigen, ob zum gewünschten Zeitpunkt ein Einsatz möglich ist.
        Kontaktiere hierfür
        bitte direkt {MARC_LINK} unter <a href={SAMPLE_MAIL_LINK}>zivildienst@stiftungswo.ch</a>.
      </p>
      <ul>
        <li>
          Nach Eingabe deiner persönlichen Daten kannst du die Einsatzplanung ausdrucken, unterschreiben und an den Einsatzbetrieb
          zurückzuschicken. Nach erfolgreicher Prüfung werden wir diese direkt an dein zuständiges Regionalzentrum weiterleiten. Das
          Aufgebot erhältst du dann automatisch von deinem zuständigen Regionalzentrum.
        </li>
      </ul>
    </div>
  );
};
