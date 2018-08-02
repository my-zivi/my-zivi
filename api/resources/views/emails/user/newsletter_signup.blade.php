<html>
<body>
    <p>Ein Zivi hat sich im iZivi registriert und sich für den Newsletter angemeldet:</p><br>
    <ul>
        <li>Vorname: {{ $user->first_name }}</li>
        <li>Nachname: {{ $user->last_name }}</li>
        <li>Zivi-Nummer: {{ $user->zdp }}</li>
        <li>E-Mail-Adresse: {{ $user->email }}</li>
    </ul>
</body>
</html>
