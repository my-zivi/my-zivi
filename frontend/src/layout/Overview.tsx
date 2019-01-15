import * as React from 'react';
import { OverviewTable } from './OverviewTable';
import { inject, observer } from 'mobx-react';
import { MainStore } from '../stores/mainStore';
import { Column, Listing } from '../types';
import { DomainStore } from '../stores/domainStore';
import IziviContent from './IziviContent';

interface Props<ListingType> {
  //tslint:disable-next-line:no-any ; the first type doesn't matter at all here and makes typing much more verbose
  store: DomainStore<any, ListingType>;
  title?: string;
  children?: React.ReactNode;
  renderActions?: (e: ListingType) => React.ReactNode;
  columns?: Array<Column<ListingType>>;
  onClickRow?: ((e: ListingType) => void) | string;
  firstRow?: React.ReactNode;
  filter?: boolean;
  mainStore?: MainStore;
}

interface State {
  loading: boolean;
}

@inject('mainStore')
@observer
export default class Overview<ListingType extends Listing> extends React.Component<Props<ListingType>, State> {
  constructor(props: Props<ListingType>) {
    super(props);
    props.store!.fetchAll().then(() => {
      this.setState({ loading: false });
      if (this.props.filter) {
        this.props.store!.filter();
      }
    });
    this.state = {
      loading: true,
    };
  }

  public handleClick = (e: ListingType) => {
    const onClickRow = this.props.onClickRow;
    if (typeof onClickRow === 'string') {
      this.props.mainStore!.navigateTo(onClickRow.replace(':id', String(e.id)));
    } else if (typeof onClickRow === 'function') {
      onClickRow(e);
    }
  };

  public render() {
    const entities = this.props.filter ? this.props.store!.filteredEntities : this.props.store!.entities;

    return (
      <IziviContent card loading={this.state.loading} title={this.props.title}>
        {this.props.children} <br />
        <br />
        {this.props.columns && (
          <OverviewTable
            columns={this.props.columns}
            renderActions={this.props.renderActions}
            data={entities}
            onClickRow={this.handleClick}
            firstRow={this.props.firstRow}
          />
        )}
      </IziviContent>
    );
  }
}
