# 1단계: 빌드
FROM maven:3.9-eclipse-temurin-17 as builder
WORKDIR /app
COPY . .
# 빌드 실행
RUN mvn clean package -DskipTests

# 2단계: 실행
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# 빌드된 결과물 중 'original-'로 시작하지 않는 진짜 jar 파일만 복사
# (find 명령어로 찾아서 app.jar로 이름을 바꿔서 가져옵니다)
COPY --from=builder /app/target/*.jar ./
RUN mv $(ls *.jar | grep -v original | head -n 1) app.jar

# 실행
ENTRYPOINT ["java", "-jar", "app.jar"]
