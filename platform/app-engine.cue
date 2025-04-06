bundle: {
	apiVersion: "v1alpha1"
	name:       "app-engine"
	instances: {
		"app-engine": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "app-engine"
			values: {
				repository: url: "https://bjw-s.github.io/helm-charts"
				chart: {
					name:    "app-template"
					version: "3.7.1"
				}
				helmValues: {
					defaultPodOptions: {
						restartPolicy: "Always"
						labels: {
							"istio.io/dataplane-mode": "ambient"
						}
					}
					controllers: {
						worker: containers: {
							app: {
								image: {
									repository: "khuedoan/app-engine"
									tag:        "5603f92"
									pullPolicy: "Always"
								}
								env: {
									TEMPORAL_URL: "http://temporal-frontend.temporal:7233"
									DOCKER_HOST: "tcp://127.0.0.1:2375"
								}
							}
							docker: {
								image: {
									repository: "docker.io/library/docker"
									tag:        "27-dind"
								}
								command: ["dockerd", "--host=tcp://127.0.0.1:2375"]
								securityContext: {
									privileged: true
								}
							}
						}

					}
				}
			}
		}
	}
}
