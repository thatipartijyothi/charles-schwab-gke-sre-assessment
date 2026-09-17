# Final submission checklist

- [ ] Replace `YOUR_PROJECT_ID` only in local runtime commands/queries; do not commit sensitive configuration.
- [ ] Run `terraform fmt -recursive`, `terraform validate` and `terraform plan`.
- [ ] Build and push both application images.
- [ ] Deploy to both clusters and record the four endpoints.
- [ ] Generate normal and synthetic-error traffic.
- [ ] Import the Grafana dashboard and capture all required panels.
- [ ] Run BigQuery queries against actual exported tables and capture results.
- [ ] Reproduce and document the readiness-probe troubleshooting scenario.
- [ ] Add reviewed screenshots using `git add -f`.
- [ ] Update `docs/evidence.md` with URLs/status/timestamps.
- [ ] Confirm there are no credentials, state files or personal data in Git history.
- [ ] Push to a personal Git repository and share read access/link with the reviewer.
- [ ] Destroy chargeable GCP resources after the assessment window.

