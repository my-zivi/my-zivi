# iZivi API

This Readme File covers developing and deploying the backend. See [web-client Readme](../web-client/readme.md) for information about the frontend.

### Development setup
1. Install PHP + mySQL + composer
2. <code>composer update</code>
3. <code>cp .env.example .env</code>
4. <code>php artisan key:generate</code>
5. <code>php artisan jwt:generate --show # (add the key manually to the .env file)</code>
6. Adjust MySQL login in .env file
7. Create a database "izivi" and import data
8. <code>php artisan serve</code>

### Live Deployment
1. Copy all files except for the vendor folder to remote server
2. Create or adapt the .env file for the live database (set APP_ENV to production and disable DEBUG)
3. Connect to server via SSH
4. Install composer if needed (https://getcomposer.org/download/) and run
    * <code>php composer.phar install</code>
5. If there have been changes to the database migration, run your custom migration scripts
    * <code>php artisan migrate</code>
6. Make sure your server endpoint points to the public folder

# Old Instructions (including migration from legacy izivi)
These are the instructions for upgrading from the old (izivi) to the new (izivi2) application. This information is usually not needed for developing or deploying. If you are still here, go right ahead:
### Instructions for data migration [old]
1. Perform "Development setup" steps 1-6
2. Create database "stiftun8_iZivi" and import the old data
3. Create empty database "izivi"
4. <code>php artisan migrate</code>
5. run db-script izivi_DB_Migration.sql from ./migration on the izivi database
6. Run the "After" migration to update all passwords:  
    <code>php artisan migrate --path=./database/migrations/After</code>
7. <code>php artisan serve</code>

### Live Deployment with data migration [old]
1. Copy all files except for the vendor folder to remote server
2. Create or adapt the .env file for the live database (set APP_ENV to production and disable DEBUG)
3. Connect to server via SSH
4. Install composer if needed (https://getcomposer.org/download/) and run
  * <code>php composer.phar install</code>
5. <code>php artisan migrate</code>
6. Aadapt the izivi_DB_Migration.sql to match your databases and run it from the console (it does not work in phpMyAdmin)
  * <code>mysql -u DATABASE_USER -p --database NEW_DATABASE_NAME < izivi_DB_Migration.sql</code>
7. <code>php artisan migrate --path=./database/migrations/After</code>
8. Make sure your server endpoint points to the public folder
