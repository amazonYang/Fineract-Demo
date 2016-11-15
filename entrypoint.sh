#!/bin/bash
keytool -genkey -noprompt -storepass password -keypass password -keyalg RSA -alias tomcat -dname "CN=tomcat" -keystore /usr/share/tomcat.keystore

#Copy database settings from environment
if [[ "${FINERACTMYSQL_PORT_3306_TCP_ADDR+1}" ]]; then
    #is linked to external mysql docker and we use those variables
    export FINERACT_HOST=$FINERACTMYSQL_PORT_3306_TCP_ADDR
    export FINERACT_PORT=$FINERACTMYSQL_PORT_3306_TCP_PORT
    export FINERACT_DATABASE="fineract_tenants"
    export FINERACT_USERNAME="fineract_tenants"
    export FINERACT_PASSWORD="password"
    echo "Via docker MySQL provisioned"
else
    export FINERACT_HOST
    export FINERACT_PORT
    export FINERACT_DATABASE
    export FINERACT_USERNAME
    export FINERACT_PASSWORD
    echo "Direct provisioned"
fi
#set variables in startup variables
export CATALINA_OPTS="-DFINERACT_HOST=${FINERACT_HOST} -DFINERACT_PORT=${FINERACT_PORT} -DFINERACT_DATABASE=${FINERACT_DATABASE} -DFINERACT_USERNAME=${FINERACT_USERNAME} -DFINERACT_PASSWORD=${FINERACT_PASSWORD}"
#run the tomcat engine
catalina.sh run