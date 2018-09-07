GO_PACKAGES := $(shell go list ./... | sed 's_github.com/sclasen/go-metrics-cloudwatch_._')
GO111MODULE := on


all: ready test

travis: tidy test

install:
	 go install ./...

forego:
	go get github.com/ddollar/forego

test: install
	go test ./...

test-aws: install forego
	forego run go test

tidy:
	go get golang.org/x/tools/cmd/goimports
	test -z "$$(goimports -l -d $(GO_PACKAGES) | tee /dev/stderr)"

lint:
	test -z "$$(golint ./... | tee /dev/stderr)"
	go vet ./...


imports:
	go get github.com/golang/lint/golint
	goimports -w .

fmt:
	go fmt ./...

ready: fmt imports tidy
