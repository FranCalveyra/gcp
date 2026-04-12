# Cloud Shell
Es un recurso análogo al CLI de AWS. Básicamente te permite interactuar con todos los recursos de GCP pero desde una terminal.

## Prerrequisitos 
- Tener, justamente, la herramienta instalada en tu sistema. Si no la tenés, [buscala acá](https://docs.cloud.google.com/sdk/docs/install-sdk)

## Ejemplos
He aquí algunos ejemplos de lo que se puede hacer:
### Verificar la cuenta activa
```bash
gcloud auth list
```

### Listar los proyectos existentes a los cuales la cuenta tiene acceso
```bash
gcloud config list project
```

### Setear la región default
```bash
gcloud config set compute/region <REGION>
```

### Crear una instancia de una VM en una zona particular
```bash
gcloud compute instances create gcelab2 --machine-type e2-medium --zone=$ZONE
```
- Notar que se crea con el nombre `gcelab2` y es de tipo `e2-medium`

### Conectarte por SSH a una instancia ya creada
```
gcloud compute ssh gcelab2 --zone=<ZONE>
```
- Hay que pasarle la zona por parámetro

### Crear un cluster de máquinas y asignarlas a una Target Pool
Vamos a crear máquinas con los nombres `www1`, `www2` y `www3`.
```bash
  gcloud compute instances create www1 \
    --zone=$ZONE \
    --tags=network-lb-tag \
    --machine-type=e2-small \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata=startup-script='#!/bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo "
<h3>Web Server: www1</h3>" | tee /var/www/html/index.html'
```

```bash
  gcloud compute instances create www2 \
    --zone=$ZONE \
    --tags=network-lb-tag \
    --machine-type=e2-small \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata=startup-script='#!/bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo "
<h3>Web Server: www2</h3>" | tee /var/www/html/index.html'
```


```bash
  gcloud compute instances create www3 \
    --zone=$ZONE \
    --tags=network-lb-tag \
    --machine-type=e2-small \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata=startup-script='#!/bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo "
<h3>Web Server: www3</h3>" | tee /var/www/html/index.html'
```

Para poder usarlas, tenemos que crear una **regla de firewall** para poder permitir el tráfico hacia estas máquinas:

```bash
gcloud compute firewall-rules create www-firewall-network-lb \
    --target-tags network-lb-tag --allow tcp:80
```

Ahora, necesitamos crear una target pool y asignar esas instancias para que el NLB pueda accederlas
- Crear la target pool
```bash
gcloud compute target-pools create www-pool \
  --region Region --http-health-check basic-check
```
- Asignar las instancias a esa pool
```bash
gcloud compute target-pools add-instances www-pool \
    --instances www1,www2,www3
```
Por último, para poder interactuar con esas instancias a través del NLB, necesitamos agregar una forwarding rule:

```bash
gcloud compute forwarding-rules create www-rule \
    --region  Region \
    --ports 80 \
    --address network-lb-ip-1 \
    --target-pool www-pool
```

## Definir reglas de firewall
```bash
gcloud compute firewall-rules create allow-ssh-clase \
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:22 \
  --source-ranges=181.20.10.5/32 \ # solo los admins pueden conectarse por SSH desde esta IP
  --target-tags=ssh-admin
```

```bash
gcloud compute firewall-rules create allow-http-public \
  --direction=INGRESS \
  --priority=1000 \
  --network=tu-vpc-pro \ # Esto es una red particular
  --action=ALLOW \
  --rules=tcp:80 \
  --source-ranges=0.0.0.0/0 \ # permito todo el tráfico HTTP
  --target-tags=web-frontend
```

```bash
gcloud compute firewall-rules create block-attacker \
  --direction=INGRESS \
  --priority=100 \
  --network=default \
  --action=DENY \
  --rules=all \
  --source-ranges=190.0.0.0/8 # bloqueo todo el tráfico dentro de este source range
```