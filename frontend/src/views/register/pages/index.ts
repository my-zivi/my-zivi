import { withPageValidations } from '../ValidatablePage';
import { BankAndInsurancePage } from './BankAndInsurancePage';
import { CommunityPasswordPage } from './CommunityPasswordPage';
import { ContactPage } from './ContactPage';
import { PersonalDetailsPage } from './PersonalDetailsPage';

export const REGISTER_FORM_PAGES = [
  {
    title: CommunityPasswordPage.Title,
    component: withPageValidations([
      'community_password',
    ])(CommunityPasswordPage),
  },
  {
    title: PersonalDetailsPage.Title,
    component: withPageValidations([
      'zdp',
      'regional_center_id',
      'first_name',
      'last_name',
      'email',
      'birthday',
      'password',
      'password_confirm',
      'newsletter',
    ])(PersonalDetailsPage),
  },
  {
    title: ContactPage.Title,
    component: withPageValidations([
      'phone',
      'address',
      'city',
      'zip',
      'hometown',
    ])(ContactPage),
  },
  {
    title: BankAndInsurancePage.Title,
    component: withPageValidations([
      'bank_iban',
      'health_insurance',
    ])(BankAndInsurancePage),
  },
];
