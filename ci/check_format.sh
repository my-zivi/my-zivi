# checks if formatters could have been run locally to fix the code style

# check backend (api)
composer global require "squizlabs/php_codesniffer=*"
# we run phpcbf twice to check if it was able to fix something
# since it reports more than it can fix we check the status code twice and check if it changed
# sadly there is no unique status code for "phpcbf fixed something and maybe there are unfixable errors"
$HOME/.composer/vendor/bin/phpcbf --standard=psr2 api/
code1=$?
$HOME/.composer/vendor/bin/phpcbf --standard=psr2 api/ > /dev/null 2>&1
code2=$?
if [ $code1 -ne $code2 ]; then
  echo "PHP Api is not properly formatted. Please reformat and commit again. See https://github.com/stiftungswo/izivi/tree/master/api#formatting"
  exit 1;
fi

# check frontend (web-client)
npm install -g prettier
cd web-client
prettier --list-different --print-width 140 --single-quote --trailing-comma es5 "src/**/*.js"
if [ $? -ne 0 ]; then
  echo "Web-client is not properly formatted. Please reformat and commit again. See https://github.com/stiftungswo/izivi/tree/master/web-client#formatting"
  exit 1;
fi
