
/* This query can be used for manual correction of entries containing an IBAN with an invalid format */
SELECT *
 FROM izivi.users
 WHERE bank_iban NOT REGEXP('^CH[0-9]{2}[[:space:]]{0,1}([0-9A-Za-z]{4,5}[[:space:]]{0,1}){4,7}[0-9A-Za-z]{0,2}$')
 AND bank_iban REGEXP('.*(CH[0-9][0-9]).*');

/* This query returns a list of all email addresses where no IBAN has been found */
SELECT CONCAT(email, ", ")
 FROM izivi.users
 WHERE bank_iban NOT REGEXP('^CH[0-9]{2}[[:space:]]{0,1}([0-9A-Za-z]{4,5}[[:space:]]{0,1}){4,7}[0-9A-Za-z]{0,2}$');