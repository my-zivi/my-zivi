import { inject, observer } from 'mobx-react';
import * as React from 'react';
import { Link, Route } from 'react-router-dom';
import Collapse from 'reactstrap/lib/Collapse';
import Nav from 'reactstrap/lib/Nav';
import Navbar from 'reactstrap/lib/Navbar';
import NavbarBrand from 'reactstrap/lib/NavbarBrand';
import NavbarToggler from 'reactstrap/lib/NavbarToggler';
import NavItem from 'reactstrap/lib/NavItem';
import NavLink from 'reactstrap/lib/NavLink';
import { ApiStore } from '../stores/apiStore';
import { MainStore } from '../stores/mainStore';

interface NavEntryProps {
  to: string;
  children: React.ReactNode;
  exact?: boolean;
}

const NavEntry = ({ to, children, exact }: NavEntryProps) => (
  <Route
    path={to}
    exact={exact}
    children={({ match }) => (
      <NavItem active={Boolean(match)}>
        <Link className="nav-link" to={to}>
          {children}
        </Link>
      </NavItem>
    )}
  />
);

interface NavProps {
  mainStore?: MainStore;
  apiStore?: ApiStore;
}

@inject('mainStore', 'apiStore')
@observer
export class Navigation extends React.Component<NavProps> {
  handleLogout = (e: React.MouseEvent<HTMLElement>) => {
    e.preventDefault();
    this.props.apiStore!.logout();
  }

  render() {
    const mainStore = this.props.mainStore!;
    const apiStore = this.props.apiStore!;

    return (
      <Navbar color={'light'} light expand={'md'}>
        <NavbarBrand href={'/'}>iZivi</NavbarBrand>
        <NavbarToggler onClick={() => (mainStore.navOpen = !mainStore.navOpen)} />
        <Collapse isOpen={mainStore.navOpen} navbar>
          <Nav className={'ml-auto'} navbar>
            {apiStore.isLoggedIn ? (
              <>
                {apiStore.isAdmin && (
                  <>
                    <NavEntry to="/users">Mitarbeiterliste</NavEntry>
                    <NavEntry to="/phones">Telefonliste</NavEntry>
                    <NavEntry to="/serviceSpecifications">Pflichtenheft</NavEntry>
                    <NavEntry to="/holidays">Freitage</NavEntry>
                    <NavEntry to="/user_feedbacks">Einsatz Feedback</NavEntry>
                    <NavEntry to="/services">Planung</NavEntry>
                    <NavEntry to="/report_sheets">Spesen</NavEntry>
                    <NavEntry to={'/payments'}>Auszahlungen</NavEntry>
                  </>
                )}
                <NavEntry to="/profile">Profil</NavEntry>
                <NavEntry to="/changePassword">Passwort ändern</NavEntry>
                <NavItem>
                  <NavLink href="/logout" onClick={this.handleLogout}>
                    Abmelden
                  </NavLink>
                </NavItem>
              </>
            ) : (
              <>
                <NavEntry to="/register/1">Registrieren</NavEntry>
                <NavEntry to="/login">Anmelden</NavEntry>
              </>
            )}
          </Nav>
        </Collapse>
      </Navbar>
    );
  }
}
