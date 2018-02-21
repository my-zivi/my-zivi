
#frontend
npm install -g prettier
cd web-client
prettier --list-different --print-width 140 --single-quote --trailing-comma es5 "src/**/*.js"
if [ $? -ne 0 ]; then
  echo "Web-client is not properly formatted. Please reformat and commit again. See #TODO"
  exit 1;
fi
