<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\User;

class FetchBICs extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'command:fetchbics';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Fetches user\'s missing BICs based on their IBAN from a webservice.';

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
        $updated = 0;
        $upToDate = 0;
        $invalid = 0;
        $error = 0;

        foreach (User::all() as $user) {
            $json = null;

            $iban = $user->bank_iban;
            if ($user->bank_bic != null) {
                $upToDate += 1;
            } elseif ($iban != null && substr($iban, 0, 2) == "CH") {
                try {
                    $this->comment("Fetching BIC for $iban");
                    $iban = preg_replace("/[^\w]/", "", $iban);
                    $json_url = "https://openiban.com/validate/$iban?getBIC=true";
                    $json = file_get_contents($json_url);
                    $data = json_decode($json, true);
                    if ($data['valid'] && array_key_exists('bic', $data['bankData'])) {
                        $user->bank_bic = $data['bankData']['bic'];
                        $user->save();
                        $updated += 1;
                    } else {
                        $this->error($json);
                        $error +=1;
                    }
                } catch (Exception $e) {
                    $this->error($e);
                    $this->error($json);
                    $error +=1;
                }
                sleep(1); //be gentle
            } else {
                $invalid += 1;
            }
        }

        $this->info("Done.");
        $this->info("$updated updated");
        $this->info("$upToDate already up to date");
        $this->info("$invalid invalid IBANs skipped");
        $this->info("$error errors");
    }
}
