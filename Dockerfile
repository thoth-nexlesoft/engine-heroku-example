# Use multi-stage build process to build this container:
# layer 0: Engine Proxy base image.
# Grab the latest version from here: https://www.apollographql.com/docs/engine/proxy-release-notes.html
FROM gcr.io/mdg-public/engine:2017.12-45-g12ba029f9 as engine

# layer 1: Alpine Linux base image (to get support for shell scripting)
FROM alpine:3.6

# install a full version of bash shell
RUN apk add --no-cache bash

WORKDIR /

# copy engine proxy binary from layer 0 to layer 1
COPY --from=engine /engineproxy_linux_amd64 .

# include your app-specific engine config file template
COPY config-template.json .

# include the startup script
COPY startup.sh .

# at runtime, perform the translation based on current environment and start Engine
CMD ["./startup.sh"]
