# iZivi - Web Client
1. Install Node.js (https://nodejs.org/en/download/)
2. Install Yarn (https://yarnpkg.com/en/docs/install)
3. cd ./web-client
4. yarn install
5. yarn run watch


# Live Deployment
1. change the BASE_URL in src/utils/api.js to point to your productive API
2. yarn build
3. Copy all contents of dist folder to corresponding folder on server (delete old files first)
4. Make sure the .htaccess file with the following content exists:
    Options -MultiViews
    RewriteEngine On
    RewriteCond %{HTTPS} =off
    RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [QSA,L,R=301]
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^ index.html [QSA,L]
