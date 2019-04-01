#!/bin/bash
if [[ $(pwd) != $(git rev-parse --show-toplevel) || $(basename $(pwd)) != "izivi" ]]; then
    echo "Execute this script inside the izivi repository."
    exit 1
fi

#echo "Building izivi_api image..."
#docker build -t izivi_api api
echo "Installing composer dependencies..."
docker run --rm -v $PWD/api:/app -w /app izivi_api composer install
echo "Booting docker-compose stack..."
docker-compose up -d
echo "Copying .env..."
cp api/.env.example api/.env
echo "Linking pre-commit hook..."
ln -s $(pwd)/hooks/pre-commit $(pwd)/.git/hooks


echo "Getting up to date izivi dump from Cyon..."
docker-compose up -d
sleep 120

createDBAndFillWithDump() {
  docker exec izivi_db mysql -u root --execute="CREATE DATABASE izivi;";
  ssh stiftun8@stiftungswo.ch mysqldump -u stiftun8_izivi2 -ptaU%4baU?5caU#7u stiftun8_izivi 2>/dev/null | docker exec -i izivi_db mysql -u root izivi
  if [[ $docker_has_izivi_api ]]; then
    migrateDB
  else
    echo "No running izivi_api container found! Please start this to enable auto-migration after dump copying."
  fi
}

migrateDB() {
  docker exec izivi_api php artisan migrate
}

docker_has_izivi_db="$(docker ps | grep izivi_db)"
docker_has_izivi_api="$(docker ps | grep izivi_api)"

if [[ $docker_has_izivi_db ]]; then
  mysql_has_izivi_db=$(docker exec izivi_db mysql -u root --execute="SHOW DATABASES LIKE 'izivi';")

  if [[ $mysql_has_izivi_db ]]; then
    echo "izivi db already exists!"
    read -e -p "Override: [y|N] " override

    case "$override" in
      [yY]|1)
        docker exec izivi_db mysql -u root --execute="DROP DATABASE izivi;"
        createDBAndFillWithDump
        ;;
      *)
        echo ""
        ;;
    esac
  else
    createDBAndFillWithDump
  fi
else
  echo "No running izivi_db container found! Please start this first"
fi

