# Provision an EKS Cluster with Sourcegraph via Terraform

This repo uses the [eks module](https://github.com/terraform-aws-modules/terraform-aws-eks) to provision an EKS cluster, and will additionally deploy the AWS Load Balancer Controller, the CSI EBS add on, and Sourcegraph on that cluster.

## Setup

### Edit Variables

In `terraform.tfvars`, uncomment the variables you wish to override their default values (as found in `variables.tf`) and set new values. For the Instance Type in each node group, this should be an array of strings. All variable types can be seen in `variables.tf`.

### Update ./resources

The override.yaml file is already configured for this repository in the `resources` directory. The values provided are suitable for a Bitbucket instance of approximately 25k repositories.

There are a few updates to make for your specific instance, detailed below:

1. In `override.yaml`, update line 20 (`frontend.ingress.host`) to the URL you wish to host your Sourcegraph instance at.
2. Replace the contents of `tls.key` with the private key for your TLS certificate.
3. Replace the contents of `tls.crt` with the certificate chain for your TLS certificate.

Optional Steps

4. Update the storageSize values for `gitserver` and `indexedSearch` to align with your Bitbucket instance size (~1.3x your code base for `gitserver` and ~.6x your codebase for `indexedSearch`).
5. The `storageClass.reclaimPolicy` is set to `Delete`, you may wish to set to `Retain`.

## Deploy

Once the setup has been completed, you can run `terraform init` to ensure everything is initialized correctly, and then run `terraform plan` to see the expected output. When ready to build the cluster, run `terraform apply`. This plan assumes you have the AWS CLI configured for your AWS account you wish to deploy on.

## Managing your deployment

To update your kubeconfig to use the newly created cluster, run the following commands:

``` sh
export REGION=$(terraform output -raw region)
export CLUSTER_NAME=$(terraform output -raw cluster_name)
aws eks --region $REGION update-kubeconfig --name $CLUSTER_NAME
```
