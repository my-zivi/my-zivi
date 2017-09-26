# iZivi Web Client
This Readme File covers developing and deploying the frontend. See [api Readme](../web-client/readme.md) for information about the backend.

### Development
1. Install Node.js (https://nodejs.org/en/download/)
2. Install Yarn (https://yarnpkg.com/en/docs/install)
3. <code>cd ./web-client</code>
4. <code>yarn install</code>
5. <code>yarn run watch</code>

### Live Deployment
1. change the BASE_URL in src/utils/api.js to point to your productive API (only if you want something different e.g. for a test deployment)
2. <code>yarn build</code>
3. Copy all contents of dist folder to corresponding folder on server (delete old files first)
4. Make sure the .htaccess file with the following content exists:
<pre>
Options -MultiViews
RewriteEngine On
RewriteCond %{HTTPS} =off
RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [QSA,L,R=301]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^ index.html [QSA,L]</pre>
