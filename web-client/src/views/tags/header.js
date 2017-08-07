import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Component from 'inferno-component';
import BootstrapNavLink from '../tags/BootstrapNavLink';

import { connect } from 'inferno-mobx';

export default class Header extends Component {
  guestMenu() {
    return [<BootstrapNavLink to="/register">Registrieren</BootstrapNavLink>, <BootstrapNavLink to="/login">Anmelden</BootstrapNavLink>];
  }

  userMenu() {
    return [<BootstrapNavLink to="/profile">Profil</BootstrapNavLink>, <BootstrapNavLink to="/logout">Abmelden</BootstrapNavLink>];
  }

  adminMenu() {
    return [
      // Static data
      <BootstrapNavLink to="/user_list">Mitarbeiterliste</BootstrapNavLink>,
      <BootstrapNavLink to="/user_phone_list">Telefonliste</BootstrapNavLink>,
      <BootstrapNavLink to="/specification">Pflichtenheft</BootstrapNavLink>,
      <BootstrapNavLink to="/freeday" mobileHidden="true">
        Freitage
      </BootstrapNavLink>,

      // Operations
      <BootstrapNavLink to="/mission_overview">Planung</BootstrapNavLink>,
      <BootstrapNavLink to="/expense" mobileHidden="true">
        Spesen
      </BootstrapNavLink>,
    ];
  }

  generateNavLinks() {
    var isLoggedIn = localStorage.getItem('jwtToken') !== null;
    var isAdmin = false;
    if (isLoggedIn) {
      var jwtDecode = require('jwt-decode');
      var decodedToken = jwtDecode(localStorage.getItem('jwtToken'));
      isAdmin = decodedToken.isAdmin;
    }

    return (
      <ul class="nav navbar-nav">
        {isAdmin ? this.adminMenu() : null}
        {isLoggedIn ? this.userMenu() : null}
        {!isLoggedIn ? this.guestMenu() : null}
      </ul>
    );
  }

  render() {
    return (
      <div>
        {BootstrapNavLink.getNavbar(this.generateNavLinks())}
        <main id="content" style="padding-top: 0">
          {this.props.children}
        </main>
      </div>
    );
  }

  componentDidUpdate() {
    $('[data-toggle="tooltip"]').tooltip();

    // Set Popover trigger mode to hover instead of click
    $('[data-toggle="popover"]').popover({ trigger: 'hover', container: 'body' });
  }
}
