FROM golang:1.19-alpine AS builder

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /sample-ci-cd

FROM alpine:3.15.4

COPY --from=builder /sample-ci-cd /
CMD [ "/sample-ci-cd" ]