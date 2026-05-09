[Link al lab](https://www.skills.google/focuses/22772?parent=catalog)

## Recursos identificados

- APIs habilitadas o implícitas: `compute.googleapis.com`.
- Redes principales: `managementnet` y `privatenet` como custom mode; `mynetwork` ya preexistente en el lab.
- Subredes creadas o usadas:
  - `managementsubnet-1` en `managementnet` con `10.130.0.0/20`
  - `privatesubnet-1` en `privatenet` con `172.16.0.0/24`
  - `privatesubnet-2` en `privatenet` con `172.20.0.0/20`
  - subredes automáticas de `mynetwork` en las regiones del lab
- Firewall rules relevantes:
  - `managementnet-allow-icmp-ssh-rdp`
  - `privatenet-allow-icmp-ssh-rdp`
  - reglas preexistentes en `mynetwork`
- Instancias creadas o usadas:
  - `managementnet-vm-1`
  - `privatenet-vm-1`
  - `mynet-vm-1`
  - `mynet-vm-2`
  - `vm-appliance` con múltiples NICs
- IAM relevante: no se crea IAM específico en este lab.
- Integraciones: SSH a VMs, resolución DNS interna entre instancias, múltiples interfaces de red y análisis de rutas con `ip route`.

## Comandos ejecutados

En los comandos siguientes, reemplazá `<REGION_1>`, `<REGION_2>`, `<ZONE_1>`, `<MYNET_VM_2_EXTERNAL_IP>`, `<MANAGEMENT_VM_EXTERNAL_IP>`, `<PRIVATE_VM_EXTERNAL_IP>`, `<MYNET_VM_2_INTERNAL_IP>`, `<MANAGEMENT_VM_INTERNAL_IP>`, `<PRIVATE_VM_INTERNAL_IP>`, `<PRIVATE_VM_1_INTERNAL_IP>`, `<MYNET_VM_1_INTERNAL_IP>` y `<MYNET_VM_2_INTERNAL_IP>` por los valores de tu lab.

### Verificar autenticación y proyecto activo

```bash
gcloud auth list
gcloud config list project
```

### Crear la red `privatenet`

```bash
gcloud compute networks create privatenet --subnet-mode=custom
gcloud compute networks subnets create privatesubnet-1 --network=privatenet --region=<REGION_1> --range=172.16.0.0/24
gcloud compute networks subnets create privatesubnet-2 --network=privatenet --region=<REGION_2> --range=172.20.0.0/20
```

### Listar redes y subredes disponibles

```bash
gcloud compute networks list
gcloud compute networks subnets list --sort-by=NETWORK
```

### Crear el firewall de `privatenet`

```bash
gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0
```

### Listar firewall rules

```bash
gcloud compute firewall-rules list --sort-by=NETWORK
```

### Crear la VM `privatenet-vm-1`

```bash
gcloud compute instances create privatenet-vm-1 --zone=<ZONE_1> --machine-type=e2-micro --subnet=privatesubnet-1
```

### Listar instancias

```bash
gcloud compute instances list --sort-by=ZONE
```

### Probar ping a IPs externas

```bash
ping -c 3 '<MYNET_VM_2_EXTERNAL_IP>'
ping -c 3 '<MANAGEMENT_VM_EXTERNAL_IP>'
ping -c 3 '<PRIVATE_VM_EXTERNAL_IP>'
```

### Probar ping a IPs internas desde `mynet-vm-1`

```bash
ping -c 3 '<MYNET_VM_2_INTERNAL_IP>'
ping -c 3 '<MANAGEMENT_VM_INTERNAL_IP>'
ping -c 3 '<PRIVATE_VM_INTERNAL_IP>'
```

### Inspeccionar interfaces dentro de `vm-appliance`

```bash
sudo ifconfig
```

### Probar conectividad desde `vm-appliance`

```bash
ping -c 3 '<PRIVATE_VM_1_INTERNAL_IP>'
ping -c 3 privatenet-vm-1
ping -c 3 '<MANAGEMENT_VM_INTERNAL_IP>'
ping -c 3 '<MYNET_VM_1_INTERNAL_IP>'
ping -c 3 '<MYNET_VM_2_INTERNAL_IP>'
```

### Ver tabla de ruteo en `vm-appliance`

```bash
ip route
```
