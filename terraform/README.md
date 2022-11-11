# Provision an EKS Cluster with Sourcegraph via Terraform

This repo uses the [eks module](https://github.com/terraform-aws-modules/terraform-aws-eks) to provision an EKS cluster, and will additionally deploy the AWS Load Balancer Controller, the CSI EBS add on, and Sourcegraph on that cluster.

This specific reference implementation uses a local Sourcegraph chart to avoid potential limits in regards to ephemeral storage for clusters. To use the remote Helm repository and ephemeral storage for specific deployments, set `use_remote_charts` to true in `terraform.tfvars`.

## Setup

### Edit Variables

In `terraform.tfvars`, uncomment the variables you wish to override their default values (as found in `variables.tf`) and set new values. For the Instance Type in each node group, this should be an array of strings. All variable types can be seen in `variables.tf`.

If you plan to set a desired size for your node group instead of using the Cluster Autoscaler, uncomment line 32 in `main.tf` and comment lines 23-67 in `helm.tf`, as well as lines 34-138 in `iam.tf` to disable the Cluster Autoscaler

### Create override.yaml

Using the [Resource Estimator](https://docs.sourcegraph.com/admin/deploy/resource_estimator) and the information outlined in the (helm documentation)[https://docs.sourcegraph.com/admin/deploy/kubernetes/helm#configure-sourcegraph-on-elastic-kubernetes-service-eks] to generate an `override.yaml` file and move it into the `resources` directory

## Deploy

Once the setup has been completed, you can run `terraform init` to ensure everything is initialized correctly, and then run `terraform plan` to see the expected output. When ready to build the cluster, run `terraform apply`. This plan assumes you have the AWS CLI configured for your AWS account you wish to deploy on.

## Managing your deployment

To update your kubeconfig to use the newly created cluster, run the following commands:

``` sh
export REGION=$(terraform output -raw region)
export CLUSTER_NAME=$(terraform output -raw cluster_name)
aws eks --region $REGION update-kubeconfig --name $CLUSTER_NAME
```