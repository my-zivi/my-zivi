import { computed, observable } from 'mobx';
import { UserFeedback, UserQuestionWithAnswers } from '../types';
import { DomainStore } from './domainStore';

export class UserFeedbackStore extends DomainStore<UserFeedback, UserQuestionWithAnswers> {
  @computed
  get entities(): UserQuestionWithAnswers[] {
    return this.userFeedbacks;
  }

  @observable
  userFeedbacks: UserQuestionWithAnswers[] = [];

  protected async doFetchAll(params: object = {}): Promise<void> {
    const res = await this.mainStore.api.get<UserQuestionWithAnswers[]>('/user_feedbacks', { params: { ...params } });
    this.userFeedbacks = res.data;
  }
}
