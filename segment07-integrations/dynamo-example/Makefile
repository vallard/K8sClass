.phony: build push

all: build push 
#CMD := $(shell aws ecr get-login --no-include-email --region us-east-1)

build:
	docker build -t vallard/eksdynamo .

push: 
	#${CMD}
	docker tag vallard/eksdynamo:latest 
	docker push 

