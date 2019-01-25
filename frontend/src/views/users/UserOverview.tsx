import * as React from 'react';
import { Column, User } from '../../types';
import Overview from '../../layout/Overview';
import { inject, observer } from 'mobx-react';
import { Link } from 'react-router-dom';
import { MainStore } from '../../stores/mainStore';
import { UserStore } from '../../stores/userStore';
import { DatePickerInput } from 'src/form/DatePickerField';
import Input from 'reactstrap/lib/Input';
import FormGroup from 'reactstrap/lib/FormGroup';

interface Props {
  mainStore?: MainStore;
  userStore?: UserStore;
}

@inject('mainStore', 'userStore')
@observer
export class UserOverview extends React.Component<Props> {
  public columns: Array<Column<User>>;

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
        format: (u: User) => (u.start ? this.props.mainStore!.formatDate(u.start) : ''),
      },
      {
        id: 'end',
        label: 'Bis',
        format: (u: User) => (u.end ? this.props.mainStore!.formatDate(u.end) : ''),
      },
      {
        id: 'active',
        label: 'Aktiv',
      },
      {
        id: 'userRole',
        label: 'Gruppe',
        format: (u: User) => <>{`${u.role.name}`}</>,
      },
    ];
  }

  public render() {
    return (
      <Overview
        columns={this.columns}
        store={this.props.userStore!}
        title={'Benutzer'}
        // renderActions={(e: User) => (
        //   <>
        //     <Link to={'/users/' + e.id}>Benutzer bearbeiten</Link>
        //   </>
        // )}
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
              >
                {[{ id: '', name: 'Alle' }, { id: 'zivi', name: 'Zivi' }, { id: 'admin', name: 'Admin' }].map(option => (
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
