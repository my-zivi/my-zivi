<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use PDO;
use PDOException;

class DatabaseCreateCommand extends Command
{
    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'This command creates a new database';

    /**
     * The console command signature.
     *
     * @var string
     */
    protected $signature = 'db:create';

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
    public function fire()
    {
        $this->info("Reading configuration...");

        $database = env('DB_DATABASE', false);
        $host = env('DB_HOST', false);
        $port = env('DB_PORT', false);
        $username = env('DB_USERNAME', false);
        $password = env('DB_PASSWORD', false);
        $charset = env('DB_CHARSET', false);
        $collation = env('DB_COLLATION', false);

        $this->info("Try to create database: ".$database."...");

        if (! $database) {
            $this->warn('Skipping creation of database as env(DB_DATABASE) is empty');
            return;
        }
        if (! $host) {
            $this->warn('Skipping creation of database as env(DB_HOST) is empty');
            return;
        }
        if (! $port) {
            $this->warn('Skipping creation of database as env(DB_PORT) is empty');
            return;
        }
        if (! $username) {
            $this->warn('Skipping creation of database as env(DB_USERNAME) is empty');
            return;
        }
        if (! $charset) {
            $this->warn('Skipping creation of database as env(DB_CHARSET) is empty');
            return;
        }
        if (! $collation) {
            $this->warn('Skipping creation of database as env(DB_COLLATION) is empty');
            return;
        }

        try {
            $pdo = $this->getPDOConnection($host, $port, $username, $password);

            $pdo->exec(sprintf(
                'CREATE DATABASE IF NOT EXISTS %s CHARACTER SET %s COLLATE %s;',
                $database,
                $charset,
                $collation
            ));
            $this->info(sprintf('Successfully created %s database', $database));
        } catch (PDOException $exception) {
            $this->error(sprintf('Failed to create %s database, %s', $database, $exception->getMessage()));
        }
    }

    /**
     * @param  string $host
     * @param  integer $port
     * @param  string $username
     * @param  string $password
     * @return PDO
     */
    private function getPDOConnection($host, $port, $username, $password)
    {
        return new PDO(sprintf('mysql:host=%s;port=%d;', $host, $port), $username, $password);
    }
}
