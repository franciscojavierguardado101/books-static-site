# books-static-site

Terraform infrastructure for deploying the Books Next.js frontend as a static site on AWS S3 + CloudFront with real-time CloudWatch monitoring.

## Architecture

```
GitHub Actions
      |
      |-- terraform.yml --> Terraform (infrastructure)
      |-- deploy-site.yml --> Next.js build --> S3 --> CloudFront invalidation
                                  |
                          Drupal Pantheon CMS
                          (fetched at build time)
```

**AWS Services**
- **S3** - private bucket stores all static HTML, JS, CSS, and image assets
- **CloudFront** - global CDN serves the site over HTTPS with OAC to S3
- **IAM** - least-privilege deployer user scoped to this bucket only
- **CloudWatch** - alarms on 4xx/5xx error rates + request volume dashboard

**GCP**
- **GCS** - backup mirror of site files on Google Cloud Storage

## How the static build works

The Books frontend is a headless Drupal + Next.js app normally deployed on Vercel/Kubernetes. For S3 hosting, the deploy workflow:

1. Checks out the Books frontend repo
2. Overrides `next.config.ts` to set `output: "export"` (static HTML generation)
3. Removes API routes (require a Node.js server, not compatible with S3)
4. Runs `next build` with `DRUPAL_BASE_URL` pointing to Pantheon Dev
5. Syncs the `out/` directory to S3 with appropriate cache headers
6. Invalidates the CloudFront distribution

## Environments

| Environment | S3 Bucket | CloudFront Price Class |
|---|---|---|
| dev | `francisco-guardado-books-dev-site` | PriceClass_100 (US/EU) |
| prod | `francisco-guardado-books-prod-site` | PriceClass_All (global) |

## GitHub Secrets Required

| Secret | Description |
|---|---|
| `AWS_ACCESS_KEY_ID` | IAM user with S3 + CloudFront permissions |
| `AWS_SECRET_ACCESS_KEY` | Corresponding secret |
| `BOOKS_FRONTEND_TOKEN` | GitHub token to checkout the Books frontend repo |

## CloudFormation equivalent

See `cloudformation/books-static-site.yml` for the CloudFormation template that provisions the same infrastructure. Demonstrates knowledge of both Terraform and native AWS IaC tooling.

## CloudWatch monitoring

Two alarms are provisioned per environment:
- **4xx error rate > 5%** - triggers when client errors (broken links, missing assets) spike
- **5xx error rate > 1%** - triggers when the S3 origin is unreachable or misconfigured

A dashboard (`{env}-books-static-site`) shows requests, error rates, and bytes downloaded in one view.
