import "encoding/yaml"

bundle: {
	apiVersion: "v1alpha1"
	name:       "backstage"
	instances: {
		"backstage": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "backstage"
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
							repository: "docker.io/khuedoan/backstage"
							tag:        "latest@sha256:7de229a1beeaf29abcfd0c6613c95c63e4eb7762738b2af788c98b36bdb02bdd"
						}
						env: {
							TESTFOO: string @timoni(runtime:string:testfoo)
						}
					}
					configMaps: config: data: "config.yaml": yaml.Marshal({
						app: baseUrl: "https://backstage.127-0-0-1.nip.io"
						backend: {
							baseUrl: "https://backstage.127-0-0-1.nip.io"
							reading: allow: [{
								host: "gitea-http.gitea:3000"
							}]
						}
						integrations: {
							gitea: [{
								host:     "gitea.127-0-0-1.nip.io"
								baseUrl:  "http://gitea-http.gitea:3000"
								username: "gitea_admin"
								password: string @timoni(runtime:string:gitea_admin_password)
							}]
						}
						techdocs: {
							generator: runIn: "local"
						}
					})
					persistence: config: {
						type:       "configMap"
						identifier: "config"
						globalMounts: [{
							path:    "/etc/backstage/config.yaml"
							subPath: "config.yaml"
						}]
					}
					service: main: {
						controller: "main"
						ports: http: {
							port:     7007
							protocol: "HTTP"
						}
					}
					ingress: main: {
						hosts: [{
							host: "backstage.127-0-0-1.nip.io"
							paths: [{
								path:     "/"
								pathType: "Prefix"
								service: {
									identifier: "main"
								}
							}]
						}]
						tls: [{
							hosts: [
								"backstage.127-0-0-1.nip.io",
							]
						}]
					}
				}
			}
		}
	}
}
