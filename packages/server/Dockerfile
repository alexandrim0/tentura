FROM dart:stable AS build

WORKDIR /tmp

COPY ./ ./

RUN dart pub get && dart compile exe -o /tmp/tentura-service bin/main.dart

FROM scratch

COPY --from=build /runtime/ /

COPY --from=build /usr/lib/ /usr/lib/

COPY --from=build /tmp/tentura-service /tentura-service

EXPOSE 2080/tcp

CMD [ "/tentura-service" ]
