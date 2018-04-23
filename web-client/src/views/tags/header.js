import { Component } from 'inferno';
import BootstrapNavLink from '../tags/BootstrapNavLink';
import Auth from '../../utils/auth';
import { environment, release } from '../../index';

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
      <BootstrapNavLink to="/user_feedback_overview">Einsatz Feedback</BootstrapNavLink>,

      // Operations
      <BootstrapNavLink to="/mission_overview">Planung</BootstrapNavLink>,
      <BootstrapNavLink to="/expense">Spesen</BootstrapNavLink>,
    ];
  }

  generateNavLinks() {
    return (
      <ul class="nav navbar-nav">
        {Auth.isAdmin() ? this.adminMenu() : null}
        {Auth.isLoggedIn() ? this.userMenu() : null}
        {!Auth.isLoggedIn() ? this.guestMenu() : null}
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
        <span class="release-info hide-print">
          {release} - {environment}
        </span>
      </div>
    );
  }

  componentDidUpdate() {
    window.$('[data-toggle="tooltip"]').tooltip();

    // Set Popover trigger mode to hover instead of click
    window.$('[data-toggle="popover"]').popover({ trigger: 'hover', container: 'body' });
  }
}
