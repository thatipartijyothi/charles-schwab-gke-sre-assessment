# Security and governance

- **Identity:** Google groups for Dev/Ops/SRE/CI roles; no direct user grants in production. Workload Identity maps the Kubernetes service account to a dedicated Google service account.
- **Secrets:** Secret Manager with CSI integration; Kubernetes Secrets and plaintext Terraform variables are not used for credentials.
- **Network:** Dedicated subnets, VPC-native alias IPs, controlled firewall rules, optional private nodes/control-plane authorized networks, and Cloud NAT egress logging.
- **Workload:** Non-root containers, dropped Linux capabilities, read-only root filesystem, resource limits and NetworkPolicy.
- **Supply chain:** Pin immutable image digests in production, scan Artifact Registry, sign images, enforce Binary Authorization, and generate SBOMs in CI.
- **Edge:** HTTPS only, managed certificates, Cloud Armor WAF/rate limiting and DDoS protection.
- **Audit:** Admin, data access and Kubernetes audit logs routed to protected retention/SIEM destinations.
- **Terraform:** Remote encrypted state, restricted state-reader group, versioning, locking, peer review and policy checks.

The sample enables public application endpoints for assessment evidence. Restrict or remove them immediately after validation.

