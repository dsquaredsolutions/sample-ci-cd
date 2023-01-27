# syntax=docker/dockerfile:1

FROM golang:1.19-alpine AS builder

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

ARG VERSION
ARG REPO_REV
ARG DATE
RUN go build -a -ldflags "\
    -X \"github.com/dsquaredsolutions/sample-ci-cd/buildinfo.gitVersion=${VERSION}\"\
    -X \"github.com/dsquaredsolutions/sample-ci-cd/buildinfo.gitRevision=${REPO_REV}\"\
    -X \"github.com/dsquaredsolutions/sample-ci-cd/buildinfo.date=${DATE}\"\
    " -v -o /sample-ci-cd

FROM alpine:3.15.4
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.15/main" > /etc/apk/repositories && \
    echo -e "http://dl-cdn.alpinelinux.org/alpine/v3.15/community" >> /etc/apk/repositories && \
    rm -rf /var/cache/apk/*
RUN apk update && apk add ca-certificates libc6-compat
COPY --from=builder /sample-ci-cd /
CMD [ "/sample-ci-cd" ]