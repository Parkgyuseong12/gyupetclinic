# 1단계: 빌드 환경
FROM eclipse-temurin:17-jdk-jammy as builder

WORKDIR /app

# 소스 코드 복사
COPY . .

# Maven 또는 Gradle 빌드 실행 및 파일명 통일
# (빌드가 끝나면 생성된 jar 파일을 'app.jar'라는 이름으로 바꿔둡니다)
RUN if [ -f "./gradlew" ]; then         chmod +x ./gradlew && ./gradlew build -x test;         mv build/libs/*.jar app.jar;     else         chmod +x ./mvnw && ./mvnw clean package -DskipTests;         mv target/*.jar app.jar;     fi

# 2단계: 실행 환경
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# 빌드 단계에서 미리 이름을 바꿔둔 app.jar만 깔끔하게 가져옵니다.
COPY --from=builder /app/app.jar app.jar

# 실행 명령어
ENTRYPOINT ["java", "-jar", "app.jar"]
