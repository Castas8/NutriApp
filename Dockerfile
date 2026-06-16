FROM eclipse-temurin:26-jdk

RUN apt-get update && apt-get install -y wget && \
    wget https://downloads.apache.org/tomcat/tomcat-11/v11.0.22/bin/apache-tomcat-11.0.22.tar.gz && \
    tar xzf apache-tomcat-11.0.22.tar.gz && \
    mv apache-tomcat-11.0.22 /opt/tomcat && \
    rm apache-tomcat-11.0.22.tar.gz

RUN rm -rf /opt/tomcat/webapps/*

COPY dist/Nutri.war /opt/tomcat/webapps/ROOT.war

EXPOSE 8080

ENV JAVA_TOOL_OPTIONS="--add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED -Djdk.attach.allowAttachSelf=true"

CMD ["/opt/tomcat/bin/catalina.sh", "run"]
