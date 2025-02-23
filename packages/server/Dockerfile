FROM dart:stable AS build

FROM scratch

COPY --from=build /runtime/ /

COPY bin/*.exe /

EXPOSE 2080/tcp

USER 33:33

CMD [ "/tentura.exe" ]
