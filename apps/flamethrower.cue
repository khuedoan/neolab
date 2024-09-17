bundle: {
	apiVersion: "v1alpha1"
	name:       "flamethrower"
	instances: {
		"flamethrower": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "flamethrower"
			values: {
				repository: url: "https://bjw-s.github.io/helm-charts"
				chart: {
					name:    "app-template"
					version: "3.1.0"
				}
				helmValues: {
					defaultPodOptions: {
						restartPolicy: "Always"
						annotations: {
							"linkerd.io/inject": "enabled"
						}
					}
					controllers: main: containers: app: {
						image: {
							repository: "docker.io/khuedoan/flamethrower"
							tag:        "latest"
						}
					}
					service: main: {
						controller: "main"
						ports: http: {
							port:     3000
							protocol: "HTTP"
						}
					}
					ingress: main: {
						hosts: [{
							host: "flamethrower.localhost"
							paths: [{
								path:     "/"
								pathType: "Prefix"
								service: {
									identifier: "main"
								}
							}]
						}]
					}
				}
			}
		}
	}
}
