/*
██████╗  █████╗ ███████╗██╗ ██████╗    ██████╗  █████╗ ████████╗ █████╗ 
██╔══██╗██╔══██╗██╔════╝██║██╔════╝    ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗
██████╔╝███████║███████╗██║██║         ██║  ██║███████║   ██║   ███████║
██╔══██╗██╔══██║╚════██║██║██║         ██║  ██║██╔══██║   ██║   ██╔══██║
██████╔╝██║  ██║███████║██║╚██████╗    ██████╔╝██║  ██║   ██║   ██║  ██║
╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝ ╚═════╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
*/

INSERT INTO izivi.users (created_at,  updated_at,  deleted_at,  remember_token, email,  password, role,  zdp,  first_name,  last_name,  address,  zip, city,  hometown,  hometown_canton, canton, birthday, phone_mobile, phone_private, phone_business, bank_iban, health_insurance, work_experience, driving_licence, ga_travelcard, half_fare_travelcard, other_fare_network, regional_center,  internal_note) (SELECT
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
    ELSE stiftun8_iZivi.accounts.email
  END AS email,
  stiftun8_iZivi.accounts.password AS password,
  CASE
    WHEN stiftun8_iZivi.accounts.accountid=50
     THEN 1
    WHEN stiftun8_iZivi.accounts.accountid=313
     THEN 1
    WHEN stiftun8_iZivi.accounts.accountid=538
     THEN 1
    WHEN stiftun8_iZivi.accounts.accountid=572
     THEN 1
    WHEN stiftun8_iZivi.accounts.accountid=591
     THEN 1
    WHEN stiftun8_iZivi.accounts.accountid=592
     THEN 1
    WHEN stiftun8_iZivi.accounts.accountid=618
     THEN 1
    WHEN stiftun8_iZivi.accounts.accountid=622
     THEN 1
   ELSE 2
  END AS role,
  stiftun8_iZivi.accounts.username AS zdp,
  stiftun8_iZivi.accounts.firstname AS first_name,
  stiftun8_iZivi.accounts.lastname AS last_name,
  CASE
    WHEN stiftun8_iZivi.zivis.street = ''
      THEN 'NO_Street'
    WHEN stiftun8_iZivi.zivis.street IS NULL
      THEN 'NULL_Street'
    ELSE stiftun8_iZivi.zivis.street
  END AS address,
  CASE
    WHEN stiftun8_iZivi.zivis.zip IS NULL OR NOT stiftun8_iZivi.zivis.zip REGEXP '[0-9]+'
      THEN 0000
    ELSE stiftun8_iZivi.zivis.zip
  END AS zip,
  CASE
    WHEN stiftun8_iZivi.zivis.city != ''
      THEN trim(stiftun8_iZivi.zivis.city) ELSE 'NoCity'
  END,
  CASE
    WHEN stiftun8_iZivi.zivis.hometown = ''
      THEN 'NO_Hometown'
    WHEN stiftun8_iZivi.zivis.hometown IS NULL
      THEN 'NULL_Hometown'
    ELSE stiftun8_iZivi.zivis.hometown
  END AS hometown,
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
  CASE
    WHEN stiftun8_iZivi.zivis.phoneM = ''
      THEN 0000000000
    WHEN stiftun8_iZivi.zivis.phoneM IS NULL
      THEN 0000000000
    ELSE stiftun8_iZivi.zivis.phoneM
  END AS phone_mobile,
  CASE
    WHEN stiftun8_iZivi.zivis.phoneP = ''
      THEN 0000000000
    WHEN stiftun8_iZivi.zivis.phoneP IS NULL
      THEN 0000000000
    ELSE stiftun8_iZivi.zivis.phoneP
  END AS phone_private,
  CASE
    WHEN stiftun8_iZivi.zivis.phoneG = ''
      THEN 0000000000
    WHEN stiftun8_iZivi.zivis.phoneG IS NULL
      THEN 0000000000
    ELSE stiftun8_iZivi.zivis.phoneG
  END AS phone_business,
  '' AS bank_iban,
  CASE WHEN stiftun8_iZivi.zivis.health_insurance IS NULL
    THEN ''
    ELSE stiftun8_iZivi.zivis.health_insurance
  END AS health_insurance,
  stiftun8_iZivi.zivis.berufserfahrung AS work_experience,
  CASE WHEN stiftun8_iZivi.zivis.fahrausweis IS NULL
       THEN 0
       ELSE stiftun8_iZivi.zivis.fahrausweis
  END AS driving_licence,
  CASE WHEN stiftun8_iZivi.zivis.ga IS NULL
       THEN 0
       ELSE stiftun8_iZivi.zivis.ga
  END AS ga_travelcard,
  CASE WHEN stiftun8_iZivi.zivis.halbtax IS NULL
       THEN 0
       ELSE stiftun8_iZivi.zivis.halbtax
  END AS half_fare_travelcard,
  stiftun8_iZivi.zivis.anderesAbo AS other_fare_network,
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
  CASE
    WHEN stiftun8_iZivi.zivis.bemerkung = ''
      THEN 'NO_Note'
    WHEN stiftun8_iZivi.zivis.bemerkung IS NULL
      THEN 'NULL_Note'
    ELSE stiftun8_iZivi.zivis.bemerkung
  END AS internal_note
FROM stiftun8_iZivi.accounts
  LEFT JOIN stiftun8_iZivi.zivis ON stiftun8_iZivi.zivis.id=stiftun8_iZivi.accounts.username);

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
  (Select id from izivi.users where izivi.users.zdp=(CASE
    WHEN LENGTH(stiftun8_iZivi.einsaetze.ziviId) = 4
      THEN concat('0', stiftun8_iZivi.einsaetze.ziviId)
    ELSE stiftun8_iZivi.einsaetze.ziviId
  END)) AS user,
  stiftun8_iZivi.einsaetze.pflichtenheft AS specification,
  stiftun8_iZivi.einsaetze.start AS start,
  stiftun8_iZivi.einsaetze.end AS end,
  CASE
    WHEN stiftun8_iZivi.einsaetze.aufgebot IS NOT NULL AND stiftun8_iZivi.einsaetze.aufgebot != 0
      THEN stiftun8_iZivi.einsaetze.aufgebot ELSE NULL
  END AS draft,
  stiftun8_iZivi.einsaetze.eligibleholiday AS eligible_holiday,
  CASE
    WHEN stiftun8_iZivi.einsaetze.employment_type = 1
      THEN 1
    WHEN stiftun8_iZivi.einsaetze.employment_type = 2
      THEN 2
    ELSE 2
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
  (Select id from izivi.users where izivi.users.zdp=(CASE
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
    INNER JOIN izivi.users ON izivi.users.zdp=stiftun8_iZivi.meldeblaetter.ziviId
    INNER JOIN izivi.missions ON izivi.missions.id=stiftun8_iZivi.meldeblaetter.einsaetze_id);


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

	
/*
██╗   ██╗███╗   ███╗██╗      █████╗ ██╗   ██╗████████╗    ███████╗██╗██╗  ██╗
██║   ██║████╗ ████║██║     ██╔══██╗██║   ██║╚══██╔══╝    ██╔════╝██║╚██╗██╔╝
██║   ██║██╔████╔██║██║     ███████║██║   ██║   ██║       █████╗  ██║ ╚███╔╝ 
██║   ██║██║╚██╔╝██║██║     ██╔══██║██║   ██║   ██║       ██╔══╝  ██║ ██╔██╗ 
╚██████╔╝██║ ╚═╝ ██║███████╗██║  ██║╚██████╔╝   ██║       ██║     ██║██╔╝ ██╗
 ╚═════╝ ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝    ╚═╝       ╚═╝     ╚═╝╚═╝  ╚═╝
*/
	
UPDATE izivi.users SET first_name = (SELECT REPLACE(first_name, 'Ã©', 'é'));
UPDATE izivi.users SET last_name = (SELECT REPLACE(last_name, 'Ã©', 'é'));
UPDATE izivi.users SET address = (SELECT REPLACE(address, 'Ã©', 'é'));
UPDATE izivi.users SET city = (SELECT REPLACE(city, 'Ã©', 'é'));
UPDATE izivi.users SET hometown = (SELECT REPLACE(hometown, 'Ã©', 'é'));
UPDATE izivi.users SET work_experience = (SELECT REPLACE(work_experience, 'Ã©', 'é'));
UPDATE izivi.specifications SET name = (SELECT REPLACE(name, 'Ã©', 'é'));

UPDATE izivi.users SET first_name = (SELECT REPLACE(first_name, 'Ã¤', 'ä'));
UPDATE izivi.users SET last_name = (SELECT REPLACE(last_name, 'Ã¤', 'ä'));
UPDATE izivi.users SET address = (SELECT REPLACE(address, 'Ã¤', 'ä'));
UPDATE izivi.users SET city = (SELECT REPLACE(city, 'Ã¤', 'ä'));
UPDATE izivi.users SET hometown = (SELECT REPLACE(hometown, 'Ã¤', 'ä'));
UPDATE izivi.users SET work_experience = (SELECT REPLACE(work_experience, 'Ã¤', 'ä'));
UPDATE izivi.specifications SET name = (SELECT REPLACE(name, 'Ã¤', 'ä'));

UPDATE izivi.users SET first_name = (SELECT REPLACE(first_name, 'Ã¼', 'ü'));
UPDATE izivi.users SET last_name = (SELECT REPLACE(last_name, 'Ã¼', 'ü'));
UPDATE izivi.users SET address = (SELECT REPLACE(address, 'Ã¼', 'ü'));
UPDATE izivi.users SET city = (SELECT REPLACE(city, 'Ã¼', 'ü'));
UPDATE izivi.users SET hometown = (SELECT REPLACE(hometown, 'Ã¼', 'ü'));
UPDATE izivi.users SET work_experience = (SELECT REPLACE(work_experience, 'Ã¼', 'ü'));
UPDATE izivi.specifications SET name = (SELECT REPLACE(name, 'Ã¼', 'ü'));

UPDATE izivi.users SET first_name = (SELECT REPLACE(first_name, 'ï¿½', 'ü'));
UPDATE izivi.users SET last_name = (SELECT REPLACE(last_name, 'ï¿½', 'ü'));
UPDATE izivi.users SET address = (SELECT REPLACE(address, 'ï¿½', 'ü'));
UPDATE izivi.users SET city = (SELECT REPLACE(city, 'ï¿½', 'ü'));
UPDATE izivi.users SET hometown = (SELECT REPLACE(hometown, 'ï¿½', 'ü'));
UPDATE izivi.users SET work_experience = (SELECT REPLACE(work_experience, 'ï¿½', 'ü'));
UPDATE izivi.specifications SET name = (SELECT REPLACE(name, 'ï¿½', 'ü'));

UPDATE izivi.users SET first_name = (SELECT REPLACE(first_name, 'Ã¶', 'ö'));
UPDATE izivi.users SET last_name = (SELECT REPLACE(last_name, 'Ã¶', 'ö'));
UPDATE izivi.users SET address = (SELECT REPLACE(address, 'Ã¶', 'ö'));
UPDATE izivi.users SET city = (SELECT REPLACE(city, 'Ã¶', 'ö'));
UPDATE izivi.users SET hometown = (SELECT REPLACE(hometown, 'Ã¶', 'ö'));
UPDATE izivi.users SET work_experience = (SELECT REPLACE(work_experience, 'Ã¶', 'ö'));
UPDATE izivi.specifications SET name = (SELECT REPLACE(name, 'Ã¶', 'ö'));

UPDATE izivi.users SET first_name = (SELECT REPLACE(first_name, 'Ã', 'í'));
UPDATE izivi.users SET last_name = (SELECT REPLACE(last_name, 'Ã', 'í'));
UPDATE izivi.users SET address = (SELECT REPLACE(address, 'Ã', 'í'));
UPDATE izivi.users SET city = (SELECT REPLACE(city, 'Ã', 'í'));
UPDATE izivi.users SET hometown = (SELECT REPLACE(hometown, 'Ã', 'í'));
UPDATE izivi.users SET work_experience = (SELECT REPLACE(work_experience, 'Ã', 'í'));
UPDATE izivi.specifications SET name = (SELECT REPLACE(name, 'Ã', 'í'));


/*
██████╗  █████╗ ███╗   ██╗██╗  ██╗     █████╗  ██████╗ ██████╗ ██████╗ ██╗   ██╗███╗   ██╗████████╗███████╗
██╔══██╗██╔══██╗████╗  ██║██║ ██╔╝    ██╔══██╗██╔════╝██╔════╝██╔═══██╗██║   ██║████╗  ██║╚══██╔══╝██╔════╝
██████╔╝███████║██╔██╗ ██║█████╔╝     ███████║██║     ██║     ██║   ██║██║   ██║██╔██╗ ██║   ██║   ███████╗
██╔══██╗██╔══██║██║╚██╗██║██╔═██╗     ██╔══██║██║     ██║     ██║   ██║██║   ██║██║╚██╗██║   ██║   ╚════██║
██████╔╝██║  ██║██║ ╚████║██║  ██╗    ██║  ██║╚██████╗╚██████╗╚██████╔╝╚██████╔╝██║ ╚████║   ██║   ███████║
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚══════╝

==== account types ====
0 Bank Account with old number system
1 Post Finance Account with old number system

3 not to be converted
4 to be converted by the IBAN calculation tool

==== Generating the CSV file ====

SET @row_number = 0;
SELECT (@row_number:=@row_number + 1) AS 'row', id AS 'zdp', bank_clearing, kontoNr FROM no_iban;

Export with Separator ";" and no escaping

==== Using the IBAN tool ====

See
https://www.six-interbank-clearing.com/de/home/standardization/iban/iban-tool.html
*/

DROP TABLE IF EXISTS izivi.no_iban;
CREATE TABLE izivi.no_iban LIKE stiftun8_iZivi.zivis; 
INSERT izivi.no_iban SELECT * FROM stiftun8_iZivi.zivis;

/* Post finance accounts */
UPDATE izivi.no_iban SET kontoNr = REPLACE(kontoNR, "Postcheque", "PC");
UPDATE izivi.no_iban SET kontoNr = REPLACE(kontoNR, "Postkonto", "PC");

/* Mark unresolvable if the correct format is not found */
UPDATE izivi.no_iban 
SET account_type = 3 
WHERE account_type = 0 
AND kontoNr NOT REGEXP('^.*([0-9]{2,5}[\-.][0-9]{2,5})+.*$');

/* Mark as post finance account if 'PC' is in the text */
UPDATE izivi.no_iban SET account_type = 1 WHERE kontoNr LIKE '%PC%';

/* Accounts with a valid IBAN don't need to be converted */
UPDATE izivi.no_iban SET account_type = 3 WHERE kontoNr REGEXP('.*(CH[0-9][0-9]).*');

/* Post finance BC code is 9000 */
UPDATE izivi.no_iban SET bank_clearing = 9000 WHERE account_type = 1;

/* remove all except numbers and '-' from the bank account */
DROP FUNCTION IF EXISTS numbersandhyphen; 
DELIMITER | 
CREATE FUNCTION numbersandhyphen( str TEXT ) RETURNS CHAR(255) 
BEGIN 
  DECLARE i, len SMALLINT DEFAULT 1; 
  DECLARE ret TEXT DEFAULT ''; 
  DECLARE c CHAR(1); 
  SET len = CHAR_LENGTH( str ); 
  REPEAT 
    BEGIN 
      SET c = MID( str, i, 1 ); 
      IF c REGEXP '[.0-9\-]' THEN 
        SET ret=CONCAT(ret,c); 
      END IF; 
      SET i = i + 1; 
    END; 
  UNTIL i > len END REPEAT; 
  RETURN ret; 
END | 
DELIMITER ; 

/* Clean up post finance account numbers */
UPDATE izivi.no_iban SET kontoNr = (LOWER(kontoNr)) WHERE account_type = 1;
UPDATE izivi.no_iban SET kontoNr = (SELECT REPLACE(kontoNr, 'pc-konto', 'pc'))  WHERE account_type = 1;
UPDATE izivi.no_iban SET kontoNr = numbersandhyphen(kontoNr) WHERE account_type = 1;

/* Mark unresolvable if there are more than 9 chars */
UPDATE izivi.no_iban SET account_type = 3 WHERE account_type = 1 AND CHAR_LENGTH(kontoNr) > 12;

/* Mark Post Finance acounts for conversion */
UPDATE izivi.no_iban SET account_type = 4 WHERE account_type = 1;

/* Mark unresolvable if no BC is set or if BS contains letters */
UPDATE izivi.no_iban 
SET account_type = 3 
WHERE account_type = 0 
AND (
bank_clearing REGEXP('^.*[A-Za-z]+.*$') 
OR bank_clearing = '' 
);

/* Mark unresolvable if there is more than one account number found */
UPDATE izivi.no_iban 
SET account_type = 3 
WHERE account_type = 0 
AND kontoNr REGEXP('^.*[0-9]+.*[A-Za-z]+.*[0-9]+.*$');

/* Clean up bank accounts without IBAN */
UPDATE izivi.no_iban 
SET account_type = 4, kontoNr = numbersandhyphen(kontoNr) 
WHERE account_type = 0;

/* Copy entries with IBAN number and unresolvable */
UPDATE izivi.users u 
LEFT JOIN izivi.no_iban z 
ON u.zdp = z.id 
SET u.bank_iban = REPLACE(z.kontoNr, '\n', ', ') 
WHERE z.account_type = 2 
OR z.account_type = 3;

/* Delete entries with IBAN and unresolvables, leave others for IBAN translation tool */
DELETE FROM izivi.no_iban 
WHERE account_type = 2
OR account_type = 3;                       