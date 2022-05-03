FROM openjdk:8-jdk-alpine
RUN addgroup -S renuka && adduser -S renuka -G renuka
USER renuka:renuka

# ARG JAR_FILE=target/*.jar
# COPY ${JAR_FILE} app.jar
# ENTRYPOINT ["java","-jar","/app.jar"]

ARG DEPENDENCY=target/dependency
COPY ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY ${DEPENDENCY}/META-INF /app/META-INF
COPY ${DEPENDENCY}/BOOT-INF/classes /app
COPY keystore.p12 /app
ENTRYPOINT ["java","-cp","app:app/lib/*","org.renuka.k8s.prometheus.app.Application"]