[Link al lab](https://www.skills.google/paths/11/course_templates/178/labs/620321)

## Recursos identificados

- APIs/servicios involucrados: `Compute Engine`, `Cloud NAT`, `Cloud Router`, `Cloud Load Balancing`.
- Red y seguridad:
  - regla de firewall para health checks (`130.211.0.0/22`, `35.191.0.0/16`).
  - red `default`.
- Cómputo e imágenes:
  - VM base `webserver`.
  - imagen custom `mywebserver`.
  - instance template `mywebserver-template`.
  - managed instance groups multi-región (`us-central1`, `europe-west1`) con autoscaling.
- Health checks y balanceo:
  - health check `http-health-check`.
  - Application Load Balancer HTTP global (IPv4/IPv6) con backend services sobre MIG.
- Testing:
  - verificación de disponibilidad con `curl`.
  - stress test con `ab` (ApacheBench) desde VM `stress-test`.

## Comandos ejecutados

### Crear firewall rule para health checks
Permite que los health checks del load balancer lleguen a las VMs backend por `tcp:80`.
```bash
gcloud compute --project=qwiklabs-gcp-04-1059d35c6e27 firewall-rules create fw-allow-health-checks --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=130.211.0.0/22,35.191.0.0/16 --target-tags=allow-health-checks
```

### Actualizar paquetes en la VM webserver
Prepara la VM base antes de instalar Apache.
```bash
sudo apt-get update
```

### Iniciar Apache en la VM webserver
Levanta el servicio HTTP para validar la imagen base.
```bash
sudo service apache2 start
```

### Verificar respuesta local de Apache
Confirma que el servidor web responde en `localhost`.
```bash
curl localhost
```

### Habilitar Apache al boot
Deja Apache habilitado para que inicie automáticamente.
```bash
sudo update-rc.d apache2 enable
```

### Crear imagen custom desde disco de la VM
Genera `mywebserver` para usarla en el instance template.
```bash
gcloud compute images create mywebserver --project=qwiklabs-gcp-04-1059d35c6e27 --source-disk=webserver --source-disk-zone=us-central1-a --storage-location=us
```

### Crear instance template para los MIG
Define configuración homogénea de las instancias backend sin IP pública.
```bash
gcloud compute instance-templates create mywebserver-template --project=qwiklabs-gcp-04-1059d35c6e27 --machine-type=f1-micro --network-interface=network=default,no-address --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=425659184878-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=allow-health-checks --create-disk=auto-delete=yes,boot=yes,device-name=mywebserver-template,image=projects/qwiklabs-gcp-04-1059d35c6e27/global/images/mywebserver,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any
```

### Crear health check TCP para los MIG
Define el check usado para determinar backends saludables.
```bash
gcloud beta compute health-checks create tcp http-health-check --project=qwiklabs-gcp-04-1059d35c6e27 --port=80 --proxy-header=NONE --no-enable-logging --check-interval=5 --timeout=5 --unhealthy-threshold=2 --healthy-threshold=2
```

### Definir la IP del Load Balancer para pruebas
Guarda la IP pública del LB en una variable de entorno.
```bash
LB_IP=34.111.70.232
```

### Esperar hasta que el LB responda tráfico HTTP
Hace polling con `curl` hasta obtener respuesta válida.
```bash
while [ -z "$RESULT" ] ;
do
  echo "Waiting for Load Balancer";
  sleep 5;
  RESULT=$(curl -m1 -s $LB_IP | grep Apache);
done
```

### Definir variable de entorno con IP/URL del LB
Prepara la VM de stress test para enviar tráfico al balanceador.
```bash
export LB_IP=http://34.111.70.232/
```

### Redefinir variable LB_IP en formato host
Normaliza la variable para usarla con `ab`.
```bash
export LB_IP=34.111.70.232
```

### Verificar variable LB_IP
Confirma que la variable quedó seteada correctamente.
```bash
echo $LB_IP
```

### Ejecutar stress test con ApacheBench
Simula alta carga para observar balanceo y autoscaling.
```bash
ab -n 500000 -c 1000 http://$LB_IP/
```
