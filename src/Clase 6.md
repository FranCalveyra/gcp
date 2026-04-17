# IAM
> IAM: **Identity and Access Management**. Nos dice quién puede hacer qué sobre qué recurso dentro de GCP.

Google separa bastante bien dos preguntas:
- **Authentication**: ¿soy realmente quien digo ser?
- **Authorization**: una vez autenticado, ¿qué permisos tengo y sobre qué recurso?

La seguridad de GCP no vive aislada. Se apoya sobre la jerarquía de recursos y desde ahí hereda permisos y políticas.

![Jerarquía de recursos de GCP](./images/Clase%206/slides/slide-2.png)

## Jerarquía de recursos
Toda la seguridad de GCP cae sobre una jerarquía. [Google la documenta acá](https://cloud.google.com/resource-manager/docs/cloud-platform-resource-hierarchy).

- **Organización**: es el nodo raíz. Suele representar a la empresa completa.
- **Folders**: agrupan por ambientes, equipos o dominios de negocio (`Prod`, `Dev`, `RRHH`, etc.)
- **Projects**: suelen ser la frontera de confianza, costos, cuotas y facturación.
- **Resources**: son los recursos concretos que consumimos, como VMs, buckets, datasets de BigQuery, etc.
- **Propiedad**: el ciclo de vida de un recurso queda atado a su superior inmediato.
	- Si un empleado se va, el proyecto no desaparece porque no le "pertenece" a esa persona, sino a la organización.
- **Herencia**: tanto los permisos como las políticas de organización fluyen hacia abajo en la jerarquía.

## Fundamentos de IAM
![Fundamentos de IAM](./images/Clase%206/slides/slide-4.png)

IAM le permite a los administradores autorizar quién puede tomar acciones sobre recursos específicos.

- Pensarlo en 3 ejes ayuda mucho:
	- **Who**: la identidad
	- **Can do what**: el rol/permisos
	- **On which resource**: el recurso objetivo
- En criollo: `Member + Role + Resource`.

## Miembros (Members)
![Members en IAM](./images/Clase%206/slides/slide-5.png)

La parte del **who** en IAM es el **member**.

- Un `member` puede ser:
	- una **Google Account** o un usuario de **Cloud Identity**
	- una **service account**
	- un **Google Group**
	- un **dominio** de Cloud Identity / Google Workspace
- En general la identidad se representa con un identificador estilo email.

## Service Accounts
Las [service accounts](https://cloud.google.com/iam/docs/service-account-overview) son cuentas asignadas a aplicaciones o cargas de trabajo. Sus identificadores tienen formato `email`, por ejemplo `nombre-sa@proyecto.iam.gserviceaccount.com`.

- **No tienen contraseña**: no están pensadas para que una persona se loguee en la consola web.
- **Son un recurso y una identidad**:
	- puedo darle permisos a una SA para que actúe sobre otros recursos
	- y también puedo darle permisos a un usuario para que administre esa SA
- **Autenticación**: usan pares de claves públicas/privadas para validar identidad frente a las APIs de Google.

Puedo tanto usar una JSON key como crear un recurso y attachear una S.A a ese recurso.
- La diferencia está en que la primera la administramos nosotros y la 2da la administra Google.

### Tipos de service accounts
![Tipos de service accounts](./images/Clase%206/slides/slide-7.png)

- **Default Service Accounts**:
	- GCP las crea automáticamente (por ejemplo al habilitar Compute Engine)
	- el peligro clásico es dejarlas con permisos demasiado amplios, tipo `Editor`
- **User-managed Service Accounts**:
	- las crea el arquitecto según la necesidad
	- permiten aplicar mejor el **Principio de Menor Privilegio**
- **Google-managed Service Accounts**:
	- las usa internamente GCP para que sus servicios interactúen entre sí
	- por ejemplo, para que Cloud Run pueda hablar con otros recursos

## Autorización: ¿qué? ¿dónde?
![Autorización en IAM](./images/Clase%206/slides/slide-8.png)

La autorización la resolvemos combinando **roles** con **recursos**.

- Un **permiso** es una acción puntual sobre una API o recurso
	- por ejemplo `compute.instances.start`
- Un **rol** es un paquete de permisos
- El rol responde **qué** puedo hacer
- El recurso responde **dónde** lo puedo hacer
- Ejemplo: `roles/compute.instanceAdmin` agrupa varios permisos administrativos sobre instancias de Compute Engine

## Roles en Cloud IAM
Los [roles de IAM](https://cloud.google.com/iam/docs/roles-overview) se dividen en 3 familias:

- **Primitivos (básicos)**:
	- son roles muy genéricos, con permisos amplios
	- no se recomienda usarlos en producción
	- a veces sirven en desarrollo o para salir del paso
- **Predefinidos**:
	- tienen mucha más granularidad
	- los crea y mantiene GCP para casos de uso comunes
- **Custom**:
	- los creamos nosotros para necesidades muy específicas
	- acá la responsabilidad de mínimo privilegio y segregación de funciones es totalmente nuestra

![Roles primitivos](./images/Clase%206/slides/slide-10.png)

Entre los roles primitivos más conocidos están:
- **Owner**: puede administrar miembros, borrar proyectos, etc.
- **Editor**: puede desplegar aplicaciones, modificar configuraciones y operar servicios.
- **Viewer**: acceso de solo lectura.
- **Billing Admin**: administra la parte de facturación, no necesariamente el resto de los recursos.

## IAM Policies
![IAM Policies](./images/Clase%206/slides/slide-11.png)

Una [IAM Policy](https://cloud.google.com/iam/docs/policies) es el documento que vincula un `role` con uno o varios `members` sobre un recurso.

- El modelo mental es: una policy es un conjunto de **bindings**
- Cada `binding` dice algo como:
	- a estos `members`
	- dales este `role`
- En formato mental:
	- `bindings: [{ role, members }]`

Los accesos resultantes de un usuario son la suma de todas las políticas aplicadas sobre este.
- Si tengo una política que me da acceso a 7 recursos distintos y tengo otra que me da acceso a otros 21 recursos diferentes a los anteriores (por poner un ejemplo), termino teniendo acceso a todos esos 28.

## Herencia y propagación en IAM
![Herencia y propagación en IAM](./images/Clase%206/slides/slide-12.png)

Las policies de IAM se heredan desde la organización hacia abajo.

- Un rol otorgado a nivel **Organización** también aplica en carpetas, proyectos y recursos inferiores.
- El acceso efectivo de un usuario es la **unión** de:
	- la policy definida sobre el recurso
	- más todas las policies heredadas
- En el modelo de `allow` que vimos en clase, un permiso dado arriba no lo "sacás" abajo con otra policy de IAM.
- Por eso conviene aplicar el **Principio de Menor Privilegio** desde el nivel más alto posible.

> Si quiero que un usuario opere sobre algún recurso para el que necesita algún privilegio, puedo darle los permisos a una `Service Account` y asignarle esa S.A al usuario particular.

## Políticas de Organización (Guardrails)
Las [Organization Policies](https://cloud.google.com/resource-manager/docs/organization-policy/overview) son restricciones configurables (`constraints`) que se aplican sobre los **recursos**, no sobre las identidades.

![Políticas de Organización](./images/Clase%206/slides/slide-13.png)

- Definen **qué está permitido hacer** en la infraestructura.
- Habitualmente se configuran en el nodo raíz (la organización) y fluyen hacia abajo.
- Son el equivalente a poner barandas de seguridad sobre toda la plataforma.

Ejemplos clásicos:
- **Restricción de ubicación**: impedir que se creen recursos fuera de una región determinada, por ejemplo solo `southamerica-east1`
- **Desactivar IPs externas**: evitar que las VMs salgan con IP pública por default
- **Restringir dominios**: permitir que solo miembros de cierto dominio reciban roles en IAM

## Links útiles
- [Jerarquía de recursos en Google Cloud](https://cloud.google.com/resource-manager/docs/cloud-platform-resource-hierarchy)
- [Visión general de IAM](https://cloud.google.com/iam/docs/overview)
- [Service Accounts](https://cloud.google.com/iam/docs/service-account-overview)
- [Roles de IAM](https://cloud.google.com/iam/docs/roles-overview)
- [IAM Policies](https://cloud.google.com/iam/docs/policies)
- [Organization Policy](https://cloud.google.com/resource-manager/docs/organization-policy/overview)
