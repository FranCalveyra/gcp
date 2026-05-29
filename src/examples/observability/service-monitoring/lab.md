[Link al lab](https://www.skills.google/focuses/19476?parent=catalog)

Este lab se complementa con la práctica Terraform en `README.md` dentro de esta misma carpeta.

[Link al lab](https://www.skills.google/focuses/19476?parent=catalog)

## Recursos identificados
- **App Engine (standard)**: creación de la aplicación App Engine y deploy de un servicio Node.js.
- **Service Monitoring (Cloud Monitoring)**: definición de un **SLO de disponibilidad** para el servicio App Engine `default` (rolling window 7 días, objetivo 99.5%).
- **Cloud Monitoring Alerting**: creación de un **alert** atado al SLO (burn rate) con lookback de 10 minutos y threshold 1.5.
- **Notification channels**: canal de notificación por **email** (configurado desde la UI).
- **Métricas/telemetría**:
  - Tráfico HTTP a App Engine (`/random-error`) para inducir errores.
  - Cálculo de burn rate del error budget vía `select_slo_burn_rate`.
- **IAM / APIs**:
  - APIs típicamente requeridas: `appengine.googleapis.com`, `monitoring.googleapis.com`.
  - La creación/edición de SLOs y alert policies requiere permisos de Monitoring (por ejemplo roles tipo `roles/monitoring.editor` en el proyecto).

## Comandos ejecutados
```bash
git clone https://github.com/haggman/HelloLoggingNodeJS.git
```

```bash
cd HelloLoggingNodeJS
```

```bash
edit index.js
```

```bash
gcloud app create --region={{{project_0.startup_script.app_region|REGION}}}
```

```bash
gcloud app deploy
```

```bash
while true; \
do curl -s https://$DEVSHELL_PROJECT_ID.appspot.com/random-error \
  -w '\n' ;sleep .1s;done
```

```bash
gcloud app deploy
```

