package main

import (
	"os"

	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
)

func main() {
	config, err := clientcmd.BuildConfigFromFlags("", os.Getenv("KUBECONFIG"))
	if err != nil {
		panic(err.Error())
	}

	kubeClient, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err.Error())
	}

	gitlabClient, err := newGitLabClient()
	if err != nil {
		panic(err.Error())
	}

	updateGitLabSettings(gitlabClient)
	setupGitLabRunner(gitlabClient, kubeClient)
}
