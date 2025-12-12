# 1단계: 빌드 환경
FROM maven:3.9-eclipse-temurin-17 as builder
WORKDIR /app

# pom.xml 먼저 복사 (의존성 캐싱)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 소스 코드 복사
COPY src ./src

# 빌드 실행
RUN mvn clean package -DskipTests -B

# 빌드 결과 확인 및 jar 파일 찾기
RUN echo "=== Build output ===" && \
    ls -la /app/target/ && \
    find /app/target -name "*.jar" -type f ! -name "*-sources.jar" ! -name "*-javadoc.jar" && \
    JAR_FILE=$(find /app/target -name "*.jar" -type f ! -name "*-sources.jar" ! -name "*-javadoc.jar" | head -n 1) && \
    echo "Found JAR: $JAR_FILE" && \
    cp "$JAR_FILE" /app/app.jar

# 2단계: 실행 환경
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# 빌드 단계에서 이름을 통일한 jar 파일 복사
COPY --from=builder /app/app.jar ./app.jar

# 파일 확인
RUN ls -la /app/ && file /app/app.jar

# 실행
ENTRYPOINT ["java", "-jar", "/app/app.jar"]