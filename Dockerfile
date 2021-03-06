FROM golang:1.15.1 AS build
RUN apt-get update && apt-get install -y libdlib-dev libblas-dev liblapack-dev libjpeg62-turbo-dev
WORKDIR /src
COPY . .
RUN useradd -u 10001 aton
RUN make build

FROM debian:buster-slim
RUN apt-get update && apt-get install -y libdlib-dev libblas-dev liblapack-dev libjpeg62-turbo-dev && apt-get clean
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /src/dist/aton /app/
COPY --from=build /src/models /app/models
COPY --from=build /src/images /app/images
EXPOSE 8080
USER aton
WORKDIR /app
CMD ["./aton"]