IMG ?= viewfintest/snapshot-init-container

all: ci

build:
	docker  build -t $(IMG) .

push:
	docker push $(IMG)

ci: build push
