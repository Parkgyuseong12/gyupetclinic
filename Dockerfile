# 1단계: 빌드 환경
FROM maven:3.9-eclipse-temurin-17 as builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# 2단계: 실행 환경
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# 와일드카드로 .jar 파일을 찾아서 app.jar로 복사
COPY --from=builder /app/target/*.jar ./app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]