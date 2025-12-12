# 1단계: 빌드 환경 (Gradle 또는 Maven 사용)
# OpenJDK 17 이미지를 기반으로 합니다.
FROM eclipse-temurin:17-jdk-jammy as builder

WORKDIR /app

# 소스 코드 복사
COPY . .

# gradlew 실행 권한 부여 및 빌드 (테스트는 건너뜀)
# (이 프로젝트가 Maven인지 Gradle인지 확인 후 적절히 실행되도록 설정)
RUN if [ -f "./gradlew" ]; then         chmod +x ./gradlew && ./gradlew build -x test;     else         chmod +x ./mvnw && ./mvnw clean package -DskipTests;     fi

# 2단계: 실행 환경 (가벼운 JRE 이미지 사용)
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# 빌드 단계에서 생성된 JAR 파일만 복사 (경로 자동 탐색)
COPY --from=builder /app/build/libs/*.jar app.jar 2>/dev/null || COPY --from=builder /app/target/*.jar app.jar

# 실행 명령어
ENTRYPOINT ["java", "-jar", "app.jar"]
