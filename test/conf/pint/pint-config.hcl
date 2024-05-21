rule {
  # Ensure that all aggregations are preserving mandatory labels.
  aggregate ".+" {
    severity = "bug"
    keep     = ["cluster_id", "installation", "pipeline", "provider"]
  }
}
