bundle: {
	apiVersion: "v1alpha1"
	name:       "temporal"
	instances: {
		"temporal": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "temporal"
			values: {
				repository: url: "https://go.temporal.io/helm-charts"
				chart: {
					name:    "temporal"
					version: "0.58.0"
				}
				helmValues: {
					additionalLabels: {
						"istio.io/dataplane-mode": "ambient"
					}
					server: {
						replicaCount: 1
						config: namespaces: {
							create: true
							namespace: [{
								name:      "default"
								retention: "3d"
							}]
						}
					}
					cassandra: config: cluster_size: 1
					elasticsearch: replicas: 1
					prometheus: enabled:     false
					grafana: enabled:        false
					web: ingress: {
						enabled:   true
						className: "istio"
						hosts: [
							"temporal.127-0-0-1.nip.io",
						]
					}
				}
			}
		}
	}
}
