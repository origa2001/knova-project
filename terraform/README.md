Terraform folder for Knova assessment

Place Terraform modules and configurations here. I'll add:
- providers.tf
- variables.tf
- main.tf (VPC, bastion, compute)
- rds.tf (managed Postgres)
- outputs.tf

I'll parameterize for environment and add a minimal example for `dev`.

Safe destroy notes
- Run `terraform plan -destroy` to preview exactly what will be removed.
- This config is modified to try to leave no lingering secrets or volumes. Notable behaviors:
		- Secrets Manager secrets are configured to be force-deleted on destroy (resource uses immediate deletion when destroyed).
	- RDS deletion protection is explicitly set to `false` here so a `terraform destroy` will remove the DB. The RDS resource is also configured with `skip_final_snapshot = true` and `backup_retention_period = 0` to avoid creating snapshots automatically on destroy (this will permanently delete data).
	- The bastion root volume is marked `delete_on_termination = true` so it will be removed when the instance is terminated.

IMPORTANT: These changes are destructive and intended to avoid leftover AWS charges for short-lived test environments. If you have production data you wish to keep, DO NOT run `terraform destroy` with these settings. Instead set `create_rds = false` or change `skip_final_snapshot = false` and `deletion_protection = true` and take manual snapshots.

Destroy steps (recommended safe workflow)
1) Preview:
```bash
cd knova-exercise/terraform
terraform plan -destroy -out=destroy.plan
```
2) Apply destroy (interactive):
```bash
terraform apply "destroy.plan"
```
3) Verify resources are gone using the AWS CLI or Console (RDS, EC2, Secrets Manager, S3 if created).

Note: The destroy-time hook uses the AWS CLI. Make sure you have the AWS CLI installed and your credentials configured when running `terraform destroy`.

SSH Key pair
- The bastion EC2 uses the key pair named by `var.key_name` (default `my-laptop-key`). Ensure that key pair exists in the target AWS account/region (us-east-2) before applying so you can SSH into the bastion. To import your public key into AWS:

```bash
aws ec2 import-key-pair --key-name my-laptop-key --public-key-material fileb://~/.ssh/id_rsa.pub --region us-east-2
```

Or create a key pair in the EC2 console and set `key_name` accordingly.