# syntax=docker/dockerfile:1

FROM golang:1.19 AS builder

WORKDIR /go/src/github.com/dsquaredsolutions/sample-ci-cd

COPY . /go/src/github.com/dsquaredsolutions/sample-ci-cd
RUN go mod download

ARG VERSION
ARG REPO_REV
ARG DATE
RUN cd /go/src/github.com/dsquaredsolutions/sample-ci-cd && go build -a -ldflags "\
    -X \"github.com/dsquaredsolutions/sample-ci-cd/buildinfo.gitVersion=${VERSION}\"\
    -X \"github.com/dsquaredsolutions/sample-ci-cd/buildinfo.gitRevision=${REPO_REV}\"\
    -X \"github.com/dsquaredsolutions/sample-ci-cd/buildinfo.date=${DATE}\"\
    " -v -o sample-ci-cd

FROM alpine:3.15.4
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.15/main" > /etc/apk/repositories && \
    echo -e "http://dl-cdn.alpinelinux.org/alpine/v3.15/community" >> /etc/apk/repositories && \
    rm -rf /var/cache/apk/*
RUN apk update && apk add ca-certificates libc6-compat
COPY --from=builder /go/src/github.com/dsquaredsolutions/sample-ci-cd/sample-ci-cd /
CMD [ "/sample-ci-cd" ]