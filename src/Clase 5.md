# VPC
> NIC: Network Interface Controller. Es la interfaz de red con la que una máquina se conecta a una red.
> Vamos a limitarnos a tomar una NIC por máquina. En la vida real se puede tener más de una.

Tengo que tener una forma de identificar a mi máquina.
Vamos a trabajar con IPv4 mayoritariamente. El problema de escalabilidad que tiene es que son direcciones de 32 bits, con cantidad finita de IPs posibles (aproximadamente $2^32 - 1$)

Antes usábamos máscaras, ahora usamos una notación para agurpar IPs llamada CIDR.
Ej: 10.0.1.0/24. El `/24` indica que los primeros 24 bits de la dirección son fijos. El resto son variables.
- Por ende, tengo 256 direcciones libres

Se pueden tener 2 subredes cubiertas por el mismo rango, pero no se **debe**.
No siempre tengo un router central que se encarga de manejar todos los otros routers (y por ende todas las otras redes).

A la hora de definir una topología de red **no es menor ni trivial** definir el CIDR.

Dentro de una red se pueden definir reglas de tráfico.
No suelen ser complejas, pero tienen que estar bien configuradas.

Puedo poner reglas a nivel máquina y a nivel router.

Un firewall dedicado es un aparato físico, una pieza de un rack.
Tiene una capacidad enorme de procesamiento de tráfico.

## RFC
El RFC 1918 es la razón por la que no nos quedamos sin IPs de IPv4, porque dice que tenemos rangos específicos según el lugar donde nos encontremos.
Ej: 10.0.0.0/8 (grande/corpo), 172.16.0.0/12 (mediano/GCP) 192.168.0.0/16 (hogareño/chico).

## GCP Networking
Sobre estos conceptos anteriores Google construye Andrómeda, el SDN (Software Defined Network), que es un sistema compuesto por 2 partes:
- **Control Plane**: definimos reglas
- **Data Plane**: ejecuta las reglas definidas en el Control Plane
Las reglas se aplican a nivel host (máquina con $N$ máquinas virtuales) y no pasan por un router central. Las reglas se distribuyen entre los hosts de manera dinámica y son estos los que filtran el tráfico antes de mandarlo a la red física.

Básicamente se hizo todo el control de red sobre todas las máquinas dentro del host a nivel software.

## VPC

>VPC: Virtual Private Cloud. Es una red virtual privada en la nube.
- Nosotros podemos armar una computadora y nunca conectarla a una red. En GCP esto no puede pasar nunca, ya que toda VM debe $\belongs$ a una VPC, no puede $\exists$ sin una red asociada.
- Si no configuramos nada previamente Google siempre tiene la VPC default lista para nosotros, que se crea con cada proyecto, en algo llamado `Auto-Mode`.
- Este Auto-Mode crea una subred automática.
	- Por default tiene configuraciones muy laxas:
		- Tráfico interno ilimitado entre VMs
		- Tráfico SSH, RDP, ICMP sin límite
			- Ojo con esto
	- Claramente no es una configuración de producción, es para tener algo rápido funcionando.
- Las VPC son globales, mientras que las subredes son regionales.
- Se pueden crear las VPCs en modo custom, con configuraciones más robustas pero que tenemos que setear manualmente.
Network = VPC para simplicidad.

Toda VPC vive dentro de un proyecto, que tiene un componente llamado VPC Routing.

## Firewall
> ¿Cómo hacemos seguridad con todo lo que tenemos configurado, con los grupos lógicos que armamos? $\longrightarrow$ Por medio de reglas de Firewall

- Nos dejan armar reglas de ingreso y egreso de tráfico. Si permitimos que entre una request automáticamente permitimos la respuesta de salida.
- En general tenemos que definir dirección `(entrada/salida)`, `prioridad` (la resolución de conflictos entre reglas se desempata por la prioridad), acción `(permitir/denegar)`, filtro de `origen/destino` según la dirección, y la combinación de `protocolo:puerto`. GCP **siempre asigna una red**.
- Los firewalls se asignan a nivel VPC y dentro de la VPC se asignan a nivel tag. A c/máquina que tenga un tag específico se le aplica una regla. En el caso de que no haya un tag definida se aplica todas las VMs, pero no es lo ideal.
	- Es más rico hacerlo por tag porque es más seguro y prolijo, más fácil de manejar la asignación (por el bajo acoplamiento).
- Se aplica `Deny by Default` (cerrar todo de entrada) y `Least Privilege Principle` (abrimos solo lo necesario)

¿Me interesa que 2 VPCs se comuniquen? $\longrightarrow$ Depende de si es necesario y si se puede permitir por temas de privacidad de datos.

Por lo general queremos que 1 proyecto tenga 1 sola VPC

Andromeda aplica todas las reglas de Firewall a nivel **NIC** (que en este caso es virtual).

### IPs externas

- Google tiene un pool de IPs públicas gigantesco. Cuando creamos una máquina nos puede asignar (por default si) un IP externo para que a través de Internet nos podamos comunicar con esa máquina.
- Llega una request a uno de los routers de borde de google y se redireccionan a partir de un NAT (Network Address Translation) para llegar a la VM dentro de GCP
- Google nos cobra muy muy poco por tener una IP externa fija reservada siempre y cuando la estemos usando. Si dejamos de usarla, te cobran mucho más.
	- No lo estás usando (según ellos) si no lo tenés asignado a ningún recurso.

### Costos
Google te cobra por los siguientes recursos de red:
- Direcciones IPs reservadas
- Cloud Load Balancing
- NAT Gateways
	- El público es para salir a Internet
	- El privado es para conectar 2 VPCs/máquinas/recursos de GCP.
		- Si querés todas con todas usás VPC Peering. Si querés un líder de grupo de VPCs usás este recurso.
- Tráfico

