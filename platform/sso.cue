bundle: {
	apiVersion: "v1alpha1"
	name:       "sso"
	instances: {
		"dex": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "dex"
			values: {
				repository: url: "https://charts.dexidp.io"
				chart: {
					name:    "dex"
					version: "0.19.0"
				}
				helmValues: {
					podAnnotations: {
						"linkerd.io/inject": "enabled"
					}
					config: {
						issuer: "http://dex.172-20-0-2.nip.io" // TODO ??
						storage: {
							type: "kubernetes"
							config: inCluster: true
						}
						oauth2: {
							passwordConnector:  "local"
							skipApprovalScreen: true
						}
						enablePasswordDB: true
						staticPasswords: [{
							email:    "demo@example.com"
							username: "demo"
							userID:   "08a8684b-db88-4b73-90a9-3cd1661f5466"
							// TODO echo password | htpasswd -BinC 10 admin | cut -d: -f2
							hash: "$2a$10$2b2cU8CPhOTaGrs1HRQuAueS7JTT5ZHsHSzYiFPm1leZck7Mc8T4W"
						}]
						staticClients: [{
							// Type: OAuth2
							// Name: Dex
							// Provider: OpenID Connect
							// Client ID: gitea
							// Discovery URL: http://dex.dex:5556/.well-known/openid-configuration
							id:   "gitea"
							name: "Gitea"
							redirectURIs: ["http://gitea.127-0-0-1.nip.io/user/oauth2/Dex/callback"]
							secret: "dev_secret_sso_gitea" // TODO autogen?
						}]
					}
					ingress: {
						enabled: true
						hosts: [{
							host: "dex.172-20-0-2.nip.io" // TODO how to get this to work locally?
							paths: [{
								path:     "/"
								pathType: "Prefix"
							}]
						}]
					}
				}
			}
		}
	}
}
