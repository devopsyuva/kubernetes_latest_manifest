FROM alpine
ARG VERSION="0.1.1"
LABEL org.opencontainers.image.authors="dubareddy.383@gmail.com"
RUN apk add --no-cache unzip
RUN curl -LO https://github.com/stackrox/kube-linter/releases/download/${VERSION}/kube-linter-darwin.zip \
    && unzip kube-linter-darwin.zip
RUN mv kube-linter /usr/local/bin
CMD ["kube-linter", "--help"]