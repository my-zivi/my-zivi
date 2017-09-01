<?php
/**
 * Created by PhpStorm.
 * User: Simon Rösch
 * Date: 7/26/17
 * Time: 9:29 AM
 */

namespace App;

class CompanyInfo
{
    // Name des Einsatzbetriebs
    const COMPANY_NAME = 'Stiftung Wirtschaft und Ökologie';
    // Kurzer Name des Einsatzbetriebs
    const COMPANY_NAME_SHORT = 'SWO';
    // Name des Einsatzbetriebs im EIS (eis.zivil-dienst.ch)
    const COMPANY_NAME_EIS = 'SWO Artenschutz';
    // Adresse des Einsatzbetriebs
    const COMPANY_ADDRESS = 'Im Schatzacker 5';
    // PLZ und Ort des Einsatzbetriebs
    const COMPANY_CITY = '8600 Dübendorf-Gfenn ';
    // Adresse des Einsatzbetriebs
    const COMPANY_ADDRESS_WORKPLACE = 'Bahnstrasse 9';
    // PLZ und Ort des Einsatzbetriebs
    const COMPANY_CITY_WORKPLACE = '8603 Schwerzenbach';
    // Artikel des Einsatzbetriebnamens (der, die oder das)
    const COMPANY_GENDER = 'die';
    // Einsatzbetriebs-Nr.
    const COMPANY_NO = '423';
    // Postkonto Nr. des Einsatzbetriebs (Für Spesen Einzahlungsschein)
    const COMPANY_ACCOUNT_NO = '';
    
    // Name der fuer den Zivildienst verantwortlichen Person
    const RESPONSIBLE_PERSON_NAME = 'Marc Pfeuti';
    // Mobile-Nr der fuer den Zivildienst verantwortlichen Person
    const RESPONSIBLE_PHONE = '077 438 57 61';
    // Funktion der fuer den Zivildienst verantwortlichen Person
    const RESPONSIBLE_FUNCTION = 'Einsatzleiter';
    // E-Mail Adresse der fuer den Zivildienst verantwortlichen Person
    const RESPONSIBLE_MAIL = 'zivildienst@stiftungswo.ch';

    const DEFAULT_ACCOUNT_NUMBER_REPORT_SHEETS = '4470 (200)';

    const SPESEN_PAYMENT_IBAN = 'CH1509000000302661798';
    const SPESEN_PAYMENT_BIC = 'POFICHBEXXX';
}
