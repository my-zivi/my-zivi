import React, { Component } from 'react';
import ScrollableCard from '../tags/scrollableCard';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import Toast from '../../utils/toast';
import { api } from '../../utils/api';
import update from 'immutability-helper';

export default class Specifications extends Component {
  constructor(props) {
    super(props);

    this.state = {
      specifications: [],
      newSpec: {},
      zdp: '',
      name: '',
      start: '',
      end: '',
      group: 0,
    };
  }

  componentDidMount() {
    this.getSpecifications();
  }

  getSpecifications() {
    this.setState({ loading: true, error: null });
    api()
      .get('specification')
      .then(response => {
        this.setState({
          specifications: response.data,
          loading: false,
        });
      })
      .catch(error => {
        this.setState({ error: error });
      });
  }

  handleChange(e, i) {
    const value = e.target.type === 'checkbox' ? e.target.checked : e.target.value;

    //this.state['specifications'][i][e.target.name] = value;
    this.setState({
      specifications: update(this.state.specifications, { [i]: { [e.target.name]: { $set: value } } }),
    });
  }

  save(i) {
    this.setState({ loading: true, error: null });
    api()
      .post('specification/' + this.state.specifications[i].id, this.state.specifications[i])
      .then(response => {
        Toast.showSuccess('Speichern erfolgreich', 'Pflichtenheft gespeichert');
        this.setState({ loading: false });
      })
      .catch(error => {
        this.setState({ loading: false, error: null });
        Toast.showError('Speichern fehlgeschlagen', 'Pflichtenheft konnte nicht gespeichert werden', error, path =>
          this.props.history.push(path)
        );
      });
  }

  handleChangeNew(e) {
    const value = e.target.type === 'checkbox' ? e.target.checked : e.target.value;
    this.setState({
      newSpec: {
        ...this.state.newSpec,
        [e.target.name]: value,
      },
    });
  }

  add() {
    this.setState({ loading: true, error: null });
    api()
      .put('specification/' + this.state.newSpec.id, this.state.newSpec)
      .then(response => {
        Toast.showSuccess('Hinzufügen erfolgreich', 'Pflichtenheft hinzugefügt');
        this.getSpecifications();
      })
      .catch(error => {
        this.setState({ loading: false, error: null });
        Toast.showError('Hinzufügen fehlgeschlagen', 'Pflichtenheft konnte nicht hinzugefügt werden', error, path =>
          this.props.history.push(path)
        );
      });
  }

  render() {
    var tbody = [];

    var specifications = this.state.specifications;
    for (let i = 0; i < specifications.length; i++) {
      tbody.push(
        <tr key={specifications[i].id}>
          <td className="col_a">
            <input
              type="checkbox"
              name="active"
              defaultChecked={specifications[i].active ? 'checked' : ''}
              onChange={e => this.handleChange(e, i)}
            />
          </td>
          <td className="col_a">{specifications[i].id}</td>
          <td className="col_a">
            <input type="text" size="20" name="name" value={specifications[i].name} onChange={e => this.handleChange(e, i)} />
          </td>

          <td className="col_a">
            <input type="text" size="5" name="short_name" value={specifications[i].short_name} onChange={e => this.handleChange(e, i)} />
          </td>

          <td className="col_b">
            <input type="text" size="5" name="pocket" value={specifications[i].pocket} onChange={e => this.handleChange(e, i)} />
          </td>
          <td className="col_a">
            <input
              type="text"
              size="5"
              name="accommodation"
              value={specifications[i].accommodation}
              onChange={e => this.handleChange(e, i)}
            />
          </td>
          <td className="col_b">
            <input
              type="text"
              size="5"
              name="working_clothes_expense"
              value={specifications[i].working_clothes_expense}
              onChange={e => this.handleChange(e, i)}
            />
          </td>
          <td className="col_a">
            <input
              type="text"
              size="5"
              name="firstday_breakfast_expenses"
              value={specifications[i].firstday_breakfast_expenses}
              onChange={e => this.handleChange(e, i)}
            />
          </td>
          <td className="col_a">
            <input
              type="text"
              size="5"
              name="working_breakfast_expenses"
              value={specifications[i].working_breakfast_expenses}
              onChange={e => this.handleChange(e, i)}
            />
          </td>
          <td className="col_a">
            <input
              type="text"
              size="5"
              name="sparetime_breakfast_expenses"
              value={specifications[i].sparetime_breakfast_expenses}
              onChange={e => this.handleChange(e, i)}
            />
          </td>
          <td className="col_a">
            <input
              type="text"
              size="5"
              name="lastday_breakfast_expenses"
              value={specifications[i].lastday_breakfast_expenses}
              onChange={e => this.handleChange(e, i)}
            />
          </td>
          <td className="col_b">
            <input
              type="text"
              size="5"
              name="firstday_lunch_expenses"
              value={specifications[i].firstday_lunch_expenses}
              onChange={e => this.handleChange(e, i)}
            />
          </td>
          <td className="col_b">
            <input
              type="text"
              size="5"
              name="working_lunch_expenses"
              value={specifications[i].working_lunch_expenses}
              onChange={e => this.handleChange(e, i)}
            />
          </td>
          <td className="col_b">
            <input
              type="text"
              size="5"
              name="sparetime_lunch_expenses"
              value={specifications[i].sparetime_lunch_expenses}
              onChange={e => this.handleChange(e, i)}
            />
          </td>
          <td className="col_b">
            <input
              type="text"
              size="5"
              name="lastday_lunch_expenses"
              value={specifications[i].lastday_lunch_expenses}
              onChange={e => this.handleChange(e, i)}
            />
          </td>
          <td className="col_a">
            <input
              type="text"
              size="5"
              name="firstday_dinner_expenses"
              value={specifications[i].firstday_dinner_expenses}
              onChange={e => this.handleChange(e, i)}
            />
          </td>
          <td className="col_a">
            <input
              type="text"
              size="5"
              name="working_dinner_expenses"
              value={specifications[i].working_dinner_expenses}
              onChange={e => this.handleChange(e, i)}
            />
          </td>
          <td className="col_a">
            <input
              type="text"
              size="5"
              name="sparetime_dinner_expenses"
              value={specifications[i].sparetime_dinner_expenses}
              onChange={e => this.handleChange(e, i)}
            />
          </td>
          <td className="col_a">
            <input
              type="text"
              size="5"
              name="lastday_dinner_expenses"
              value={specifications[i].lastday_dinner_expenses}
              onChange={e => this.handleChange(e, i)}
            />
          </td>
          <td className="col_a">
            <input
              className="btn btn-sm"
              type="submit"
              value="&nbsp;speichern&nbsp;"
              onClick={() => {
                this.save(i);
              }}
            />
          </td>
        </tr>
      );
    }

    let inputForm = (
      <React.Fragment>
        <tr style={{ background: 'white' }}>
          <td colSpan="20" style={{ paddingTop: '20px', paddingBottom: '20px' }}>
            Pflichtenheft hinzufügen (Lediglich Zahlen und Bodenstriche sind erlaubt für die Nummer!)
          </td>
        </tr>
        <tr>
          <td className="col_a">
            <input type="checkbox" name="active" onChange={e => this.handleChangeNew(e)} />
          </td>
          <td className="col_a">
            <input type="text" style={{ width: '70px' }} name="id" onChange={e => this.handleChangeNew(e)} required />
          </td>
          <td className="col_a">
            <input type="text" size="20" name="name" onChange={e => this.handleChangeNew(e)} />
          </td>

          <td className="col_a">
            <input type="text" size="5" name="short_name" onChange={e => this.handleChangeNew(e)} />
          </td>

          <td className="col_b">
            <input type="text" size="5" name="pocket" onChange={e => this.handleChangeNew(e)} />
          </td>
          <td className="col_a">
            <input type="text" size="5" name="accommodation" onChange={e => this.handleChangeNew(e)} />
          </td>
          <td className="col_b">
            <input type="text" size="5" name="working_clothes_expense" onChange={e => this.handleChangeNew(e)} />
          </td>
          <td className="col_a">
            <input type="text" size="5" name="firstday_breakfast_expenses" onChange={e => this.handleChangeNew(e)} />
          </td>
          <td className="col_a">
            <input type="text" size="5" name="working_breakfast_expenses" onChange={e => this.handleChangeNew(e)} />
          </td>
          <td className="col_a">
            <input type="text" size="5" name="sparetime_breakfast_expenses" onChange={e => this.handleChangeNew(e)} />
          </td>
          <td className="col_a">
            <input type="text" size="5" name="lastday_breakfast_expenses" onChange={e => this.handleChangeNew(e)} />
          </td>
          <td className="col_b">
            <input type="text" size="5" name="firstday_lunch_expenses" onChange={e => this.handleChangeNew(e)} />
          </td>
          <td className="col_b">
            <input type="text" size="5" name="working_lunch_expenses" onChange={e => this.handleChangeNew(e)} />
          </td>
          <td className="col_b">
            <input type="text" size="5" name="sparetime_lunch_expenses" onChange={e => this.handleChangeNew(e)} />
          </td>
          <td className="col_b">
            <input type="text" size="5" name="lastday_lunch_expenses" onChange={e => this.handleChangeNew(e)} />
          </td>
          <td className="col_a">
            <input type="text" size="5" name="firstday_dinner_expenses" onChange={e => this.handleChangeNew(e)} />
          </td>
          <td className="col_a">
            <input type="text" size="5" name="working_dinner_expenses" onChange={e => this.handleChangeNew(e)} />
          </td>
          <td className="col_a">
            <input type="text" size="5" name="sparetime_dinner_expenses" onChange={e => this.handleChangeNew(e)} />
          </td>
          <td className="col_a">
            <input type="text" size="5" name="lastday_dinner_expenses" onChange={e => this.handleChangeNew(e)} />
          </td>
          <td className="col_a">
            <input
              className="btn btn-sm"
              type="submit"
              value="&nbsp;hinzufügen&nbsp;"
              onClick={() => {
                this.add();
              }}
            />
          </td>
        </tr>
      </React.Fragment>
    );

    return (
      <Header>
        <div className="page page__specification">
          <ScrollableCard>
            <h1>Pflichtenheft</h1>
            <table className="table table-bordered table-hover">
              <thead>
                <tr>
                  <th rowSpan="2" className="col_a">
                    Aktiv
                  </th>
                  <th rowSpan="2" className="col_a">
                    ID
                  </th>
                  <th rowSpan="2" className="col_a">
                    Name
                  </th>
                  <th rowSpan="2" className="col_a">
                    Short-Name
                  </th>
                  <th rowSpan="2" className="col_b">
                    Taschengeld
                  </th>
                  <th rowSpan="2" className="col_a">
                    Unterkunft
                  </th>
                  <th rowSpan="2" className="col_b">
                    Kleider
                  </th>
                  <th colSpan="4" className="col_a">
                    Fr&uuml;hst&uuml;ck
                  </th>
                  <th colSpan="4" className="col_b">
                    Mittagessen
                  </th>
                  <th colSpan="5" className="col_a">
                    Abendessen
                  </th>
                </tr>
                <tr>
                  <td className="col_a" style={{ textAlign: 'center' }}>
                    Erster Tag
                  </td>
                  <td className="col_a" style={{ textAlign: 'center' }}>
                    Arbeit
                  </td>
                  <td className="col_a" style={{ textAlign: 'center' }}>
                    Frei
                  </td>
                  <td className="col_a" style={{ textAlign: 'center' }}>
                    Letzter Tag
                  </td>
                  <td className="col_b" style={{ textAlign: 'center' }}>
                    Erster Tag
                  </td>
                  <td className="col_b" style={{ textAlign: 'center' }}>
                    Arbeit
                  </td>
                  <td className="col_b" style={{ textAlign: 'center' }}>
                    Frei
                  </td>
                  <td className="col_b" style={{ textAlign: 'center' }}>
                    Letzter Tag
                  </td>
                  <td className="col_a" style={{ textAlign: 'center' }}>
                    Erster Tag
                  </td>
                  <td className="col_a" style={{ textAlign: 'center' }}>
                    Arbeit
                  </td>
                  <td className="col_a" style={{ textAlign: 'center' }}>
                    Frei
                  </td>
                  <td className="col_a" style={{ textAlign: 'center' }}>
                    Letzter Tag
                  </td>
                  <td />
                </tr>
              </thead>
              <tbody>
                {tbody}
                {inputForm}
              </tbody>
            </table>
          </ScrollableCard>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
