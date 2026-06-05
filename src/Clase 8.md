# Monitoreo y Alertas

## Monitoreo

Recopilación, procesamiento, agregación y visualización de datos cuantitativos en tiempo real sobre un sistema. Ejemplos de lo que monitoreás: recuento y tipos de consultas, recuento y tipos de errores, tiempos de procesamiento, tiempo de vida de los servidores.

El monitoreo se basa en **métricas**, no en historias. Una métrica es un valor numérico que representa el estado del sistema en un momento dado a lo largo del tiempo. Me permite entender la salud del sistema ahora mismo, incluso cuando no hay ninguna alerta disparada.

Me da la capacidad de detectar incidentes y también de prevenirlos.

### La pirámide del monitoreo

El monitoreo es la base de todo lo demás. Sin visibilidad sobre el sistema, no podés hacer nada de lo que está arriba:

```
          Product
        Developing
      Capacity planning
          Testing
  Postmortems / root cause
      Incident response
         Monitoring        ← base
```

No tiene sentido hablar de capacity planning o de mejoras al producto si el monitoreo está roto.

## Observabilidad

> Es la capacidad de entender el estado interno de un sistema complejo basándose únicamente en los datos que este genera hacia el exterior.

La observabilidad me debería permitir ser consciente de qué pasa en mi sistema en todo momento, no solo para hacer *troubleshooting*, sino también para *forensics*. Depende de tres pilares:

- **Métricas**: valores numéricos medidos en el tiempo. Son ideales para detectar anomalías y ver tendencias (CPU, memoria, tasa de errores).
- **Logs**: registros de eventos discretos. Cada evento que sucede debería generar uno.
- **Traces**: muestran el recorrido de una request a través de todos los componentes del sistema (microservicios, bases de datos, APIs externas).

El monitoreo es una de las funciones necesarias para que un sistema sea observable.

## Rendimiento y confiabilidad

Las cuatro métricas clave para saber si un sistema está medianamente monitoreado (los "Four Golden Signals"):

- **Latencia**: tiempo en procesar una request. Hay que diferenciar la latencia de los errores de la de las respuestas exitosas.
- **Tráfico**: la demanda que está soportando el sistema (requests por segundo, conexiones, lecturas a disco).
- **Errores**: pueden ser explícitos (HTTP 500), implícitos (HTTP 200 con contenido incorrecto) o por incumplimiento de un SLO de latencia.
- **Saturación**: qué tan lleno está el recurso más limitante del sistema (memoria, CPU, disco).

## Herramientas de observabilidad

- **Cloud Monitoring**: recolecta métricas de rendimiento y estado de salud de la infraestructura y las aplicaciones para generar dashboards y alertas.
- **Cloud Logging**: almacena, busca y analiza logs de los servicios para auditorías y resolución de problemas.
- **Error Reporting**: agrupa automáticamente los errores de aplicaciones en ejecución para notificar y ayudar a priorizar su solución.
- **Cloud Trace**: rastrea el camino de las solicitudes a través de sistemas distribuidos para encontrar cuellos de botella y latencia entre microservicios.
- **Cloud Profiler**: analiza continuamente el consumo de recursos (CPU, memoria) a nivel de código para optimizar el rendimiento y reducir costos de computación.

## Cloud Monitoring

El scope default del monitoreo de Google es el `proyecto`. Se puede ampliar a nivel organización.

Tiene cuatro capacidades principales:

- **Métricas**: datos numéricos medidos a lo largo del tiempo (CPU, memoria, latencia de red).
- **Dashboards**: visualizaciones gráficas para identificar tendencias o picos de uso de un vistazo.
- **Umbrales y alertas**: definís una regla y Cloud Monitoring la vigila. Ej: "Si el uso de CPU supera el 80% durante 5 minutos, mandar un email".
- **Uptime checks**: verificaciones externas para saber si una aplicación es accesible desde distintas partes del mundo.

### Cómo funciona por dentro

El flujo tiene tres etapas:

1. **Metric Collection**: los 100+ servicios de GCP mandan métricas automáticamente. GKE puede usar Prometheus u OpenTelemetry. Compute Engine necesita el Ops Agent. También soporta Hybrid/Multi-Cloud.
2. **Metric Storage**: todo se guarda en Cloud Monitoring Storage y se accede vía API.
3. **Visualization and Analysis**: desde ahí se arman dashboards, uptime checks, alert policies y notificaciones. Para exportar a terceros (ej: Grafana) también hay soporte.

## Cloud Logging

Los logs pasan por cuatro etapas:

1. **Ingesta**: servicios de GCP y agentes envían logs.
2. **Router de Logs**: filtra, enruta y excluye registros. Acá podés decidir qué logs guardás, adónde van y cuáles descartás.
3. **Buckets**: almacenamiento en `_Default` o `_Required` (o buckets propios).
4. **Análisis**: Logs Explorer con lenguaje LQL para consultar y filtrar.

Además de guardarse en buckets, los logs se pueden exportar a BigQuery para análisis más complejos.

### Tipos de logs

- **Logs de plataforma**: los provistos por Google, sobre sus propios servicios (ej: VPC Flow Logs).
- **Logs de componentes**: generados por software que corre sobre la infra de Google pero que no es 100% administrado (GKE, el SO de una VM).
- **Logs de seguridad**: ¿quién hizo qué, dónde y cuándo? Son críticos para auditoría y análisis forense.
- **Logs de usuario**: los que vos escribís en el código para seguir la lógica del negocio.
- **Logs multi-cloud**: registros de AWS, Azure o servidores on-premise centralizados en GCP para tener un panel único de observabilidad.

### Propiedades importantes

- **Inmutabilidad**: los registros son definitivos. Una vez escritos, no se pueden editar ni borrar individualmente.
- **Bloqueo de buckets**: podés fijar políticas de retención para compliance normativo y auditorías forenses.
- **Logs de auditoría**: registro inmutable de toda actividad administrativa y de acceso a datos en la plataforma.
- **Métricas basadas en logs**: podés generar métricas de monitoreo a partir de patrones de texto en los registros. Eso habilita armar dashboards y alertas sobre eventos que no tienen una métrica nativa.

### De logs a métricas

El flujo es: tus recursos emiten logs → Cloud Logging los recibe → definís un filtro LQL (ej: `resource.type="gce_instance" AND severity=ERROR`) → cada vez que un log coincide, se genera un punto de datos numérico → Cloud Monitoring lo trata como cualquier otra métrica → podés graficarlo y disparar alertas.

El log original sigue su camino normal hacia el almacenamiento; la métrica es una capa paralela encima.

## Error Reporting

Identifica, contabiliza, analiza y agrupa las caídas de servicios en ejecución. Lo útil es que no te tira un log por cada error — agrupa errores similares y te muestra el stack trace, lo que hace mucho más fácil priorizar qué arreglar.

Recibe alertas cuando aparece en producción un error nuevo o uno existente empieza a dispararse con alta frecuencia. Mucho más manejable que revisar logs crudos.

## Cloud Trace

Sigue el viaje de una request a través de múltiples contenedores y servicios para encontrar cuellos de botella. Usa un **Trace ID** único por petición, y un **span** por cada microservicio o componente que la procesa. Los spans se acumulan, lo que te permite ver exactamente dónde está la latencia.

Lo valioso es que no solo ve los servicios propios — también identifica latencias ocultas en llamadas a APIs externas y consultas a bases de datos.

## Cloud Profiler

Hace muestreo de la pila de llamadas mediante *snapshots* separados por pocos milisegundos. Con esas fotos arma un perfil estadístico de uso de recursos. Dependiendo del lenguaje puede analizar: uso de memoria, CPU, uso de pila, pila asignada y tiempo total de ejecución de una función.

Ayuda a encontrar qué proceso consume más de un recurso particular sin tener que instrumentar nada manualmente.

## Alertas

Se definen a partir de umbrales sobre métricas o sobre logs. Para cada alerta hay que definir:

- **Canal de notificación**: correo electrónico o mensajería (Slack, PagerDuty, etc.).
- **Ciclo de vida**: hay que registrar la gestión del incidente desde Open hasta Closed para asegurar trazabilidad. Si una alerta se abre y no se cierra, no sabés si alguien la atendió.
- **Higiene de alertas**: usar Muting Rules durante mantenimientos y ventanas de alineación para evitar la fatiga del equipo técnico. Si tenés una cantidad descomunal de alertas que nadie lee, no tenés ni idea del estado real del sistema.
- **Alertas basadas en logs**: para notificación inmediata ante eventos críticos específicos que no tienen métrica nativa (ej: detección de intrusiones, errores de auditoría).

Las alertas de performance las atás a un período de tiempo. Por lo general, los objetivos que disparan las alertas se basan en el SLO definido con el cliente.

> **SLI** (Service Level Indicator): la métrica con la que medís.
>
> **SLO** (Service Level Objective): el valor objetivo de esa métrica — lo que acordaste en el SLA.
