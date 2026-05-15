[Link al lab](https://www.skills.google/course_templates/864/labs/621027)

## Recursos identificados

- APIs habilitadas: `compute.googleapis.com`, `monitoring.googleapis.com`, `logging.googleapis.com`.
- VM: `quickstart-vm` (e2-small, Debian, us-east4-c, tag `http-server`).
- Firewall: permite tcp:80 desde `0.0.0.0/0` a VMs con tag `http-server`.
- Software en la VM: Apache2 + PHP + Google Cloud Ops Agent.
- Ops Agent config: pipelines personalizados para métricas y logs de Apache (`apache`, `apache_access`, `apache_error`).
- Cloud Monitoring: dashboard predefinido "Apache Overview", canal de notificación por email, alerting policy por tráfico Apache (`workload.googleapis.com/apache.traffic > 4 KiB/s`).

## Comandos ejecutados

En los comandos siguientes, reemplazá `<ZONE>` y `<PROJECT_ID>` por los valores de tu lab.

### Verificar autenticación y proyecto activo

```bash
gcloud auth list
gcloud config list project
```

### Conectarse a la VM por SSH

```bash
gcloud compute ssh --zone "<ZONE>" "quickstart-vm" --project "<PROJECT_ID>"
```

### Instalar Apache y PHP

```bash
sudo apt-get update
sudo apt-get install apache2 php7.0 -y
```

### Instalar el Ops Agent

```bash
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install
```

### Hacer backup del config y configurar pipelines de Apache

```bash
sudo cp /etc/google-cloud-ops-agent/config.yaml /etc/google-cloud-ops-agent/config.yaml.bak

sudo tee /etc/google-cloud-ops-agent/config.yaml > /dev/null << EOF
metrics:
  receivers:
    apache:
      type: apache
  service:
    pipelines:
      apache:
        receivers:
          - apache
logging:
  receivers:
    apache_access:
      type: apache_access
    apache_error:
      type: apache_error
  service:
    pipelines:
      apache:
        receivers:
          - apache_access
          - apache_error
EOF
```

### Reiniciar el Ops Agent y verificar estado

```bash
sudo systemctl restart google-cloud-ops-agent
sudo systemctl status "google-cloud-ops-agent*"
```

### Generar tráfico al servidor Apache

```bash
timeout 120 bash -c -- 'while true; do curl localhost; sleep $((RANDOM % 4)) ; done'
```

### Ver el dashboard de Apache (Console)

> **Cloud Monitoring → Dashboards → Apache Overview** — muestra métricas de tráfico, workers activos y requests por segundo exportadas por el Ops Agent.

### Crear canal de notificación y alerting policy (Console)

> 1. **Monitoring → Alerting → Edit notification channels** → agregar canal Email.
> 2. **Monitoring → Alerting → Create policy** → métrica `workload.googleapis.com/apache.traffic`, threshold > 4 KiB/s, duración 1 minuto, notificar al canal creado.
