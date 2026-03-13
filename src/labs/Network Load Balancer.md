# Set Up a NLB (Network Load Balancer)
[Link al Lab](https://www.skills.google/focuses/12007?catalog_rank=%7B%22rank%22%3A1%2C%22num_filters%22%3A0%2C%22has_search%22%3Atrue%7D&parent=catalog&search_id=76185041)

El Lab trata de crear un cluster de máquinas `e2-small` y ponerlas detrás de un NLB para poder redirigr el tráfico entre ellas.

Para ello, hay que seguir una serie de pasos, detallados en el subitem [Crear un cluster de máquinas y asignarlas a una Target Pool](../Cloud%20Shell.md#crear-un-cluster-de-m%C3%A1quinas-y-asignarlas-a-una-target-pool) del archivo de Cloud Shell.

Aparece el concepto de [Forwarding Rule](https://docs.cloud.google.com/load-balancing/docs/forwarding-rule-concepts), que entiendo que son las reglas de mappeo para redirigir tráfico. En el caso del lab, mappea el puerto 80 de la IP del NLB hacia la pool de instancias con el argumento `target-pool`. 
Esta pool de instancias sería el cluster de máquinas entre el cual queremos distribuir el tráfico.


