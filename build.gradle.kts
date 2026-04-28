plugins {
    kotlin("jvm") version "2.3.0"
    id("org.openprojectx.karate.gradle") version "0.1.70"
}

group = "org.openprojectx.karate.gradle.example"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
    testImplementation("com.github.tomakehurst:wiremock-jre8:2.35.2")
    testImplementation("org.junit.jupiter:junit-jupiter:5.11.4")
}

kotlin {
    jvmToolchain(17)
}

tasks.test {
    useJUnitPlatform()
}

regression {
    workflowsDirs.add("src/test/resources/workflows")
    environmentsDirs.add("src/test/resources/environments")
    datasetsRootDir.set("src/test/resources/datasets")

    datasets {
        register("default") {
            path.set("default")
        }
        register("edge-cases") {
            path.set("advanced/edge-cases")
        }
    }
}