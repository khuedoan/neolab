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
					service: {
						type:     "NodePort"
						port:     5000
						nodePort: 30000 // The range of valid ports is 30000-32767
					}
					ingress: {
						enabled:   true
						className: "istio"
						pathtype:  "Prefix"
						hosts: [{
							host: "registry.127-0-0-1.nip.io"
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
