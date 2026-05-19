ARG BASE_IMAGE=eclipse-temurin:17-jdk-jammy
FROM ${BASE_IMAGE}

ENV APP_HOME=/workspace \
    GRADLE_USER_HOME=/opt/gradle-cache \
    MAVEN_REPO_HOME=/opt/maven-repository

WORKDIR ${APP_HOME}

COPY gradle gradle
COPY gradlew gradlew
COPY settings.gradle.kts build.gradle.kts gradle.properties ./

RUN chmod +x ./gradlew \
    && ./gradlew --no-daemon help

COPY . .

RUN ./gradlew --no-daemon regressionRun \
    && find "${GRADLE_USER_HOME}/caches/modules-2/files-2.1" -type f \( -name "*.jar" -o -name "*.pom" -o -name "*.module" \) \
        | while read -r file; do \
            rel="${file#${GRADLE_USER_HOME}/caches/modules-2/files-2.1/}"; \
            group="${rel%%/*}"; \
            rest="${rel#*/}"; \
            artifact="${rest%%/*}"; \
            rest="${rest#*/}"; \
            version="${rest%%/*}"; \
            target_dir="${MAVEN_REPO_HOME}/$(printf '%s' "${group}" | tr '.' '/')/${artifact}/${version}"; \
            mkdir -p "${target_dir}"; \
            cp "${file}" "${target_dir}/$(basename "${file}")"; \
        done \
    && ./gradlew --offline --no-daemon regressionRun

CMD ["./gradlew", "--offline", "--no-daemon", "regressionRun"]
