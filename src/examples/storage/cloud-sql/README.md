# Terraform Example: Cloud SQL

Este ejemplo implementa una práctica Terraform basada en el lab **Implementing Cloud SQL**.

## Qué crea

- APIs necesarias: `compute`, `sqladmin`, `servicenetworking`.
- Peering privado para Cloud SQL (`google_service_networking_connection`).
- Instancia Cloud SQL MySQL (`wordpress-db`) con:
  - Public IP habilitada.
  - Private IP en la VPC seleccionada.
- Base de datos `wordpress`.
- 2 VMs de apoyo:
  - `wordpress-proxy`
  - `wordpress-private-ip`
- Firewall para exponer HTTP en las VMs de demo.

## Uso rápido

1. Inicializá:

```bash
terraform init
```

2. Definí `terraform.tfvars`:

```hcl
project_id        = "tu-project-id"
region            = "us-central1"
zone              = "us-central1-a"
network_name      = "default"
sql_root_password = "cambiame-por-una-password-segura"
```

3. Plan y apply:

```bash
terraform plan
terraform apply
```

## Comandos útiles post-deploy

Con la salida `sql_instance_connection_name`, en `wordpress-proxy` podés correr:

```bash
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy && chmod +x cloud_sql_proxy
export SQL_CONNECTION=<connection_name>
./cloud_sql_proxy -instances=$SQL_CONNECTION=tcp:3306 &
```

## Notas

- Este ejemplo crea infraestructura base y conectividad; la instalación guiada de WordPress (UI) se hace manual como en el lab.
- El password root se maneja por variable sensible; no lo hardcodees en código versionado.
