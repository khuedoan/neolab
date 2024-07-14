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
		"linkerd-crds": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "linkerd"
			values: {
				repository: url: "https://helm.linkerd.io/stable"
				chart: {
					name:    "linkerd-crds"
					version: "1.8.0"
				}
			}
		}
		"linkerd-control-plane": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "linkerd"
			values: {
				repository: url: "https://helm.linkerd.io/stable"
				chart: {
					name:    "linkerd-control-plane"
					version: "1.16.11"
				}
				helmValues: {
					identityTrustAnchorsPEM: string @timoni(runtime:string:linkerd_ca_crt)
					identity: issuer: tls: {
						crtPEM: string @timoni(runtime:string:linkerd_issuer_crt)
						keyPEM: string @timoni(runtime:string:linkerd_issuer_key)
					}
				}
			}
		}
		"linkerd-viz": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "linkerd"
			values: {
				repository: url: "https://helm.linkerd.io/stable"
				chart: {
					name:    "linkerd-viz"
					version: "30.12.11"
				}
			}
		}
		"ingress-nginx": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "ingress-nginx"
			values: {
				repository: url: "https://kubernetes.github.io/ingress-nginx"
				chart: {
					name:    "ingress-nginx"
					version: "4.11.0"
				}
				helmValues: {
					controller: {
						ingressClassResource: default: true
						podAnnotations: {
							"linkerd.io/inject": "enabled"
						}
					}
				}
			}
		}
	}
}
