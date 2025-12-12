# 1단계: 빌드 환경
FROM maven:3.9-eclipse-temurin-17 as builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# jar 파일명을 변수로 저장하고 app.jar로 복사
RUN cp /app/target/*.jar /app/target/app.jar

# 2단계: 실행 환경
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# 이제 확실하게 app.jar가 존재함
COPY --from=builder /app/target/app.jar ./app.jar

ENTRYPOINT ["java", "-jar", "/app/app.jar"]