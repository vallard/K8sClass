.PHONY: all build-dev build push

VERSION := latest

all: build push 

build: 
	docker build . -t k8s-sample/fe:${VERSION}
	docker tag k8s-sample/fe:${VERSION} 188966951897.dkr.ecr.us-west-2.amazonaws.com/k8s-sample/fe

push: 
	$$(echo aws ecr get-login-password --region us-west-2) | docker login --username AWS --password-stdin 188966951897.dkr.ecr.us-west-2.amazonaws.com
	docker push 188966951897.dkr.ecr.us-west-2.amazonaws.com/k8s-sample/fe
