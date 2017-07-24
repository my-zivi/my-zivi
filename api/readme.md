# iZivi API

## Install
1. composer update
2. cp .env.example .env
3. php artisan key:generate
4. php artisan jwt:generate --show # (add the key manually to the .env file)
5. Adjust MySQL login in .env file
6. php artisan migrate