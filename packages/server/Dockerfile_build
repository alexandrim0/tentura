FROM dart:stable AS build

WORKDIR /app

COPY *.yaml ./

RUN echo "resolution:" >> pubspec_overrides.yaml && dart pub get

COPY ./bin ./bin

COPY ./lib ./lib

RUN dart run build_runner build -d

RUN dart compile exe bin/main.dart -o bin/tentura

FROM scratch

COPY --from=build /runtime/ /

COPY --from=build /app/bin/tentura /

EXPOSE 2080/tcp

USER 33:33

CMD [ "/tentura" ]
