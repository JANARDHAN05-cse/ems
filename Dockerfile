FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app

# copy everything
COPY . .

# ensure mvnw is executable, then build the jar
RUN chmod +x mvnw \
 && ./mvnw -DskipTests clean package

# copy the first non-original jar produced into a predictable name
RUN JAR_FILE=$(sh -c "ls -1 target/*.jar 2>/dev/null | grep -v 'original' | head -n 1") \
 && if [ -z "$JAR_FILE" ]; then echo "No jar produced!" >&2; exit 1; fi \
 && cp "$JAR_FILE" /app/app.jar

EXPOSE 8080

CMD ["java","-jar","/app/app.jar"]