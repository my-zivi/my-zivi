import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Component from 'inferno-component';

import { connect } from 'inferno-mobx';

@connect(['accountStore'])
export default class Header extends Component {
  guestMenu() {
    return [<Link to="/register">Registrieren</Link>, <Link to="/login">Anmelden</Link>];
  }

  userMenu() {
    return [<Link to="/profile">Profil</Link>, <Link to="/logout">Abmelden</Link>];
  }

  adminMenu() {
    return [
      // Static data
      <Link to="/user_list">Mitarbeiterliste</Link>,
      <Link to="/user_phone_list">Telefonliste</Link>,
      <Link to="/specification">Pflichtenheft</Link>,
      <Link to="/freeday">Freitage</Link>,

      // Operations
      <Link to="/mission_overview">Planung</Link>,
      <Link to="/expense">Spesen</Link>,
    ];
  }

  render() {
    var isLoggedIn = localStorage.getItem('jwtToken') !== null;
    var isAdmin = false;
    if (isLoggedIn) {
      var jwtDecode = require('jwt-decode');
      var decodedToken = jwtDecode(localStorage.getItem('jwtToken'));
      isAdmin = decodedToken.isAdmin;
    }

    return (
      <div>
        <header className="header">
          <Link to="/">
            <h1>iZivi</h1>
          </Link>
          <nav>
            {isAdmin ? this.adminMenu() : null}
            {isLoggedIn ? this.userMenu() : null}
            {!isLoggedIn ? this.guestMenu() : null}
          </nav>
        </header>
        <main id="content">{this.props.children}</main>
      </div>
    );
  }
}
