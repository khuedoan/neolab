.POSIX:
.PHONY: *

env ?= dev

export KUBECONFIG = $(shell pwd)/cluster/kubeconfig-${env}.yaml

default: cluster system platform apps hack

cluster:
	make -C cluster env=${env}

system:
	sops exec-env ./secrets/${env}.enc.yaml 'timoni bundle apply --runtime-from-env --file system/addons.cue'

platform:
	sops exec-env ./secrets/${env}.enc.yaml 'timoni bundle apply --runtime-from-env --file platform/gitlab.cue'
	sops exec-env ./secrets/${env}.enc.yaml 'timoni bundle apply --runtime-from-env --file platform/vpn.cue'
	sops exec-env ./secrets/${env}.enc.yaml 'timoni bundle apply --runtime-from-env --file platform/sso.cue'

apps:
	sops exec-env ./secrets/${env}.enc.yaml 'timoni bundle apply --runtime-from-env --file apps/blog.cue'
	sops exec-env ./secrets/${env}.enc.yaml 'timoni bundle apply --runtime-from-env --file apps/backstage.cue'

hack:
	sops exec-env ./secrets/${env}.enc.yaml 'cd hack && go run .'

fmt:
	cue fmt ./...
	cd hack && go fmt ./...

# TODO better way to gen cert?
# https://linkerd.io/2.15/tasks/generate-certificates
certs:
	cd secrets \
		&& step certificate create root.linkerd.cluster.local ca.crt ca.key --profile root-ca --no-password --insecure \
		&& step certificate create identity.linkerd.cluster.local issuer.crt issuer.key --profile intermediate-ca --not-after 8760h --no-password --insecure --ca ca.crt --ca-key ca.key
