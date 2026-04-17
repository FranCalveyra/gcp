[Link al lab](https://www.skills.google/catalog_lab/2058)

## Recursos identificados

- Contexto del lab:
  - 2 proyectos temporales (`PROJECTID1`, `PROJECTID2`).
  - 2 identidades humanas (`Username1`, `Username2`).
  - 2 configuraciones locales de `gcloud`: `default` y `user2`.
- APIs/servicios principales:
  - `Compute Engine`
  - `Identity and Access Management (IAM)`
  - políticas IAM a nivel proyecto
- Recursos de compute:
  - VM existente `centos-clean`
  - VMs creadas o probadas durante el lab: `lab-1`, `lab-2`, `lab-3`, `lab-4`
  - red y subred por defecto del proyecto/lab
- Recursos IAM en el segundo proyecto:
  - binding `roles/viewer` para `Username2`
  - rol custom `projects/$PROJECTID2/roles/devops`
  - binding `roles/iam.serviceAccountUser` para `Username2`
- Recursos de service account:
  - service account `devops`
  - binding `roles/iam.serviceAccountUser` para la service account
  - binding `roles/compute.instanceAdmin` para la service account
  - VM `lab-3` con la service account adjunta
- Archivos/config local usados durante la práctica:
  - `~/.config/gcloud/configurations/config_default`
  - `~/.bashrc` para exportar `PROJECTID2`, `USERID2` y `SA`

## Comandos ejecutados

### Verificar que `gcloud` ya esta instalado
Se usa para confirmar el entorno inicial dentro de la VM `centos-clean`.
```bash
gcloud --version
```

### Autenticar `gcloud` y definir region/zona por defecto
Se usa para iniciar sesion y dejar seteada la ubicacion por defecto del primer proyecto.
```bash
gcloud auth login
gcloud config set compute/region <REGION_1>
gcloud config set compute/zone <ZONE_1>
```

### Crear la primera VM del lab
Se usa para crear `lab-1` en el proyecto inicial.
```bash
gcloud compute instances create lab-1 \
  --zone <ZONE_1> \
  --machine-type=e2-standard-2
```

### Revisar configuracion activa y zonas disponibles
Se usa para inspeccionar defaults actuales y elegir otra zona en la misma region.
```bash
gcloud config list
gcloud compute zones list
```

### Cambiar la zona por defecto
Se usa para demostrar que `gcloud` persiste configuraciones locales.
```bash
gcloud config set compute/zone <ZONE_MISMA_REGION>
gcloud config list
```

### Inspeccionar el archivo de configuracion local
Se usa para validar que la configuracion se guarda como texto plano.
```bash
cat ~/.config/gcloud/configurations/config_default
```

### Crear una segunda configuracion de `gcloud`
Se usa para preparar un contexto separado para `Username2`.
```bash
gcloud init --no-launch-browser
```

### Probar acceso de solo lectura con `user2`
Se usa para comprobar que `user2` puede listar instancias pero no crearlas todavia.
```bash
gcloud compute instances list
gcloud compute instances create lab-2 \
  --zone <ZONE_2> \
  --machine-type=e2-standard-2
gcloud config configurations activate default
```

### Listar roles IAM disponibles
Se usa para revisar roles predefinidos desde CLI.
```bash
gcloud iam roles list | grep "name:"
```

### Inspeccionar permisos del rol `compute.instanceAdmin`
Se usa para identificar el set minimo de permisos que despues se reutiliza en el rol custom.
```bash
gcloud iam roles describe roles/compute.instanceAdmin
```

### Cambiar a `user2` y apuntar al segundo proyecto
Se usa para mostrar que inicialmente `user2` no tiene acceso sobre `PROJECTID2`.
```bash
gcloud config configurations activate user2
echo "export PROJECTID2=<PROJECT_ID_2>" >> ~/.bashrc
. ~/.bashrc
gcloud config set project $PROJECTID2
```

### Volver a la configuracion admin e instalar `jq`
Se usa para volver al usuario con permisos y preparar utilidades locales.
```bash
gcloud config configurations activate default
sudo yum -y install epel-release
sudo yum -y install jq
```

### Exportar `USERID2` y dar rol Viewer en el segundo proyecto
Se usa para habilitar acceso de lectura de `Username2` sobre `PROJECTID2`.
```bash
echo "export USERID2=<USERNAME_2>" >> ~/.bashrc
. ~/.bashrc
gcloud projects add-iam-policy-binding $PROJECTID2 \
  --member user:$USERID2 \
  --role=roles/viewer
```

### Validar acceso Viewer de `user2` en el segundo proyecto
Se usa para comprobar que puede listar recursos pero sigue sin poder crear VMs.
```bash
gcloud config configurations activate user2
gcloud config set project $PROJECTID2
gcloud compute instances list
gcloud compute instances create lab-2 \
  --zone <ZONE_2> \
  --machine-type=e2-standard-2
gcloud config configurations activate default
```

### Crear un rol custom para el equipo DevOps
Se usa para encapsular permisos de administracion de instancias en un rol propio del proyecto.
```bash
gcloud iam roles create devops \
  --project $PROJECTID2 \
  --permissions "compute.instances.create,compute.instances.delete,compute.instances.start,compute.instances.stop,compute.instances.update,compute.disks.create,compute.subnetworks.use,compute.subnetworks.useExternalIp,compute.instances.setMetadata,compute.instances.setServiceAccount"
```

### Dar a `user2` el rol `iam.serviceAccountUser`
Se usa para permitir que `user2` pueda crear instancias con una service account adjunta.
```bash
gcloud projects add-iam-policy-binding $PROJECTID2 \
  --member user:$USERID2 \
  --role=roles/iam.serviceAccountUser
```

### Vincular el rol custom `devops` a `user2`
Se usa para completar el set de permisos necesarios para operar Compute Engine en `PROJECTID2`.
```bash
gcloud projects add-iam-policy-binding $PROJECTID2 \
  --member user:$USERID2 \
  --role=projects/$PROJECTID2/roles/devops
```

### Verificar que `user2` ahora puede crear `lab-2`
Se usa para confirmar que los nuevos bindings IAM ya tienen efecto.
```bash
gcloud config configurations activate user2
gcloud compute instances create lab-2 \
  --zone <ZONE_2> \
  --machine-type=e2-standard-2
gcloud compute instances list
```

### Volver al usuario admin y crear la service account `devops`
Se usa para preparar el escenario de automatizacion con service accounts.
```bash
gcloud config configurations activate default
gcloud config set project $PROJECTID2
gcloud iam service-accounts create devops --display-name devops
gcloud iam service-accounts list --filter "displayName=devops"
SA=$(gcloud iam service-accounts list --format="value(email)" --filter "displayName=devops")
```

### Dar `iam.serviceAccountUser` a la service account
Se usa para permitir que la service account pueda asociarse a instancias.
```bash
gcloud projects add-iam-policy-binding $PROJECTID2 \
  --member serviceAccount:$SA \
  --role=roles/iam.serviceAccountUser
```

### Dar `compute.instanceAdmin` a la service account
Se usa para que la identidad de servicio pueda administrar instancias.
```bash
gcloud projects add-iam-policy-binding $PROJECTID2 \
  --member serviceAccount:$SA \
  --role=roles/compute.instanceAdmin
```

### Crear `lab-3` con la service account adjunta
Se usa para montar una VM que hereda permisos via IAM de la service account.
```bash
gcloud compute instances create lab-3 \
  --zone <ZONE_2> \
  --machine-type=e2-standard-2 \
  --service-account $SA \
  --scopes "https://www.googleapis.com/auth/compute"
```

### Conectarse a `lab-3` y probar permisos de la service account
Se usa para validar desde dentro de la VM que la identidad adjunta puede operar sobre Compute Engine.
```bash
gcloud compute ssh lab-3 --zone <ZONE_2>
gcloud config list
gcloud compute instances create lab-4 \
  --zone <ZONE_2> \
  --machine-type=e2-standard-2
gcloud compute instances list
```
