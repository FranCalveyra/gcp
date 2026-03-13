# Introducción
## Regiones y Zonas
- Los servidores de GCP se manejan por Regiones y Zonas.
- Las **regiones** se manejan a nivel ciudad. Existen data centers dentro de estas.
	- Por el SLA que firmó GCP, en cada región tiene que haber al menos 3 data centers para los servicios ofrecidos: 1 para ofrecer el servicio y 2 de respaldo/réplica
- Las **zonas** representan un data center concreto; no son todas iguales.
	- Difieren a nivel acceso y a nivel latencia
	- [Completar]
- Existe lo que se llaman **Points of Presence** (PoP), que son lugares donde ya hay datos guardados para poder distribuirlos mejor.
- _No todos los servidores son iguales_: el costo de mantenimiento claramente difiere según la zona geográfica.
	- Por lo general, EE.UU es mucho más barato; hasta 10 veces menos que Brasil
	- No tiene sentido, estando en Argentina, pagar un servicio en Europa, porque no tenemos un cable físico de fibra que vaya directo; entonces tiene que hacer el salto con latencia agregada a EE.UU o a la región más cercana.
> Van a haber más concentración de recursos en los lugares donde más consumo haya, claramente. Por eso hay tantos PoP en EE.UU y en Europa.

![GCP Map](images/Clase%201/GCPMap.png)

Existen también servicios (principalmente los relacionados al **almacenamiento**) que pueden ser multi-región (replicándolos en varias regiones), pero incurre en costos extra.

## Billing
- Se crea una **organización** por empresa, que administra todos los _departamentos_, con fines de gobernanza (acceso, monitoreo, aplicación de políticas)
	- Puedo tener el depto. de contabilidad, de ingeniería, cada uno con sus carpetas o _folders_
		- Dentro de la folder, puedo tener $N$ **proyectos**
- A cada proyecto se le asignan recursos por los que se le va a cobrar a la Billing Account
- Una org puede tener $N$ B.A y c/u puede tener $M$ proyectos asignados, que pueden $\in$ a diferentes folders
## Formas de interactuar con GCP
- **Cloud Platform**: interfaz web, que te deja hacer de todo <img src="images/GCP Logo.png" height="40" width="40">
	- Crear y asignar recursos
	- Administrar proyectos
	- Monitorear uso y controlar costos
	- Dentro de esto, existe `Cloud Shell`, que es una terminal configurada con todo lo necesario para permitirnos usar el Cloud SDK
- **Cloud SDK**: nos permite interactuar con la plataforma con cualquier terminal/lenguaje (con sus respectivos clientes)<img src="images/Clase 1/gcloud sdk logo.png" height="40" width="40">
	- En el caso de los lenguajes, wrappean los llamados a las APIs a través de métodos de los clientes
- **Cloud APIs**: todos los servicios exponen una API que permite que nuestros servicios use la plataforma, incluso si el lenguaje particular no posee un SDK que la wrappee
- **Cloud MobileApp**: es más que nada para monitoreo y control

