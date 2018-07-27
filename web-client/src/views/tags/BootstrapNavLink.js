import { Component } from 'inferno';
import { Link } from 'inferno-router';

export default class BootstrapNavLink extends Component {
  static getNavbar(navLinks) {
    return (
      <nav className="navbar navbar-default navbar-fixed-top">
        <div className="container-fluid">
          <div className="navbar-header">
            <button
              type="button"
              className="navbar-toggle collapsed"
              data-toggle="collapse"
              data-target="#bs-example-navbar-collapse-1"
              aria-expanded="false"
            >
              <span className="sr-only">Toggle navigation</span>
              <span className="icon-bar" />
              <span className="icon-bar" />
              <span className="icon-bar" />
            </button>
            <BootstrapNavLink to="/" liClasses="navbar-brand">
              iZivi
            </BootstrapNavLink>
          </div>

          <div className="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            {navLinks}
          </div>
        </div>
      </nav>
    );
  }

  render() {
    let classes = '';
    if (this.props.mobileHidden) {
      classes = 'hidden-xs ';
    }
    classes += this.props.liClasses;

    return (
      <li className={classes} style={{ marginBottom: '0px', listStyle: 'none' }}>
        <Link to={this.props.to}>{this.props.children}</Link>
      </li>
    );
  }
}
