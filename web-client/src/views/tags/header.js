import Inferno from 'inferno';
import { Link } from 'inferno-router';

export default function() {
  const isLoggedIn = false; // this.state.isLoggedIn;
  const isAdmin = false; // this.state.isLoggedIn;

  function guestMenu() {
    return [<Link to="/register">Registrieren</Link>, <Link to="/login">Anmelden</Link>];
  }

  function userMenu() {
    return [<Link to="/profile">Profil</Link>, <Link to="/logout">Abmelden</Link>];
  }

  function adminMenu() {
    return [
      // Static data
      <Link to="/user_list">Mitarbeiterliste</Link>,
      <Link to="/user_phone_list">Telefonliste</Link>,
      <Link to="/specification">Pflichtenheft</Link>,
      <Link to="/freeday">Freitage</Link>,

      // Operationss
      <Link to="/mission_overview">Planung</Link>,
      <Link to="/expense">Spesen</Link>,
      <Link to="/blog">Blog</Link>,
      <Link to="/credit">Credit</Link>,
    ];
  }

  return (
    <header className="header">
      <Link to="/">
        <h1>iZivi</h1>
      </Link>
      <nav>
        {isLoggedIn & isAdmin ? adminMenu() : null}
        {isLoggedIn ? userMenu() : null}
        {!isLoggedIn ? guestMenu() : null}
      </nav>
    </header>
  );
}
