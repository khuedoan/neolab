package e2e

import (
	"encoding/json"
	"io"
	"net/http"
	"testing"
)

func TestGiteaHealth(t *testing.T) {
	resp, err := http.Get("http://gitea.localhost/api/healthz") // TODO get domain name automatically
	if err != nil {
		t.Fatal(err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		t.Fatalf("expected status code to be 200, but got %d", resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		t.Fatal(err)
	}

	var healthz struct {
		Status string `json:"status"`
		Checks map[string][]struct {
			Status string `json:"status"`
		} `json:"checks"`
	}

	err = json.Unmarshal(body, &healthz)
	if err != nil {
		t.Fatal(err)
	}

	if healthz.Status != "pass" {
		t.Errorf("expected status to be 'pass', but got '%s'", healthz.Status)
	}

	for _, checks := range healthz.Checks {
		for _, check := range checks {
			if check.Status != "pass" {
				t.Errorf("expected check status to be 'pass', but got '%s'", check.Status)
			}
		}
	}
}
