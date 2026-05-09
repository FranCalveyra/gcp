# Google Cloud Platform + AI Fundamentals - Universidad Austral

> Material completo del curso de GCP + AI Fundamentals, Universidad Austral, año 2026

## Sobre este repositorio

Este repositorio contiene el material completo del curso **GCP + AI Fundamentals** de la Universidad Austral, cursado durante el año 2026. El contenido está organizado en formato de libro digital utilizando [mdBook](https://rust-lang.github.io/mdBook/), facilitando el estudio y la comprensión de los servicios y arquitecturas de Google Cloud Platform, y los servicios de AI que ofrece.

## Criterios de evaluación
- Para aprobar la materia es necesario tener todos los laboratorios aprobados.
	- Algunos van a servir como checkpoint
- Parcial teórico multiple choice al final de la materia
- Es promocionable si te sacas 7 o más
## Contenido

### Clases Teórico-Prácticas

El curso incluye 16 clases que cubren los aspectos fundamentales de GCP:

- **Clase 1**: [Introducción](./src/Clase%201.md)
  - Regiones vs zonas, PoPs y latencia/costos
  - Organización, folders, proyectos y billing accounts
  - Formas de interactuar con GCP (Console, Cloud Shell, SDK, APIs)
- **Clase 2**: [Recursos de cómputo (Compute Engine y MIGs)](./src/Clase%202.md)
  - Familias/series/tipos de máquinas; arquitectura (Intel/AMD/ARM) y variantes (local SSD)
  - Modelos de aprovisionamiento (standard/spot/flex-start/reservations)
  - Managed Instance Groups: alta disponibilidad, autoscaling y rolling updates
- **Clase 3**: [Serverless: App Engine, Cloud Run Functions y Cloud Run Service](./src/Clase%203.md)
  - Limitaciones de VMs/MIGs (tiempos de provisioning, init/stabilization, infra ociosa)
  - FaaS vs containers: eventos, concurrencia, límites y tiempos de arranque
  - Modelos de billing en Cloud Run (request-based vs instance-based)
- **Clase 4**: [Almacenamiento: GCS, Cloud SQL y Firestore](./src/Clase%204.md)
  - Cloud Storage (object storage): durabilidad, replicación, clases de storage y pricing
  - Cloud SQL: HA, backups, parches/updates y réplicas de lectura
  - Firestore: modelo documento, índices, costos read/write y sharding (splits)
- **Clase 5**: [Networking: VPC, subredes, CIDR y firewall](./src/Clase%205.md)
  - CIDR y planificación de rangos IP; conceptos base (NIC, IPv4, RFC1918)
  - VPC global vs subred regional; auto-mode vs custom-mode
  - Firewall rules por VPC/tags; deny by default y costos de networking (IPs, LB, NAT, tráfico)
- **Clase 6**: [Seguridad: IAM, jerarquía de recursos y guardrails](./src/Clase%206.md)
  - Jerarquía (org/folders/projects/resources), herencia y ciclo de vida
  - Member + Role + Resource; roles primitivos/predefinidos/custom
  - Service Accounts (tipos, autenticación) y Organization Policies (constraints)
- **Clase 7**: [Terraform e Infrastructure as Code](./src/Clase%207.md)
  - Motivación y problemas de “clickops”; CloudFormation vs Terraform
  - Terraform CLI (`init/plan/apply/destroy`) y lectura segura del plan
  - State, drift, state remoto/locking y buenas prácticas
- **Clase 8**: 
- **Clase 9**: 
- **Clase 10**: 
- **Clase 11**: 
- **Clase 12**:
- **Clase 13**:
- **Clase 14**:

### Recursos Adicionales

### Labs y prácticas

- Labs documentados:
  - [Network Load Balancer](./src/examples/load-balancer/create-nlb/lab.md)
  - [Application Load Balancer with Autoscaling](./src/examples/load-balancer/application-load-balancer/lab.md)
  - [Cloud Storage](./src/examples/storage/buckets/lab.md)
  - [Cloud SQL](./src/examples/storage/cloud-sql/lab.md)
  - [Cloud Run Functions Qwik Start](./src/examples/cloud-run/cloud-run-functions-qwik-start/lab.md)
  - [Cloud Pub Sub With Cloud Run](./src/examples/cloud-run/pubsub-with-cloud-run/lab.md)
  - [Configuring IAM with gcloud](./src/examples/iam/configuring-iam-with-gcloud/lab.md)
  - [Exploring IAM](./src/examples/iam/exploring-iam/lab.md)
  - [Configuring VPC](./src/examples/network/configuring-vpc/lab.md)
  - [VPC Controlling Access](./src/examples/network/controlling-access/lab.md)
  - [Multiple VPC](./src/examples/network/multiple-vpc/lab.md)
  - [Build a Secure Network - Challenge](./src/examples/network/build-secure-network-challenge/lab.md)
  - [Automating Infrastructure Deployment With Terraform](./src/examples/terraform/automating-infrastructure-deployment/lab.md)
  - [Build IaC with Terraform](./src/examples/terraform/build-iac-with-terraform/lab.md)
  - [Log Analytics](./src/labs/Log Analytics.md)
  - [Service Monitoring](./src/labs/Service Monitoring.md)
  - [Alerting in GCP](./src/labs/Alerting in GCP.md)
- Prácticas Terraform:
  - [Application Load Balancer with Autoscaling](./src/examples/load-balancer/application-load-balancer/README.md)
  - [Cloud Storage Lab](./src/examples/storage/buckets/README.md)
  - [Cloud SQL](./src/examples/storage/cloud-sql/README.md)
  - [Cloud Run Functions Qwik Start](./src/examples/cloud-run/cloud-run-functions-qwik-start/README.md)
  - [Pub/Sub with Cloud Run](./src/examples/cloud-run/pubsub-with-cloud-run/README.md)
  - [Configuring IAM with gcloud](./src/examples/iam/configuring-iam-with-gcloud/README.md)
  - [Exploring IAM](./src/examples/iam/exploring-iam/README.md)
  - [Configuring VPC](./src/examples/network/configuring-vpc/README.md)
  - [VPC Controlling Access](./src/examples/network/controlling-access/README.md)
  - [Multiple VPC Networks](./src/examples/network/multiple-vpc/README.md)
  - [Build a Secure Network - Challenge](./src/examples/network/build-secure-network-challenge/README.md)
  - [Automating Infrastructure Deployment With Terraform](./src/examples/terraform/automating-infrastructure-deployment/README.md)
  - [Build IaC with Terraform](./src/examples/terraform/build-iac-with-terraform/README.md)
  - [Alerting in GCP](./src/examples/monitoring-and-alerts/alerting-in-gcp/README.md)
  - [Service Monitoring](./src/examples/monitoring-and-alerts/service-monitoring/README.md)
  - [Log Analytics](./src/examples/monitoring-and-alerts/log-analytics/README.md)

### Estructura del repositorio

```
aws/
├── book/                    # Carpeta generada con el libro compilado
├── src/                     # Contenido del curso
│   ├── SUMMARY.md          # Índice del libro
│   ├── Clase 1.md          # Introducción a la nube
│   ├── images/             # Imágenes extraídas de las presentaciones
│   ├── presentations/      # PDFs originales de las presentaciones
│   └── examples/           # Ejemplos de código
├── book.toml               # Configuración de mdBook
└── README.md               # Este archivo
```

## Cómo usar este repositorio

### Para estudiar

1. **Visualizar el libro**: Accede al contenido en formato web ejecutando:
   ```bash
   mdbook serve
   ```
   Luego abre `http://localhost:3000` en tu navegador

2. **Leer offline**: Navega directamente por los archivos `.md` en el directorio `src/`

3. **Orden recomendado**: Sigue la secuencia de clases para un aprendizaje progresivo

### Para desarrolladores

- **Requisitos previos**: Instalar mdBook
  ```bash
  cargo install mdbook
  ```

- **Generar el libro**:
  ```bash
  mdbook build
  ```

### Para contribuir

- Si encontrás errores o mejoras, no dudes en crear un issue o pull request
- Las correcciones y ampliaciones son bienvenidas

## Temas principales


## Notas importantes

- Este material contiene las presentaciones del curso transcriptas a formato Markdown
- El contenido está actualizado con las prácticas y servicios de GCP vigentes en 2026
- Los PDFs originales se mantienen en `src/presentations/` para referencia
- Compatible con mdBook para una experiencia de lectura optimizada

---

**Docentes**: Rodrigo Pazos, Mora Villa Abrille  
**Materia**: GCP + AI Fundamentals
**Universidad**: Universidad Austral  
**Año**: 2026