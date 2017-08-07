# iZivi API

## DB migration preparation
1. Install PHP + mySQL, 
2. create a db user with all Data and Structure privileges + REFERENCES privilege
2. Create database stiftun8_iZivi and import the old data
3. Create database izivi

## Install
1. composer update
2. cp .env.example .env
3. php artisan key:generate
4. php artisan jwt:generate --show # (add the key manually to the .env file)
5. Adjust MySQL login in .env file
6. php artisan migrate
7. run db-script izivi_DB_Migration.sql from ./migration on the izivi database
8. Run the "After" migration to update all passwords:  
php artisan migrate --path=.\database\migrations\After

## Running
1. php artisan serve