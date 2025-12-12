# 1단계: 빌드 환경
FROM maven:3.9-eclipse-temurin-17 as builder
WORKDIR /app

# pom.xml과 소스 복사
COPY pom.xml .
COPY src ./src
COPY src/main/wro ./src/main/wro

# WAR 파일 빌드
RUN mvn clean package -DskipTests -B

# 빌드 결과 확인
RUN ls -la /app/target/

# 2단계: 실행 환경 (Tomcat 또는 내장 서버 필요)
FROM tomcat:9-jre17

# 기존 ROOT 애플리케이션 제거
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# WAR 파일을 ROOT.war로 복사 (루트 경로로 배포)
COPY --from=builder /app/target/petclinic.war /usr/local/tomcat/webapps/ROOT.war

# 또는 petclinic 경로로 배포하려면:
# COPY --from=builder /app/target/petclinic.war /usr/local/tomcat/webapps/petclinic.war

EXPOSE 8080

CMD ["catalina.sh", "run"]