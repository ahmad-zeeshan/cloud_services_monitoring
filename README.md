### Deploy Prometheus on AWS to monitor EC2 instances using node exporter role

Terrafom deploy Prometheus on an AWS EC2 instance using Terraform

To launch additional EC2 instances and equip them with Node Exporter for performance monitoring using Terraform.

To ensure Prometheus effectively collects and processes performance data from these in-stances.

The configuration for the Servers, Prometheus and Grafana will be done by Ansible.

To run the code:

```
terraform plan

terraform apply
```
and then run the ansible playbook to configure the machines.
