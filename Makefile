.POSIX:
.PHONY: *

env ?= dev

export KUBECONFIG = $(shell pwd)/cluster/kubeconfig-${env}.yaml

default: cluster system platform apps hack

cluster:
	make -C cluster env=${env}

system:
	sops exec-env ./secrets/${env}.enc.yaml "timoni bundle apply --runtime-from-env --file system/addons.cue";
	kubectl apply -f hack/todo.yaml
	sops exec-env ./secrets/${env}.enc.yaml "timoni bundle apply --runtime-from-env --file system/registry.cue";

platform:
	sops exec-env ./secrets/${env}.enc.yaml "timoni bundle apply --runtime-from-env --file platform/temporal.cue";
	sops exec-env ./secrets/${env}.enc.yaml "timoni bundle apply --runtime-from-env --file platform/app-engine.cue";
	sops exec-env ./secrets/${env}.enc.yaml "timoni bundle apply --runtime-from-env --file platform/gitea.cue";
	sops exec-env ./secrets/${env}.enc.yaml "timoni bundle apply --runtime-from-env --file platform/sso.cue";
	sops exec-env ./secrets/${env}.enc.yaml "timoni bundle apply --runtime-from-env --file platform/vpn.cue";

apps:
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
