#api
composer global require "squizlabs/php_codesniffer=*"
$HOME/.composer/vendor/bin/phpcbf --standard=psr2 api/
code1=$?
$HOME/.composer/vendor/bin/phpcbf --standard=psr2 api/ > /dev/null 2>&1
code2=$?
if [ $code1 -ne $code2 ]; then
  echo "PHP Api is not properly formatted. Please reformat and commit again. See #TODO"
  exit 1;
fi

#frontend
npm install -g prettier
cd web-client
prettier --list-different --print-width 140 --single-quote --trailing-comma es5 "src/**/*.js"
if [ $? -ne 0 ]; then
  echo "Web-client is not properly formatted. Please reformat and commit again. See #TODO"
  exit 1;
fi
