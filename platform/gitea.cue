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
							host: "gitea.127-0-0-1.nip.io"
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
						}
						config: {
							server: {
								LANDING_PAGE: "explore"
								ROOT_URL:     "http://gitea.127-0-0-1.nip.io"
								OFFLINE_MODE: true
							}
							repository: {
								DISABLED_REPO_UNITS: "repo.wiki,repo.projects,repo.packages"
								DISABLE_STARS:       true
								DEFAULT_BRANCH:      "master"
							}
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
					}
				}
			}
		}
	}
}
