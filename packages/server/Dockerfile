FROM dart:stable AS build

# WORKDIR /app

# COPY pubspec* ./

# RUN dart pub get

# COPY ./ ./

# RUN dart pub get --offline

# RUN dart compile exe bin/main.dart -o bin/server

FROM scratch

COPY --from=build /runtime/ /

# COPY --from=build /app/bin/server /

COPY ./bin/server /

EXPOSE 2080/tcp

CMD [ "/server" ]
