FROM ballerina/ballerina:swan-lake-beta1 AS ballerina-builder
USER root
ADD . /src
WORKDIR /src

RUN bal build --offline -a --skip-tests

FROM adoptopenjdk/openjdk11:jre-11.0.10_9-alpine
WORKDIR /home/ballerina

LABEL maintainer="choreo"

RUN addgroup troupe \
      && adduser --system  --disabled-password --shell /bin/bash --gecos 'ballerina' --ingroup troupe ballerina

COPY --from=ballerina-builder /src/target/bin/ratelimit_decision_maker.jar /home/ballerina
RUN chown ballerina /home/ballerina/ratelimit_decision_maker.jar

EXPOSE  9090
USER ballerina

CMD java -Xms256m -XX:+UseContainerSupport -XX:MinRAMPercentage=75.0 -XX:MaxRAMPercentage=75.0 -jar ratelimit_decision_maker.jar || \
   cat ballerina-internal.log
