# Design decisions and rationale

| Decision | Rationale | Trade-off / production evolution |
|---|---|---|
| Two VPC-native GKE Standard clusters | Demonstrates explicit node-pool, IP and operational control | Autopilot reduces node operations; regional Standard improves control-plane HA |
| Separate subnets and secondary ranges | Prevents IP overlap and isolates capacity planning | Requires deliberate CIDR governance |
| Zonal clusters for assessment | Controls demo cost while retaining two-cluster behavior | Production uses regional clusters across three zones |
| Stateless sample services | Makes failover and horizontal scaling deterministic | Real state uses managed regional/multi-region data services |
| Three replicas + HPA + PDB | Supports rolling updates, disruption tolerance and scaling | Small demo nodes may need quota/capacity adjustment |
| Workload Identity | Avoids static service-account keys | Requires precise IAM bindings |
| Structured stdout logs | Native GKE collection and searchable fields | Standardize schema and propagate trace/request IDs in production |
| Cloud Logging sink to BigQuery | SQL-based incident and trend analysis | Retention, partition controls and sink filters manage cost |
| Managed Prometheus + Grafana | PromQL portability and Kubernetes-native metrics | BigQuery remains for logs, not high-frequency metrics |
| Regional LoadBalancer services by default | Immediately testable without fleet/MCI prerequisites | Production uses one HTTPS global entry point, WAF and managed certificates |

## SLO proposal

- Availability SLO: 99.9% successful non-synthetic requests over 30 days.
- Latency SLO: 95% of `/work` requests below 500 ms over 30 days.
- Alerts use multi-window burn rates rather than a single static threshold to reduce noise.

