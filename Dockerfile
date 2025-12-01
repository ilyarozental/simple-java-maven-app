# syntax=docker/dockerfile:1

# ---------------- Build stage ----------------
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /workspace

# Version will come from GitHub Actions
ARG APP_VERSION=1.0.0

COPY pom.xml .
COPY src ./src

# Set jar version and build
RUN mvn -B -q versions:set -DnewVersion=${APP_VERSION} \
    && mvn -B -q test package

# ---------------- Runtime stage ----------------
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy the built jar (name includes version)
COPY --from=build /workspace/target/*.jar app.jar

ENTRYPOINT ["java","-jar","/app/app.jar"]
