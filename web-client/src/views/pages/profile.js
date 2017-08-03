import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import InputField from '../tags/InputField';
import InputFieldWithHelpText from '../tags/InputFieldWithHelpText';
import InputCheckbox from '../tags/InputCheckbox';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from "../../utils/api";
import LoadingView from "../tags/loading-view";
import Header from "../tags/header";

export default class User extends Component {
    constructor(props) {
        super(props);

        this.state = {
            result: [],
            cantons: [],
        };
    }

    componentDidMount()
    {
        this.getUser();
        this.getCantons();
    }

    getCantons() {
        axios.get(
            ApiService.BASE_URL+'canton',
            { headers: { Authorization: "Bearer " + localStorage.getItem('jwtToken') } }
        ).then((response) => {
            this.setState({
                cantons : response.data,
            });
        }).catch((error) => {
            this.setState({error: error});
        });
    }

    renderCantons() {
        var options = [];
        options.push(<option value=""></option>);


        for(let i = 0; i < this.state.cantons.length; i++) {

            let isSelected = null;
            if(parseInt(this.state.result['canton']) == i) {
                isSelected.push(selected);
                console.log("isSelected does not work yet"); //TODO
            }

            options.push(<option value={this.state.cantons[i].id}  {isSelected}>{this.state.cantons[i].short_name}</option>)
        }

        return options;
    }

    getUser() {
        this.setState({loading: true, error: null});

        axios.get(
            ApiService.BASE_URL+'user'+(this.props.params.userid ? '/'+this.props.params.userid : ''),
            { headers: { Authorization: "Bearer " + localStorage.getItem('jwtToken') } }
        ).then((response) => {
            this.setState({
                result: response.data,
                loading: false
            });

        }).catch((error) => {
            this.setState({error: error});
        });
    }

    handleChange(e) {
        console.log(e);
        const value = e.target.type === 'checkbox' ? e.target.checked : e.target.value;
        this.state['result'][e.target.name] = value;
        this.setState(this.state);
        console.log(this.state);
        console.log(this.state.result.id);
    }

    handleCantonSelectChange(e) {

        let selectedValue = $("select#canton option:checked").val();
        this.state['result'][e.target.name] = selectedValue;
        this.setState(this.state);
        console.log(this.state);
        console.log(this.state.result.id);
    }

    save(){
        this.setState({loading:true, error:null});
        axios.post(
            ApiService.BASE_URL+'user/'+this.state.result.id,
            this.state.result,
            { headers: { Authorization: "Bearer " + localStorage.getItem('jwtToken') } }
        ).then((response) => {
            this.setState({loading: false});
        }).catch((error) => {
            this.setState({error: error});
        });
    }

    render() {

        let result = this.state.result;
        let howerText_BankName = "Name, Postleitzahl und Ort deiner Bank. Während der Eingabe werden dir Banken mit den entsprechenden Namen und aus den entsprechenden Ortschaften vorgeschlagen welche du auswählen kannst um automatisch die Clearing-Nr. und Postkonto-Nr. abfüllen zu lassen. Beispiel: Meine Bank, 8000 Zürich";

        return (
			<Header>
                <div className="page page__user_list">
                    <Card>
                        <h1>Profil</h1>
                        <div class="container">

                        <form class="form-horizontal">
                            <hr />
                                <button name="resetPassword" type="submit" class="btn btn-primary">Passwort zurücksetzen</button>
                                <input name="id" value="00000" type="hidden"/>
                                <input name="action" value="saveEmployee" type="hidden"/>
                            <hr />

                            <h3>Persönliche Informationen</h3>
                            <InputField id="zdp" label="ZDP" value={result.zdp} disabled="true"/>
                            <InputField id="first_name" label="Vorname" value={result.first_name} self={this} />
                            <InputField id="last_name" label="Nachname" value={result.last_name} self={this} />

                            <InputField id="address" label="Strasse" value={result.address} self={this} />
                            <InputField id="city" label="Ort" value={result.city} self={this} />

                            <InputField inputType="date" id="birthday" label="Geburtstag" value={result.birthday} self={this} />
                            <InputField id="hometown" label="Heimatort" value={result.hometown} self={this} />

                            <InputField inputType="email" id="email" label="E-Mail" value={result.email} self={this} />
                            <InputField inputType="tel" id="phone_mobile" label="Tel. Mobil" value={result.phone_mobile} self={this} />
                            <InputField inputType="tel" id="phone_private" label="Tel. Privat" value={result.phone_private} self={this} />
                            <InputField inputType="tel" id="phone_business" label="Tel. Geschäft" value={result.phone_business} self={this} />

                            <div class="form-group">
                                <label class="control-label col-sm-3" for="canton">Kanton</label>
                                <div class="col-sm-9">
                                    <select id="canton" name="canton" class="form-control" onChange={(e)=>this.handleCantonSelectChange(e)}>
                                        { this.renderCantons() }
                                    </select>
                                </div>
                            </div>,

                            <hr />
                            <h3>Bank-/Postverbindung</h3>,
                            <InputFieldWithHelpText id="bank_iban" label="IBAN-Nr." value={result.bank_iban} popoverText={howerText_BankName} self={this} />
                            <InputFieldWithHelpText id="post_account" label="Postkonto-Nr." value={result.post_account} popoverText={howerText_BankName} self={this} />

                            <hr />
                             <h3>Diverse Informationen</h3>,
                             <div class="form-group">
                                 <label class="control-label col-sm-3" for="berufserfahrung">Berufserfahrung</label>
                                 <div class="col-sm-8">
                                     <textarea rows="4" id="berufserfahrung" name="berufserfahrung" class="form-control" onChange={(e)=>this.handleChange(e)}>{result.work_experience}</textarea>
                                 </div>
                                 <div id="_helpberufserfahrung" className="col-sm-1">
                                     <a href="#" data-toggle="popover" title="Berufserfahrung" data-content="Text TODO">
                                         <span style="font-size:2em;" className="glyphicon glyphicon-question-sign" aria-hidden="true"/>
                                     </a>
                                 </div>
                             </div>

                             <div class="form-group">
                                 <label class="control-label col-sm-3" for="hometown">Regionalzentrum</label>
                                 <div class="col-sm-9">
                                     <select id="regionalzentrum" name="regionalzentrum" class="form-control" onChange={(e)=>this.handleChange(e)}> // regional_center
                                         <option value="-1"></option>
                                         <option value="1">Regionalzentrum Thun</option>
                                         <option value="3">Regionalzentrum Rueti/ZH</option>
                                         <option value="4">Regionalzentrum Luzern</option>
                                         <option value="6">Centre regional Lausanne</option>
                                         <option value="7">Regionalzentrum Rivera</option>
                                         <option value="8">Regionalzentrum Aarau</option>
                                     </select>
                                 </div>
                             </div>

                             <InputCheckbox id="driving_licence" value={result.driving_licence} label="Führerausweis" self={this} />
                             <InputCheckbox id="travel_card" value={result.travel_card} label="GA" self={this} />

                             <div class="form-group">
                                 <label class="control-label col-sm-3" for="internal_comment">Int. Bemerkung</label>
                                 <div class="col-sm-9">
                                     <textarea rows="4" id="internal_note" class="form-control" onChange={(e)=>this.handleChange(e)}>{result.internal_note}</textarea>
                                 </div>
                             </div>

                            <button type="submit" class="btn btn-primary" onclick={()=>{this.save()}}>Absenden</button>
                        </form>
                        </div>
                    </Card>
                <LoadingView loading={this.state.loading} error={this.state.error}/>
            </div>
        </Header>
        );
    }
}
