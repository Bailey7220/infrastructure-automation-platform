# Verification and Measurement Plan

This project publishes no measured deployment-time improvement, uptime percentage, recovery-time improvement, or compliance score. This document defines evidence to collect, not performance results already achieved.

## Minimum evidence

| Area | What to record | What success establishes |
|---|---|---|
| Static validation | Commit, versions, run URL, logs, conclusions | The specified checks passed for that revision |
| Preflight fixture tests | Commit, test command, test output | Tested presence-check paths behave as asserted with dummy inputs |
| Provisioning | Reviewed plan, start/end times, apply result, VM IDs | Intended resources were created or changed in the tested environment |
| Guest access | Intended client, verified fingerprints, connection result | Access worked through the tested path |
| Configuration | Inventory scope, Ansible recap, failed/skipped tasks | The specified roles ran against those hosts |
| HTTP readiness | Guest-local endpoints, responses, retries | Specified endpoints answered as expected |
| Monitoring | Scrape-target health and a sample metric | The tested monitoring path collected expected data |
| Repeat execution | Second plan and Ansible recap | Whether unexpected changes remained |
| Recovery | Backup identifier, isolated restore steps, service/data checks | The particular backup could be restored and checked |

Do not publish secrets, full Terraform state, sensitive inventories, tokens, or unredacted logs.

## Timing methodology

1. Record the exact commit, versions, template, and initial environment.
2. Define start and finish conditions before timing.
3. State whether downloads, image pulls, VM boot, configuration, and readiness checks are included.
4. Separate cold runs from runs using cached dependencies or images.
5. Record failures and retries rather than silently excluding them.
6. Report observations as lab results, not general production benchmarks.

Only claim time savings against a comparable measured baseline. Do not infer uptime from a health check or recovery time from deployment success.

## Current evidence status

On October 22, 2026, the owner supplied terminal output demonstrating successful local Terraform formatting/init/validation and Ansible syntax checks with the intended configuration. The owner also reported passing GitHub checks and preflight regression tests. Exact Actions run URLs and complete logs are not recorded or independently reviewed here; later commits require their own checks.

These are static-validation and fixture-test observations, not measurements of live deployment, service health, monitoring operation, timing, or restore success. Those remain unverified.

[Project status](../PROJECT_STATUS.md) | [Pipeline](PIPELINE.md)
