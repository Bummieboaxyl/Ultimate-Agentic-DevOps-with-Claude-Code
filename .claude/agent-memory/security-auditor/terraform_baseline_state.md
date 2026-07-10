---
name: terraform-baseline-state
description: Snapshot of terraform/ resource coverage as of the first full security audit (2026-07-09) — what exists vs. what CLAUDE.md claims exists
metadata:
  type: project
---

As of 2026-07-09, `terraform/` contains only 5 files: `main.tf`, `providers.tf`,
`variables.tf`, `outputs.tf`, `backend.tf`. Resources defined: `aws_s3_bucket.site`,
`aws_s3_bucket_public_access_block.site`, `aws_s3_bucket_versioning.site`,
`aws_cloudfront_origin_access_control.s3_oac`, `aws_s3_bucket_policy.site`,
`aws_cloudfront_distribution.cdn`. No IAM, OIDC provider, KMS, DynamoDB, or
response-headers-policy resources exist anywhere in the repo (confirmed via repo-wide
grep for `oidc|aws_iam` — only matches were in `.claude/agents/*.md` and `CLAUDE.md`
docs, not actual `.tf` code).

**Why this matters:** CLAUDE.md's architecture section describes "GitHub OIDC
provider + IAM role for keyless CI/CD auth" as part of the Terraform-managed
infrastructure, and `.github/workflows/` doesn't exist yet either. This is a gap
between documented/intended architecture and actual IaC state, not something a
future audit should assume is "missing/regressed" — it may simply not be built yet.

`backend.tf` intentionally ships with the S3 backend block commented out, with
inline bootstrap instructions (apply once locally to create the state bucket/
DynamoDB table, then uncomment and `terraform init -migrate-state`). The state
bucket (`bunmiolowo-dmisite-terraform-state`) and `terraform-locks` DynamoDB table
are NOT defined as resources in this repo — they must be audited separately
(directly via AWS) since their encryption/versioning/public-access config isn't
visible in code.

**How to apply:** On future audits, re-check whether IAM/OIDC resources and
`.github/workflows/` have since been added (don't rely on this memory being still
accurate — re-glob `terraform/**` and grep for `aws_iam|oidc` each time). If backend.tf
is still commented out, flag that state is local (unencrypted-at-rest on disk, no
locking) as a live finding rather than assuming migration already happened. If IAM/
OIDC resources have been added, audit them fresh against the checklist (least
privilege, no wildcards, OIDC trust scoped to repo/branch) — no prior findings exist
to compare against yet since this was the first audit.
