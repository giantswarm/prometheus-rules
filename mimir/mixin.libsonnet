local mimir = import 'mimir-mixin/mixin-compiled.libsonnet';

mimir{
  _config+:: {
    tags: [
      "owner:team-atlas",
      "topic:observability",
      "component:mimir"
    ],

    per_cluster_label: 'cluster_id',
    // Not sure why the default is set to instance, but we want to set it to node
    per_node_label: 'node',
    // We marked it as disabled as this should be enabled only if the enterprise gateway is enabled
    gateway_enabled: false,
    // Whether alerts for experimental ingest storage are enabled.
    ingest_storage_enabled: false,
    // Disable all autoscaling components because we currently do not use it
    autoscaling: {
      query_frontend: {
        enabled: false,
      },
      ruler_query_frontend: {
        enabled: false,
      },
      querier: {
        enabled: false,
      },
      ruler_querier: {
        enabled: false,
      },
      distributor: {
        enabled: false,
      },
      ruler: {
        enabled: false,
      },
      gateway: {
        enabled: false,
      },
    },
  },
}
