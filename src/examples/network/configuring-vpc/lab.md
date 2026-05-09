[Link al lab](https://www.skills.google/focuses/19172?parent=catalog)

## Recursos identificados

- APIs habilitadas: `compute.googleapis.com`.
- Red principal: VPC auto mode `mynetwork`, con subnetworks automáticas por región dentro del rango `10.128.0.0/9`.
- Instancias usadas en el lab: `default-vm-1`, `mynet-vm-1` y `mynet-vm-2`.
- Firewall rules observadas o creadas: reglas `default-allow-*` de la red `default`, `mynetwork-ingress-allow-ssh-from-cs`, `mynetwork-ingress-allow-icmp-internal`, `mynetwork-ingress-deny-icmp-all` y `mynetwork-egress-deny-icmp-all`.
- Etiquetas relevantes: `lab-ssh` para limitar el acceso SSH a las VMs objetivo.
- IAM relevante: no se crea IAM explícito; el lab usa las credenciales temporales del proyecto y los permisos ya otorgados.
- Integraciones: Cloud Shell como cliente SSH, `curl` a `api.ipify.org` para descubrir la IP pública y resolución DNS interna entre VMs.

## Comandos ejecutados

En los comandos siguientes, reemplazá `<ZONE_1>`, `<ZONE_2>` y `<EXTERNAL_IP_MYNET_VM_2>` por los valores de tu lab.

### Verificar autenticación y proyecto activo

```bash
gcloud auth list
gcloud config list project
```

### Crear la VPC auto mode del lab

```bash
gcloud compute networks create mynetwork --subnet-mode=auto
```

### Crear las instancias de prueba

```bash
gcloud compute instances create default-vm-1 \
  --machine-type e2-micro \
  --zone=<ZONE_1> \
  --network=default

gcloud compute instances create mynet-vm-1 \
  --machine-type e2-micro \
  --zone=<ZONE_1> \
  --network=mynetwork

gcloud compute instances create mynet-vm-2 \
  --machine-type e2-micro \
  --zone=<ZONE_2> \
  --network=mynetwork
```

### Probar SSH sin reglas personalizadas

```bash
gcloud compute ssh qwiklabs@mynet-vm-2 --zone <ZONE_2>
```

### Obtener la IP pública de Cloud Shell

```bash
ip=$(curl -s https://api.ipify.org)
echo "My External IP address is: $ip"
```

### Permitir SSH desde Cloud Shell

```bash
gcloud compute firewall-rules create \
  mynetwork-ingress-allow-ssh-from-cs \
  --network mynetwork \
  --action ALLOW \
  --direction INGRESS \
  --rules tcp:22 \
  --source-ranges $ip \
  --target-tags=lab-ssh
```

### Asociar el tag `lab-ssh` a las VMs

```bash
gcloud compute instances add-tags mynet-vm-2 \
  --zone <ZONE_2> \
  --tags lab-ssh

gcloud compute instances add-tags mynet-vm-1 \
  --zone <ZONE_1> \
  --tags lab-ssh
```

### Validar conectividad SSH luego de abrir el firewall

```bash
gcloud compute ssh qwiklabs@mynet-vm-2 --zone <ZONE_2>
exit
gcloud compute ssh qwiklabs@mynet-vm-1 --zone <ZONE_1>
```

### Probar ping interno entre VMs

```bash
ping mynet-vm-2.<ZONE_2>
```

### Permitir ICMP interno dentro de la VPC

```bash
gcloud compute firewall-rules create \
  mynetwork-ingress-allow-icmp-internal \
  --network mynetwork \
  --action ALLOW \
  --direction INGRESS \
  --rules icmp \
  --source-ranges 10.128.0.0/9
```

### Repetir la prueba de ping interno

```bash
ping mynet-vm-2.<ZONE_2>
```

### Verificar que el ping a la IP externa siga bloqueado

```bash
ping <EXTERNAL_IP_MYNET_VM_2>
```

### Crear una regla deny de ICMP con prioridad mayor

```bash
gcloud compute ssh qwiklabs@mynet-vm-1 --zone <ZONE_1>
ping mynet-vm-2.<ZONE_2>

gcloud compute firewall-rules create \
  mynetwork-ingress-deny-icmp-all \
  --network mynetwork \
  --action DENY \
  --direction INGRESS \
  --rules icmp \
  --priority 500

ping mynet-vm-2.<ZONE_2>
```

### Bajar la prioridad de la regla deny

```bash
gcloud compute firewall-rules update \
  mynetwork-ingress-deny-icmp-all \
  --priority 2000

ping mynet-vm-2.<ZONE_2>
```

### Inspeccionar las reglas de firewall de la red

```bash
gcloud compute firewall-rules list --filter="network:mynetwork"
```

### Bloquear ICMP saliente

```bash
gcloud compute firewall-rules create \
  mynetwork-egress-deny-icmp-all \
  --network mynetwork \
  --action DENY \
  --direction EGRESS \
  --rules icmp \
  --priority 10000

gcloud compute firewall-rules list --filter="network:mynetwork"
ping mynet-vm-2.<ZONE_2>
```
