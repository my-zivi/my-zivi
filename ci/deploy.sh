#!/bin/bash

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

#Read config env
CONFIG_FILE=deploy/izivi.$ENVIRONMENT.env
TARGET=$target
export $(ssh $TARGET "cat $CONFIG_FILE" | xargs)

TMP=izivi_deploy_tmp
BACKUP_DIR=./backup/izivi/$ENVIRONMENT

if [ -z "$PROJECT_DIR" ]; then
  echo "PROJECT_DIR is not set"
  exit 1
fi

# upload and move folders
cp web-client/htaccess.dist web-client/dist/.htaccess && \
ssh $TARGET mkdir -p ${PROJECT_DIR} ${PROJECT_DIR}.bak && \
rsync -ra --exclude '.git' --exclude 'node_modules' . $TARGET:$TMP && \
ssh $TARGET cp $CONFIG_FILE $TMP/api/.env && \
ssh $TARGET rm -r ${PROJECT_DIR}.bak && \
ssh $TARGET mv $PROJECT_DIR ${PROJECT_DIR}.bak && \
ssh $TARGET mv $TMP $PROJECT_DIR

# db backup and migrate
ssh $TARGET mkdir -p $BACKUP_DIR && \
ssh $TARGET "mysqldump -u $DB_USERNAME -p$DB_PASSWORD $DB_DATABASE | bzip2 -c > $BACKUP_DIR/${DB_DATABASE}_$(date +%Y_%m_%d-%H:%M:%S).sql.bz2" && \
ssh $TARGET "cd $PROJECT_DIR/api && php72 artisan migrate"
