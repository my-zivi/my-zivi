import { action, computed, observable, reaction } from 'mobx';
import { MainStore } from './mainStore';
import { DomainStore } from './domainStore';
import { User, UserFilter } from '../types';
import moment from 'moment';
import debounce from 'lodash.debounce';

export class UserStore extends DomainStore<User> {
  protected get entityName() {
    return {
      singular: 'Der Beutzer',
      plural: 'Die Benutzer',
    };
  }

  @computed
  get entities(): Array<User> {
    return this.users;
  }

  @computed
  get entity(): User | undefined {
    return this.user;
  }

  set entity(holiday: User | undefined) {
    this.user = holiday;
  }

  @observable
  public users: User[] = [];

  @observable
  public user?: User;

  @observable
  public userFilters: UserFilter;

  constructor(mainStore: MainStore) {
    super(mainStore);
    this.userFilters = observable.object({
      zdp: '',
      name: '',
      date_from: moment()
        .subtract(1, 'year')
        .date(0)
        .format('Y-MM-DD'),
      date_to: moment()
        .add(5, 'year')
        .date(0)
        .format('Y-MM-DD'),
      active: false,
      role: '',
    });

    reaction(
      () => [
        this.userFilters.zdp,
        this.userFilters.name,
        this.userFilters.date_from,
        this.userFilters.date_to,
        this.userFilters.active,
        this.userFilters.role,
      ],
      () => {
        this.filter();
      }
    );
  }

  @action
  public updateFilters(updates: Partial<UserFilter>) {
    this.userFilters = Object.assign(this.userFilters, updates);
  }

  @action
  protected async doDelete(id: number) {
    await this.mainStore.api.delete('/users/' + id);
    await this.doFetchAll();
  }

  @action
  protected async doFetchAll() {
    const res = await this.mainStore.api.get<User[]>('/users');
    this.users = res.data;
  }

  protected async doFetchOne(id: number) {
    const res = await this.mainStore.api.get<User>('/users/' + id);
    this.user = res.data;
  }

  @action
  protected async doPost(user: User) {
    const response = await this.mainStore.api.post<User[]>('/users', user);
    this.users = response.data;
  }

  @action
  protected async doPut(user: User) {
    const response = await this.mainStore.api.put<User[]>('/users/' + user.id, user);
    this.users = response.data;
  }

  public filter = debounce(() => {
    this.filteredEntities = this.users
      .filter((u: User) => {
        const { zdp, name, date_from, date_to, active, role } = this.userFilters;
        if (zdp && !u.zdp.toString().startsWith(zdp.toString())) {
          return false;
        }
        if (name && !(u.first_name + ' ' + u.last_name).toLowerCase().includes(name.toLowerCase())) {
          return false;
        }
        if (date_from && u.start && moment(u.start).isBefore(moment(date_from))) {
          return false;
        }
        if (date_to && u.end && moment(u.end).isAfter(moment(date_to))) {
          return false;
        }
        if (active && !u.active) {
          return false;
        }
        if (role && u.role.name !== role) {
          return false;
        }
        return true;
      })
      .sort((a: User, b: User) => {
        if (!a.start && b.start) {
          return 1;
        }
        if (!b.start && a.start) {
          return -1;
        }
        if (!b.start || !a.start) {
          return 0;
        }
        return moment(a.start).isBefore(b.start) ? 1 : -1;
      });
  }, 100);
}
