# 1단계: 빌드 환경 (Maven 이미지)
FROM maven:3.9-eclipse-temurin-17 as builder
WORKDIR /app
COPY . .

# 빌드 실행 (테스트 생략)
RUN mvn clean package -DskipTests

# [핵심 변경] 빌드된 파일 중 'original'이 아닌 진짜 jar를 찾아서 'app.jar'로 이름을 미리 바꿔둡니다.
# (빌드 단계에서 확실하게 파일을 준비해두는 방식)
RUN find target -type f -name "*.jar" ! -name "*original*" -exec mv {} target/app.jar \;

# 2단계: 실행 환경 (JRE 이미지)
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# 빌드 단계에서 이미 이름을 바꿔둔 app.jar 파일만 정확하게 가져옵니다.
COPY --from=builder /app/target/app.jar app.jar

# 실행
ENTRYPOINT ["java", "-jar", "app.jar"]
