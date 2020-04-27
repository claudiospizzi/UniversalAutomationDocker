# Stop, remove, rebuild and start the containers
docker-compose stop
docker-compose rm -f
docker-compose up -d --build
