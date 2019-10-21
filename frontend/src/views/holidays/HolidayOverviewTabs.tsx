import { Formik, FormikActions } from 'formik';
import moment from 'moment';
import * as React from 'react';
import { Tab, TabList, TabPanel, Tabs } from 'react-tabs';
import Button from 'reactstrap/lib/Button';
import * as yup from 'yup';
import { HolidayStore } from '../../stores/holidayStore';
import { MainStore } from '../../stores/mainStore';
import { Holiday } from '../../types';
import { apiDate } from '../../utilities/validationHelpers';
import { HolidayOverviewTable } from './HolidayOverviewTable';
import HolidayTableRow from './HolidayTableRow';

export const HolidayOverviewTabs: React.FunctionComponent<{mainStore: MainStore, holidayStore: HolidayStore}> = props => {
    const mainStore = props.mainStore;
    const holidayStore = props.holidayStore;
    const handleAdd = async (holiday: Holiday, actions: FormikActions<Holiday>) => {
        await holidayStore!.put(holidaySchema.cast(holiday) as Holiday);
    };
    const handleSubmit = async (holiday: Holiday, actions: FormikActions<Holiday>) => {
        await holidayStore!.put(holidaySchema.cast(holiday) as Holiday);
        actions.setSubmitting(false);
      };
    const holidaySchema = yup.object({
    beginning: apiDate().required(),
    ending: apiDate().required(),
    holiday_type: yup.string().required().matches(/company_holiday|public_holiday/),
    description: yup.string().required(),
  });

    return (
    <Tabs>
            <Formik
              validationSchema={holidaySchema}
              initialValues={{
                beginning: moment().format('Y-MM-DD'),
                ending: moment().format('Y-MM-DD'),
                holiday_type: 'company_holiday',
                description: '',
              }}
              onSubmit={handleAdd}
              render={({ isSubmitting, submitForm }) => (
                <HolidayTableRow
                  buttons={[
                    <Button key={'submitButton'} color={'success'} disabled={isSubmitting} onClick={submitForm}>Hinzufügen</Button>,
                  ]}
                />
              )}
            />
            <TabList>
              <Tab>Aktuell</Tab>
              <Tab>Zukunft</Tab>
              <Tab>Vergangenheit</Tab>
            </TabList>
            <TabPanel>
            <HolidayOverviewTable mainStore={mainStore!}>
              {holidayStore.actualEntities.map(holiday => (
              <Formik
                key={holiday.id}
                validationSchema={holidaySchema}
                initialValues={holiday}
                onSubmit={handleSubmit}
                render={({ isSubmitting, submitForm }) => (
                  <HolidayTableRow
                    buttons={[
                      (
                        <Button color={'success'} disabled={isSubmitting} onClick={submitForm}>
                          Speichern
                        </Button>
                      ),
                      (
                        <Button color={'danger'} disabled={isSubmitting} onClick={() => holidayStore!.delete(holiday.id!)}>
                          Löschen
                        </Button>
                      ),
                    ]}
                  />
                )}
              />
            ))}
            </HolidayOverviewTable>
            </TabPanel>
            <TabPanel>
            <HolidayOverviewTable mainStore={mainStore!}>
              {holidayStore.futureEntities.map(holiday => (
              <Formik
                key={holiday.id}
                validationSchema={holidaySchema}
                initialValues={holiday}
                onSubmit={handleSubmit}
                render={({ isSubmitting, submitForm }) => (
                  <HolidayTableRow
                    buttons={[
                      (
                        <Button color={'success'} disabled={isSubmitting} onClick={submitForm}>
                          Speichern
                        </Button>
                      ),
                      (
                        <Button color={'danger'} disabled={isSubmitting} onClick={() => holidayStore!.delete(holiday.id!)}>
                          Löschen
                        </Button>
                      ),
                    ]}
                  />
                )}
              />
            ))}
            </HolidayOverviewTable>
            </TabPanel>
            <TabPanel>
            <HolidayOverviewTable mainStore={mainStore!}>
              {holidayStore.passedEntities.map(holiday => (
              <Formik
                key={holiday.id}
                validationSchema={holidaySchema}
                initialValues={holiday}
                onSubmit={handleSubmit}
                render={({ isSubmitting, submitForm }) => (
                  <HolidayTableRow
                    buttons={[
                      (
                        <Button color={'success'} disabled={isSubmitting} onClick={submitForm}>Speichern</Button>
                      ),
                      (
                        <Button color={'danger'} disabled={isSubmitting} onClick={() => holidayStore!.delete(holiday.id!)}>Löschen</Button>
                      ),
                    ]}
                  />
                )}
              />
            ))}
            </HolidayOverviewTable>
        </TabPanel>
    </Tabs>
  );
};
