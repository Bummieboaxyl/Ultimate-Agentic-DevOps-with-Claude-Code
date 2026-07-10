---
name: s3-versioning-leak
description: S3 bucket has versioning enabled but no lifecycle policies to clean old versions
metadata:
  type: project
---

## S3 Versioning Configuration Issue

**Fact:** S3 bucket `bunmiolowo-dmisite-{AccountID}` has versioning enabled (terraform/main.tf:22-28) with NO lifecycle policies defined.

**Cost Impact:** Every deployment that uploads files creates new object versions. All prior versions persist indefinitely in Standard storage, incurring full storage charges. For a static portfolio with regular deployments (weekly or more), this compounds quickly—potentially doubling storage costs over 6+ months.

**Why:** Versioning was enabled for safety during development, but lifecycle rules were never added to expire old versions.

**How to apply:** Add S3 lifecycle policy (terraform/main.tf) to:
- Delete non-current versions after 30 days
- Consider deleting delete markers after 7 days
- This retains versioning for rollback while preventing cost creep

**Related:** [[cloudfront-price-class]] — another quick win on the same infrastructure
