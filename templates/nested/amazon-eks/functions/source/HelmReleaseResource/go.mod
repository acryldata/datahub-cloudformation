module github.com/aws-quickstart/quickstart-helm-resource-provider

go 1.16

require (
	github.com/ahmetb/go-linq/v3 v3.2.0
	github.com/aws-cloudformation/cloudformation-cli-go-plugin v1.0.3
	github.com/aws/aws-lambda-go v1.26.0
	github.com/aws/aws-sdk-go v1.40.43
	github.com/containerd/containerd v1.5.7
	github.com/gofrs/flock v0.8.0
	github.com/pkg/errors v0.9.1
	github.com/stretchr/testify v1.7.0
	helm.sh/helm/v3 v3.7.0
	k8s.io/api v0.22.1
	k8s.io/apiextensions-apiserver v0.22.1
	k8s.io/apimachinery v0.22.1
	k8s.io/cli-runtime v0.22.1
	k8s.io/client-go v0.22.1
	k8s.io/kubectl v0.22.1
	oras.land/oras-go v0.4.0
	sigs.k8s.io/aws-iam-authenticator v0.5.3
	sigs.k8s.io/yaml v1.2.0
)
