# Reliability

> Todo lo que se ve esta clase está basado en un libro de SRE (Site Reliability Engineering) publicado por Google en 2016.

La confiabilidad es la característica más fundamental de cualquier producto. Si una persona no puede confiar en un servicio, ese servicio falló.

> Reliability: la capacidad de un sistema de ejecutar su función prevista de manera consistente, bajo condiciones variables, durante un período de tiempo determinado.

## El problema del sysadmin

Hace algunos años el perfil dominante para operar sistemas era el **sysadmin**: una persona o equipo que administraba producción de forma **manual o semiautomática** (mantenimiento, actualizaciones, deploys).

Dos problemas concretos de ese modelo:
- **Escala lineal**: a medida que el sistema crece, necesitás más y más gente operándolo.
- **Tensión estructural**: los developers quieren llevar cambios a producción lo antes posible. Los sysadmins quieren minimizar cambios porque el cambio introduce errores. Son objetivos opuestos.

## Site Reliability Engineering (SRE)

**Ben Treynor Sloss** crea el concepto en 2003 cuando le asignan liderar un equipo de sysadmins en Google. Durante 13 años desarrollaron métodos para reducir esa tensión entre dev y ops, automatizando y reduciendo fricción en el mantenimiento y despliegue.

En 2016 Google publica el libro [Site Reliability Engineering](https://sre.google/sre-book/table-of-contents/) con todas sus prácticas. Hoy es adoptado en empresas de software de todo tipo y tamaño.

## Tolerancia al riesgo

La confiabilidad extrema es **costosa**: ya sea por hardware redundante o por dedicar esfuerzo de ingeniería a mejorar confiabilidad en vez de sacar features.

El punto clave: la diferencia entre 99.9% y 99.99% de disponibilidad requiere muchísimo esfuerzo, y muchas veces **la mejora percibida por los usuarios es mínima o nula**, porque otra parte del sistema es menos confiable (GCS es mucho más confiable que la conexión de red del celular del usuario).

Por eso hay que construir un consenso entre producto e ingeniería para definir cuál es la disponibilidad que realmente necesitamos.

| Disponibilidad | Downtime / Año | Downtime / Mes | Downtime / Semana | Downtime / Día |
|---|---|---|---|---|
| **99.999%** | 5.256 min | 0.438 min | 0.101 min | 0.014 min |
| **99.990%** | 52.56 min | 4.38 min | 1.011 min | 0.144 min |
| **99.900%** | 8.76 hs | 43.8 min | 10.108 min | 1.44 min |
| **99.500%** | 43.8 hs | 3.65 hs | 50.538 min | 7.2 min |
| **99.000%** | 87.6 hs | 7.3 hs | 101.077 min | 14.4 min |

## SLI, SLO y SLA

- **Service Level Indicator (SLI)**: la métrica con la que medís. Lo primero que hay que preguntarse es *qué* vamos a medir. Existen infinitas variables de un sistema que podemos monitorear; un subconjunto reducido de ellas nos va a servir para entender qué tan bien funciona el sistema.
- **Service Level Objective (SLO)**: el valor objetivo de esa métrica. Una vez que podés medir algo, podés establecer umbrales: si estás por debajo del umbral tiene que sonar una alarma que te haga focalizar en mejorar la confiabilidad en vez de sacar nueva funcionalidad.
- **Service Level Agreement (SLA)**: el acuerdo legal con el cliente, que puede tener implicancias financieras. El SLA tiene que ser más relajado que el SLO — si ya sonaron las alarmas internas (SLO) antes de violar el acuerdo, tenés margen para actuar.

## Error Budget

Concepto creado por el equipo de Treynor Sloss para poder determinar de manera **objetiva** si el equipo tiene que trabajar en confiabilidad o en features nuevas.

- Se mide con una **rolling window** de X días: se toma el conjunto de métricas del período y se lo compara con el SLO.
- Si el resultado da que estás **por debajo del SLO** → congelás features y trabajás en confiabilidad.
- Si tenés presupuesto disponible → usarlo para sacar funcionalidad nueva que mejore la experiencia o atraiga usuarios.

Ej: si tengo un SLO de 95% de availability y actualmente tengo 99%, mi Error Budget es de 4%. Si bajo de 95%, hay que parar y arreglar.

## Toil

> Trabajo asociado con correr un servicio en prod que suele ser manual, repetitivo, automatizable, táctico, que no ofrece valor que perdura en el tiempo y escala linealmente.

- **Táctico**: reactivo, se ejecuta ante una interrupción o alerta. No es estratégico ni proactivo.
- **Valor perdurable**: un cambio o mejora en el proceso que es repetible y reduce fricción o costos. Automatizar algún paso del despliegue, por ejemplo.

La idea es reducir este trabajo porque consume tiempo de personas del equipo en algo que no suma tanto valor, y además es desgastante por el estrés de potencialmente generar un error.

Un caso super típico es el deploy manual de una aplicación.

## Four Golden Signals

Las cuatro métricas genéricas y mínimas para determinar que un sistema está medianamente monitoreado:

- **Latencia**: el tiempo en procesar una request. Es necesario diferenciar la latencia entre errores y respuestas exitosas — una respuesta de error rápida no es lo mismo que una respuesta exitosa lenta.
- **Tráfico**: la demanda que está soportando el sistema. Se puede medir en requests por segundo, conexiones concurrentes o lecturas a disco, dependiendo del tipo de sistema.
- **Errores**: pueden ser explícitos (HTTP 500), implícitos (HTTP 200 con contenido incorrecto) o que fallen algún requerimiento no funcional (respuesta correcta pero demasiado lenta).
- **Saturación**: el uso de los recursos del sistema. Lo mejor es medir el recurso por el que el sistema está limitado (memoria, disco, CPU). La saturación afecta rápidamente a la latencia.

## MTBF y MTTR

- **Mean Time Between Failures (MTBF)**: el tiempo promedio que pasa entre dos errores en el sistema. Es imposible que sea infinito, pero hay que apuntar a que sea lo más alto posible con mecanismos que identifiquen bugs lo antes posible.
- **Mean Time To Repair (MTTR)**: el promedio de tiempo desde que encontramos un bug en producción hasta que lo solucionamos. Puede ser cero si capturamos los bugs en etapas de testing previas. Si el error ya está en producción, un **canary release** y herramientas de rollback ayudan a identificar y mitigar el impacto.

## CI/CD Pipelines

- Un pipeline de **CI** (Continuous Integration) reduce muchísimo las chances de mandar código roto a producción.
	- También te permite generar un artefacto testeado de manera mucho más sencilla y reproducible.
- Un pipeline de **CD** puede ser:
	- **Continuous Delivery**: automatiza hasta dejar el artefacto listo para deployar, con un paso manual de aprobación.
	- **Continuous Deployment**: automatiza el deploy completo, sin intervención humana.
