[Link al lab](https://www.skills.google/paths/12/course_templates/654/labs/592556)
Fuente pública utilizada para extraer comandos (por requerir login): [Build and Secure Networks in Google Cloud: Challenge Lab (DEV Community)](https://dev.to/sandeepk27/build-and-secure-networks-in-google-cloud-challenge-lab-5g38).

## Recursos identificados

- APIs/servicios GCP:
  - `Compute Engine API` (`compute.googleapis.com`).
  - `Identity-Aware Proxy API` (`iap.googleapis.com`) para SSH vía IAP TCP forwarding.
- Recursos principales:
  - Red `acme-vpc`.
  - Subred de gestión `acme-mgmt-subnet` (CIDR usado para SSH interno).
  - VM `bastion` (sin public IP en el escenario objetivo).
  - VM `juice-shop` (exposición HTTP pública y SSH interno restringido).
  - Reglas de firewall: `open-access` (a eliminar), regla SSH vía IAP, regla HTTP pública, regla SSH interna.
- IAM:
  - Uso de permisos para administrar firewall/tagging en Compute Engine.
  - Acceso operativo vía IAP (normalmente con rol como `roles/iap.tunnelResourceAccessor` para usuarios operadores).
- Integraciones:
  - IAP TCP forwarding -> SSH a `bastion`.
  - `bastion` -> SSH interno a `juice-shop`.
  - Exposición HTTP de `juice-shop` mediante regla ingress acotada a `tcp:80`.

## Comandos ejecutados

```bash
gcloud compute firewall-rules delete open-access
```

```bash
gcloud compute instances start bastion --zone=us-central1-b
```

```bash
gcloud compute firewall-rules create ssh-ingress --allow=tcp:22 --source-ranges 35.235.240.0/20 --target-tags [NETWORK_TAG_1] --network acme-vpc
```

```bash
gcloud compute instances add-tags bastion --tags=[NETWORK_TAG_1] --zone=us-central1-b
```

```bash
gcloud compute firewall-rules create http-ingress --allow=tcp:80 --source-ranges 0.0.0.0/0 --target-tags [NETWORK_TAG_2] --network acme-vpc
```

```bash
gcloud compute instances add-tags juice-shop --tags=[NETWORK_TAG_2] --zone=us-central1-b
```

```bash
gcloud compute firewall-rules create internal-ssh-ingress --allow=tcp:22 --source-ranges 192.168.10.0/24 --target-tags [NETWORK_TAG_3] --network acme-vpc
```

```bash
gcloud compute instances add-tags juice-shop --tags=[NETWORK_TAG_3] --zone=us-central1-b
```

```bash
ssh <internal-IP-of-juice-shop>
```
