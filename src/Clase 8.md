# Monitoreo y Alertas
## Observabilidad
La observabilidad me deberia permitir ser consciente de qué pasa en mi sistema en todo momento, no solo para hacer *troubleshooting*, sino tambien para *forensics*.

Una de las funciones necesarias para que el sistema sea observable es el **monitoreo**.
Cada evento que sucede debería generar un log (o registro de auditoría).

El monitoreo me permite entender la salud/estado del sistema en este momento, aún cuando no determiné/generé una alerta.

Todo el planteo que hace GCP sobre cómo administrar logs y monitoreo en la plataforma se basa en esta idea:
> Tener parámetros de salud de mi sistema.

El monitoreo se basa en métricas, no en historias. Una métrica es un valor numérico que representa el estado del sistema en un momento dado a lo largo del tiempo.

Para poder monitorear, necesito construir métricas a partir de... [Completar]
Puedo tener distintas métricas según el nivel de la infraestructura.


Me da la capacidad de:
- Detectar incidentes
- Prevenir incidentes

### Herramientas de observabilidad
- **Cloud Monitoring**: dashboard que te muestra datos numéricos medidos a lo largo del tiempo
- **Cloud Logging**: te deja ver los logs
- **Error Reporting**: se dedica a recolectar errores
- **Cloud Trace**: rastrea acciones
- **Cloud Profiler**: analiza el consumo de recursos


## Cloud Monitoring
El scope default del monitoreo de Google es el `proyecto`.
Se puede monitorear a nivel organización.

## Cloud Logging
Puede guardar logs en un bucket o en BigQuery


> Me falta completar un montón de data, después voy a pasar la presentación.


## Cloud Trace
Para trazar una request, se usa un Trace ID y va enchufando el identificador del recurso/microservicio en el header de la request, con el nombre de _span_.

El span es acumulativo, se va stackeando, lo que me permite justamente trackear donde estan las latencias y/o errores.

Te lo da en un gráfico re piola.

Este me deja ver dónde está la latencia

## Cloud Profiler
Stackea snapshots de uso de recursos, lo que me permite justamente ver qué proceso consume más de un recurso particular.

## Alertas
Establecer límites de tiempo para definir alertas es clave para tener alertas no redundantes.

Por lo general, los objetivos que tienen que cumplirse para disparar las alertas se basan en el SLA definido con el cliente.

>**SLO**: Service Level Objective, es valor de la métrica objetivo. El valor que acordé en el SLA
>
>**SLI**: Service Level Indicator, es el indicador con el que mido. La métrica objetivo.


Si tenés una cantidad descomunal de alertas que nadie lee, no tenés ni idea del estado real del sistema. No tenés plena claridad.

Diseñar las alertas es un trabajo por sí solo, al que hay que dedicarle tiempo.

Las alertas de performance las ato a un período de tiempo.