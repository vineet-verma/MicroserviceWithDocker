FROM openjdk:8

RUN apt-get update
RUN apt-get install net-tools

RUN apt-get install -y unzip
RUN apt-get install wget
RUN mkdir -p /usr/app/files
WORKDIR /usr/app

RUN apt-get update && apt-get -y install python curl unzip && cd /tmp && curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && unzip awscli-bundle.zip && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && rm awscli-bundle.zip && rm -rf awscli-bundle

COPY runserver.sh target/razor-polling-service.jar /usr/app/

RUN wget -N https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip
RUN unzip newrelic-java.zip
COPY newrelic.yml.template /var/lib/
COPY newrelic.sh /var/lib/

#To allow on prem deployments as undefined user
RUN chmod 777 /usr/app
RUN chmod +x /usr/app/runserver.sh

# download xray
RUN wget https://s3.dualstack.us-east-2.amazonaws.com/aws-xray-assets.us-east-2/xray-daemon/aws-xray-daemon-linux-3.x.zip
RUN unzip aws-xray-daemon-linux-3.x.zip

ADD aws-env /usr/app
RUN chmod u+x aws-env

EXPOSE 8080 2000

CMD ["./runserver.sh"]

ENV NEWRELIC_KEY=eead7f4a2b126437cd9183d7b0e298fced2aeb5a
ENV GROUP_NAME=DOC-SERVICES
