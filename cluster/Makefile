.POSIX:

env ?= dev

apply:
	k3d cluster start neolab-dev || k3d cluster create --config k3d.yaml
	k3d kubeconfig get neolab-dev > kubeconfig-${env}.yaml
