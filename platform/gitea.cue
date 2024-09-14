bundle: {
	apiVersion: "v1alpha1"
	name:       "gitea"
	instances: {
		"gitea": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "gitea"
			values: {
				repository: url: "https://dl.gitea.io/charts"
				chart: {
					name:    "gitea"
					version: "10.4.0"
				}
				helmValues: {
					ingress: {
						enabled: true
						hosts: [{
							host: "gitea.localhost"
							paths: [{
								path:     "/"
								pathType: "Prefix"
							}]
						}]
					}
					gitea: {
						admin: {
							username: "gitea_admin"
							password: string @timoni(runtime:string:gitea_admin_password)
							email:    "admin@example.com"
						}
						config: {
							database: {
								DB_TYPE: "sqlite3"
							}
							session: {
								PROVIDER: "memory"
							}
							cache: {
								ADAPTER: "memory"
							}
							queue: {
								TYPE: "level"
							}
							server: {
								LANDING_PAGE: "explore"
								ROOT_URL:     "http://gitea.localhost"
								OFFLINE_MODE: true
							}
							repository: {
								DISABLED_REPO_UNITS: "repo.wiki,repo.projects,repo.packages"
								DISABLE_STARS:       true
								DEFAULT_BRANCH:      "master"
							}
							// TODO waiting for Gitea v1.23 https://github.com/go-gitea/gitea/pull/30622
							// oauth2_client: {
							// 	ENABLE_AUTO_REGISTRATION: true
							// 	OPENID_CONNECT_SCOPES: "email profile"
							// 	USERNAME: "username"
							// }
							"service.explore": {
								DISABLE_USERS_PAGE: true
							}
							actions: {
								ENABLED: false
							}
							webhook: {
								ALLOWED_HOST_LIST: "private"
							}
						}
						podAnnotations: {
							"linkerd.io/inject": "enabled"
						}
					}
					"redis-cluster": {
						enabled: false
					}
					redis: {
						enabled: false
					}
					postgresql: {
						enabled: false
					}
					"postgresql-ha": {
						enabled: false
					}
				}
			}
		}
	}
}
