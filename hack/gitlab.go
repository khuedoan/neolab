package main

import (
	"context"
	"errors"
	"fmt"
	"os"

	"github.com/xanzy/go-gitlab"
	"k8s.io/api/core/v1"
	k8serrors "k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

func newGitLabClient() (*gitlab.Client, error) {
	root_password := os.Getenv("gitlab_root_password")
	if root_password == "" {
		return nil, errors.New("No GitLab root password provided")
	}

	gitlabClient, err := gitlab.NewBasicAuthClient(
		"root",
		root_password,
		gitlab.WithBaseURL("http://gitlab.127-0-0-1.nip.io"),
	)
	if err != nil {
		return nil, err
	}

	return gitlabClient, nil
}

func updateGitLabSettings(gitlabClient *gitlab.Client) {
	_, _, err := gitlabClient.Settings.UpdateSettings(&gitlab.UpdateSettingsOptions{
		AutoDevOpsEnabled: gitlab.Ptr(false),
		DefaultBranchName: gitlab.Ptr("master"),
		GravatarEnabled:   gitlab.Ptr(false),
		SignupEnabled:     gitlab.Ptr(false),
	})

	if err != nil {
		panic(err.Error())
	}
}

func setupGitLabRunner(gitlabClient *gitlab.Client, kubeClient *kubernetes.Clientset) {
	runnerSecretName := "gitlab-runner-secret"
	runnerSecretNamespace := "gitlab"

	_, err := kubeClient.CoreV1().Secrets(runnerSecretNamespace).Get(context.TODO(), runnerSecretName, metav1.GetOptions{})
	if k8serrors.IsNotFound(err) {
		fmt.Printf("Secret %s in namespace %s not found, registering new GitLab runner", runnerSecretName, runnerSecretNamespace)
	} else {
		fmt.Printf("Secret %s in namespace %s already exists, nothing to do", runnerSecretName, runnerSecretNamespace)
		return
	}

	runner, _, err := gitlabClient.Users.CreateUserRunner(&gitlab.CreateUserRunnerOptions{
		RunnerType:  gitlab.Ptr("instance_type"),
		RunUntagged: gitlab.Ptr(true),
	})

	if err != nil {
		panic(err.Error())
	}

	runnerSecret := &v1.Secret{
		ObjectMeta: metav1.ObjectMeta{
			Name: "gitlab-runner-secret",
		},
		Type: v1.SecretTypeOpaque,
		StringData: map[string]string{
			"runner-registration-token": "", // need to leave as an empty string for compatibility reasons
			"runner-token":              runner.Token,
		},
	}

	_, err = kubeClient.CoreV1().Secrets("gitlab").Create(context.TODO(), runnerSecret, metav1.CreateOptions{})
	if err != nil {
		panic(err.Error())
	}
}
