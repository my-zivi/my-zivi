import debounce from 'lodash.debounce';
import { action, computed, observable, reaction } from 'mobx';
import moment from 'moment';
import { User, UserFilter } from '../types';
import { DomainStore } from './domainStore';
import { MainStore } from './mainStore';

export class UserStore extends DomainStore<User> {
  protected get entityName() {
    return {
      singular: 'Der Beutzer',
      plural: 'Die Benutzer',
    };
  }

  @computed
  get entities(): User[] {
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
  users: User[] = [];

  @observable
  user?: User;

  @observable
  userFilters: UserFilter;

  filter = debounce(() => {
    this.filteredEntities = this.users.filter((user: User) => {
        const { zdp, name, date_from, date_to, active, role } = this.userFilters;
        switch (true) {
          case zdp && !user.zdp.toString().startsWith(zdp.toString()):
          case name && !(user.first_name + ' ' + user.last_name).toLowerCase().includes(name.toLowerCase()):
          case date_from && user.beginning && moment(user.beginning).isBefore(moment(date_from)):
          case date_to && user.ending && moment(user.ending).isAfter(moment(date_to)):
          case active && !user.active:
            return false;
          default:
            return !(role && user.role !== role);
        }
      })
      .sort((a: User, b: User) => {
        if (!a.beginning && b.beginning) {
          return 1;
        }
        if (!b.beginning && a.beginning) {
          return -1;
        }
        if (!b.beginning || !a.beginning) {
          return 0;
        }
        return moment(a.beginning).isBefore(b.beginning) ? 1 : -1;
      });
  }, 100);

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
      this.filter,
    );
  }

  @action
  updateFilters(updates: Partial<UserFilter>) {
    this.userFilters = {...this.userFilters, ...updates};
  }

  @action
  protected async doDelete(id: number) {
    await this.mainStore.api.delete('/users/' + id);
    await this.doFetchAll();
    await this.filter();
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
}
