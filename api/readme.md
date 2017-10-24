# iZivi API

This Readme file covers developing and deploying the backend. See [web-client Readme](../web-client/readme.md) for information about the frontend.

### Development setup
1. Install dependencies: `docker run --rm -v $(PWD):/app -w /app composer install`
2. Start up the docker stack: `docker-compose up`
3. ``cp .env.example .env``
4. ``php artisan key:generate``
5. run ``php artisan jwt:generate --show`` and add the key manually to the .env file
6. Create a database "izivi" and import data
    - Export Database as SQL from Cyon PHPMyAdmin
        - Make sure your dump contains a `CREATE DATABASE izivi; USE izivi;` at the start
        - This should include your own user - set its role to 1 (admin) so you get admin access for your local application. (Or do it later using a database editor)
    - Import into your own database (your container name may vary): `docker exec -i izivi_db_1 mysql -uroot -pa < dump.sql`
7. Adjust MySQL parameters in .env file if needed
8. Done. API is available on `localhost:8000`

### Logging
``` PHP
use Symfony\Component\Console\Output\ConsoleOutput;
// [...]
$output = new ConsoleOutput();
$output->writeln("some log to console");
```
The logs will be displayed in the terminal where you started your artisan server.

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
