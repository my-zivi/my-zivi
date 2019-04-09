<?php

namespace App\Console\Commands;

use App\User;
use Illuminate\Console\Command;
use libphonenumber\NumberParseException;
use libphonenumber\PhoneNumberUtil;

class FormatPhonenumbersCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'command:format-phonenumbers {--dry-run : don\'t save changes}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Formats all (valid) phone numbers in a standard way';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        $phoneUtil = PhoneNumberUtil::getInstance();

        $result = [];

        foreach (User::all() as $user) {
            foreach (['phone_mobile', 'phone_private', 'phone_business'] as $key) {
                $number = trim($user[$key], " \t\n\r\0\x0B-");
                if (empty($number)) {
                    continue;
                }
                $valid = false;
                try {
                    $numberProto = $phoneUtil->parse($number, 'CH');
                    $isValid = $phoneUtil->isValidNumber($numberProto);
                    if ($isValid) {
                        $valid = true;
                        $formatted = $phoneUtil->formatOutOfCountryCallingNumber($numberProto, 'CH');
                        if ($formatted != $number) {
                            $user[$key] = $formatted;

                            $result[] = [
                                'id'          => $user->id,
                                'name'        => $user->first_name . ' ' . $user->last_name,
                                'status'      => 'formatted',
                                'number_type' => substr($key, 6),
                                'before'      => $number,
                                'after'       => $formatted,
                            ];
                        }
                    }
                } catch (NumberParseException $e) {
                    // invalid
                }
                if (!$valid) {
                    $result[] = [
                        'id'          => $user->id,
                        'name'        => $user->first_name . ' ' . $user->last_name,
                        'status'      => 'invalid',
                        'number_type' => substr($key, 6),
                        'before'      => $number,
                        'after'       => '',
                    ];
                }
            }
            if (!$this->options()['dry-run']) {
                $user->save();
            }
        }


        $table = [];
        $formattedCount = 0;
        $invalidCount = 0;

        foreach ($result as $item) {
            if ($item['status'] === 'formatted') {
                if ($this->getOutput()->isVeryVerbose()) {
                    $table[] = $item;
                }
                $formattedCount++;
            }
            if ($item['status'] === 'invalid') {
                if ($this->getOutput()->isVerbose()) {
                    $table[] = $item;
                }
                $invalidCount++;
            }
        }

        if (!empty($table)) {
            $this->table([
                'ID',
                'User',
                'Status',
                'Typ',
                'Vorher',
                'Nacher',
            ], $table, 'compact');
        }

        $total = $formattedCount + $invalidCount;

        $this->info('done');
        $this->info("$total total");
        $this->info("$formattedCount formatted");
        $this->info("$invalidCount invalid");
    }
}
