#!/bin/bash -vue

case $1 in
  "test")
    echo "Treating Warnings AS Warnings"
    CI=false
    ;;
  *)
    echo "Treating Warnings AS ERRORS"
    ;;
esac

# do build the frontend first
cd frontend && yarn build && cd -

if [ ! -f $HOME/.ssh/id_rsa ]; then
  echo "Setting up SSH key"
  ./ci/establish-ssh.sh
fi

case $1 in
  "test")
    ENVIRONMENT=test
    ;;
  "prod")
    ENVIRONMENT=prod
    ;;
  *)
    echo "Invalid environment"
    exit 1
    ;;
esac

# This imports the config from $CONFIG_FILE on the remote system ($TARGET) into this scripts environment
echo "deploy app to $ENVIRONMENT."
CONFIG_FILE=deploy/izivi.$ENVIRONMENT.env
TARGET=$target
export $(ssh $TARGET "cat $CONFIG_FILE" | xargs)

TMP=izivi_deploy_tmp_${TRAVIS_BRANCH}_${TRAVIS_COMMIT}
BACKUP_DIR=./backup/izivi/$ENVIRONMENT

# upload and move folders
cp frontend/htaccess.dist frontend/build/.htaccess && \
ssh $TARGET mkdir -p ${PROJECT_DIR} ${PROJECT_DIR}.bak && \
rsync -ra --exclude '.git' --exclude 'node_modules' . $TARGET:$TMP && \
ssh $TARGET sed -i'' "s/COMMIT_ID/$TRAVIS_COMMIT/" $TMP/frontend/build/static/js/main.*.js && \
ssh $TARGET sed -i'' "s/ENVIRONMENT/$ENVIRONMENT/" $TMP/frontend/build/static/js/main.*.js && \
ssh $TARGET sed -i'' "s,BASE_URL,$API_URL," $TMP/frontend/build/static/js/main.*.js && \
ssh $TARGET sed -i'' "s,SENTRY_DSN,$SENTRY_DSN_PUBLIC," $TMP/frontend/build/static/js/main.*.js && \
ssh $TARGET cp $CONFIG_FILE $TMP/api/.env && \
ssh $TARGET rm -r ${PROJECT_DIR}.bak && \
ssh $TARGET mv $PROJECT_DIR ${PROJECT_DIR}.bak && \
ssh $TARGET mv $TMP $PROJECT_DIR

# db backup and migrate
ssh $TARGET mkdir -p $BACKUP_DIR && \
ssh $TARGET "mysqldump -u $DB_USERNAME -p$DB_PASSWORD $DB_DATABASE | bzip2 -c > $BACKUP_DIR/${DB_DATABASE}_$(date +%Y_%m_%d-%H:%M:%S).sql.bz2" && \
ssh $TARGET "cd $PROJECT_DIR/api && php72 artisan migrate --no-interaction --force"
