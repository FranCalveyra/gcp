---
name: gcp-lab-to-terraform
description: Extrae comandos ejecutados desde labs de Google Skills/Cloud Skills Boost, documenta recursos identificados, crea ejemplos Terraform por lab con buenas practicas, y conecta resultados en SUMMARY.md/README.md. Usar cuando el usuario pida transformar labs en markdown accionable y en practicas IaC repetibles.
---

# GCP Lab to Terraform

## Ejecucion directa

Para generar un prompt listo para pegar en el chat del agente:

```bash
./scripts/run-gcp-lab-to-terraform.sh "<lab_1_url>" "<lab_1_example_dir>" "<lab_2_url>" "<lab_2_example_dir>"
```

Ejemplo:

```bash
./scripts/run-gcp-lab-to-terraform.sh \
  "https://www.skills.google/focuses/49757?..." \
  "src/examples/cloud-run/cloud-run-functions-qwik-start" \
  "https://www.skills.google/paths/12/course_templates/559/labs/564964" \
  "src/examples/cloud-run/pubsub-with-cloud-run"
```

El script imprime el prompt y lo copia al clipboard en macOS (`pbcopy`) si esta disponible.

## Objetivo

Estandarizar un flujo repetible para:

1. Extraer **solo comandos** de labs.
2. Documentarlos en markdown en espanol.
3. Identificar recursos usados por cada lab.
4. Crear practicas Terraform reutilizables.
5. Enlazar labs/practicas en `src/SUMMARY.md` y `README.md`.

## Convenciones de salida

- Escribir en espanol (idealmente espanol argentino) cuando sea texto explicativo.
- Mantener comandos CLI sin traducir.
- Mantener nombres de servicios GCP sin traducir.
- Evitar ruido: priorizar contenido accionable.

## Inputs esperados

- URL(s) del/los lab(s).
- Directorio destino **por lab** (carpeta del ejemplo), por ejemplo `src/examples/cloud-run/pubsub-with-cloud-run`.

Regla: **no se requiere que exista un `lab.md` previo**. El agente debe crear `lab.md` dentro de cada carpeta indicada.

## Workflow

Copiar este checklist y marcar avance:

```text
Progreso:
- [ ] 1) Relevar contenido de labs y extraer comandos
- [ ] 2) Actualizar markdowns de labs (comandos + explicacion)
- [ ] 3) Identificar recursos por lab
- [ ] 4) Crear ejemplos Terraform por lab
- [ ] 5) Ejecutar terraform fmt y verificacion basica
- [ ] 6) Hacer wiring en SUMMARY.md y README.md
- [ ] 7) Crear/actualizar README de examples
```

---

## 1) Extraer comandos de labs

1. Obtener contenido del lab:
   - Usar `WebFetch` si la URL es publica.
   - Si la URL requiere login, buscar espejo publico en Cloud Skills Boost o fuente oficial equivalente.
2. Extraer **solo comandos ejecutados** (sin texto narrativo).
3. Si el usuario lo pide, agregar antes de cada comando:
   - `### <titulo breve>`
   - una linea explicando para que se usa.

### Regla para comandos multilinea

- Preservar banderas y orden.
- Formatear con bloques `bash`.
- No inventar comandos que no aparezcan en la guia base.

---

## 2) Actualizar markdowns de labs

En cada carpeta de ejemplo indicada por el usuario, crear/actualizar `lab.md` con esta estructura minima:

```markdown
[Link al lab](...)

## Recursos identificados
- ...

## Comandos ejecutados
### ...
```bash
comando
```
```

Notas:
- La seccion `Recursos identificados` se puede agregar antes o despues de comandos.
- Si el usuario pidio "solo comandos", no agregar explicaciones extra fuera de lo solicitado.

---

## 3) Identificar recursos por lab

Para cada lab, listar al menos:

- APIs habilitadas.
- Recursos principales (Cloud Run services, Cloud Run Functions, Pub/Sub, buckets, VMs, etc.).
- IAM (service accounts + roles relevantes).
- Integraciones (triggers, push endpoints, Eventarc, etc.).

Mantener el inventario pragmatico; no hiper-detallar campos irrelevantes.

---

## 4) Crear ejemplos Terraform por lab

Crear una carpeta por practica, por ejemplo:

- `src/examples/cloud-run/<lab-slug>/`

Archivos minimos por practica:

- `versions.tf`
- `variables.tf`
- `main.tf`
- `outputs.tf`
- `README.md`

### Buenas practicas obligatorias

- Variables para valores repetidos (`project_id`, `region`, nombres, imagenes).
- `locals` para derivaciones y centralizacion.
- `outputs` utiles (URLs, nombres de recursos clave).
- Dependencias explicitas cuando evitan race conditions.
- `disable_on_destroy = false` al habilitar APIs.
- Evitar hardcode de datos sensibles o IDs de proyecto.

---

## 5) Verificacion tecnica minima

1. Ejecutar `terraform fmt` sobre los nuevos ejemplos.
2. Ejecutar chequeos livianos disponibles (por ejemplo lints del editor).
3. Si no se puede validar runtime real, dejarlo explicitado al final.

---

## 6) Wiring en documentacion global

Actualizar:

- `src/SUMMARY.md`:
  - agregar labs en `# Labs` apuntando a `./examples/**/<lab-slug>/lab.md`
  - agregar practicas en `# Ejemplos` (o seccion equivalente) apuntando a `./examples/**/<lab-slug>/README.md`
- `README.md` (raiz):
  - agregar seccion corta de labs y practicas con links.

Mantener estilo consistente con el repo.

---

## 7) README de `src/examples/`

Si existe `src/examples/README.md` vacio o incompleto:

- Describir que practicas hay.
- Explicar uso rapido (`terraform init`, `plan`, `apply`).
- Incluir recomendaciones de uso.
- Si el usuario lo pide, agregar link al folder remoto de GitHub.

## Criterios de calidad (DoD)

- Cada lab tiene comandos extraidos y legibles.
- Cada lab tiene recursos identificados.
- Cada lab tiene practica Terraform funcionalmente coherente.
- Documentacion global enlaza labs + practicas.
- No hay placeholders sin resolver en rutas locales.
