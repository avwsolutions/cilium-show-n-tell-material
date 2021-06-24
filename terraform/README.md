# Create playground cluster

This project uses `Google Kubernetes Engine` (**GKE**) to provide playground resources. The `Terraform` code is created to deploy here.

## Prerequisites

- Terraform 0.13 or higher
- Google Provider 3.5.0 or higher
- Google Cloud Platform (**GCP**) account with enough permissions to spin-up a `GKE cluster`

## Create playground cluster steps

### Prepare Gcloud CLI

Ensure that you are logged in from the `gcloud CLI` and set your *default project*.
```
gcloud auth login
gcloud auth application-default login
gcloud auth application-default login my-awesome-project
```

### Apply Terraform

First run `terraform plan` to ensure everything is set to `apply`. Advice is to create a `terrraform.tfvars` file to include your specific variables, like the actual `project` and `cluster_name`.

```
terraform plan --var-file=terraform.tfvars
terraform apply --var-file=terraform.tfvars
```

### Import GKE cluster into your local kubectl

Run the following command to import the newly created clusters. Please use your own specified `project` and `cluster_name`.

```
gcloud --project=myawesomeproject container clusters get-credentials playground --zone=us-central1
```

### Validate kubectl and cluster state

Just some simple check to validate everything is running as expected !

```
kubectl get nodes
kubectl get pods --field-selector status.phase!=Running -A
```

## Write down the cluster CIDR

For deploying `cilium` we need to write down or store the `cluster CIDR`. Use the command below for extracting this value.

```
gcloud container clusters describe "playground" --zone "us-central1" --format 'value(clusterIpv4Cidr)'
```

You are now ready to deploy some awesome applications to demostrate !
