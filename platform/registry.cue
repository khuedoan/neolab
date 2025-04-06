bundle: {
	apiVersion: "v1alpha1"
	name:       "registry"
	instances: {
		"registry": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "registry"
			values: {
				repository: url: "http://zotregistry.dev/helm-charts"
				chart: {
					name:    "zot"
					version: "0.1.67"
				}
				helmValues: {
					podLabels: {
						"istio.io/dataplane-mode": "ambient"
					}
					image: repository: "ghcr.io/project-zot/zot"
					ingress: {
						enabled:   true
						className: "istio"
						pathtype:  "Prefix"
						hosts: [{
							host: "registry.localhost"
							paths: [{
								path: "/"
							}]
						}]
					}
					persistence: true
					pvc: {
						create:  true
						storage: "10Gi"
					}
				}
			}
		}
	}
}
