import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';

export default class Specifications extends Component {
  constructor(props) {
    super(props);

    this.state = {
      specifications: [],
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
    axios
      .get(ApiService.BASE_URL + 'specification', { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
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

  render() {
    var tbody = [];

    var specifications = this.state.specifications;
    for (let i = 0; i < specifications.length; i++) {
      tbody.push(
        <tr>
          <td class="col_a">
            <input type="checkbox" name="active" defaultChecked={specifications[i].active ? 'checked' : ''} />
          </td>
          <td class="col_a">{specifications[i].id}</td>
          <td class="col_a">
            <input type="text" size="20" name="name" value={specifications[i].name} />
          </td>

          <td class="col_a">
            <input type="text" size="5" name="short_name" value={specifications[i].short_name} />
          </td>

          <td class="col_b">
            <input type="text" size="5" name="pocket" value={specifications[i].pocket} />
          </td>
          <td class="col_a">
            <input type="text" size="5" name="accommodation" value={specifications[i].accommodation} />
          </td>
          <td class="col_b">
            <input type="text" size="5" name="working_clothes_expense" value={specifications[i].working_clothes_expense} />
          </td>
          <td class="col_a">
            <input type="text" size="5" name="firstday_breakfast_expenses" value={specifications[i].firstday_breakfast_expenses} />
          </td>
          <td class="col_a">
            <input type="text" size="5" name="working_breakfast_expenses" value={specifications[i].working_breakfast_expenses} />
          </td>
          <td class="col_a">
            <input type="text" size="5" name="sparetime_breakfast_expenses" value={specifications[i].sparetime_breakfast_expenses} />
          </td>
          <td class="col_a">
            <input type="text" size="5" name="lastday_breakfast_expenses" value={specifications[i].lastday_breakfast_expenses} />
          </td>
          <td class="col_b">
            <input type="text" size="5" name="firstday_lunch_expenses" value={specifications[i].firstday_lunch_expenses} />
          </td>
          <td class="col_b">
            <input type="text" size="5" name="working_lunch_expenses" value={specifications[i].working_lunch_expenses} />
          </td>
          <td class="col_b">
            <input type="text" size="5" name="sparetime_lunch_expenses" value={specifications[i].sparetime_lunch_expenses} />
          </td>
          <td class="col_b">
            <input type="text" size="5" name="lastday_lunch_expenses" value={specifications[i].lastday_lunch_expenses} />
          </td>
          <td class="col_a">
            <input type="text" size="5" name="firstday_dinner_expenses" value={specifications[i].firstday_dinner_expenses} />
          </td>
          <td class="col_a">
            <input type="text" size="5" name="working_dinner_expenses" value={specifications[i].working_dinner_expenses} />
          </td>
          <td class="col_a">
            <input type="text" size="5" name="sparetime_dinner_expenses" value={specifications[i].sparetime_dinner_expenses} />
          </td>
          <td class="col_a">
            <input type="text" size="5" name="lastday_dinner_expenses" value={specifications[i].lastday_dinner_expenses} />
          </td>
          <td class="col_a">
            <input class="btn" type="submit" value="&nbsp;speichern&nbsp;" />
          </td>
        </tr>
      );
    }

    return (
      <Header>
        <div className="page page__specification">
          <Card>
            <h1>Pflichtenheft</h1>
            <table class="table table-bordered table-hover">
              <thead>
                <tr>
                  <th ROWSPAN="2" class="col_a">
                    Aktiv
                  </th>
                  <th ROWSPAN="2" class="col_a">
                    ID
                  </th>
                  <th ROWSPAN="2" class="col_a">
                    Name
                  </th>
                  <th ROWSPAN="2" class="col_a">
                    Short-Name
                  </th>
                  <th ROWSPAN="2" class="col_b">
                    Taschengeld
                  </th>
                  <th ROWSPAN="2" class="col_a">
                    Unterkunft
                  </th>
                  <th ROWSPAN="2" class="col_b">
                    Kleider
                  </th>
                  <th COLSPAN="4" class="col_a">
                    Fr&uuml;hst&uuml;ck
                  </th>
                  <th COLSPAN="4" class="col_b">
                    Mittagessen
                  </th>
                  <th COLSPAN="5" class="col_a">
                    Abendessen
                  </th>
                </tr>
                <tr>
                  <td class="col_a" style="text-align:center">
                    Erster Tag
                  </td>
                  <td class="col_a" style="text-align:center">
                    Arbeit
                  </td>
                  <td class="col_a" style="text-align:center">
                    Frei
                  </td>
                  <td class="col_a" style="text-align:center">
                    Letzter Tag
                  </td>
                  <td class="col_b" style="text-align:center">
                    Erster Tag
                  </td>
                  <td class="col_b" style="text-align:center">
                    Arbeit
                  </td>
                  <td class="col_b" style="text-align:center">
                    Frei
                  </td>
                  <td class="col_b" style="text-align:center">
                    Letzter Tag
                  </td>
                  <td class="col_a" style="text-align:center">
                    Erster Tag
                  </td>
                  <td class="col_a" style="text-align:center">
                    Arbeit
                  </td>
                  <td class="col_a" style="text-align:center">
                    Frei
                  </td>
                  <td class="col_a" style="text-align:center">
                    Letzter Tag
                  </td>
                  <td />
                </tr>
              </thead>
              <tbody>{tbody}</tbody>
            </table>
          </Card>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
