[Link al lab](https://www.skills.google/paths/11/course_templates/49/labs/619646)

## Recursos identificados

- Servicio principal: `Cloud SQL` (instancia MySQL `wordpress-db`).
- Red y conectividad:
  - conexión por proxy (`cloud_sql_proxy`) sobre `127.0.0.1:3306`.
  - conexión por `Private IP` (internal IP de Cloud SQL).
- Compute Engine:
  - VM `wordpress-proxy`.
  - VM `wordpress-private-ip`.
- Base de datos:
  - DB `wordpress`.
- Aplicación:
  - WordPress conectado a Cloud SQL por dos métodos (proxy e internal IP).

## Comandos ejecutados

### Descargar Cloud SQL Auth Proxy y dar permisos de ejecución
Se usa para instalar el binario del proxy en la VM `wordpress-proxy`.
```bash
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy && chmod +x cloud_sql_proxy
```

### Guardar el connection name de Cloud SQL en variable
Se usa para reutilizar el identificador de instancia en los comandos del proxy.
```bash
export SQL_CONNECTION=[SQL_CONNECTION_NAME]
```

### Verificar la variable SQL_CONNECTION
Se usa para confirmar que la variable quedó correctamente seteada.
```bash
echo $SQL_CONNECTION
```

### Iniciar Cloud SQL Proxy en background
Se usa para abrir un túnel local seguro hacia la instancia Cloud SQL.
```bash
./cloud_sql_proxy -instances=$SQL_CONNECTION=tcp:3306 &
```

### Obtener external IP de la VM desde metadata server
Se usa para abrir WordPress en el navegador y completar configuración inicial.
```bash
curl -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip && echo
```
