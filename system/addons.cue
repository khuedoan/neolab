bundle: {
	apiVersion: "v1alpha1"
	name:       "addons"
	instances: {
		"flux": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-aio"
			namespace: "flux-system"
			values: {
				controllers: {
					notification: enabled: false
				}
			}
		}
		"cert-manager": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "cert-manager"
			values: {
				repository: url: "https://charts.jetstack.io"
				chart: {
					name:    "cert-manager"
					version: "1.x"
				}
				helmValues: {
					installCRDs: true
				}
			}
		}
		"istio-base": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "istio-system"
			values: {
				repository: url: "https://istio-release.storage.googleapis.com/charts"
				chart: {
					name:    "base"
					version: "1.25.1"
				}
			}
		}
		"istiod": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "istio-system"
			values: {
				repository: url: "https://istio-release.storage.googleapis.com/charts"
				chart: {
					name:    "istiod"
					version: "1.25.1"
				}
				helmValues: {
					profile: "ambient"
				}
			}
		}
		"istio-cni": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "istio-system"
			values: {
				repository: url: "https://istio-release.storage.googleapis.com/charts"
				chart: {
					name:    "cni"
					version: "1.25.1"
				}
				helmValues: {
					profile: "ambient"
					global: platform: "k3d"
				}
			}
		}
		"ztunnel": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "istio-system"
			values: {
				repository: url: "https://istio-release.storage.googleapis.com/charts"
				chart: {
					name:    "ztunnel"
					version: "1.25.1"
				}
			}
		}
		"istio-ingress": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "istio-system"
			values: {
				repository: url: "https://istio-release.storage.googleapis.com/charts"
				chart: {
					name:    "gateway"
					version: "1.25.1"
				}
			}
		}
	}
}
