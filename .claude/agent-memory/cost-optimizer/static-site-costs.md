---
name: static-site-costs
description: Architecture and cost drivers for static portfolio deployed via S3+CloudFront
metadata:
  type: project
---

## Static Site Cost Profile

**Architecture:** Pure HTML/CSS portfolio (no JS) deployed to S3 + CloudFront, CI/CD via GitHub Actions with OIDC.

**Cost Drivers (ranked by annual impact):**

1. **S3 Storage** (~$1-3/year base, +$0-5/year per deployment frequency without lifecycle)
   - Standard storage only
   - Versioning enabled (no cleanup) — **LEAK**
   - No Intelligent-Tiering needed (all files warm)
   - Small total size (~2-5MB typical)

2. **CloudFront Data Transfer** (~$5-20/year)
   - PriceClass_200 when 100 sufficient — **OVERSPEND**
   - Caching well-tuned (using Managed-CachingOptimized)
   - No compression misconfiguration observed
   - Small payload site

3. **Backend State** (~$1-2/year)
   - S3 + DynamoDB for terraform state
   - Minimal: one state file, infrequent lock operations

4. **GitHub Actions / OIDC** (no cost)
   - Already using OIDC (best practice, no key rotation cost)

**Quick Wins:** Add S3 lifecycle rule (save $2-5/year, 5 min implementation), downgrade CloudFront PriceClass_200→100 (save $30-50/year, 2 min implementation).

**Not applicable:** Intelligent-Tiering (portfolio files always warm), reserved capacity (too small), CloudWatch retention (not configured).
