import React, { Component } from 'react';
import ScrollableCard from '../tags/scrollableCard';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import DatePicker from '../tags/InputFields/DatePicker';
import Toast from '../../utils/toast';
import { api } from '../../utils/api';

export default class UserList extends Component {
  constructor(props) {
    super(props);

    var date = new Date();
    var firstDay = new Date('2000', date.getMonth(), 1).toISOString().slice(0, 10);
    var lastDay = new Date(date.getFullYear() + 5, date.getMonth(), 1).toISOString().slice(0, 10);

    this.state = {
      users: [],
      zdp: '',
      name: '',
      start: firstDay,
      end: lastDay,
      active: false,
      group: 0,
    };
  }

  componentDidMount() {
    this.getUsers();
  }

  getUsers() {
    this.setState({ loading: true, error: null });
    api()
      .get('user/zivi')
      .then(response => {
        this.setState({
          users: response.data,
          loading: false,
        });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  handleChange(e) {
    const value = e.target.type === 'checkbox' ? e.target.checked : e.target.value;
    this.setState({
      [e.target.name]: value,
    });
  }

  handleDateChange(e) {
    let value = e.target.value;

    if (value) {
      value = DatePicker.dateFormat_CH2EN(value);
    } else {
      value = this.state.lastDateValue;
    }

    value = value.slice(0, 10);

    this.setState({ [e.target.name]: value });
  }

  deleteUser(user) {
    this.setState({ loading: true, error: null });
    api()
      .delete('user/' + user.id)
      .then(response => {
        Toast.showSuccess('Löschen erfolgreich', 'Benutzer wurde erfolgreich gelöscht');
        this.getUsers();
      })
      .catch(error => {
        this.setState({ loading: false, error: null });
        Toast.showError('Löschen fehlgeschlagen', 'Benutzer konnte nicht gelöscht werden', error, path => this.props.history.push(path));
      });
  }

  render() {
    var temp = [];
    var users = this.state.users;
    for (let i = 0; i < users.length; i++) {
      if (this.state.zdp && !users[i].zdp.startsWith(this.state.zdp)) {
        continue;
      }
      if (this.state.name && (users[i].first_name + ' ' + users[i].last_name).toLowerCase().indexOf(this.state.name.toLowerCase()) === -1) {
        continue;
      }
      if (this.state.start && users[i].start < this.state.start) {
        continue;
      }
      if (this.state.end && users[i].end > this.state.end) {
        continue;
      }
      if (
        this.state.active &&
        (users[i].start == null ||
          users[i].end < new Date().toISOString().slice(0, 10) ||
          users[i].start > new Date().toISOString().slice(0, 10))
      ) {
        continue;
      }
      if (+this.state.group !== 0 && +users[i].role_id !== +this.state.group) {
        continue;
      }

      temp.push(
        <tr key={users[i].id}>
          <td className="hidden-xs">{users[i].zdp}</td>
          <td>
            <a href={'/profile/' + users[i].id}>
              {users[i].first_name} {users[i].last_name}
            </a>
          </td>
          <td>{users[i].start}</td>
          <td>{users[i].end}</td>
          <td className="hidden-xs">{users[i].active}</td>
          <td className="hidden-xs">{users[i].role}</td>
          <td className="hidden-xs">
            <button
              className="btn btn-danger btn-xs"
              onClick={() => {
                if (window.confirm('Möchten Sie ' + users[i].first_name + ' ' + users[i].last_name + ' wirklich löschen?')) {
                  this.deleteUser(users[i]);
                }
              }}
            >
              Löschen
            </button>
          </td>
        </tr>
      );
    }

    return (
      <Header>
        <div className="page page__user_list">
          <ScrollableCard>
            <h1>Benutzerliste</h1>
            <table className="table table-hover" cellSpacing="0" cellPadding="2">
              <thead>
                <tr>
                  <th className="hidden-xs">ZDP</th>
                  <th>Vorname Name</th>
                  <th>Start</th>
                  <th>Ende</th>
                  <th className="hidden-xs">Aktiv?</th>
                  <th className="hidden-xs">Gruppe</th>
                  <th className="hidden-xs" />
                </tr>
                <tr>
                  <td className="hidden-xs">
                    <input
                      className="form-control"
                      name="zdp"
                      size="5"
                      type="text"
                      value={this.state.zdp}
                      onChange={this.handleChange.bind(this)}
                    />
                  </td>
                  <td>
                    <input
                      className="form-control"
                      name="name"
                      size="15"
                      type="text"
                      value={this.state.name}
                      onChange={this.handleChange.bind(this)}
                    />
                  </td>
                  <td>
                    <DatePicker id="start" value={this.state.start} onChange={this.handleDateChange.bind(this)} showLabel={false} />
                  </td>
                  <td>
                    <DatePicker id="end" value={this.state.end} onChange={this.handleDateChange.bind(this)} showLabel={false} />
                  </td>
                  <td className="hidden-xs">
                    <input
                      className="form-control"
                      name="active"
                      type="checkbox"
                      checked={this.state.active}
                      onChange={this.handleChange.bind(this)}
                    />
                  </td>
                  <td className="hidden-xs">
                    <select className="form-control" name="group" value={this.state.group} onInput={this.handleChange.bind(this)}>
                      <option value="0">(Alle Gruppen)</option>
                      <option value="1">Admins</option>
                      <option value="2">Zivis</option>
                    </select>
                  </td>
                  <td className="hidden-xs" />
                </tr>
              </thead>
              <tbody>{temp}</tbody>
            </table>
          </ScrollableCard>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
