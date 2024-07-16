bundle: {
	apiVersion: "v1alpha1"
	name:       "gitlab"
	instances: {
		"gitlab": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "gitlab"
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
					controllers: main: {
						type: "statefulset"
						containers: app: {
							image: {
								repository: "gitlab/gitlab-ce"
								tag:        "17.1.2-ce.0"
							}
							env: {
								GITLAB_ROOT_PASSWORD: string @timoni(runtime:string:gitlab_root_password)
								GITLAB_OMNIBUS_CONFIG: """
									external_url 'http://gitlab.127-0-0-1.nip.io'

									gitlab_rails['monitoring_whitelist'] = ['0.0.0.0/0']
									gitlab_rails['omniauth_enabled'] = false
									prometheus_monitoring['enable'] = false
									puma['worker_processes'] = 0
									sidekiq['concurrency'] = 10
									"""
							}
							probes: {
								startup: {
									enabled: true
									custom:  true
									spec: {
										httpGet: {
											path: "/-/liveness"
											port: 80
										}
										initialDelaySeconds: 30
										failureThreshold:    20
									}
								}
								liveness: {
									enabled: true
									custom:  true
									spec: {
										httpGet: {
											path: "/-/liveness"
											port: 80
										}
									}
								}
								readiness: {
									enabled: true
									custom:  true
									spec: {
										httpGet: {
											path: "/-/readiness"
											port: 80
										}
									}
								}
							}
						}
					}
					persistence: data: {
						type:       "persistentVolumeClaim"
						accessMode: "ReadWriteOnce"
						size:       "10Gi"
						globalMounts: [
							{
								path:    "/etc/gitlab"
								subPath: "config"
							},
							{
								path:    "/var/log/gitlab"
								subPath: "logs"
							},
							{
								path:    "/var/opt/gitlab"
								subPath: "data"
							},
						]
					}
					service: main: {
						controller: "main"
						ports: http: {
							port:     80
							protocol: "HTTP"
						}
					}
					ingress: main: {
						annotations: {
							"nginx.ingress.kubernetes.io/proxy-body-size": "5m"
						}
						hosts: [{
							// TODO domain from runtime
							host: "gitlab.127-0-0-1.nip.io"
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
		"gitlab-runner": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "gitlab"
			values: {
				repository: url: "https://charts.gitlab.io"
				chart: {
					name:    "gitlab-runner"
					version: "0.66.0"
				}
				helmValues: {
					gitlabUrl: "http://gitlab"
					rbac: create: true
					podAnnotations: {
						"linkerd.io/inject": "enabled"
					}
					runners: {
						secret: "gitlab-runner-secret"
						config: """
							[[runners]]
							    clone_url = "http://gitlab"
							    [runners.kubernetes]
							        namespace = "{{.Release.Namespace}}"
							        image = "alpine"
							"""
					}
				}
			}
		}
	}
}
