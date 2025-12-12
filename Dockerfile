# 1단계: 빌드 환경
FROM maven:3.9-eclipse-temurin-17 as builder
WORKDIR /app
COPY . .

# 빌드 실행
RUN mvn clean package -DskipTests

# [수정된 부분] target 폴더 안에서 파일을 찾도록 경로를 명확히 지정!
# target 폴더 안에 있는 jar 파일 중 'original'이 아닌 것을 찾아서 app.jar로 변경
RUN mv $(ls target/*.jar | grep -v original | head -n 1) target/app.jar

# 2단계: 실행 환경
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# 빌드 단계에서 만들어둔 파일을 가져옴
COPY --from=builder /app/target/app.jar app.jar

# 실행
ENTRYPOINT ["java", "-jar", "app.jar"]
