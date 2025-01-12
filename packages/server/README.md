## Build server

  `dart run build_runner build -d`
  `dart compile exe bin/main.dart -o bin/server`

## Build docker image

  Replace version tag with actual
  `docker build --no-cache -t vbulavintsev/tentura-service:v0.0.1 .`
