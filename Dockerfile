# 1단계: 빌드 환경 (Maven이 미리 설치된 이미지 사용)
FROM maven:3.9-eclipse-temurin-17 as builder

WORKDIR /app

# 소스 코드 전체 복사
COPY . .

# 복잡한 스크립트 대신 Maven 명령어로 바로 빌드 (테스트 생략)
RUN mvn clean package -DskipTests

# 2단계: 실행 환경 (가벼운 JRE 이미지)
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# 빌드된 결과물(jar)만 가져오기
COPY --from=builder /app/target/*.jar app.jar

# 실행
ENTRYPOINT ["java", "-jar", "app.jar"]
