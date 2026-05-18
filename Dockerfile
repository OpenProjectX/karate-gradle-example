ARG BASE_IMAGE=eclipse-temurin:17-jdk-jammy
FROM ${BASE_IMAGE}

ENV APP_HOME=/workspace \
    GRADLE_USER_HOME=/opt/gradle-cache

WORKDIR ${APP_HOME}

COPY gradle gradle
COPY gradlew gradlew
COPY settings.gradle.kts build.gradle.kts gradle.properties ./

RUN chmod +x ./gradlew \
    && ./gradlew --no-daemon help

COPY . .

RUN ./gradlew --no-daemon regressionRun \
    && ./gradlew --offline --no-daemon regressionRun

CMD ["./gradlew", "--offline", "--no-daemon", "regressionRun"]
