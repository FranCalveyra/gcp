# Terraform Example: Network Load Balancer

Este ejemplo implementa la arquitectura del lab **Set Up a Network Load Balancer** con Terraform: un conjunto de VMs detrás de un Network Load Balancer (capa 4, TCP) que distribuye el tráfico HTTP entre ellas.

## Qué despliega

- VMs `google_compute_instance` (Apache vía startup script) creadas con `for_each` a partir de `instance_names`.
- Regla de firewall que permite el puerto HTTP sobre el tag de red de las instancias.
- `google_compute_http_health_check` para chequear la salud de las VMs.
- `google_compute_target_pool` que agrupa las instancias y usa el health check.
- `google_compute_address` regional (IP externa del balanceador).
- `google_compute_forwarding_rule` (`EXTERNAL`, TCP) que mapea el puerto HTTP de la IP hacia el target pool.

> Un Load Balancer en GCP no es un único recurso: es la combinación de forwarding rule + target pool + health check.

## Uso rápido

```bash
terraform init
terraform plan -var="project_id=<PROJECT_ID>"
terraform apply -var="project_id=<PROJECT_ID>"
```

La IP pública del balanceador queda expuesta en el output `load_balancer_ip`.

## Recomendaciones

- No hardcodear `project_id`, región ni nombres: usá variables.
- Corré `terraform destroy` al terminar para evitar costos.
