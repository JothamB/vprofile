FROM tomcat:9-jdk11
COPY ./target/vprofile.* /usr/local/tomcat/webapps/ROOT.war
CMD ["catalina.sh", "run"]
