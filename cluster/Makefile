.POSIX:

env ?= dev

apply:
	# Create the cache registry outside of the config file so that it can be shared across multiple projects
	k3d registry list docker-io || k3d registry create docker-io --port 5000 --proxy-remote-url https://registry-1.docker.io --volume docker-io-cache:/var/lib/registry
	k3d cluster start neolab-dev || k3d cluster create --config k3d.yaml
	k3d kubeconfig get neolab-dev > kubeconfig-${env}.yaml
