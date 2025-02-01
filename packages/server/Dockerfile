FROM dart:stable AS build

FROM scratch

COPY --from=build /runtime/ /

COPY bin/main.exe /tentura

EXPOSE 2080/tcp

USER 33:33

CMD [ "/tentura" ]
