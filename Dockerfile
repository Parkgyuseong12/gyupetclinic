FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app

COPY pom.xml .
COPY src ./src

# WAR 파일 빌드
RUN mvn clean package -DskipTests -B

# 빌드 결과 확인
RUN ls -la /app/target/

# 2단계: 실행 환경
FROM tomcat:9-jre17

# 기존 ROOT 애플리케이션 완전 제거
RUN rm -rf /usr/local/tomcat/webapps/ROOT /usr/local/tomcat/webapps/ROOT.war

# WAR 파일을 ROOT.war로 복사
COPY --from=builder /app/target/petclinic.war /usr/local/tomcat/webapps/ROOT.war

# Spring Profile 환경변수 설정
ENV SPRING_PROFILES_ACTIVE=mysql

# Tomcat이 자동으로 WAR를 압축 해제하도록 대기
# autoDeploy가 활성화되어 있으므로 자동으로 처리됨

EXPOSE 8080

CMD ["catalina.sh", "run"]