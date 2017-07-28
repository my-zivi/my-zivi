INSERT INTO izivi.users (created_at,  updated_at,  deleted_at,  remember_token,  email,  password,  zdp,  first_name,  last_name,  address,  city,  hometown,  hometown_canton,  canton,  birthday,  phone_mobile,  phone_private,  phone_business,  bank_iban,  post_account,  work_experience,  driving_licence,  travel_card,  regional_center,  internal_note) (SELECT
  NULL AS created_at,
  NULL AS updated_at,
  NULL AS deleted_at,
  NULL AS remember_token,
  CASE
    WHEN stiftun8_iZivi.accounts.email = 'zivi@swo-network.org'
      THEN concat('zivi@swo-network.org@', stiftun8_iZivi.accounts.username, '.no')
    WHEN stiftun8_iZivi.accounts.email = 'keine Angabe '
      THEN concat('keine_Angabe_@', stiftun8_iZivi.accounts.username, '.no')
    WHEN stiftun8_iZivi.accounts.email = ''
      THEN concat('_@', stiftun8_iZivi.accounts.username, '.no')
    WHEN stiftun8_iZivi.accounts.email IS NULL
      THEN concat('IS_NULL@', stiftun8_iZivi.accounts.username, '.no')
    ELSE concat('else@', stiftun8_iZivi.accounts.username, '.no')
  END AS email,
  stiftun8_iZivi.accounts.password AS password,
  stiftun8_iZivi.accounts.username AS zdp,
  stiftun8_iZivi.accounts.firstname AS first_name,
  stiftun8_iZivi.accounts.lastname AS last_name,
  stiftun8_iZivi.zivis.street AS address,
  CASE
    WHEN stiftun8_iZivi.zivis.city != ''
      THEN trim(stiftun8_iZivi.zivis.city) ELSE 'NoCity'
  END,
  stiftun8_iZivi.zivis.hometown AS hometown,
  CASE
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'ZH'
      THEN 1
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'BE'
      THEN 2
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'LU'
      THEN 3
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'UR'
      THEN 4
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'SZ'
      THEN 5
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'OW'
      THEN 6
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'NW'
      THEN 7
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'GL'
      THEN 8
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'ZG'
      THEN 9
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'FR'
      THEN 10
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'SO'
      THEN 11
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'BS'
      THEN 12
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'BL'
      THEN 13
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'SH'
      THEN 14
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'AR'
      THEN 15
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'AI'
      THEN 16
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'SG'
      THEN 17
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'GR'
      THEN 18
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'AG'
      THEN 19
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'TG'
      THEN 20
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'TI'
      THEN 21
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'VD'
      THEN 22
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'VS'
      THEN 23
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'NE'
      THEN 24
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'GE'
      THEN 25
    WHEN stiftun8_iZivi.zivis.hometown_canton = 'JU'
      THEN 26
  END AS hometown_canton,
  1 AS canton,
  CASE
    WHEN stiftun8_iZivi.zivis.dateofbirth IS NOT NULL AND stiftun8_iZivi.zivis.dateofbirth != 0
      THEN stiftun8_iZivi.zivis.dateofbirth ELSE NOW()
  END AS birthday,
  stiftun8_iZivi.zivis.phoneM AS phone_mobile,
  stiftun8_iZivi.zivis.phoneP AS phone_private,
  stiftun8_iZivi.zivis.phoneG AS phone_business,
  '' AS bank_iban,
  stiftun8_iZivi.zivis.bank_post_account_no AS post_account,
  stiftun8_iZivi.zivis.berufserfahrung AS work_experience,
  stiftun8_iZivi.zivis.fahrausweis AS driving_licence,
  concat(stiftun8_iZivi.zivis.ga, ' ', stiftun8_iZivi.zivis.halbtax ,' ', stiftun8_iZivi.zivis.anderesAbo) AS travel_card,
   CASE
    WHEN stiftun8_iZivi.zivis.regionalzentrum = 3
      THEN 2
    WHEN stiftun8_iZivi.zivis.regionalzentrum = 6
      THEN 3
    WHEN stiftun8_iZivi.zivis.regionalzentrum = 7
      THEN 4
    WHEN stiftun8_iZivi.zivis.regionalzentrum = 8
      THEN 5
    WHEN stiftun8_iZivi.zivis.regionalzentrum = 4
      THEN 5 #Luzern gibt es nicht mehr als Zentrum! alles nach Araau
   ELSE 1
  END AS regional_center,
  stiftun8_iZivi.zivis.bemerkung AS internal_note
FROM stiftun8_iZivi.accounts INNER JOIN stiftun8_iZivi.zivis
  ON stiftun8_iZivi.zivis.id=stiftun8_iZivi.accounts.username WHERE stiftun8_iZivi.zivis.city != '');


INSERT INTO izivi.specifications (id, name, short_name, working_clothes_payment, working_clothes_expense, working_breakfast_expenses, working_lunch_expenses, working_dinner_expenses, sparetime_breakfast_expenses, sparetime_lunch_expenses, sparetime_dinner_expenses, firstday_breakfast_expenses, firstday_lunch_expenses, firstday_dinner_expenses, lastday_breakfast_expenses, lastday_lunch_expenses, lastday_dinner_expenses, working_time_model, working_time_weekly, accommodation, pocket, manual_file, active) (
Select
stiftun8_iZivi.pflichtenheft.id,
stiftun8_iZivi.pflichtenheft.name,
stiftun8_iZivi.pflichtenheft.short_name,
stiftun8_iZivi.pflichtenheft.working_clothes_payment,
stiftun8_iZivi.pflichtenheft.working_clothes_expense*100,
stiftun8_iZivi.pflichtenheft.working_breakfast_expenses,
stiftun8_iZivi.pflichtenheft.working_lunch_expenses,
stiftun8_iZivi.pflichtenheft.working_dinner_expenses,
stiftun8_iZivi.pflichtenheft.sparetime_breakfast_expenses,
stiftun8_iZivi.pflichtenheft.sparetime_lunch_expenses,
stiftun8_iZivi.pflichtenheft.sparetime_dinner_expenses,
stiftun8_iZivi.pflichtenheft.firstday_breakfast_expenses,
stiftun8_iZivi.pflichtenheft.firstday_lunch_expenses,
stiftun8_iZivi.pflichtenheft.firstday_dinner_expenses,
stiftun8_iZivi.pflichtenheft.lastday_breakfast_expenses,
stiftun8_iZivi.pflichtenheft.lastday_lunch_expenses,
stiftun8_iZivi.pflichtenheft.lastday_dinner_expenses,
stiftun8_iZivi.pflichtenheft.working_time_model,
stiftun8_iZivi.pflichtenheft.working_time_weekly,
stiftun8_iZivi.pflichtenheft.accommodation,
stiftun8_iZivi.pflichtenheft.pocket,
stiftun8_iZivi.pflichtenheft.manualfile AS manual_file,
stiftun8_iZivi.pflichtenheft.active
from stiftun8_iZivi.pflichtenheft);


INSERT INTO izivi.specifications (id, name, short_name, working_clothes_payment, working_clothes_expense, working_breakfast_expenses, working_lunch_expenses, working_dinner_expenses, sparetime_breakfast_expenses, sparetime_lunch_expenses, sparetime_dinner_expenses, firstday_breakfast_expenses, firstday_lunch_expenses, firstday_dinner_expenses, lastday_breakfast_expenses, lastday_lunch_expenses, lastday_dinner_expenses, working_time_model, working_time_weekly, accommodation, pocket, manual_file, active) VALUES
  (19532, 'Gruppeneinsätze, Feldarbeiten', 'F', 'Fr. 60 / Monat, max. Fr. 240', 230, 400, 1700, 700, 400, 900, 700, 400, 1700, 700, 400, 1700, 700, 0, 42.00, 1000, 500, 'conditions.pdf', 0),
  (19535, 'Gruppeneinsätze, Feldarbeiten', 'F', 'Fr. 60 / Monat, max. Fr. 240', 230, 400, 1700, 700, 400, 900, 700, 400, 1700, 700, 400, 1700, 700, 0, 42.00, 1000, 500, 'conditions.pdf', 0);


INSERT INTO izivi.missions (id, created_at, updated_at, deleted_at, user, specification, start, end, draft, eligible_holiday, role, first_time, long_mission, probation_period) (Select
  stiftun8_iZivi.einsaetze.id,
  NULL AS created_at,
  NULL AS updated_at,
  NULL AS deleted_at,
  (Select id from users where users.zdp=(CASE
    WHEN LENGTH(stiftun8_iZivi.einsaetze.ziviId) = 4
      THEN concat('0', stiftun8_iZivi.einsaetze.ziviId)
    ELSE stiftun8_iZivi.einsaetze.ziviId
  END)) AS user,
  stiftun8_iZivi.einsaetze.pflichtenheft AS specification,
  stiftun8_iZivi.einsaetze.start AS start,
  stiftun8_iZivi.einsaetze.end AS end,
  CASE
    WHEN stiftun8_iZivi.einsaetze.aufgebot IS NOT NULL AND stiftun8_iZivi.einsaetze.aufgebot != 0
      THEN stiftun8_iZivi.einsaetze.aufgebot ELSE NOW()
  END AS draft,
  stiftun8_iZivi.einsaetze.eligibleholiday AS eligible_holiday,
  CASE
    WHEN stiftun8_iZivi.einsaetze.employment_type = 1
      THEN 1
    WHEN stiftun8_iZivi.einsaetze.employment_type = 2
      THEN 2
    WHEN stiftun8_iZivi.einsaetze.employment_type = 7
      THEN 3
    ELSE 3
  END AS role,
  stiftun8_iZivi.einsaetze.firsttime AS first_time,
  stiftun8_iZivi.einsaetze.long_employment AS long_mission,
  stiftun8_iZivi.einsaetze.probation_period AS probation_period
FROM stiftun8_iZivi.einsaetze WHERE stiftun8_iZivi.einsaetze.ziviId != '' AND stiftun8_iZivi.einsaetze.ziviId != 'gast');

INSERT INTO izivi.report_sheets (SELECT
  stiftun8_iZivi.meldeblaetter.id,
  NULL AS created_at,
  NULL AS updated_at,
  NULL AS deleted_at,
  stiftun8_iZivi.meldeblaetter.start,
  stiftun8_iZivi.meldeblaetter.end,
  (Select id from users where users.zdp=(CASE
    WHEN LENGTH(stiftun8_iZivi.meldeblaetter.ziviId) = 4
      THEN concat('0', stiftun8_iZivi.meldeblaetter.ziviId)
    ELSE stiftun8_iZivi.meldeblaetter.ziviId
  END)) AS user,
  stiftun8_iZivi.meldeblaetter.done,
  stiftun8_iZivi.meldeblaetter.work,
  stiftun8_iZivi.meldeblaetter.work_comment,
  stiftun8_iZivi.meldeblaetter.compholiday_holiday AS company_holiday_holiday,
  stiftun8_iZivi.meldeblaetter.compholiday_comment AS company_holiday_comment,
  stiftun8_iZivi.meldeblaetter.compholiday_vacation AS company_holiday_vacation,
  stiftun8_iZivi.meldeblaetter.workfree,
  stiftun8_iZivi.meldeblaetter.workfree_comment,
  stiftun8_iZivi.meldeblaetter.add_workfree AS additional_workfree,
  stiftun8_iZivi.meldeblaetter.add_workfree_comment AS additional_workfree_comment,
  stiftun8_iZivi.meldeblaetter.ill,
  stiftun8_iZivi.meldeblaetter.ill_comment,
  stiftun8_iZivi.meldeblaetter.holiday,
  stiftun8_iZivi.meldeblaetter.holiday_comment,
  stiftun8_iZivi.meldeblaetter.urlaub AS vacation,
  stiftun8_iZivi.meldeblaetter.urlaub_comment AS vacation_comment,
  stiftun8_iZivi.meldeblaetter.fahrspesen AS driving_charges,
  stiftun8_iZivi.meldeblaetter.fahrspesen_comment AS driving_charges_comment,
  stiftun8_iZivi.meldeblaetter.ausserordentlich AS extraordinarily,
  stiftun8_iZivi.meldeblaetter.ausserordentlich_comment AS extraordinarily_comment,
  stiftun8_iZivi.meldeblaetter.kleider AS clothes,
  stiftun8_iZivi.meldeblaetter.kleider_comment AS clothes_comment,
  stiftun8_iZivi.meldeblaetter.einsaetze_id AS mission,
  stiftun8_iZivi.meldeblaetter.konto_nr AS bank_account_number,
  stiftun8_iZivi.meldeblaetter.beleg_nr AS document_number,
  stiftun8_iZivi.meldeblaetter.verbucht AS booked_date,
  stiftun8_iZivi.meldeblaetter.bezahlt AS paid_date
  FROM stiftun8_iZivi.meldeblaetter
    INNER JOIN users ON izivi.users.zdp=stiftun8_iZivi.meldeblaetter.ziviId
    INNER JOIN missions ON izivi.missions.id=stiftun8_iZivi.meldeblaetter.einsaetze_id);


INSERT INTO izivi.holidays(date_from, date_to, holiday_type, description)
  (SELECT
    start,
    end,
    1,
    'Betriebsferien' FROM stiftun8_iZivi.companyholidays);

INSERT INTO izivi.holidays(date_from, date_to, holiday_type, description)
  (SELECT
    date,
    date,
    2,
    description FROM stiftun8_iZivi.holidays);