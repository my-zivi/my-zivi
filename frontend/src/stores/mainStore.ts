import { observable } from 'mobx';

export class MainStore {
  @observable
  public navOpen = false;
}
