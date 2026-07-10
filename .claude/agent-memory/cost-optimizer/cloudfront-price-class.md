---
name: cloudfront-price-class
description: CloudFront using PriceClass_200 when portfolio only needs PriceClass_100
metadata:
  type: project
---

## CloudFront Price Class Mismatch

**Fact:** CloudFront distribution (terraform/main.tf:77) configured with `price_class = "PriceClass_200"` for a static portfolio website.

**Cost Impact:** PriceClass_200 costs ~30% more than PriceClass_100 due to coverage of additional regions. A portfolio site doesn't require global edge location distribution—cost difference is ~$30-50/year depending on traffic.

**Why:** Default/conservative choice that wasn't revisited.

**How to apply:** Change line 77 from `"PriceClass_200"` to `"PriceClass_100"`. PriceClass_100 covers most traffic (N. America, Europe, Asia, Australia). If later analysis shows high traffic from excluded regions, revert to 200. But for a portfolio, 100 is appropriate.

**Related:** [[s3-versioning-leak]] — prioritize S3 lifecycle first (higher savings), then address price class.
