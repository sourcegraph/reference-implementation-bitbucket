# Sourcegraph Reference Implementation -- Bitbucket Server

A reference terraform repository to deploy Sourcegraph on AWS and connect to a Bitbucket Server instance

## Setup

This repository assumes you have the CLI configured for AWS and that your user has the proper permissions to create the resources required to run Sourcegraph.

Prerequisites:
- `aws`
- `terraform`
- `kubectl`
- `helm`