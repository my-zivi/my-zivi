import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Component from 'inferno-component';

export default class BootstrapNavLink extends Component {
  static getNavbar(navLinks) {
    return (
      <nav class="navbar navbar-default navbar-fixed-top">
        <div class="container-fluid">
          <div class="navbar-header">
            <button
              type="button"
              class="navbar-toggle collapsed"
              data-toggle="collapse"
              data-target="#bs-example-navbar-collapse-1"
              aria-expanded="false"
            >
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar" />
              <span class="icon-bar" />
              <span class="icon-bar" />
            </button>
            <BootstrapNavLink to="/" liClasses="navbar-brand">
              iZivi
            </BootstrapNavLink>
          </div>

          <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
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
      <li class={classes} style="margin-bottom: 0px; list-style: none;">
        <Link to={this.props.to}>{this.props.children}</Link>
      </li>
    );
  }
}
