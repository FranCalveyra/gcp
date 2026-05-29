# Arquitectura de Nube en GCP — Universidad Austral

> Material del curso **GCP + AI Fundamentals** de la Universidad Austral, año 2026.

Este repositorio reúne apuntes de clase, laboratorios guiados y prácticas Terraform para estudiar servicios de Google Cloud con foco en arquitectura, fundamentos operativos e infraestructura como código.

La secuencia importante es esta: **concepto → lab → Terraform**. No al revés. Si arrancás copiando infraestructura sin entender qué problema resuelve el servicio, estás construyendo sobre arena.

## Ruta rápida

| Quiero... | Ir a |
|---|---|
| Leer el libro desde el índice fuente | [`src/SUMMARY.md`](./src/SUMMARY.md) |
| Empezar por la introducción del libro | [`src/README.md`](./src/README.md) |
| Ver las prácticas Terraform | [`src/examples/README.md`](./src/examples/README.md) |
| Configurar el entorno local | [`docs/INSTALL.md`](./docs/INSTALL.md) |

## Criterios de evaluación

- Para aprobar la materia hay que tener todos los laboratorios aprobados.
- Algunos laboratorios funcionan como checkpoint.
- Hay un parcial teórico multiple choice al final de la materia.
- La materia es promocionable con nota **7 o más**.

## Cómo estudiar este material

1. Leé la clase correspondiente y entendé el modelo mental del servicio.
2. Hacé el lab para ver el comportamiento real en Google Cloud.
3. Recién después revisá la práctica Terraform para ver cómo se modela como infraestructura.
4. Si algo falla, explicá primero **qué recurso esperabas crear** y **qué estado real quedó en GCP**. Ese músculo vale más que memorizar comandos.

## Contenido del curso

| Clase | Tema | Archivo |
|---|---|---|
| 1 | Introducción a la nube, regiones, zonas, billing e interacción con GCP | [`Clase 1.md`](./src/Clase%201.md) |
| 2 | Recursos de cómputo, Compute Engine y Managed Instance Groups | [`Clase 2.md`](./src/Clase%202.md) |
| 3 | Serverless: App Engine, Cloud Run Functions y Cloud Run Service | [`Clase 3.md`](./src/Clase%203.md) |
| 4 | Almacenamiento: Cloud Storage, Cloud SQL y Firestore | [`Clase 4.md`](./src/Clase%204.md) |
| 5 | Networking: VPC, subredes, CIDR, firewall y costos de red | [`Clase 5.md`](./src/Clase%205.md) |
| 6 | IAM, jerarquía de recursos, roles, service accounts y guardrails | [`Clase 6.md`](./src/Clase%206.md) |
| 7 | Terraform e Infrastructure as Code | [`Clase 7.md`](./src/Clase%207.md) |
| 8 | Monitoreo, logging, tracing, profiling y alertas | [`Clase 8.md`](./src/Clase%208.md) |
| 9 | Observabilidad, Ops Agent, OpenTelemetry y monitoreo de red | [`Clase 9.md`](./src/Clase%209.md) |

## Labs documentados

| Tipo de recurso | Labs |
|---|---|
| Balanceadores de carga | [Network Load Balancer](./src/examples/load-balancer/create-nlb/lab.md), [Application Load Balancer with Autoscaling](./src/examples/load-balancer/application-load-balancer/lab.md) |
| Almacenamiento | [Cloud Storage](./src/examples/storage/buckets/lab.md), [Cloud SQL](./src/examples/storage/cloud-sql/lab.md) |
| Cloud Run | [Cloud Run Functions Qwik Start](./src/examples/cloud-run/cloud-run-functions-qwik-start/lab.md), [Cloud Pub/Sub With Cloud Run](./src/examples/cloud-run/pubsub-with-cloud-run/lab.md), [Build a Serverless App with Cloud Run that Creates PDF Files](./src/examples/cloud-run/pdf-converter/lab.md), [Build a Resilient, Asynchronous System with Cloud Run and Pub/Sub](./src/examples/cloud-run/resilient-async-pubsub/lab.md), [Developing a REST API with Go and Cloud Run](./src/examples/cloud-run/rest-api-go/lab.md), [Creating PDFs with Go and Cloud Run](./src/examples/cloud-run/pdf-converter-go/lab.md) |
| IAM | [Configuring IAM with gcloud](./src/examples/iam/configuring-iam-with-gcloud/lab.md), [Exploring IAM](./src/examples/iam/exploring-iam/lab.md) |
| Redes | [Configuring VPC](./src/examples/network/configuring-vpc/lab.md), [VPC Controlling Access](./src/examples/network/controlling-access/lab.md), [Multiple VPC](./src/examples/network/multiple-vpc/lab.md), [Build a Secure Network - Challenge](./src/examples/network/build-secure-network-challenge/lab.md), [Analyzing Network Traffic with VPC Flow Logs](./src/examples/network/vpc-flow-logs/lab.md) |
| Terraform | [Build IaC with Terraform](./src/examples/terraform/build-iac-with-terraform/lab.md), [Automating Infrastructure Deployment With Terraform](./src/examples/terraform/automating-infrastructure-deployment/lab.md) |
| Monitoreo | [Log Analytics](./src/examples/monitoring-and-alerts/log-analytics/lab.md), [Monitoring a Compute Engine by using Ops Agent](./src/examples/observability/ops-agent-monitoring/lab.md), [Service Monitoring](./src/examples/monitoring-and-alerts/service-monitoring/lab.md), [Alerting in GCP](./src/examples/monitoring-and-alerts/alerting-in-gcp/lab.md), [View application latency with Cloud Trace](./src/examples/observability/cloud-trace/lab.md) |
| Confiabilidad | [Building a DevOps Pipeline](./src/examples/reliability/devops-pipeline/lab.md) |

## Prácticas Terraform

Las prácticas están agrupadas por tipo de recurso en [`src/examples`](./src/examples/README.md):

| Categoría | Índice |
|---|---|
| Cloud Run | [`src/examples/cloud-run`](./src/examples/cloud-run/README.md) |
| Balanceadores de carga | [`src/examples/load-balancer`](./src/examples/load-balancer/README.md) |
| Almacenamiento | [`src/examples/storage`](./src/examples/storage/README.md) |
| IAM | [`src/examples/iam`](./src/examples/iam/README.md) |
| Redes | [`src/examples/network`](./src/examples/network/README.md) |
| Terraform | [`src/examples/terraform`](./src/examples/terraform/README.md) |
| Monitoreo | [`src/examples/monitoring-and-alerts`](./src/examples/monitoring-and-alerts/README.md) |
| Confiabilidad | [`src/examples/reliability`](./src/examples/reliability/README.md) |

## Recursos adicionales

- [`Cloud Shell`](./src/Cloud%20Shell.md): uso básico de CLI y herramientas de Google Cloud.
- [`Notas extra`](./src/Notas%20extra.md): apuntes complementarios.
- [`docs/INSTALL.md`](./docs/INSTALL.md): instalación de mdBook y preprocesadores.

## Uso local

Para leer el material no necesitás compilar nada: podés abrir los Markdown dentro de `src/`.

Si querés levantar el libro como sitio local:

```bash
mdbook serve
```

Después abrí `http://localhost:3000`.

Para preparar el entorno completo, seguí la [guía de instalación](./docs/INSTALL.md).

## Estructura del repositorio

```text
gcp/
├── book.toml                  # Configuración de mdBook
├── docs/
│   └── INSTALL.md             # Guía de instalación local
├── src/
│   ├── README.md              # Introducción interna del libro
│   ├── SUMMARY.md             # Índice del libro
│   ├── Clase *.md             # Apuntes de clase
│   ├── Cloud Shell.md         # Recurso adicional
│   ├── Notas extra.md         # Recurso adicional
│   └── examples/              # Labs y prácticas Terraform
├── book/                      # Salida generada por mdBook
└── README.md                  # Este archivo
```

## Convenciones del material

- Los conceptos se explican en español.
- Los nombres de servicios, comandos y recursos de GCP se mantienen en inglés cuando corresponde.
- Los labs muestran el camino guiado de aprendizaje.
- Las prácticas Terraform muestran una implementación reutilizable, no un reemplazo del razonamiento.
- No hardcodees `project_id`, región, credenciales ni valores sensibles: parametrizá.

---

**Docentes**: Rodrigo Pazos, Mora Villa Abrille<br>
**Materia**: GCP + AI Fundamentals<br>
**Universidad**: Universidad Austral<br>
**Año**: 2026
