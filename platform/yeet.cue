bundle: {
	apiVersion: "v1alpha1"
	name:       "yeet"
	instances: {
		"yeet": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "yeet"
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
						worker: containers: app: {
							image: {
								repository: "docker.io/khuedoan/yeet"
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
