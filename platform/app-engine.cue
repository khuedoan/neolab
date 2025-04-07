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
						worker: {
							strategy: "RollingUpdate"
							containers: {
								app: {
									image: {
										repository: "khuedoan/app-engine"
										tag:        "09a2131"
										pullPolicy: "Always"
									}
									env: {
										TEMPORAL_URL: "http://temporal-frontend.temporal:7233"
									}
								}
								docker: {
									image: {
										repository: "docker.io/library/docker"
										tag:        "27-dind"
									}
									securityContext: {
										privileged: true
									}
								}
							}
						}

					}
					persistence: {
						socket: {
							type: "emptyDir"
							globalMounts: [{
								path:    "/var/run"
								subPath: "docker.sock"
							}]
						}
					}
				}
			}
		}
	}
}
