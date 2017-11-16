FROM golang:alpine as builder

WORKDIR /go/src/github.com/superliuwr/go-cli-boilerplate

COPY glide.yaml glide.lock Makefile /go/src/github.com/superliuwr/go-cli-boilerplate
RUN make depend

COPY . /go/src/github.com/superliuwr/go-cli-boilerplate
RUN make build-all-docker

From alpine:latest

WORKDIR /root/
COPY --from=builder /go/src/github.com/superliuwr/go-cli-boilerplate .
RUN chmod +x /root/go-cli-boilerplate

ENTRYPOINT ["/root/go-cli-boilerplate"]