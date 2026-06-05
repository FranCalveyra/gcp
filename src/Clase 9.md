# Observabilidad

> Es la capacidad de entender el estado interno de un sistema complejo basándose únicamente en los datos que este genera hacia el exterior.

Depende de tres tipos de datos:
- **Métricas**: valores numéricos medidos en el tiempo. Son ideales para detectar anomalías y ver tendencias (CPU, memoria, tasa de errores).
- **Logs**: registros de eventos discretos.
- **Traces**: muestran el recorrido de una request a través de todos los componentes del sistema (microservicios, bases de datos, APIs externas).

## Observabilidad en GCP

Varios servicios emiten métricas y logs de forma nativa, sin necesitar configuración adicional: App Engine, GKE, Cloud Run y Cloud Run Functions. Todos mandan sus datos directamente a la **Cloud Logging API** y la **Cloud Monitoring API**.

Para VMs con Compute Engine, en cambio, necesitás instalar el **Ops Agent**.

## Monitoreo en GKE

GKE se integra nativamente con Cloud Logging y Cloud Monitoring. También se puede integrar con **GC Managed Prometheus**:
- Funciona con un modelo de extracción (pull): scrapea métricas de la aplicación a intervalos regulares (ej: cada 15 segundos).
- La aplicación expone un endpoint `/metrics` con las métricas en formato Prometheus.
- Los datos se almacenan en **Cloud Monarch** (el repositorio global de métricas de Google) y se visualizan en Cloud Monitoring.

## Ops Agent

Agente unificado de Google Cloud para Compute Engine que combina la recolección de logs y métricas en un solo proceso:
- Hace scraping de métricas de Prometheus y las envía directo al Global Data Store (Monarch). No hace falta instalar servidores de Prometheus completos en cada VM.
- Simplifica el Service Discovery dentro del entorno de Compute Engine — básicamente te dice qué tenés corriendo.
- Tiene soporte oficial para las distros de Linux más usadas y Windows.

## Open Telemetry

Proyecto open source de la CNCF que da APIs, SDKs y herramientas para recolectar datos de telemetría. La pieza central es el *collector*, que orquesta la recolección, el procesamiento y la exportación:
- **Receivers**: capturan datos en distintos formatos.
- **Processors**: transforman, filtran y enriquecen los datos.
- **Exporters**: envían los datos a uno o más destinos (Datadog, Elastic, New Relic).

En GCP se conecta con tres servicios:
- **Cloud Trace**: visualización de latencias en microservicios distribuidos mediante trazas propagadas por OTel.
- **Cloud Monitoring**: ingesta de métricas personalizadas y del sistema mediante Monarch.
- **Managed Prometheus**: colección de métricas compatibles con Prometheus usando el collector de OpenTelemetry.

## Incorporar métricas propias a Cloud Monitoring

Dependiendo de dónde corra la aplicación, el camino es distinto:

- **GKE (Managed Service for Prometheus)**: exponés un endpoint `/metrics` con librerías estándar de Prometheus. El Managed Service hace el scraping automático, almacena en Monarch y visualizás en Cloud Monitoring. Lo usás cuando la métrica no es parte del set prefabricado de Cloud Monitoring — es decir, cuando necesitás una métrica custom.
- **VMs (Ops Agent)**: configurás el agente en la instancia, él captura las métricas y las manda a la API de Cloud Monitoring.
- **Instrumentación directa (OpenTelemetry SDKs)**: integrás el SDK de OTel en el código (Java, Go, Python, .NET) y enviás los datos a un OTel Collector centralizado.

## Monitoreo de red

Cuando monitoreás la red de GCP, no lo hacés a nivel del dispositivo físico — lo hacés a nivel de la interfaz de red de cada VM.

### VPC Flow Logs

Registran los metadatos de las conexiones de red. Se basan en 5 elementos clave (el "5-tuple"):
- IP de origen y destino
- Puerto de origen y destino
- Protocolo

Los logs se capturan **dentro de la interfaz de red de la VM**, no en el cable físico ni en el router central. Esto tiene una implicancia importante:
- **Tráfico saliente (Egress)**: si una regla de firewall bloquea la salida de una VM, el log sí registra el intento.
- **Tráfico entrante (Ingress)**: si una regla de firewall bloquea un paquete que viene de afuera, **no queda registrado** en el log.

Se habilitan por subred y se puede configurar el intervalo de agregación, la tasa de muestreo y qué metadatos incluir (ID de la VM, ID del endpoint). Ver [formato completo del registro](https://docs.cloud.google.com/vpc/docs/flow-logs#record_format).

### Logs del firewall

Los logs de firewall **no están activos por defecto** — hay que editar cada regla para incluirla en los logs.

Cada registro tiene:
- `action`: Allow o Deny.
- `rule_details`: el nombre de la regla que se aplicó.
- `connection`: IP de origen, puerto de destino y protocolo.
- `disposition`: indica si la regla es de prioridad más alta o si se aplicó por defecto.

La diferencia entre los dos tipos de log es clara: el **Firewall Log** te dice qué regla actuó. El **VPC Flow Log** te da la estadística del tráfico (bytes, paquetes).

### Logs de load balancers

Cada tipo de balanceador registra cosas distintas:
- **Application Load Balancers**: status codes HTTP, URLs exactas y latencias. Permiten ver exactamente qué experimentó el usuario final en el navegador.
- **Network Load Balancers**: conectividad pura — flujos de paquetes, IPs y puertos.
- **Proxy Load Balancers**: terminación de la conexión del cliente e inicio de la conexión al backend. Útiles para diagnosticar problemas de negociación SSL/TLS.
