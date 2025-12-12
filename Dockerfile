# 1단계: 빌드 환경
FROM maven:3.9-eclipse-temurin-17 as builder
WORKDIR /app
COPY . .

# [핵심] -DfinalName=app 옵션을 줘서, 결과물이 무조건 'target/app.jar'로 나오게 만듭니다.
RUN mvn clean package -DskipTests -DfinalName=app

# 2단계: 실행 환경
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# 이름이 'app.jar'로 고정되었으니, 고민 없이 그대로 가져옵니다.
COPY --from=builder /app/target/app.jar .

# 실행
ENTRYPOINT ["java", "-jar", "app.jar"]
