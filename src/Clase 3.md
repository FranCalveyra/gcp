# Recursos de Cómputo - Continuación

## Las VMs y los MIGs toman bastante tiempo...

- Cuando creamos una Vm sen casi todos los casos el **provisioning** se hace según el **mejor esfuerzo** (en unga unga, cuando pueda). **Configurar y encender** la VM también **toma tiempo**
- Un MIG responde a subas y bajas de demanda con una ventana de por lo menos 10 mins. entre lo que se conoce como el **initialization** process y el **stabilization** process
  - Por cierta cantidad de tiempo (desde que creo la máquina a partir de la regla de auto-scaling hasta que efectivamente está corriendo), no miro el consumo de recursos para decidir si levanto una instancia nueva
    - Puedo estar inicializando la máquina, clonando un repo (según la config), instalando todas las dependencias, ejecutando algún proceso que consuma mucha CPU, etc.
  - En esos 10 minutos entre inicialización y estabilización, me cobran ($$).
    - El proceso de inicialización puede tener una duración configurable
    - Si $T_{init} > T_{stab} \Longrightarrow T_{stab} = 0$ . Es decir, no tengo tiempo de estabilización
- Puede haber un caso extremo en donde tengo un servicio que responde una request cada 10 mins.
  - En este caso, termino teniendo un MIG o un server dedicado para no hacer nada la mayor parte del tiempo. Es decir, terminás teniendo *infraestructura ociosa*

> No existe el MIG sin instancias. No podés configurar un MIG vacío, porque un Load Balancer no puede existir por sí solo.

Para evitar estos problemas de infra ociosa, podemos trasladarnos a una solución `serverless`.

## App Engine 

Es un framework serverless donde montamos nuestro código (con una estructura particular). Nos perdemos ciertos aspectos de configurabilidad (como interactuar con el S.O de la máquina sobre la que está montado nuestro servicio serverless), además de que estamos limitados a ciertos lenguajes.

Es un PaaS, no tengo ni idea de la infraestructura como tal, me abstraigo de muchas de las configuraciones necesarias. A partir de ahora, nos cobran sólo por tiempo de ejecución.
Nos administran sólo por tiempo de ejecución.

## Cloud Run Functions 

Esta es la solución FaaS (Function as a Service), que también es serverless.

- Corre ante eventos concretos, sobre [Cloud Run Service](#cloud-run-service).
- Funcionan con `Functions Framework`, un SDK disponible para algunos lenguajes y una cierta estructura (ej: un `main.py` y un `requirements.txt` en )
- La primera generación era más limitada (límites de vCPU, RAM y timeout de ejecución)
  - El timeout era de aprox. 15 minutos.
  - Tenían límites de concurrencia
- Las de 2da gen son mucho más óptimas

## Cloud Run Service 

- Puedo publicar y compartir imágenes (artefactos) que contienen la config del O.S, alas dependencias y el contexto necesario disponible.
- GCP crea contenedores en una fracción del tiempo porque se ahorra los pasos de provisioning y la inicialización es mucho menos compleja
- Obvio que no todas las imágenes son iguales y GCP tiene mejores prácticas

### Ventajas

El container tarda muchísimo menos en levantarse que las VM, por cómo funcionan los contenedores en sí.

- La ventaja de usar containers es la portabilidad/inter-operabilidad: me abstraigo del lenguaje y del ambiente.
  - Mismo si mañana me quiero cambiar de Cloud Provider, y el otro también tiene un servicio de Container Running, me llevo mis imágenes y pum para casa

### Límites

- El Build System de  tiene que tener acceso a mi imagen
- Las imágenes no pueden pesar más de 10GB
- Hay un límite de consumo de recursos de los containers en ejecución
  - Pasado este límite, te cobran
- Si tarda más de $4 \text{ minutos}$ en levantarse, no puedo correr el container
- No se pueden usar imágenes basadas sobre . Sí o sí tiene que ser a partir de alguna distro de 

### Cobro

#### Request-based billing

Te cobran por:

- Cantidad de requests
- $\frac{\text{Cantidad de CPU}}{\text{unidad de tiempo}}$
- $\frac{\text{Cantidad de memoria}}{\text{unidad de tiempo}}$
En los últimos 2 me cobran por el tiempo de inactividad. En cuanto a la CPU, es 10 veces menos que el tiempo de actividad (claramente la CPU es más cara)

#### Instance-based billing

Existe también el **billing basado en instancias**, que también te cobra por los últimos 2 anteriores, pero se le agrega el tipo de GPU usado, y su uso por unidad de tiempo.