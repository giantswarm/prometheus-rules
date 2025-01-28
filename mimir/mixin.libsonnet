(import 'mimir-mixin/mixin.libsonnet') + {
  _config+:: {
    tags: [
      'owner:team-atlas',
      'topic:observability',
      'component:mimir',
    ],

    per_cluster_label: 'cluster_id',
    // Not sure why the default is set to instance, but we want to set it to node
    per_node_label: 'node',
    per_component_loki_label: 'component',
    // We marked it as disabled as this should be enabled only if the enterprise gateway is enabled
    gateway_enabled: false,
    // Whether alerts for experimental ingest storage are enabled.
    ingest_storage_enabled: false,
    // Disable autoscaling components we do not use
    autoscaling_hpa_prefix: 'mimir-',
    // Whether autoscaling panels and alerts should be enabled for specific Mimir services.
    autoscaling: {
      query_frontend: {
        enabled: false,
        hpa_name: $._config.autoscaling_hpa_prefix + 'query-frontend',
      },
      ruler_query_frontend: {
        enabled: false,
        hpa_name: $._config.autoscaling_hpa_prefix + 'ruler-query-frontend',
      },
      querier: {
        enabled: true,
        hpa_name: $._config.autoscaling_hpa_prefix + 'querier',
      },
      ruler_querier: {
        enabled: false,
        hpa_name: $._config.autoscaling_hpa_prefix + 'ruler-querier',
      },
      store_gateway: {
        enabled: false,
        hpa_name: $._config.autoscaling_hpa_prefix + 'store-gateway',
      },
      distributor: {
        enabled: true,
        hpa_name: $._config.autoscaling_hpa_prefix + 'distributor',
      },
      ruler: {
        enabled: false,
        hpa_name: $._config.autoscaling_hpa_prefix + 'ruler',
      },
      gateway: {
        enabled: true,
        hpa_name: $._config.autoscaling_hpa_prefix + 'gateway',
      },
      ingester: {
        enabled: false,
        hpa_name: $._config.autoscaling_hpa_prefix + 'ingester',
      },
      compactor: {
        enabled: false,
        hpa_name: $._config.autoscaling_hpa_prefix + 'compactor',
      },
    },
  },
}
