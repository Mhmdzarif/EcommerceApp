# -------- Build stage (uses Maven + JDK) --------
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy Maven files first to leverage Docker cache
COPY pom.xml .
RUN mvn -q -e -DskipTests dependency:go-offline

# Copy the source and build
COPY src ./src
RUN mvn -q -DskipTests package

# -------- Runtime stage (slim JRE only) --------
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose app port
EXPOSE 8080

# Start the application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
