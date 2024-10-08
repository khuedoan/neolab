bundle: {
	apiVersion: "v1alpha1"
	name:       "blog"
	instances: {
		// TODO too easy to mess up
		"blog": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			// TODO too easy to mess up
			namespace: "blog"
			values: {
				repository: url: "https://bjw-s.github.io/helm-charts"
				chart: {
					name:    "app-template"
					version: "3.1.0"
				}
				helmValues: {
					defaultPodOptions: annotations: {
						"linkerd.io/inject": "enabled"
					}
					controllers: main: containers: app: {
						image: {
							// TODO
							repository: "stefanprodan/podinfo"
							tag:        "latest"
						}
						env: {
							TESTFOO: string @timoni(runtime:string:testfoo)
						}
					}
					service: main: {
						controller: "main"
						ports: http: {
							// TODO
							port:     9898
							protocol: "HTTP"
						}
					}
					ingress: main: {
						hosts: [{
							// TODO domain from runtime
							host: "blog.localhost"
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
