FROM dart:stable AS build

WORKDIR /app

COPY *.yaml ./

RUN echo "resolution:" >> pubspec_overrides.yaml && dart pub get

COPY ./bin ./bin

COPY ./lib ./lib

RUN dart run build_runner build -d

RUN dart compile exe bin/main.dart -o bin/server

FROM scratch

COPY --from=build /runtime/ /

COPY --from=build /app/bin/server /

EXPOSE 2080/tcp

CMD [ "/server" ]
