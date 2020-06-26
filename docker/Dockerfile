FROM golang:1.13.12-alpine3.12

RUN apk add --no-cache make

WORKDIR /usr/src/myapp

COPY src/ .

RUN make build

CMD ["./demo.bin"]