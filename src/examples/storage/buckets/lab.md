[Link al lab](https://www.skills.google/focuses/19083?parent=catalog)

## Recursos identificados

- Servicio principal: `Cloud Storage`.
- Recursos de storage:
  - bucket principal (`BUCKET_NAME_1`).
  - objetos (`setup.html`, `setup2.html`, `setup3.html` y versiones).
- Seguridad y acceso:
  - ACLs de objeto (`private`, `AllUsers:R`).
  - CSEK (Customer-supplied encryption keys) vía `.boto`.
  - rotación de claves CSEK.
- Gobierno del dato:
  - lifecycle policy (delete por edad).
  - versioning de bucket.
- Operaciones de datos:
  - sincronización recursiva con `gsutil rsync`.

## Comandos ejecutados

### Definir nombre de bucket en variable
Se usa para reutilizar el nombre del bucket durante todo el lab.
```bash
export BUCKET_NAME_1=<enter bucket name 1 here>
```

### Verificar variable del bucket
Se usa para confirmar que `BUCKET_NAME_1` quedó bien seteada.
```bash
echo $BUCKET_NAME_1
```

### Descargar archivo de muestra
Se usa para bajar `setup.html` y trabajar con objetos de prueba.
```bash
curl \
https://hadoop.apache.org/docs/current/\
hadoop-project-dist/hadoop-common/\
ClusterSetup.html > setup.html
```

### Crear copias locales del archivo
Se usa para tener múltiples objetos para pruebas de cifrado/versionado.
```bash
cp setup.html setup2.html
cp setup.html setup3.html
```

### Subir archivo al bucket
Se usa para cargar el primer objeto al bucket.
```bash
gcloud storage cp setup.html gs://$BUCKET_NAME_1/
```

### Exportar ACL actual del objeto
Se usa para inspeccionar permisos actuales del objeto.
```bash
gsutil acl get gs://$BUCKET_NAME_1/setup.html > acl.txt
cat acl.txt
```

### Forzar ACL privada en el objeto
Se usa para restringir acceso a modo privado y validar resultado.
```bash
gsutil acl set private gs://$BUCKET_NAME_1/setup.html
gsutil acl get gs://$BUCKET_NAME_1/setup.html > acl2.txt
cat acl2.txt
```

### Hacer objeto público por ACL
Se usa para habilitar lectura pública del objeto.
```bash
gsutil acl ch -u AllUsers:R gs://$BUCKET_NAME_1/setup.html
gsutil acl get gs://$BUCKET_NAME_1/setup.html > acl3.txt
cat acl3.txt
```

### Borrar archivo local
Se usa para validar recuperación desde bucket.
```bash
rm setup.html
```

### Listar archivos locales
Se usa para verificar que `setup.html` fue eliminado.
```bash
ls
```

### Recuperar objeto desde bucket
Se usa para copiar nuevamente `setup.html` al entorno local.
```bash
gcloud storage cp gs://$BUCKET_NAME_1/setup.html setup.html
```

### Generar clave CSEK
Se usa para crear una clave AES-256 base64 para cifrado del lado cliente.
```bash
python3 -c 'import base64; import os; print(base64.encodebytes(os.urandom(32)))'
```

### Abrir configuración gsutil (.boto)
Se usa para configurar `encryption_key` y/o `decryption_key`.
```bash
ls -al
nano .boto
```

### Subir archivos cifrados con CSEK
Se usa para cargar objetos que queden cifrados con la clave configurada.
```bash
gsutil cp setup2.html gs://$BUCKET_NAME_1/
gsutil cp setup3.html gs://$BUCKET_NAME_1/
```

### Borrar archivos locales de setup
Se usa para forzar nueva descarga y validar descifrado.
```bash
rm setup*
```

### Descargar archivos setup desde bucket
Se usa para recuperar y validar acceso a objetos cifrados.
```bash
gsutil cp gs://$BUCKET_NAME_1/setup* ./
```

### Mostrar contenido de archivos recuperados
Se usa para comprobar que los archivos se pudieron descifrar.
```bash
cat setup.html
cat setup2.html
cat setup3.html
```

### Abrir .boto para rotación de claves
Se usa para mover clave vieja a `decryption_key1` y preparar nueva clave.
```bash
nano .boto
```

### Generar nueva clave CSEK para rotación
Se usa para actualizar `encryption_key`.
```bash
python3 -c 'import base64; import os; print(base64.encodebytes(os.urandom(32)))'
```

### Reabrir .boto para setear la nueva clave
Se usa para pegar nueva `encryption_key`.
```bash
nano .boto
```

### Reescribir objeto para rotar cifrado
Se usa para volver a cifrar `setup2.html` con la nueva clave.
```bash
gsutil rewrite -k gs://$BUCKET_NAME_1/setup2.html
```

### Abrir .boto para desactivar decryption_key vieja
Se usa para simular cierre de rotación de claves.
```bash
nano .boto
```

### Descargar objeto ya rotado
Se usa para validar que `setup2.html` sigue siendo legible.
```bash
gsutil cp gs://$BUCKET_NAME_1/setup2.html recover2.html
```

### Intentar descargar objeto no rotado
Se usa para demostrar fallo esperado en objeto con clave vieja.
```bash
gsutil cp gs://$BUCKET_NAME_1/setup3.html recover3.html
```

### Ver lifecycle policy actual
Se usa para inspeccionar la configuración vigente del bucket.
```bash
gsutil lifecycle get gs://$BUCKET_NAME_1
```

### Crear archivo de policy lifecycle
Se usa para definir reglas de borrado automático por edad.
```bash
nano life.json
```

### Aplicar lifecycle policy al bucket
Se usa para activar la política definida en `life.json`.
```bash
gsutil lifecycle set life.json gs://$BUCKET_NAME_1
```

### Verificar lifecycle policy aplicada
Se usa para confirmar que la policy quedó activa.
```bash
gsutil lifecycle get life.json gs://$BUCKET_NAME_1
```

### Consultar estado de versioning
Se usa para verificar si el bucket tiene versionado habilitado.
```bash
gsutil versioning get gs://$BUCKET_NAME_1
```

### Habilitar versioning en bucket
Se usa para conservar versiones históricas de objetos.
```bash
gsutil versioning set on gs://$BUCKET_NAME_1
```

### Revalidar versioning
Se usa para confirmar que el versionado quedó encendido.
```bash
gsutil versioning get gs://$BUCKET_NAME_1
```

### Revisar tamaño del archivo actual
Se usa como referencia antes de crear nuevas versiones.
```bash
ls -al setup.html
```

### Editar archivo para cambiar contenido
Se usa para generar una nueva versión del objeto.
```bash
nano setup.html
```

### Subir versión nueva del objeto
Se usa para crear una versión adicional en el bucket.
```bash
gcloud storage cp -v setup.html gs://$BUCKET_NAME_1
```

### Editar nuevamente archivo para otra versión
Se usa para producir una tercera variante del objeto.
```bash
nano setup.html
```

### Subir otra versión del objeto
Se usa para tener varias versiones recuperables.
```bash
gcloud storage cp -v setup.html gs://$BUCKET_NAME_1
```

### Listar todas las versiones del objeto
Se usa para obtener el `VERSION_NAME` histórico.
```bash
gcloud storage ls -a gs://$BUCKET_NAME_1/setup.html
```

### Guardar versión objetivo en variable
Se usa para facilitar la descarga de una versión específica.
```bash
export VERSION_NAME=<Enter VERSION name here>
```

### Verificar VERSION_NAME
Se usa para confirmar que la variable contiene el path versionado completo.
```bash
echo $VERSION_NAME
```

### Recuperar versión histórica del objeto
Se usa para restaurar una versión antigua en `recovered.txt`.
```bash
gcloud storage cp $VERSION_NAME recovered.txt
```

### Comparar tamaños entre versión actual y recuperada
Se usa para verificar que se recuperó contenido anterior.
```bash
ls -al setup.html
ls -al recovered.txt
```

### Crear estructura de directorios de prueba
Se usa para preparar un escenario de sincronización recursiva.
```bash
mkdir firstlevel
mkdir ./firstlevel/secondlevel
cp setup.html firstlevel
cp setup.html firstlevel/secondlevel
```

### Sincronizar directorio local al bucket
Se usa para copiar recursivamente estructura y archivos.
```bash
gsutil rsync -r ./firstlevel gs://$BUCKET_NAME_1/firstlevel
```

### Listado recursivo de objetos sincronizados
Se usa para comparar estructura en bucket vs local.
```bash
gcloud storage ls -r gs://$BUCKET_NAME_1/firstlevel
```

### Salir de Cloud Shell
Se usa para terminar la sesión del lab.
```bash
exit
```
