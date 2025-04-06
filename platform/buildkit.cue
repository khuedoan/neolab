bundle: {
	apiVersion: "v1alpha1"
	name:       "buildkit"
	instances: {
		"buildkit": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "buildkit"
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
						main: containers: app: {
							image: {
								repository: "docker.io/moby/buildkit"
								tag:        "rootless"
							}
							args: [
								"--addr=tcp://0.0.0.0:1234",
								"--oci-worker-no-process-sandbox",
							]
							securityContext: appArmorProfile: type: "Unconfined"
						}
					}
					service: main: {
						controller: "main"
						ports: http: {
							port:     1234
							protocol: "TCP"
						}
					}
				}
			}
		}
	}
}
