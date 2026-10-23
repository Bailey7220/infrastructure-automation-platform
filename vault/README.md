# Vault placeholder

`vault-policy.hcl` is an empty placeholder. It does not define an access policy or establish a working Vault integration.

Terraform contains a VM definition named `vault-001`. A VM definition is not a Vault service implementation: the current [Ansible playbook](../ansible/playbook.yml) includes common, webserver, and monitoring roles, but no Vault role.

## Not established

This directory provides no evidence of Vault installation, server configuration, TLS, storage configuration, initialization, unsealing, authentication methods, applied policies, secrets integration, or backup and restore testing.

Do not put root tokens, unseal keys, credentials, or Terraform state in this directory. Do not claim that the project uses Vault to manage its runtime secrets based on this placeholder or the VM name.

Any future Vault implementation needs a separately reviewed design and runtime validation. See the [root README](../README.md) and [project status](../PROJECT_STATUS.md) for the current project boundaries.
