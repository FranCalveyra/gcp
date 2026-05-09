[Link al lab](https://www.skills.google/focuses/19082?parent=catalog)

## Recursos identificados

- APIs/servicios involucrados: `IAM`, `Cloud Storage`, `Compute Engine`, `Service Accounts`.
- Principales identidades:
  - `Username 1` con permisos de administración del proyecto.
  - `Username 2` con acceso inicial de lectura al proyecto y luego acceso acotado a Cloud Storage.
  - principal externo `altostrat.com` usado para practicar grants de `Service Account User` y `Compute Instance Admin (v1)`.
- Almacenamiento:
  - bucket de Cloud Storage multi-region con un objeto de prueba `sample.txt`.
- IAM:
  - remoción del acceso de proyecto para `Username 2`.
  - grant de `Storage Object Viewer` para validar acceso restringido.
  - service account `read-bucket-objects`.
  - cambio de permisos del service account desde `Storage Object Viewer` a `Storage Object Creator`.
- Cómputo:
  - VM `demoiam` en Compute Engine.
  - imagen `Debian GNU/Linux 12 (bookworm)`.
  - machine type `e2-micro`.
  - service account `read-bucket-objects` adjunta a la VM con scope de Storage.
- Validaciones del lab:
  - listado de objetos del bucket desde Cloud Shell con permisos limitados.
  - pruebas de lectura/escritura al bucket desde SSH en la VM.

## Comandos ejecutados

### Listar el contenido del bucket con el segundo usuario
Verifica que `Username 2` tenga acceso restringido a Cloud Storage sin recuperar acceso completo al proyecto.
```bash
gcloud storage ls gs://[YOUR_BUCKET_NAME]
```

### Probar acceso a Compute Engine desde la VM
Se ejecuta desde la VM `demoiam` para comprobar que la identidad adjunta no puede listar instancias.
```bash
gcloud compute instances list
```

### Descargar el archivo de prueba desde el bucket
La copia se hace desde la VM usando el service account adjunto.
```bash
gcloud storage cp gs://[YOUR_BUCKET_NAME]/sample.txt .
```

### Renombrar el archivo descargado
Prepara un segundo nombre para probar la escritura sobre el bucket.
```bash
mv sample.txt sample2.txt
```

### Intentar subir el archivo renombrado sin permisos de escritura
Antes de cambiar el rol del service account, esta operación devuelve `403 AccessDeniedException`.
```bash
gcloud storage cp sample2.txt gs://[YOUR_BUCKET_NAME]
```

### Reintentar la subida después de otorgar `Storage Object Creator`
Luego de actualizar el rol del service account, la misma copia pasa a funcionar.
```bash
gcloud storage cp sample2.txt gs://[YOUR_BUCKET_NAME]
```
[Link al lab](https://www.skills.google/focuses/19082?parent=catalog)

## Recursos identificados

- APIs/servicios involucrados: `IAM`, `Cloud Storage`, `Compute Engine`, `Service Accounts`, `Cloud Shell`.
- Principales IAM del ejercicio:
  - `Username 1` como administrador del proyecto temporal del lab.
  - `Username 2`, que pasa de tener `Viewer` a no tener acceso al proyecto y luego recibe acceso acotado a Cloud Storage.
  - un principal de ejemplo sobre `altostrat.com` para practicar `Service Account User` y `Compute Instance Admin (v1)`.
- Cloud Storage:
  - bucket con nombre globalmente único y ubicación multi-región.
  - objeto `sample.txt` para probar lectura y escritura.
- Compute e identidad:
  - service account `read-bucket-objects`.
  - VM `demoiam` (`e2-micro`, Debian 12) usando esa service account.
  - scope de Storage `Read Write` en la VM para probar acceso desde SSH.
- Roles relevantes:
  - remoción del acceso de proyecto para `Username 2`.
  - `roles/storage.objectViewer` para `Username 2`.
  - `roles/storage.objectViewer` y luego `roles/storage.objectCreator` sobre la service account `read-bucket-objects`.
  - `roles/iam.serviceAccountUser` sobre la service account.
  - `roles/compute.instanceAdmin.v1` a nivel proyecto.

## Comandos ejecutados

### Listar el bucket desde Cloud Shell como `Username 2`
Verifica que el usuario sin acceso al proyecto igual pueda inspeccionar objetos si tiene permisos puntuales sobre Cloud Storage.
```bash
gcloud storage ls gs://[YOUR_BUCKET_NAME]
```

### Intentar listar instancias desde la VM `demoiam`
Prueba el alcance efectivo de la service account adjunta a la VM y sus scopes.
```bash
gcloud compute instances list
```

### Copiar `sample.txt` desde el bucket hacia la VM
Descarga el archivo de prueba usando las credenciales de la service account.
```bash
gcloud storage cp gs://[YOUR_BUCKET_NAME]/sample.txt .
```

### Renombrar el archivo descargado
Prepara un nuevo nombre local para probar la subida posterior.
```bash
mv sample.txt sample2.txt
```

### Intentar subir `sample2.txt` sin permiso de creación
Este paso falla mientras la service account solo tenga permisos de lectura.
```bash
gcloud storage cp sample2.txt gs://[YOUR_BUCKET_NAME]
```

### Reintentar la subida después de otorgar `Storage Object Creator`
Vuelve a ejecutar la copia una vez ajustado el rol de la service account.
```bash
gcloud storage cp sample2.txt gs://[YOUR_BUCKET_NAME]
```
