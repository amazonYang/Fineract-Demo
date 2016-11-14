# CoreBanking
Mekar's own core banking system based on Fineract/Mifos X

##Fineract install

###Local setup
1. Checkout build MekarIndonesia/Fineract from Github
2. Build the Docker instance using: docker build -t mekar/fineract .
3. Start local mysql 5.6 instance: (add mount to project directory)
docker run --name fineractmysql -p3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql:5.6
4. Install 2 basic database scripts from database/local
5. Startup Fineract docker image: 
docker run --link fineractmysql -p:8443:8443 -p8080:8080 fineract
6. Test interaction on http://localhost:8443/app/, ignore SSL warning
Additional:
7. Start local nginx instance + mount conf.d local docker run —name nginx —link fineract -V nginx/conf.d:/etc/nginx/conf.d/ nginx

###Setup for dev
1. Prepare database using script
2. Startup fineract docker image with startup parameters for db host, username, password. 
3. Copy fineract-dev.mekar.id.conf

