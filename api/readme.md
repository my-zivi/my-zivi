# iZivi API

This Readme file covers developing and deploying the backend. See [web-client Readme](../web-client/readme.md) for information about the frontend.

### Development setup
0. Build the api image: ``docker build -t izivi_api api``
1. Install dependencies: ``docker run --rm -v $PWD/api:/app -w /app izivi_api composer install``
2. Start up the docker stack: ``docker-compose up -d``
3. Copy .env file: ``cp api/.env.example api/.env``
4. Generate key: ``docker exec izivi_api php artisan key:generate`` (it will be populated into the api/.env file)
5. run ``docker exec izivi_api php artisan jwt:generate --show`` and add the key manually to the .env file
6. Import Database
    - Export Database as SQL from Cyon (Datenbank -> MySQL -> stiftun8_izivi2 -> Backup)
    - Open PHPMyAdmin available  on `localhost:48080` and create a database "izivi"
    - Import the database from the backup file
    - Edit your user and set the role to 1 (admin) or use the tech@stiftungswo.ch account (see Keepass).
7. Adjust MySQL parameters in .env file if needed
8. The API is now available on `localhost:48000`
9. Run the database migration `docker exec izivi_api php artisan migrate`


### Formatting

[phpcbf](https://github.com/squizlabs/PHP_CodeSniffer) is used to automatically format our code based on [PSR-2](https://www.php-fig.org/psr/psr-2/).  
Just run `composer run format` or `docker exec izivi_api composer run format`.

You should run this before each commit or else the [CI](https://travis-ci.org/stiftungswo) system will yell at you.

### Logging

For logging please use lumen logger (e.g. `\Log::warning("your message here.");`).
Please see https://lumen.laravel.com/docs/5.2/errors for more detailled documentation.

The log files will be written to `api/storage/logs/` which is shared between your docker container and your development machine. 

### Live Deployment
1. Copy all files except for the vendor folder to remote server
2. Create or adapt the .env file for the live database (set APP_ENV to production and disable DEBUG)
3. Connect to server via SSH
4. Install composer if needed (https://getcomposer.org/download/) and run
    * ``php composer.phar install``
5. If there have been changes to the database migration, run your custom migration scripts
    * ``php artisan migrate``
6. Make sure your server endpoint points to the public folder

# Old Instructions (including migration from legacy izivi)
These are the instructions for upgrading from the old (izivi) to the new (izivi2) application. This information is usually not needed for developing or deploying. If you are still here, go right ahead:
### Instructions for data migration [old]
1. Perform "Development setup" steps 1-6
2. Create database "stiftun8_iZivi" and import the old data
3. Create empty database "izivi"
4. ``php artisan migrate``
5. run db-script izivi_DB_Migration.sql from ./migration on the izivi database
6. Run the "After" migration to update all passwords:  
    ``php artisan migrate --path=./database/migrations/After``
7. ``php artisan serve``

### Live Deployment with data migration [old]
1. Copy all files except for the vendor folder to remote server
2. Create or adapt the .env file for the live database (set APP_ENV to production and disable DEBUG)
3. Connect to server via SSH
4. Install composer if needed (https://getcomposer.org/download/) and run
  * ``php composer.phar install``
5. ``php artisan migrate``
6. Aadapt the izivi_DB_Migration.sql to match your databases and run it from the console (it does not work in phpMyAdmin)
  * ``mysql -u DATABASE_USER -p --database NEW_DATABASE_NAME < izivi_DB_Migration.sql``
7. ``php artisan migrate --path=./database/migrations/After``
8. Make sure your server endpoint points to the public folder
