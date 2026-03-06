# Cloud Shell
Es un recurso análogo al CLI de AWS. Básicamente te permite interactuar con todos los recursos de GCP pero desde una terminal.

## Prerrequisitos 
- Tener, justamente, la herramienta instalada en tu sistema. Si no la tenés, [buscala acá](https://docs.cloud.google.com/sdk/docs/install-sdk)

## Ejemplos
He aquí algunos ejemplos de lo que se puede hacer:
### Verificar la cuenta activa
```
gcloud auth list
```

### Listar los proyectos existentes a los cuales la cuenta tiene acceso
```
gcloud config list project
```

### Setear la región default
```
gcloud config set compute/region <REGION>
```

### Crear una instancia de una VM en una zona particular
```
gcloud compute instances create gcelab2 --machine-type e2-medium --zone=$ZONE
```
- Notar que se crea con el nombre `gcelab2` y es de tipo `e2-medium`

### Conectarte por SSH a una instancia ya creada
```
gcloud compute ssh gcelab2 --zone=<ZONE>
```
- Hay que pasarle la zona por parámetro