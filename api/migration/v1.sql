# v1.sql
#
# This script migrates all data from the legacy version of iZivi (https://github.com/stiftungswo/izivi) to the newer format
# However, it does that with no regards on data validity.
# To ensure that data is loaded to a Rails conforming DB, create a new DB with `rails db:create db:migrate`
# and then load all data with `mysql -u[User] -p < dump.sql`.
# To generate a Dump, convert the data with this script and then export using
# `mysqldump --no-create-info --complete-insert [database] > dump.sql -u[User] -p`
#
# This file can be deleted as soon as we can be sure that the new version is stable

SET sql_mode = '';

-- -----------------------------
-- === DROP ALL FOREIGN KEYS ===
-- -----------------------------

ALTER TABLE missions
    DROP FOREIGN KEY missions_user_foreign,
    DROP FOREIGN KEY missions_specification_foreign;
ALTER TABLE report_sheets
    DROP FOREIGN KEY report_sheets_user_foreign,
    DROP FOREIGN KEY report_sheets_mission_foreign;
ALTER TABLE holidays
    DROP FOREIGN KEY holidays_holiday_type_foreign;
ALTER TABLE users
    DROP FOREIGN KEY users_canton_foreign,
    DROP FOREIGN KEY users_hometown_canton_foreign,
    DROP FOREIGN KEY users_regional_center_foreign,
    DROP FOREIGN KEY users_role_foreign;
ALTER TABLE payment_entries
    DROP FOREIGN KEY payment_entries_user_foreign,
    DROP FOREIGN KEY payment_entries_report_sheet_foreign,
    DROP FOREIGN KEY payment_entries_payment_foreign;
ALTER TABLE user_feedbacks
    DROP FOREIGN KEY user_feedbacks_user_foreign;

DROP INDEX report_sheets_user_foreign ON report_sheets;
DROP INDEX missions_user_foreign ON missions;
DROP INDEX users_role_foreign ON users;
DROP INDEX users_regional_center_foreign ON users;
DROP INDEX users_email_unique ON users;


-- --------------------------
-- === DROP UNUSED TABLES ===
-- --------------------------

DROP TABLE
    no_iban,
    cantons,
    user_feedbacks,
    user_feedback_questions,
    logs,
    holiday_types,
    password_resets,
    roles,
    migrations;


-- ------------------------------------------
-- === DROP OUTDATED TIME-BARRED SERVICES ===
-- ------------------------------------------

DELETE FROM missions WHERE end < '2009-01-01';
DELETE FROM report_sheets WHERE end < '2009-01-01';
DELETE FROM users WHERE id NOT IN (SELECT user FROM missions GROUP BY user) AND updated_at IS NULL;

-- --------------------------------
-- === DROP ALL DELETED RECORDS ===
-- --------------------------------

DELETE FROM report_sheets WHERE deleted_at IS NOT NULL;
DELETE report_sheets FROM report_sheets
    INNER JOIN missions ON missions.id = report_sheets.mission
    WHERE missions.deleted_at IS NOT NULL;
DELETE FROM missions WHERE deleted_at IS NOT NULL;


-- --------------------------------------
-- === DROP USERS WITH DUPLICATE ZDP ===
-- --------------------------------------

DELETE FROM users WHERE id = 1052;
DELETE FROM users WHERE id = 1024;
UPDATE users SET users.zdp = 10 WHERE users.id = 251;
UPDATE users SET users.zdp = 11 WHERE users.id = 517;

-- -------------------------
-- === ALTER USERS TABLE ===
-- -------------------------

UPDATE users
    SET birthday = '2019-08-23'
    WHERE birthday = '0000-00-00';

UPDATE users SET created_at = '2000-01-01 00:00:01' WHERE created_at IS NULL;
UPDATE users SET updated_at = '2000-01-01 00:00:01' WHERE updated_at IS NULL;

ALTER TABLE users
    DROP PRIMARY KEY,
    CHANGE id id BIGINT AUTO_INCREMENT PRIMARY KEY,
    CHANGE role role INT DEFAULT 2 NOT NULL,
    CHANGE zdp zdp INT NOT NULL,
    CHANGE regional_center regional_center_id BIGINT NULL,
    CHANGE created_at created_at  DATETIME NOT NULL,
    CHANGE updated_at updated_at  DATETIME NOT NULL,
    CHANGE internal_note internal_note TEXT NULL,
    CHANGE phone phone VARCHAR(255) NOT NULL,
    CHANGE zip zip INT NOT NULL,
    DROP COLUMN canton,
    DROP COLUMN phone_business,
    DROP COLUMN phone_mobile,
    DROP COLUMN phone_private,
    DROP COLUMN bank_bic,
    DROP COLUMN driving_licence,
    DROP COLUMN ga_travelcard,
    DROP COLUMN half_fare_travelcard,
    DROP COLUMN other_fare_network,
    DROP COLUMN hometown_canton,
    DROP COLUMN deleted_at,  -- It has not deleted users
    DROP COLUMN remember_token,

    RENAME COLUMN password TO legacy_password,

    ADD COLUMN encrypted_password VARCHAR(255) DEFAULT '' NOT NULL,
    ADD COLUMN reset_password_token VARCHAR(255) NULL,
    ADD COLUMN reset_password_sent_at DATETIME NULL;


-- -------------------------------------------------------
-- === ALTER SPECIFICATIONS ==> SERVICE SPECIFICATIONS ===
-- -------------------------------------------------------

RENAME TABLE specifications TO service_specifications;

ALTER TABLE service_specifications
    DROP PRIMARY KEY,
    RENAME COLUMN id TO identification_number,
    ADD COLUMN id BIGINT AUTO_INCREMENT PRIMARY KEY,

    DROP COLUMN pocket,
    DROP COLUMN manual_file,
    DROP COLUMN working_clothes_payment,
    DROP COLUMN working_time_model,
    DROP COLUMN working_time_weekly,
    CHANGE active active TINYINT(1) DEFAULT 1 NULL,

    RENAME COLUMN working_clothes_expense TO work_clothing_expenses,
    RENAME COLUMN accommodation TO accommodation_expenses,

    ADD COLUMN work_days_expenses TEXT NOT NULL,
    ADD COLUMN paid_vacation_expenses TEXT NOT NULL,
    ADD COLUMN first_day_expenses TEXT NOT NULL,
    ADD COLUMN last_day_expenses TEXT NOT NULL,
    ADD COLUMN location VARCHAR(255) DEFAULT 'zh' NULL,
    ADD COLUMN created_at DATETIME NOT NULL,
    ADD COLUMN updated_at DATETIME NOT NULL;

# Convert to newer JSON format
UPDATE service_specifications SET work_days_expenses = CONCAT(
    '{',
        '"breakfast":', working_breakfast_expenses, ',',
        '"lunch":', working_lunch_expenses, ','
        '"dinner":', working_dinner_expenses,
    '}'
) WHERE 1;

UPDATE service_specifications SET paid_vacation_expenses = CONCAT(
    '{',
        '"breakfast":', sparetime_breakfast_expenses, ',',
        '"lunch":', sparetime_lunch_expenses, ','
        '"dinner":', sparetime_dinner_expenses,
    '}'
) WHERE 1;

UPDATE service_specifications SET first_day_expenses = CONCAT(
    '{',
        '"breakfast":', firstday_breakfast_expenses, ',',
        '"lunch":', firstday_lunch_expenses, ','
        '"dinner":', firstday_dinner_expenses,
    '}'
) WHERE 1;

UPDATE service_specifications SET last_day_expenses = CONCAT(
    '{',
        '"breakfast":', lastday_breakfast_expenses, ',',
        '"lunch":', lastday_lunch_expenses, ','
        '"dinner":', lastday_dinner_expenses,
    '}'
) WHERE 1;

ALTER TABLE service_specifications
    DROP COLUMN working_breakfast_expenses,
    DROP COLUMN working_lunch_expenses,
    DROP COLUMN working_dinner_expenses,

    DROP COLUMN sparetime_breakfast_expenses,
    DROP COLUMN sparetime_lunch_expenses,
    DROP COLUMN sparetime_dinner_expenses,

    DROP COLUMN firstday_breakfast_expenses,
    DROP COLUMN firstday_lunch_expenses,
    DROP COLUMN firstday_dinner_expenses,

    DROP COLUMN lastday_breakfast_expenses,
    DROP COLUMN lastday_lunch_expenses,
    DROP COLUMN lastday_dinner_expenses;


-- -----------------------------------
-- === ALTER MISSIONS ==> SERVICES ===
-- -----------------------------------

RENAME TABLE missions TO services;

DELETE FROM report_sheets
    WHERE mission IN (SELECT id FROM services WHERE deleted_at IS NOT NULL);
DELETE FROM report_sheets WHERE deleted_at IS NOT NULL;

# Use db id for foreign key

ALTER TABLE services
    ADD COLUMN service_specification_id BIGINT NOT NULL;

UPDATE services
    LEFT JOIN service_specifications ON services.specification = service_specifications.identification_number
SET services.service_specification_id = service_specifications.id
WHERE 1;

# Convert updated_at and created_at to a datetime: Remove not null values

UPDATE services SET created_at = '2000-01-01 00:00:01' WHERE created_at IS NULL;
UPDATE services SET updated_at = '2000-01-01 00:00:01' WHERE updated_at IS NULL;
UPDATE services SET mission_type = 0 WHERE mission_type IS NULL;

ALTER TABLE services
    DROP PRIMARY KEY,

    CHANGE id id BIGINT AUTO_INCREMENT PRIMARY KEY,
    CHANGE user user_id BIGINT NOT NULL,
    CHANGE start beginning DATE NOT NULL,
    CHANGE end ending DATE NOT NULL,
    CHANGE first_time first_swo_service TINYINT(1) DEFAULT 1 NOT NULL,
    CHANGE long_mission long_service TINYINT(1) DEFAULT 0 NOT NULL,
    CHANGE probation_period probation_service TINYINT(1) DEFAULT 0 NOT NULL,
    CHANGE feedback_mail_sent feedback_mail_sent TINYINT(1) DEFAULT 0 NOT NULL,
    CHANGE mission_type service_type INT DEFAULT 0 NOT NULL,

    CHANGE created_at created_at DATETIME NOT NULL,
    CHANGE updated_at updated_at DATETIME NOT NULL,

    RENAME COLUMN draft TO confirmation_date,

    DROP COLUMN eligible_holiday,
    DROP COLUMN specification,
    DROP COLUMN feedback_done,
    DROP COLUMN deleted_at;


-- ----------------
-- === HOLIDAYS ===
-- ----------------

UPDATE holidays SET created_at = '2000-01-01 00:00:01' WHERE created_at IS NULL;
UPDATE holidays SET updated_at = '2000-01-01 00:00:01' WHERE updated_at IS NULL;

ALTER TABLE holidays
    DROP PRIMARY KEY,
    CHANGE id id BIGINT AUTO_INCREMENT PRIMARY KEY,
    CHANGE holiday_type holiday_type INT DEFAULT 1 NOT NULL,
    CHANGE created_at created_at DATETIME NOT NULL,
    CHANGE updated_at updated_at DATETIME NOT NULL,
    RENAME COLUMN date_from TO beginning,
    RENAME COLUMN date_to TO ending,
    DROP COLUMN deleted_at; -- It has no deleted holidays


-- ------------------------
-- === REGIONAL CENTERS ===
-- ------------------------

ALTER TABLE regional_centers
    DROP PRIMARY KEY,
    CHANGE id id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ADD COLUMN created_at DATETIME NOT NULL,
    ADD COLUMN updated_at DATETIME NOT NULL;


-- ----------------------
-- === EXPENSE SHEETS ===
-- ----------------------

RENAME TABLE report_sheets TO expense_sheets;

UPDATE expense_sheets SET created_at = '2000-01-01 00:00:01' WHERE created_at IS NULL;
UPDATE expense_sheets SET updated_at = '2000-01-01 00:00:01' WHERE updated_at IS NULL;
UPDATE expense_sheets SET work = 0 WHERE work IS NULL;
UPDATE expense_sheets SET company_holiday_vacation = 0 WHERE company_holiday_vacation IS NULL;
UPDATE expense_sheets SET company_holiday_holiday = 0 WHERE company_holiday_holiday IS NULL;
UPDATE expense_sheets SET workfree = 0 WHERE workfree IS NULL;
UPDATE expense_sheets SET clothes = 0 WHERE clothes IS NULL;

ALTER TABLE expense_sheets
    DROP PRIMARY KEY,
    CHANGE id id BIGINT AUTO_INCREMENT PRIMARY KEY,
    RENAME COLUMN start TO beginning,
    RENAME COLUMN end TO ending,
    CHANGE user user_id BIGINT NOT NULL,
    CHANGE work work_days INT NOT NULL,
    CHANGE company_holiday_vacation unpaid_company_holiday_days INT DEFAULT 0 NOT NULL,
    CHANGE company_holiday_holiday paid_company_holiday_days INT DEFAULT 0 NOT NULL,
    CHANGE workfree workfree_days INT DEFAULT 0 NOT NULL,

    RENAME COLUMN ill TO sick_days,
    RENAME COLUMN ill_comment TO sick_comment,

    RENAME COLUMN holiday TO paid_vacation_days,
    RENAME COLUMN holiday_comment TO paid_vacation_comment,

    RENAME COLUMN vacation TO unpaid_vacation_days,
    RENAME COLUMN vacation_comment TO unpaid_vacation_comment,

    CHANGE driving_charges driving_expenses INT DEFAULT 0 NOT NULL,
    RENAME COLUMN driving_charges_comment TO driving_expenses_comment,

    CHANGE extraordinarily extraordinary_expenses INT DEFAULT 0 NOT NULL,
    RENAME COLUMN extraordinarily_comment TO extraordinary_expenses_comment,

    CHANGE clothes clothing_expenses INT DEFAULT 0 NOT NULL,
    RENAME COLUMN clothes_comment TO clothing_expenses_comment,

    CHANGE state state INT DEFAULT 0 NOT NULL,

    CHANGE created_at created_at DATETIME NOT NULL,
    CHANGE updated_at updated_at DATETIME NOT NULL,
    ADD COLUMN payment_timestamp DATETIME NULL,

    DROP COLUMN deleted_at;

ALTER TABLE expense_sheets
    DROP COLUMN additional_workfree,
    DROP COLUMN additional_workfree_comment,
    DROP COLUMN document_number,
    DROP COLUMN ignore_first_last_day,
    DROP COLUMN mission,
    DROP COLUMN work_comment,
    DROP COLUMN workfree_comment;

# Generate payment timestamps
UPDATE expense_sheets
    LEFT JOIN payment_entries ON payment_entries.report_sheet = expense_sheets.id
    LEFT JOIN payments ON payment_entries.payment = payments.id
    SET expense_sheets.payment_timestamp = payments.created_at
    WHERE 1;

# To prevent huge payment with all legacy payments, we take ending of expense sheet and choose first day
# of next month as payment timestamp
UPDATE expense_sheets
    SET payment_timestamp = DATE_ADD(LAST_DAY(`ending`), INTERVAL 1 DAY)
    WHERE payment_timestamp IS NULL AND state = 3;

DROP TABLE payments, payment_entries;


-- ------------------------------------------
-- === CONFIGURE FOREIGN KEYS AND INDICES ===
-- ------------------------------------------

ALTER TABLE users
    ADD CONSTRAINT index_users_on_email UNIQUE (email),
    ADD CONSTRAINT index_users_on_reset_password_token UNIQUE (reset_password_token),
    ADD CONSTRAINT fk_rails_0402495f12 FOREIGN KEY (regional_center_id) REFERENCES REGIONAL_CENTERS (id);
CREATE INDEX index_users_on_regional_center_id ON users (regional_center_id);
CREATE INDEX index_users_on_zdp ON users (zdp);

ALTER TABLE services
    ADD CONSTRAINT fk_rails_51a813203f FOREIGN KEY (user_id) REFERENCES users (id),
    ADD CONSTRAINT fk_rails_05245f4b1b FOREIGN KEY (service_specification_id) REFERENCES service_specifications (id);
CREATE INDEX index_services_on_service_specification_id ON services (service_specification_id);
CREATE INDEX index_services_on_user_id ON services (user_id);

ALTER TABLE service_specifications
    ADD CONSTRAINT index_service_specifications_on_identification_number UNIQUE(identification_number);

ALTER TABLE expense_sheets
    ADD CONSTRAINT fk_rails_7fa777c334 FOREIGN KEY (user_id) REFERENCES users (id);
CREATE INDEX index_expense_sheets_on_user_id ON expense_sheets (user_id);
