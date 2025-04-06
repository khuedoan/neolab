.POSIX:
.PHONY: *

env ?= dev

export KUBECONFIG = $(shell pwd)/cluster/kubeconfig-${env}.yaml

default: cluster system platform apps hack

cluster:
	make -C cluster env=${env}

system platform apps:
	@for file in $(wildcard $@/*.cue); do \
		sops exec-env ./secrets/${env}.enc.yaml "timoni bundle apply --runtime-from-env --file $$file"; \
	done

hack:
	sops exec-env ./secrets/${env}.enc.yaml 'cd hack && go run .'

test:
	cd test/e2e && go test

fmt:
	cue fmt ./...
	cd hack && go fmt ./...
	cd test/e2e && go fmt ./...

clean:
	k3d cluster delete neolab-dev
