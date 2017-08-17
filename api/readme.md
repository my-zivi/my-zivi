# iZivi API

## Development only setup
1. Install PHP + mySQL 
2. composer update
3. cp .env.example .env
4. php artisan key:generate
5. php artisan jwt:generate --show # (add the key manually to the .env file)
6. Adjust MySQL login in .env file
7. Create a database "izivi" and import data
8. php artisan serve


## Setup for data migration
1. See "Development only setup" 1-6
2. Create database "stiftun8_iZivi" and import the old data
3. Create empty database "izivi"
4. php artisan migrate
5. run db-script izivi_DB_Migration.sql from ./migration on the izivi database
6. Run the "After" migration to update all passwords:  
* Windows:
    php artisan migrate --path=.\database\migrations\After
* *nix:
    php artisan migrate --path=./database/migrations/After
7. php artisan serve