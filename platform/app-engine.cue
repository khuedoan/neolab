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
						annotations: {
							"linkerd.io/inject": "enabled"
						}
					}
					controllers: {
						worker: containers: app: {
							image: {
								repository: "docker.io/khuedoan/app-engine"
								tag:        "a941275"
								pullPolicy: "Always"
							}
							env: {
								TEMPORAL_HOST: "temporal-frontend.temporal:7233"
							}
						}
					}
				}
			}
		}
	}
}
