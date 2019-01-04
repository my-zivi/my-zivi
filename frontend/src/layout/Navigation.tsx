import NavItem from 'reactstrap/lib/NavItem';
import { Link, Route } from 'react-router-dom';
import * as React from 'react';
import { ReactNode } from 'react';
import { inject, observer } from 'mobx-react';
import Navbar from 'reactstrap/lib/Navbar';
import NavbarBrand from 'reactstrap/lib/NavbarBrand';
import NavbarToggler from 'reactstrap/lib/NavbarToggler';
import Collapse from 'reactstrap/lib/Collapse';
import Nav from 'reactstrap/lib/Nav';
import NavLink from 'reactstrap/lib/NavLink';
import { MainStore } from '../stores/mainStore';
import { ApiStore } from '../stores/apiStore';

interface NavEntryProps {
  to: string;
  children: ReactNode;
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
  handleLogout = (e: any) => {
    e.preventDefault();
    this.props.apiStore!.logout();
  };

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
                    <NavEntry to="/specifications">Pflichtenheft</NavEntry>
                    <NavEntry to="/holidays">Freitage</NavEntry>
                    <NavEntry to="/userFeedbackOverview">Einsatz Feedback</NavEntry>
                    <NavEntry to="/missions">Planung</NavEntry>
                    <NavEntry to="/expenses">Spesen</NavEntry>
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
                <NavEntry to="/register">Registrieren</NavEntry>
                <NavEntry to="/login">Anmelden</NavEntry>
              </>
            )}
          </Nav>
        </Collapse>
      </Navbar>
    );
  }
}
