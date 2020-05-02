export GO111MODULE=on
GOOS=linux 
GOARCH=amd64

all: isucari

isucari: *.go
	go build -o isucari
