APP_NAME := go-cli-boilerplate
BINARY_NAME := go-cli-boilerplate
CONTAINER_NAME := go-cli-boilerplate
IMAGE_NAME := local/go-cli-boilerplate:latest

build-all: clean depend fmt cover build

build-all-docker: fmt cover build

depend:
	glide install

fmt:
	gofmt -w -s $$(find . -type f -name '*.go' -not -path "./vendor/*")

cover:
	./bin/cover.sh

cover-report: cover
	go tool cover -func=coverage.out
	go tool cover -html=coverage.out

build:
	go build ./cmd/$(APP_NAME)

build-race:
	go build -race ./cmd/$(APP_NAME)

test:
	go test $$(glide nv)

test-race:
	go test -race $$(glide nv)

clean:
	rm -f coverage.out
	rm -f ./$(BINARY_NAME)

run: build
	./$(BINARY_NAME)

docker:
	docker build -t $(IMAGE_NAME) .

run-docker: docker
	docker run -d --name $(CONTAINER_NAME) $(IMAGE_NAME)

stop-docker:
	docker stop $(CONTAINER_NAME)

.PHONY: depend build build-race build-all build-all-docker fmt cover cover-report test test-race clean run run-docker stop-docker