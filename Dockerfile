FROM tomcat:jre8

ADD ./server.xml /usr/local/tomcat/conf/server.xml
ADD ./entrypoint.sh /entrypoint.sh
ADD ./fineract-provider.war /usr/local/tomcat/webapps/fineract-provider.war

COPY apps/community-app/ /usr/local/tomcat/webapps/app
COPY api-docs/ /usr/local/tomcat/webapps/api-docs
COPY pentahoReports /root/.mifosx

RUN chmod +x /entrypoint.sh

RUN apt-get update \
	&& apt-get install -y mysql-client \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /run/mysqld \
	&& chown 999 /run/mysqld

RUN wget http://central.maven.org/maven2/org/drizzle/jdbc/drizzle-jdbc/1.3/drizzle-jdbc-1.3.jar \
	&& mv drizzle-jdbc-1.3.jar /usr/local/tomcat/lib 

EXPOSE 8443 8009 8080

ENTRYPOINT /entrypoint.sh
