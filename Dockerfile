# 1단계: 빌드 환경
FROM maven:3.9-eclipse-temurin-17 as builder
WORKDIR /app
COPY . .

# 빌드 실행
RUN mvn clean package -DskipTests

# [디버깅] 도대체 파일이 생기긴 한 건지, 이름이 뭔지 로그에 출력합니다.
# (나중에 GitHub Actions 로그에서 이 부분을 확인할 수 있습니다)
RUN echo "=== BUILD OUTPUT CHECK ===" && ls -al target/

# 2단계: 실행 환경
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# 이름 바꾸지 말고, jar 파일이면 일단 다 가져옵니다.
COPY --from=builder /app/target/*.jar ./

# [핵심] 실행할 때 쉘 스크립트로 'original'이 아닌 jar를 찾아서 실행합니다.
# 파일 이름이 꼬여도 알아서 실행 파일을 찾아냅니다.
ENTRYPOINT ["/bin/sh", "-c", "java -jar $(ls *.jar | grep -v original | head -n 1)"]
