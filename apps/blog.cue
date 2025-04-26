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
					defaultPodOptions: labels: {
						"istio.io/dataplane-mode":   "ambient"
						"app.kubernetes.io/version": "6.8.0"
					}
					controllers: main: {
						strategy: "RollingUpdate"
						containers: app: {
							image: {
								// TODO
								repository: "stefanprodan/podinfo"
								tag:        "6.8.0"
							}
							env: {
								TESTFOO: string @timoni(runtime:string:testfoo)
							}
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
						className: "istio"
						hosts: [{
							// TODO domain from runtime
							host: "blog.127-0-0-1.nip.io"
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
