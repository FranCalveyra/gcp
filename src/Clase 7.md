# Terraform

> **IaC**: Infrastructure as Code. Describir la infraestructura en archivos versionables y aplicarla de forma automatizada, en vez de apretar botones a mano en la consola.

Las arquitecturas productivas se vuelven complicadas rápido: redes, VMs, buckets, functions, bases de datos, IAM. Llevar registro de todos los componentes y su estado configurándolos a mano tiene varios problemas:

- **Baja velocidad**: cada cambio depende de que alguien se acuerde del paso a paso.
- **Errores**: la consola te deja hacer cosas inconsistentes entre ambientes.
- **Downtime**: si rehacés algo mal, lo notan los usuarios.
- **Sin auditoría**: no queda registro claro de quién cambió qué ni por qué.

La idea de IaC es resolver todo esto describiendo la infraestructura como código. Un simple script que levante recursos ya es una forma (rudimentaria) de IaC: se puede versionar, correr varias veces y revisar en un PR.

## De Cloudformation a Terraform

- En **2011 AWS** creó [CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html): permitía declarar en JSON (hoy también YAML) cómo tenía que verse la infraestructura de un proyecto.
	- A partir de esa declaración AWS podía replicar toda la infra en segundos.
	- La limitación: solo habla con AWS.
- En **2014 Hashicorp** publica [Terraform](https://developer.hashicorp.com/terraform/intro), inicialmente open-source y hoy source-available (BSL).
	- Usa HCL (HashiCorp Configuration Language), más legible que JSON.
	- Es **agnóstico de cloud**: hay providers para GCP, AWS, Azure, Kubernetes, GitHub, Datadog, etc.
	- Adopción altísima, hoy es prácticamente el estándar de la industria para IaC multi-cloud.

## Terraform CLI

Terraform es una herramienta de línea de comandos con 4 comandos centrales que conviene tener presentes.

### `terraform init`
Prepara el ambiente local.

- Descarga los **providers** declarados (por ejemplo `hashicorp/google`).
- Trae los **módulos** externos referenciados.
- Deja todo preparado en `.terraform/` para poder armar planes.
- Es el primer comando que corremos en un proyecto nuevo o después de agregar un provider/módulo.

### `terraform plan`
Compara la declaración actual contra el estado real y propone qué hacer.

- Lee los `.tf`, consulta el **state** y habla con la API del cloud.
- Devuelve un plan con todas las acciones en un orden específico.
- Hay **4 operaciones válidas**:
	- **Create**: recurso nuevo.
	- **Update**: cambios in-place.
	- **Delete**: borrar un recurso existente.
	- **Replace**: destruir y volver a crear (típico cuando tocás un campo inmutable).
- Se puede persistir con `-out` para aplicarlo después:
	- `terraform plan -out=tfplan`

### `terraform apply`
Aplica el plan.

- Si le pasás un plan guardado (`terraform apply tfplan`), lo ejecuta tal cual.
- Si no, genera uno al vuelo, te lo muestra y pide confirmación.
- Ejecuta las operaciones respetando las dependencias del grafo de recursos.

### `terraform destroy`
Elimina todos los recursos gestionados por el proyecto.

- Lo hace en el orden inverso al de creación: primero las VMs, después las subnets, al final la VPC (al revés no es válido).
- Útil para tirar abajo ambientes de prueba sin dejar recursos huérfanos.

## El archivo `.tf`

La declaración vive en archivos con extensión `.tf` y usa HCL. Un ejemplo mínimo para GCP:

```hcl
provider "google" {
  project = "my-81bd"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      # Asigna una IP externa efímera
    }
  }
}
```

- El bloque `provider` configura el cloud destino y credenciales/región por defecto.
- Cada bloque `resource "<tipo>" "<nombre>"` describe un recurso concreto. El `<nombre>` es un identificador **local** del código, no el nombre del recurso en GCP.
- Los bloques anidados (`boot_disk`, `network_interface`) reflejan la estructura del recurso en la API.

## Cómo arma el plan Terraform

> Terraform tiene la inteligencia de mirar la declaración y el estado, y proponer un plan para ir del estado actual al deseado.

Pero la forma en la que llega a ese plan no siempre es la que queremos o anticipamos. El flujo mental es algo así:

![Flujo de armado de plan en Terraform](./images/Clase%207/slides/slide-10.png)

- Lee el archivo de configuración (`.tf`).
- Lee el **state**.
- Por cada recurso decide:
	- si no existe en el state ⇒ `Create()`
	- si existe ⇒ `Read()` contra la API y chequea conflictos
	- si está planeado para destrucción ⇒ `Delete()`
	- si no ⇒ `Update()`
- Con todas esas decisiones arma el plan final.

### Cuidado con los replace

- Un **recreate** no es gratuito si el estado actual del recurso importa.
	- Una VM con discos, datos locales o configuración manual se pierde.
	- Un bucket con objetos adentro no se puede recrear sin borrar todo.
- Muchos cambios parecen inofensivos pero tocan un **campo inmutable** (por ejemplo el `machine_type` de una VM en algunos escenarios, o el nombre de ciertos recursos).
- Terraform no conserva data dentro del recurso: si hay que hacer replace, destruye y crea uno nuevo, limpio.
- Por eso: **siempre leer el plan antes de aplicar**.

## State

> El **state** es la representación que Terraform tiene de la infraestructura actual. Es un JSON que mapea los recursos declarados con los recursos reales en el cloud.

- Todo plan depende del state: Terraform no vuelve a escanear todo el cloud cada vez, confía en el state.
- Si trato de aplicar un plan armado sobre un state viejo **inválido** (que no refleja el estado real), Terraform lo detecta y frena.
	- Ej: si tengo 2 VMs creadas y declaradas en mi `main.tf`, pero borro una a manopla, cuando quiera re-aplicar el plan, no voy a poder. Va a reventar todo por los aires.

> La desviación entre el estado de Terraform con el estado real se conoce como `drift`

### State local vs remoto

- **Local**: `terraform.tfstate` en el directorio del proyecto.
	- Funciona para jugar solo, rompe rápido en equipo.
	- Si dos personas tienen estados locales distintos, cada una va a proponer cambios inconsistentes.
- **Remoto**: el state vive en un backend compartido (por ejemplo un bucket de GCS, S3, Terraform Cloud).
	- Todos trabajan sobre el mismo state.
	- Se puede combinar con **locking** para impedir dos escrituras simultáneas tanto al state como al cloud real.
- Incluso con state remoto, sin locking podés tener **condiciones de carrera** entre dos `apply` corriendo al mismo tiempo.

## Buenas prácticas

- **Nunca apliquen un plan sin revisarlo antes.**
	- El `plan` es la herramienta de seguridad principal de Terraform.
	- Mirar especialmente los `-` (destroy) y los `-/+` (replace).
- Versionar los `.tf` en Git y revisar cambios por PR.
- Usar **state remoto con locking** apenas hay más de una persona tocando el proyecto.
- Separar ambientes (`dev`, `stg`, `prod`) en workspaces, carpetas o proyectos distintos.
- No editar recursos administrados por Terraform desde la consola: drift asegurado.

## Links útiles
- [Terraform: introducción oficial](https://developer.hashicorp.com/terraform/intro)
- [Google Cloud Provider para Terraform](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Comandos de Terraform CLI](https://developer.hashicorp.com/terraform/cli/commands)
- [State de Terraform](https://developer.hashicorp.com/terraform/language/state)
- [Backends remotos](https://developer.hashicorp.com/terraform/language/backend)
- [AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)

> La mayoría de las herramientas de IaC son **transaccionales**. Si falla una operación, no se hace ninguna dentro del plan de la IaC tool.