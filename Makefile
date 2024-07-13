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

hack:
	sops exec-env ./secrets/${env}.enc.yaml 'cd hack && go run .'

fmt:
	cue fmt ./...
	cd hack && go fmt ./...
