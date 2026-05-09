[Link al lab](https://www.skills.google/focuses/1231?parent=catalog)

## Recursos identificados

- APIs habilitadas o implícitas: `compute.googleapis.com`, `iam.googleapis.com`.
- Red usada por el lab: VPC `default`.
- Instancias principales: `blue`, `green` y `test-vm`.
- Firewall rules relevantes: `default-allow-internal`, `allow-http-web-server`.
- Tags relevantes: `web-server` aplicado a `blue`.
- IAM relevante: service account `Network-admin`, rol `Compute Network Admin`, luego `Compute Security Admin`.
- Integraciones: acceso por SSH a VMs, `curl` para validar HTTP interno/externo y activación de credenciales de service account con archivo `credentials.json`.

## Comandos ejecutados

En los comandos siguientes, reemplazá `<ZONE>`, `<BLUE_INTERNAL_IP>`, `<GREEN_INTERNAL_IP>`, `<BLUE_EXTERNAL_IP>` y `<GREEN_EXTERNAL_IP>` por los valores de tu lab.

### Verificar autenticación y proyecto activo

```bash
gcloud auth list
gcloud config list project
```

### Instalar nginx en `blue`

```bash
sudo apt-get install nginx-light -y
sudo nano /var/www/html/index.nginx-debian.html
cat /var/www/html/index.nginx-debian.html
exit
```

### Instalar nginx en `green`

```bash
sudo apt-get install nginx-light -y
sudo nano /var/www/html/index.nginx-debian.html
cat /var/www/html/index.nginx-debian.html
exit
```

### Crear la VM de prueba

```bash
gcloud compute instances create test-vm --machine-type=e2-micro --subnet=default --zone=<ZONE>
```

### Probar conectividad HTTP interna

```bash
curl <BLUE_INTERNAL_IP>
curl -c 3 <GREEN_INTERNAL_IP>
```

### Probar conectividad HTTP externa

```bash
curl <BLUE_EXTERNAL_IP>
curl -c 3 <GREEN_EXTERNAL_IP>
```

### Verificar permisos insuficientes con la service account por defecto

```bash
gcloud compute firewall-rules list
gcloud compute firewall-rules delete allow-http-web-server
```

### Activar la service account subida manualmente al VM

```bash
gcloud auth activate-service-account --key-file credentials.json
```

### Verificar permisos con `Compute Network Admin`

```bash
gcloud compute firewall-rules list
gcloud compute firewall-rules delete allow-http-web-server
```

### Verificar permisos con `Compute Security Admin`

```bash
gcloud compute firewall-rules list
gcloud compute firewall-rules delete allow-http-web-server
```

### Confirmar que el acceso HTTP externo deja de funcionar tras borrar la regla

```bash
curl -c 3 <BLUE_EXTERNAL_IP>
```
