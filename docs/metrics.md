# Verification and Measurement Plan

This project currently publishes no measured deployment-time improvement, uptime percentage, recovery-time improvement, or compliance score. This document defines evidence to collect, not results already achieved.

## Minimum evidence

| Area | What to record | What a successful check establishes |
|---|---|---|
| Source validation | Commit, tool versions, job logs, conclusions | The specific static checks passed for that source revision |
| Provisioning | Reviewed plan, start/end times, apply outcome, VM IDs | The tested configuration created or changed the intended resources |
| Guest access | Intended client, verified SSH fingerprints, connection result | Access worked through the tested path |
| Configuration | Inventory scope, Ansible recap, failed/skipped tasks | The tested roles ran against the specified hosts |
| HTTP readiness | Guest-local endpoints, responses, retries | The specified endpoints answered as expected |
| Monitoring | Scrape-target health and a sample visible metric | The tested monitoring path collected the expected data |
| Repeat execution | Second run's plan and Ansible recap | Whether unexpected changes remained in that tested environment |
| Recovery | Backup identifier, isolated restore steps, service/data checks | The particular backup could be restored and checked |

Do not publish secrets, full Terraform state, sensitive inventories, tokens, or unredacted logs as evidence.

## Timing methodology

If measuring deployment duration later:

1. Record the exact commit, tool versions, template, and initial environment.
2. Define start and finish conditions before timing.
3. State whether provider downloads, image pulls, VM boot, configuration, and readiness checks are included.
4. Separate a cold run from a run using cached dependencies/images.
5. Record failures and retries rather than excluding them silently.
6. Report observations as results from this lab, not general production benchmarks.

Only claim time savings if a comparable baseline was actually measured with the same boundaries. Do not infer uptime from a successful health check or recovery time from a successful deployment.

## Current evidence status

Source code and documentation are available. Passing CI, live deployment, measured timing, monitoring operation, and successful backup restoration are not verified by this document.

[Project status](../PROJECT_STATUS.md) | [Pipeline verification steps](PIPELINE.md)
