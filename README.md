# Sourcegraph Reference Implementation -- Bitbucket Server

A reference terraform repository to deploy Sourcegraph on AWS and connect to a Bitbucket Server instance

## Setup

This repository assumes you have the CLI configured for AWS and that your user has the proper permissions to create the resources required to run Sourcegraph.

Prerequisites:
- `aws`
- `terraform`
- `kubectl`
- `helm`

## Private resources

This repository will not track files containing `tls` in the `terraform/resources` directory, but will track the `override.yaml` file in the `terraform/resources` directory. Be sure not to commit any sensitive data in your `override.yaml` file.

## Configuring Sourcegraph

After deploying based on the template in `terraform`, you can set a CNAME record to route your chosen hostname to the newly provisioned ALB for your instance. At that point, you should be able to create your initial admin account and begin configuration.

Some example JSON configuration for Sourcegraph's Site Config is included in `sourcegraph-config`, as well as an example of the JSON configuration for Bitbucket Server, with links to documentation in comments on each of those files.