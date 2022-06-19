.phony: build push

all: build push 
CMD := $(shell aws ecr get-login --no-include-email --region us-west-2)

build:
	docker build -t vallard/eks-dynamo .

push: 
	${CMD}
	docker tag vallard/eks-dynamo:latest 188966951897.dkr.ecr.us-west-2.amazonaws.com/vallard/eks-dynamo:latest
	docker push 188966951897.dkr.ecr.us-west-2.amazonaws.com/vallard/eks-dynamo:latest
