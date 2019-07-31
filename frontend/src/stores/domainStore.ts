// tslint:disable:no-console
import { template } from 'lodash';
import { action, observable } from 'mobx';
import { noop } from '../utilities/helpers';
import { MainStore } from './mainStore';

/**
 * This class wraps all common store functions with success/error popups.
 * The desired methods that start with "do" should be overridden in the specific stores.
 */
export class DomainStore<SingleType, OverviewType = SingleType> {
  protected get entityName() {
    return { singular: 'Die Entität', plural: 'Die Entitäten' };
  }

  get entity(): SingleType | undefined {
    throw new Error('Not implemented');
  }

  set entity(e: SingleType | undefined) {
    throw new Error('Not implemented');
  }

  get entities(): OverviewType[] {
    throw new Error('Not implemented');
  }

  set entities(entities: OverviewType[]) {
    throw new Error('Not implemented');
  }

  private static buildErrorMessage(e: { messages: any }, defaultMessage: string) {
    if ('messages' in e) {
      return this.buildServerErrorMessage(e, defaultMessage);
    }

    return defaultMessage;
  }

  private static buildServerErrorMessage(e: { messages: any }, defaultMessage: string) {
    if ('error' in e.messages) {
      return `${defaultMessage}: ${e.messages.error}`;
    } else if ('human_readable_descriptions' in e.messages) {
      return this.buildHumanReadableErrorList(e, defaultMessage);
    } else if ('errors' in e.messages && typeof e.messages.errors === 'string') {
      return `${defaultMessage}: ${e.messages.errors}`;
    }

    return defaultMessage;
  }

  private static buildHumanReadableErrorList(e: { messages: any }, defaultMessage: string) {
    const errorMessageTemplate = `
              <ul class="mt-1 mb-0">
                <% _.forEach(messages, message => {%>
                    <li><%- message %></li>
                <%});%>
              </ul>
            `;

    return `${defaultMessage}:` + template(errorMessageTemplate)({ messages: e.messages.human_readable_descriptions });
  }

  @observable
  filteredEntities: OverviewType[] = [];

  filter: () => void = noop;

  protected entitiesURL?: string = '';
  protected entityURL?: string = '';

  constructor(protected mainStore: MainStore) {}

  @action
  async fetchAll(params: object = {}) {
    try {
      await this.doFetchAll(params);
    } catch (e) {
      this.mainStore.displayError(DomainStore.buildErrorMessage(e, `${this.entityName.plural} konnten nicht geladen werden`));
      console.error(e);
      throw e;
    }
  }

  @action
  async fetchOne(id: number) {
    try {
      this.entity = undefined;
      return await this.doFetchOne(id);
    } catch (e) {
      this.mainStore.displayError(DomainStore.buildErrorMessage(e, `${this.entityName.singular} konnte nicht geladen werden`));
      console.error(e);
      throw e;
    }
  }

  @action
  async post(entity: SingleType) {
    this.displayLoading(async () => {
      try {
        await this.doPost(entity);
        this.mainStore.displaySuccess(`${this.entityName.singular} wurde gespeichert.`);
      } catch (e) {
        this.mainStore.displayError(DomainStore.buildErrorMessage(e, `${this.entityName.singular} konnte nicht gespeichert werden`));
        throw e;
      }
    });
  }

  @action
  async put(entity: SingleType) {
    this.displayLoading(async () => {
      try {
        await this.doPut(entity);
        this.mainStore.displaySuccess(`${this.entityName.singular} wurde gespeichert.`);
      } catch (e) {
        this.mainStore.displayError(DomainStore.buildErrorMessage(e, `${this.entityName.singular} konnte nicht gespeichert werden`));
        console.error(e);
        throw e;
      }
    });
  }

  @action
  async delete(id: number | string) {
    this.displayLoading(async () => {
      try {
        await this.doDelete(id);
        this.mainStore.displaySuccess(`${this.entityName.singular} wurde gelöscht.`);
      } catch (e) {
        this.mainStore.displayError(DomainStore.buildErrorMessage(e, `${this.entityName.singular} konnte nicht gelöscht werden`));
        console.error(e);
        throw e;
      }
    });
  }

  async displayLoading<P>(f: () => Promise<P>) {
    // TODO: trigger loading indicator in MainStore
    await f();
  }

  async notifyProgress<P>(f: () => Promise<P>, { errorMessage = 'Fehler!', successMessage = 'Erfolg!' } = {}) {
    this.displayLoading(async () => {
      try {
        await f();
        if (successMessage) {
          this.mainStore.displaySuccess(successMessage);
        }
      } catch (e) {
        if (successMessage) {
          this.mainStore.displayError(errorMessage);
        }
        console.error(e);
        throw e;
      }
    });
  }

  protected async doFetchAll(params: object = {}) {
    if (!this.entitiesURL) {
      throw new Error('Not implemented');
    }

    const res = await this.mainStore.api.get<OverviewType[]>(this.entitiesURL);
    this.entities = res.data;
  }

  protected async doFetchOne(id: number): Promise<SingleType | void> {
    if (!this.entityURL) {
      throw new Error('Not implemented');
    }

    const res = await this.mainStore.api.get<SingleType>(this.entityURL + id);
    this.entity = res.data;
  }

  protected async doPost(entity: SingleType) {
    if (!this.entitiesURL) {
      throw new Error('Not implemented');
    }

    const response = await this.mainStore.api.post<OverviewType>(this.entitiesURL, entity);
    this.entities.push(response.data);
  }

  @action
  protected async doPut(entity: SingleType) {
    if (!this.entityURL || !('id' in entity)) {
      throw new Error('Not implemented');
    }

    const entityWithId = entity as SingleType & { id: any };

    const response = await this.mainStore.api.put<SingleType>(this.entitiesURL + entityWithId.id, entity);
    this.entity = response.data;

    if (this.entities.length > 0) {
      this.entities.findIndex(value => (value as any).id === entityWithId.id);
    }
  }

  @action
  protected async doDelete(id: number | string) {
    if (!this.entityURL) {
      throw new Error('Not implemented');
    }

    await this.mainStore.api.delete(this.entityURL + id);
    await this.doFetchAll();
    await this.filter();
  }
}
