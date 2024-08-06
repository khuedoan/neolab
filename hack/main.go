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

	// TODO kubeClient, err := kubernetes.NewForConfig(config)
	_, err = kubernetes.NewForConfig(config)
	if err != nil {
		panic(err.Error())
	}
}
