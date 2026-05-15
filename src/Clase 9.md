# Observabilidad
Hay varios servicios que generan logs y alertas por sí solos (y no se pueden apagar), tales como:
- GKE
- Cloud Run
- Cloud Functions
- [Uno más]

>¿Qué ventajas tiene usar Prometheus (o una herramienta open source de monitoreo) y que sea un servicio administrado por GCP sobre usar Cloud Logging?
>
>Si uso la herramienta open-source me la puedo llevar, básicamente

Los logs generados por [inserte servicios particulares] van a **Cloud Monarch** (ahora llamado Global Data Store).
- Es un repositorio de logs donde van todos los productos grandes de Google (Gmail, Youtube, etc.)

## Ops Agent
Agente unificado de Google Cloud para Compute Engine que combina la recolección de logs y métricas en 1 solo proceso:
- **Integración Nativa**: scrapea métricas de Prometheus y las envia directo al Global Data Store
- **Simplicidad Operativa**: no hace falta instalar ni gestionar servidores de Prometheus completos en cada VM.
	- Básicamente es un servicio consolidado
	- Puedo tener mi propia implementación, pero Ops Agent me lo da todo unificado.
- **Service Discovery**: se simplifica dentro del entorno de Compute Engine
	- Sirve para mappear nuestras soluciones, para saber qué cuerno tengo
- Tiene soporte oficial para varias distros de Linux y Windows


## Open Telemetry
Es un proyecto open source que tiene APIs, SDK y herramientas para recolectar datos de telemetría
Tiene un _collector_ que orquesta la recolección, procesamiento y exportación de datos
- **Receivers**: capturan datos en distintos formatos
- **Processors**: son transformadores, filtros y enriquecedores de datos
- **Exporters**: envían los datos a uno o más destinos (Datadog, Elastic, New Relic)

### Dentro de GCP
Se conecta con Cloud Trace, Cloud Monitoring y Managed Prometheus.

## Incorporar métricas propias en Cloud Monitoring
- GKE apps (Managed Service for Prometheus)
	- Se expone un endpoint `/metrics` en la aplicación usando librerías de Prometheus
		- Prometheus se autentica con la cuenta del usuario. El endpoint no es público
	- El "Managed Service for Prometheus" scrapea automáticamente
	- Las métricas se guardan en **Monarch**
	- Voy a usar Prometheus cuando la métrica no es parte del set prefabricado de métricas de Cloud Monitoring. Es decir, cuando quiera hacer una métrica custom
- Aplicaciones en VMs (Ops Agent)
	- Se configura el Ops Agent en la instancia de VM
	- El agente captura las métricas y las envía a la API de Cloud Monitoring
- Instrumentación Directa (OpenTelemetry SDKs)
	- Se integra el SDK de OpenTelemetry con código directamente (Java, Go, Python, .NET)
	- Se envían los datos a un OTel Collector centralizado

## Monitoreo de red
Cuando yo monitoreo la red en una red instalada por mí, lo hago a nivel del dispositivo de comunicaciones.
### VPC Flow Logs
Es el registro de llamadas de la red. Captura los metadatos de las conexiones. Se basa en 5 elementos clave:
- IP de origen
- IP de destino
- Puerto de origen
- Puerto de destino
- Protocolo

En este caso, monitoreo los metadatos de todas las conexiones a la interfaz de red de una subred.
- Se habilita por subred por separado
- Se configura:
	- Intervalo de agregación (o de guardado)
	- Tasa de muestreo
	- Metadatos (ID de la VM, ID del endpoint)

Los logs se capturan dentro de la interfaz de red de la VM, no en el cable físico o en el router central

Se registra el tráfico individual de cada máquina:
- Tráfico Saliente: una regla de Firewall que bloquea la salida de una VM
- Tráfico Entrante: una regla de Firewall que bloquea la entrada a una VM

Nos conviene activar logs de Firewall regla por regla.


### Logs del firewall
[Inserte contenido]
La solución para identificar el tráfico entrante que no está llegando requiere tanto del logs de trafico saliente como del entrante

Otro approach es permitir el tráfico que busco con una prioridad muy alta

### Logs de load balancers
- ALB (Application Load Balancers): registra status code de HTTP, URLs exactas y latencias de respuesta. Permiten ver exactamente qué experimentó el usuario final en su navegador
- NLB (Network LB): se centran en conectividad pura, solo registran flujos de paquetes, IPs y puertos
- Proxy Load Balancers: detallan la terminiación de la conexión del cliente y el inicio de la conexión al backend. Ayudan en el diagnóstico de problemas de negociación SSL/TLS o protocolos TCP específicos.