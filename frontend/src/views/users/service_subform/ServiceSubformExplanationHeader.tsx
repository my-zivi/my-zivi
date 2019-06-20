import * as React from 'react';

export const ServiceSubformExplanationHeader = () => (
  <>
    <h3>Einsatzplanung</h3>
    <p>
      Um eine Einsatzplanung zu erfassen, klicke unten auf "Neue Einsatzplanung hinzufügen", wähle ein Pflichtenheft aus und trage
      Start- und Enddatum ein.
      <br/>
      Klicke nach dem Erstellen der Einsatzplanung auf "Drucken", um ein PDF zu generieren. Dieses kannst du dann an den Einsatzbetrieb
      schicken.
    </p>
    <p>
      <b>Beachte:</b> Zivi-Einsätze im Naturschutz müssen an einem Montag beginnen und an einem Freitag enden, ausser es handelt sich um
      deinen letzten Zivi Einsatz und du leistest nur noch die verbleibenden Resttage.
    </p>
  </>
);
