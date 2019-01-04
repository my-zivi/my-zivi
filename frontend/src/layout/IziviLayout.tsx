import * as React from 'react';
import { Component, ReactNode } from 'react';
import Navbar from 'reactstrap/lib/Navbar';
import NavbarBrand from 'reactstrap/lib/NavbarBrand';
import NavbarToggler from 'reactstrap/lib/NavbarToggler';
import { inject, observer } from 'mobx-react';
import { MainStore } from '../stores/mainStore';
import Collapse from 'reactstrap/lib/Collapse';
import Nav from 'reactstrap/lib/Nav';
import { ApiStore } from '../stores/apiStore';
import NavItem from 'reactstrap/lib/NavItem';
import { Link } from 'react-router-dom';
import NavLink from 'reactstrap/lib/NavLink';
import { CssBaseline } from './theme';

interface NavEntryProps {
  to: string;
  children: ReactNode;
}

//TODO add react router to highlight active link
const NavEntry = ({ to, children }: NavEntryProps) => (
  <NavItem>
    <Link className="nav-link" to={to}>
      {children}
    </Link>
  </NavItem>
);

interface NavProps {
  mainStore?: MainStore;
  apiStore?: ApiStore;
}

@inject('mainStore', 'apiStore')
@observer
class Navigation extends React.Component<NavProps> {
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

export class IziviLayout extends Component {
  render = () => (
    <div>
      <CssBaseline />
      <Navigation />
      {this.props.children}
    </div>
  );
}
