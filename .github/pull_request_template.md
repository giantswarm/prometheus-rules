Before adding a new alerting rule into this repository you should consider creating an SLO rules instead.
SLO helps you both increase the quality of your monitoring and reduce the alert noise.

* How to create a SLO rule: https://github.com/giantswarm/sloth-rules#how-to-create-a-slo
* Documentation: https://intranet.giantswarm.io/docs/observability/slo-alerting/

---
Towards: https://github.com/giantswarm/...

This PR ...

### Checklist

- [ ] Update CHANGELOG.md
- [ ] Add [Unit tests](https://github.com/giantswarm/prometheus-rules/#testing)
- [ ] Follow [Alert structure](https://github.com/giantswarm/prometheus-rules/#how-alerts-are-structured)
- [ ] Consider [creating a dashboard](https://docs.giantswarm.io/tutorials/observability/data-exploration/creating-custom-dashboards/) ([guidelines](https://intranet.giantswarm.io/docs/product/ux/guidelines/dashboards/)) (if it does not exist already) to help oncallers monitor the status of the issue.
- [ ] Request review from oncall area, as well as team (e.g: `oncall-kaas-cloud` GitHub group).
