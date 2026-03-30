# Almacenamiento

> **Aclaración respecto del Lab**: una Service Account es una cuenta de un usuario artificial que tiene permisos para realizar operaciones de manera automática sobre los distintos recursos de GCP. Operan como un *proceso aparte*.

Google ofrece una cantidad muy amplia de soluciones de almacenamiento en la nube, pero nos vamos a enfocar en 3 particulares:
- Cloud Storage
- Cloud SQL
- Cloud Firestore

>***Google File System***: es un FS que SÓLO appendea. Es rapidísimo para escribir.

## Cloud Storage (GCS) <img src="https://miro.medium.com/1*UPYci8aQvCIZ_BbmLO_3vA.png" height="40" width="40"/> 
(2010)
Es un *bucket*, una solución `object store`, parecido a un network file system en la nube, casi "infinito". Usa una interfaz REST.
La diferencia clave con un file system es que los tiempos de lectura a esa escala son incompatibles con este: en un file system real es imposible tener una lectura de esa cantidad de archivos.

En sí, hacen una serie de operaciones sobre los archivos que guardamos:
- Replicación
- Partición y reconstrucción
- Guarda metadata particular del archivo

La interfaz que le dan al usuario la hace ver similar a un FS.

Tiene una **durabilidad** altísima (11 nueves), haciendo casi imposible que un archivo se pierda a lo largo del tiempo. Se logra justamente con mecanismos de **reconstrucción** (si mi archivo se rompe o pierde, lo puedo recuperar), **replicación geográfica** de los datos (al menso 2 zonas, con posibilidad de multiregión) y **validaciones constantes** de los datos.

Está construido sobre Colossus, sucesor de GFS, permitiendo capacidad infinita. Es administrado por Spanner, garantizando consistencia fuerte de la metadata.

Por el cliente, yo interactúo con la metadata del archivo, no con el archivo en sí. El Blob es todo lo que conoce

### Pricing
[Insertar foto]
- Region no te cobra el `outbound data transfer` porque lees datos dentro de la misma región.
- Multi-región es más caro que región, pero más barato que dual-region, porque Google no te deja elegir dónde guardarlo
	- Justamente por esto es que tanto acá como en dual-region te cobran por `outbound data transfer`, porque te movés afuera de la región
	- Te cobran la replicación por escribir un archivo
- Elijo zona porque tengo muy poca latencia y muchísimo ancho de banda.
	- Este es el más caro justamente por esto.

### Tipos de buckets
- **Rapid buckets**: el zonal, funciona a los piques. Se usa para AI/ML, análisis de datos, etc.
- **Standard storage**: es ideal para lectura frecuente de un conjunto de archivos.
- **Nearline, Coldline, Storage**: en este orden, el costo de almacenamiento es cada vez más barato
	- El costo de escritura es caro de manera creciente, según el orden anterior
	- El compromiso del tiempo de vida es también creciente (30, 90 y 365 días, respectivamente)

## Cloud SQL <img src="https://www.gstatic.com/bricks/image/85b9a54c-5ffc-4126-8824-32fb08fcf1a3.png" height="40" width="40"/>
(2015)
- Es un servicio de bases de datos relacionales. No lo administrás vos, sino que directamente lo usás.
- Maneja por sí solo:
	- Updates
	- Parches
	- Vertical Scaling
	- Auto-resizing del disco on-the-fly
- Por lo general, tiene una **disponibilidad alta** por el uso de 2 instancias (una primaria y otra standby), una en cada zona.
	- Si falla la primaria, la standby la reemplaza. Se van replicando entre sí y cuando la primaria está disponible la vuelve a reemplazar.
	- Son 2 discos a nivel zonal, 1 a nivel regional.
	- Tiene chequeos automáticos (a nivel Persistent Disk) para revisar qué tan sincronizadas están.
- Tiene **backups automatizados** periódicos, pudiendo recuperarnos en un click de un `DELETE FROM` erróneo. Son incrementales.
- Podés asignar **réplicas de lectura** para alivianar la carga de la instancia primaria.

## Firestore <img src="https://firebase.google.com/static/images/products/firestore/firestore-hero_1x.png?hl=es-419" height="40" width="40"/>
(2017)
- BD NoSQL orientada a documentos
	- Los documentos son JSON con un encodeo binario más eficiente que el JSON común, que pueden pesar hasta 1 MB
- 2 modos de operación: Native y Datastore.
	- Native te permite usarlo como BaaS, con límites de 10k escrituras/segundo
	- Datastore se usa cuando tenemos un backend que interactúa con nuestra instancia. Sin límites ni features de BaaS
- Solo nos deja hacer queries si tenemos índices para hacerla. El índice de un solo field lo hace automático, pero el complejo hay que armarlo manual
- Es serverless, no te cobran por nada que no sea read/write ni almacenamiento. Las escrituras consideran el mantenimiento de los índices
- Hay costo por GiB
- Los datos se organizan en splits.
	- Split es una implementación de sharding pero completamente administrado por Firestore. Nosotros tenemos que elegir la sharding key, y Firestore se encarga de manejar los splits por tamaño o por frecuencia de lectura, además de juntar los datos que se suelen consultar juntos en los mismos splits
		- No hay que usar keys secuenciales porque sino corremos el riesgo de sobrecargar nodos
		- Autobalancea la carga en un mismo shard, creando subparticiones
	- Nos permite escalar prácticamente de forma infinita sin degradación de performance.

> `Sharding`: particionar datos a partir de una clave.