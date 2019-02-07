import { DomainStore } from './domainStore';
import { UserFeedback, UserQuestionWithAnswers } from '../types';
import { computed, observable } from 'mobx';

export class UserFeedbackStore extends DomainStore<UserFeedback, UserQuestionWithAnswers> {
  @computed
  get entities(): Array<UserQuestionWithAnswers> {
    return this.userFeedbacks;
  }

  @observable
  public userFeedbacks: UserQuestionWithAnswers[] = [];

  protected async doFetchAll(params: object = {}): Promise<void> {
    const res = await this.mainStore.api.get<UserQuestionWithAnswers[]>('/user_feedbacks', { params: { ...params } });
    this.userFeedbacks = res.data;
  }
}
