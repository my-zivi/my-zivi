import { inject, observer } from 'mobx-react';
import * as React from 'react';
import { Link } from 'react-router-dom';
import Button from 'reactstrap/lib/Button';
import FormGroup from 'reactstrap/lib/FormGroup';
import Input from 'reactstrap/lib/Input';
import { DatePickerInput } from '../../form/DatePickerField';
import Overview from '../../layout/Overview';
import { MainStore } from '../../stores/mainStore';
import { UserStore } from '../../stores/userStore';
import { Column, User } from '../../types';
import { translateUserRole } from '../../utilities/helpers';

interface Props {
  mainStore?: MainStore;
  userStore?: UserStore;
}

@inject('mainStore', 'userStore')
@observer
export class UserOverview extends React.Component<Props> {
  columns: Array<Column<User>>;

  constructor(props: Props) {
    super(props);
    this.columns = [
      {
        id: 'zdp',
        label: 'ZDP',
        format: (u: User) => <>{String(u.zdp)}</>,
      },
      {
        id: 'name',
        label: 'Name',
        format: (u: User) => <Link to={'/users/' + u.id}>{`${u.first_name} ${u.last_name}`}</Link>,
      },
      {
        id: 'start',
        label: 'Von',
        format: (u: User) => (u.beginning ? this.props.mainStore!.formatDate(u.beginning) : ''),
      },
      {
        id: 'end',
        label: 'Bis',
        format: (u: User) => (u.ending ? this.props.mainStore!.formatDate(u.ending) : ''),
      },
      {
        id: 'active',
        label: 'Aktiv',
      },
      {
        id: 'userRole',
        label: 'Gruppe',
        format: translateUserRole,
      },
    ];
  }

  render() {
    return (
      <Overview
        columns={this.columns}
        store={this.props.userStore!}
        title={'Benutzer'}
        renderActions={(user: User) => (
          <Button color={'danger'} onClick={() => this.props.userStore!.delete(user.id!)}>
            Löschen
          </Button>
        )}
        filter={true}
        firstRow={
          <tr>
            <td>
              <Input
                type={'text'}
                onChange={(e: React.ChangeEvent<HTMLInputElement>) => {
                  this.props.userStore!.updateFilters({
                    zdp: e.target.value,
                  });
                }}
                value={this.props.userStore!.userFilters.zdp || ''}
              />
            </td>
            <td>
              <Input
                type={'text'}
                onChange={(e: React.ChangeEvent<HTMLInputElement>) => {
                  this.props.userStore!.updateFilters({
                    name: e.target.value,
                  });
                }}
                value={this.props.userStore!.userFilters.name}
              />
            </td>
            <td>
              <DatePickerInput
                value={new Date(this.props.userStore!.userFilters.date_from)}
                onChange={(d: Date) => {
                  this.props.userStore!.updateFilters({
                    date_from: d.toISOString(),
                  });
                }}
              />
            </td>
            <td>
              <DatePickerInput
                value={new Date(this.props.userStore!.userFilters.date_to)}
                onChange={(d: Date) => {
                  this.props.userStore!.updateFilters({
                    date_to: d.toISOString(),
                  });
                }}
              />
            </td>
            <td>
              <FormGroup check>
                <Input
                  type={'checkbox'}
                  onChange={(e: React.ChangeEvent<HTMLInputElement>) => {
                    this.props.userStore!.updateFilters({
                      active: e.target.checked,
                    });
                  }}
                  checked={this.props.userStore!.userFilters.active}
                />
              </FormGroup>
            </td>
            <td>
              <Input
                type={'select'}
                onChange={(e: React.ChangeEvent<HTMLInputElement>) => {
                  this.props.userStore!.updateFilters({
                    role: e.target.value,
                  });
                }}
                value={this.props.userStore!.userFilters.role || ''}
              >
                {[{ id: '', name: 'Alle' }, { id: 'civil_servant', name: 'Zivi' }, { id: 'admin', name: 'Admin' }].map(option => (
                  <option value={option.id} key={option.id}>
                    {option.name}
                  </option>
                ))}
              </Input>
            </td>
          </tr>
        }
      />
    );
  }
}
