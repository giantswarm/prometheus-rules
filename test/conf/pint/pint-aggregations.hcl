rule {
  # Ensure that all aggregations are preserving "job" label.
  aggregate ".+" {
    severity = "bug"
    keep     = ["cluster_id", "installation", "pipeline", "provider"]
  }
}
