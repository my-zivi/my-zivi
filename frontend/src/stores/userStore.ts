import debounce from 'lodash.debounce';
import { action, computed, observable, reaction } from 'mobx';
import moment from 'moment';
import { User, UserFilter } from '../types';
import { DomainStore } from './domainStore';
import { MainStore } from './mainStore';

export class UserStore extends DomainStore<User> {
  protected get entityName() {
    return {
      singular: 'Der Benutzer',
      plural: 'Die Benutzer',
    };
  }

  @computed
  get entities(): User[] {
    return this.users;
  }

  set entities(users: User[]) {
    this.users = users;
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
        const { zdp, name, beginning, ending, active, role } = this.userFilters;
        switch (true) {
          case zdp && !user.zdp.toString().startsWith(zdp.toString()):
          case name && !(user.first_name + ' ' + user.last_name).toLowerCase().includes(name.toLowerCase()):
          case beginning && user.beginning && moment(user.beginning).isBefore(moment(beginning)):
          case ending && user.ending && moment(user.ending).isAfter(moment(ending)):
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

  protected entityURL = '/users/';
  protected entitiesURL = '/users/';

  constructor(mainStore: MainStore) {
    super(mainStore);
    this.userFilters = observable.object({
      zdp: '',
      name: '',
      beginning: moment()
        .subtract(1, 'year')
        .date(0)
        .format('Y-MM-DD'),
      ending: moment()
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
        this.userFilters.beginning,
        this.userFilters.ending,
        this.userFilters.active,
        this.userFilters.role,
      ],
      this.filter,
    );
  }

  @action
  updateFilters(updates: Partial<UserFilter>) {
    this.userFilters = { ...this.userFilters, ...updates };
  }
}
