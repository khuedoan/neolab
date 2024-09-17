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

# TODO better way to gen cert?
# https://linkerd.io/2.15/tasks/generate-certificates
certs:
	cd secrets \
		&& step certificate create root.linkerd.cluster.local ca.crt ca.key --profile root-ca --no-password --insecure \
		&& step certificate create identity.linkerd.cluster.local issuer.crt issuer.key --profile intermediate-ca --not-after 8760h --no-password --insecure --ca ca.crt --ca-key ca.key

clean:
	k3d cluster delete neolab-dev
