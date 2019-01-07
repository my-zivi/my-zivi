import { observable } from 'mobx';
import { displayError, displaySuccess, displayWarning } from '../utilities/notification';

export class MainStore {
  @observable
  public navOpen = false;

  public displayWarning = displayWarning;
  public displaySuccess = displaySuccess;
  public displayError = displayError;
}
