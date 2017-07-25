<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class ReportSheet extends Model
{
    protected $fillable = ['id',
                           'start',
                           'end',
                           'user',
                           'done',
                           'work',
                           'work_comment',
                           'national_holiday',
                           'company_holiday',
                           'company_holiday_comment',
                           'workfree',
                           'workfree_comment',
                           'additional_workfree',
                           'additional_workfree_comment',
                           'ill',
                           'ill_comment',
                           'holiday',
                           'holiday_comment',
                           'vacation',
                           'vacation_comment',
                           'driving_charges',
                           'driving_charges_comment',
                           'extraordinarily',
                           'extraordinarily_comment',
                           'clothes',
                           'clothes_comment',
                           'employmentId',
                           'bank_account_number',
                           'document_number', // "Beleg Nummer"
                           'booked_date',
                           'paid_date'
                        ];
}
