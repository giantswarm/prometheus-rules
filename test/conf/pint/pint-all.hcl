rule {
  # Disallow spaces in label/annotation keys, they're only allowed in values.
  reject ".* +.*" {
    label_keys      = true
    annotation_keys = true
  }

  # Disallow URLs in labels, they should go to annotations.
  reject "https?://.+" {
    label_keys   = true
    label_values = true
  }

  # Ensure that all aggregations are preserving mandatory labels.
  aggregate ".+" {
    severity = "bug"
    keep     = ["cluster_id", "installation", "pipeline", "provider"]
  }
}

rule {
  # This block will apply to all alerting rules.
  match {
    kind = "alerting"
  }

  # Each alert must have a 'description' annotation.
  annotation "description" {
    severity = "bug"
    required = true
  }

  # Each alert must have a 'runbook_url' annotation.
  annotation "runbook_url" {
    severity = "bug"
    required = true
  }

  # Each alert should have a 'dashboardUid' annotation.
  annotation "__dashboardUid__" {
    severity = "warning"
    required = true
  }

  # Each alert must have a 'severity' label that's either 'page' or 'notify'.
  label "severity" {
    severity = "bug"
    value    = "(page|notify)"
    required = true
  }

  # Each alert must have an `area' label that's either 'kaas' or 'platform'.
  label "area" {
    severity = "bug"
    value    = "(kaas|platform)"
    required = true
  }

  # Check how many times each alert would fire in the last 1d.
  alerts {
    range   = "1d"
    step    = "1m"
    resolve = "5m"
  }
}
