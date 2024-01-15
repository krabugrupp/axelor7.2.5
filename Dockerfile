FROM gradle:7.5.1-jdk11 as build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle -x test build --no-daemon

FROM tomcat:9.0-jdk11-corretto
EXPOSE 8080
RUN rm -rf /usr/local/tomcat/webapps/*
#COPY ./build/libs/axelor-erp-*.war /usr/local/tomcat/webapps/ROOT.war
COPY --from=build /home/gradle/src/build/libs/*.war /usr/local/tomcat/webapps/ROOT.war
COPY src/main/resources/axelor-config.properties /usr/local/tomcat/
COPY Calibri/*.ttf /usr/share/fonts/truetype/
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk
CMD ["catalina.sh","run"]
