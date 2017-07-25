import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Component from 'inferno-component';

import { connect } from 'inferno-mobx';

import Card from '../tags/card';

//import API from '../../utils/api.js';
import axios from 'axios';

// const click = () => {
// 	console.log('Clicked on ' + this.props.name);
// 	//this.props.onCarSelected(this.props.name, this.props.id, this.props.make);
// }

// export default function (props) {

// 	return (
// 		<div className="page page__login">
// 			<Card>
// 				<h1>Login</h1>
// 				<form>
// 					Username:
// 					<br/>
// 					<input type="text" name="username" />
// 					<br/>
// 					Password:
// 					<br/>
// 					<input type="password" name="pw" />
// 					<br/>
// 					<br/>
// 					<input type="button" value="Senden" onClick={props.name}/>
// 				</form>
// 			</Card>
// 		</div>
// 	);
// }

//const url = 'https://dev.stiftungswo.ch/api/regionalcenter';
const inputEmail = 'office@stiftungswo.ch';
const inputPassword = '1234';

@connect(['accountStore'])
export default class Login extends Component {
  constructor(props) {
    super(props);

    this.state = {
      count: 0,
      data: [],
    };
  }

  componentDidMount() {
    // fetch(url)
    // 	.then(response => {
    // 		if (response.status >= 400) {
    // 			throw new Error("Bad response from server");
    // 		}
    // 	})
    // 	.then(data => {
    // 		this.setState({ data: data });
    // 	});
    // fetch(url).then(r => r.json())
    // 	.then(data => this.setState({ data: data }))
    // 	.catch(e => console.log(e))
    // axios.get('http://localhost:3001/posts')
    // 	.then(function (response) {
    // 		console.log(response);
    // 	})
    // 	.catch(function (error) {
    // 		console.log(error);
    // 	});
    // axios.post(
    // 	'https://dev.stiftungswo.ch/api/auth/login',
    // 	{email: 'office@stiftungswo.ch', password: '1234'}
    // ).then(response => {
    // 		console.log(response.data);
    // 		console.log(response.status);
    // 		console.log(response.statusText);
    // 		console.log(response.headers);
    // 		console.log(response.config);
    // 		console.log('----Login----');
    // 		console.log(response);
    // 		console.log(response.data.message);
    // 		console.log(response.data.data.token);
    // 		localStorage.setItem('jwtToken', response.data.data.token);
    // 		console.log(localStorage.getItem('jwtToken'));
    // 		console.log('----RegionalCenter----');
    // 		axios.get(
    // 			'https://dev.stiftungswo.ch/api/regionalcenter',
    // 			//null, // {"key: "value"}
    // 			{ headers: { Authorization: "Bearer " + localStorage.getItem('jwtToken') } }
    // 			//{'Authorization': "Bearer " + localStorage.getItem('jwtToken')}
    // 		).then(response => {
    // 			console.log(response);
    // 			this.setState({ data: response.data });
    // 		}).catch(error => {
    // 			//dispatch({ type: AUTH_FAILED });
    // 			//dispatch({ type: ERROR, payload: error.data.error.message });
    // 			console.log('RegionalCenter Error');
    // 			console.log(error);
    // 		});
    // }).catch(error => {
    // 		//dispatch({ type: AUTH_FAILED });
    // 		//dispatch({ type: ERROR, payload: error.data.error.message });
    // 		console.log('GeneralAPI Error');
    // 		console.log(error);
    // });
  }

  increase() {
    this.setState({
      count: (this.state.count += 1),
    });
  }

  decrease() {
    this.setState({
      count: (this.state.count -= 1),
    });
  }

  login() {
    axios
      .post('https://dev.stiftungswo.ch/api/auth/login', { email: inputEmail, password: inputPassword })
      .then(response => {
        console.log(response);
        console.log(response.data.message);
        console.log(response.data.data.token);
        console.log(this.props);
        console.log(this.props.accountStore);
        //console.log(this.props.accountStore.email)

        this.props.accountStore.email = inputEmail;
        this.props.accountStore.token = response.data.data.token;
        this.props.accountStore.isLoggedIn = true;
        this.props.accountStore.isAdmin = true;
        localStorage.setItem('jwtToken', response.data.data.token);
        console.log(this.props);
        //this.props.history.push('/home')
      })
      .catch(error => {
        console.log('Login failed!');
        console.log(error); // to be verified also: error.data.error.message
        if (!error.response) {
          // network error
          console.log('Cannot connect to API server.');
        } else {
          // http status code
          console.log(error.response.status);
          // response data
          console.log(error.response.data);
        }
      });
  }

  render() {
    return (
      <div className="page page__login">
        <Card>
          {this.state.data.map(data => (
            <div>
              <ul>
                <li>{data.id}</li>
                <li>{data.name}</li>
              </ul>
              <br />
            </div>
          ))}
          <h1>{this.state.count}</h1>
          <button onClick={() => this.increase()}>+</button>
          <button onClick={() => this.decrease()}>-</button>
          <button onClick={() => this.login()}>Login</button>
        </Card>
      </div>
    );
  }
}
