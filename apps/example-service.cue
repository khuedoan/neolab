bundle: {
	apiVersion: "v1alpha1"
	name:       "examples"
	instances: {
		"example-service": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "example-service"
			values: {
				repository: url: "https://bjw-s.github.io/helm-charts"
				chart: {
					name:    "app-template"
					version: "3.1.0"
				}
				helmValues: {
					controllers: main: containers: app: {
						image: {
							// TODO
							repository: "stefanprodan/podinfo"
							tag:        "latest"
						}
					}
					service: main: {
						controller: "main"
						ports: http: {
							port:     8080
							protocol: "HTTP"
						}
					}
					ingress: main: {
						hosts: [{
							// TODO domain from runtime
							host: "example-service.127-0-0-1.nip.io"
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
