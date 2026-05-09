[Link al lab](https://www.skills.google/focuses/19098?parent=catalog)

## Recursos identificados

- APIs y providers:
  - Terraform provider: `hashicorp/google`.
  - API principal utilizada por los recursos: `Compute Engine API` (`compute.googleapis.com`).
- Recursos principales:
  - VPC auto mode: `mynetwork` (`google_compute_network`).
  - Firewall rule: `mynetwork-allow-http-ssh-rdp-icmp` (`google_compute_firewall`).
  - VM instances: `mynet-vm-1` y `mynet-vm-2` (`google_compute_instance`).
- IAM:
  - Se usa la identidad del proyecto/lab en Cloud Shell para aprovisionar recursos (sin creación explícita de service accounts en el flujo base).
- Integraciones:
  - Módulo Terraform reutilizable para instancias (`source = "./instance"` en el lab original).
  - Referencias entre recursos para dependencia implícita (por ejemplo `google_compute_network.mynetwork.self_link`).

## Comandos ejecutados

### Verificar Terraform instalado
```bash
terraform --version
```

### Crear carpeta de trabajo Terraform
```bash
mkdir tfinfra
```

### Inicializar Terraform en la carpeta del lab
```bash
cd tfinfra
terraform init
```

### Formatear configuración Terraform
```bash
terraform fmt
```

### Inicializar nuevamente luego de crear módulos y archivos
```bash
terraform init
```

### Revisar plan de infraestructura
```bash
terraform plan
```

### Aplicar cambios de infraestructura
```bash
terraform apply
```

### Confirmar aplicación del plan
```bash
yes
```

### Verificar conectividad entre VMs por IP interna
```bash
ping -c 3 <Enter mynet-vm-2's internal IP here>
```
