---
name: presentation-pdf-to-class-notes
description: Transforma presentaciones PDF de clases en apuntes Markdown con estilo consistente al resto del curso, reutilizando diagramas, enlaces y wiring en SUMMARY.md cuando corresponda. Usar cuando el usuario pida convertir slides/decks/presentaciones PDF en `Clase N.md`, mantener el tono de las clases previas, o extraer contenido visual de un PDF a notas legibles.
---

# Presentation PDF to Class Notes

## Objetivo

Estandarizar un flujo repetible para:

1. Relevar una presentacion PDF de clase.
2. Copiar el estilo editorial de las clases ya existentes.
3. Convertir el deck en apuntes Markdown utiles, no en una transcripcion literal.
4. Reusar diagramas/imagenes del PDF cuando aporten contexto.
5. Enlazar la nueva clase en `src/SUMMARY.md` si corresponde.

## Convenciones de salida

- Escribir en espanol, idealmente con tono de apuntes similar al resto del repo.
- Mantener nombres de productos y conceptos de GCP sin traducir cuando asi se usen comunmente.
- Priorizar explicacion sintetica y accionable.
- Evitar copiar texto de slides al pie de la letra si puede resumirse mejor.
- Si el usuario pide excluir portada o cierre, respetarlo explicitamente.

## Inputs esperados

- PDF fuente, por ejemplo `src/presentations/*.pdf`.
- Archivo Markdown destino, por ejemplo `src/Clase 6.md`.
- Clases previas del curso para copiar tono, estructura e intensidad de detalle.
- Indicaciones del usuario sobre:
  - slides a excluir
  - uso de imagenes
  - nivel de detalle
  - necesidad de actualizar indices globales

## Workflow

Copiar este checklist y marcar avance:

```text
Progreso:
- [ ] 1) Relevar estilo de clases existentes
- [ ] 2) Extraer texto util del PDF
- [ ] 3) Recuperar slides visuales como imagenes si hace falta
- [ ] 4) Redactar apuntes en Markdown
- [ ] 5) Agregar links e imagenes seleccionadas
- [ ] 6) Actualizar SUMMARY.md/README.md si corresponde
- [ ] 7) Verificar y limpiar archivos auxiliares no usados
```

---

## 1) Relevar estilo de clases existentes

Antes de escribir:

1. Leer 2 o 3 archivos `src/Clase *.md` cercanos.
2. Detectar:
   - tono del texto
   - nivel de detalle
   - uso de bullets vs parrafos
   - uso de imagenes locales o remotas
   - forma de introducir definiciones y aclaraciones
3. Mantener consistencia con el repo, no con una plantilla generica.

### Patron esperado en este repo

- Titulo corto (`# IAM`, `# VPC`, etc.).
- Secciones tematicas (`##`).
- Explicaciones breves en espanol.
- Bullets con foco en ideas operativas.
- Imagenes insertadas solo cuando ayudan.
- Links oficiales cuando agregan contexto util.

---

## 2) Extraer texto util del PDF

1. Leer el PDF directamente para rescatar texto estructural.
2. Identificar que slides tienen:
   - texto puro
   - diagramas
   - contenido mixto
3. No asumir que la extraccion de texto alcanza: muchos decks tienen slides visuales que salen vacias o incompletas.

### Regla editorial

- Convertir el deck en **notas de clase**.
- No copiar portada ni slide final si el usuario las excluye.
- Reformular para que se lea como apunte corrido, no como slide deck serializado.

---

## 3) Recuperar slides visuales como imagenes

Si el PDF tiene slides visuales, renderizar paginas a PNG y revisar cuales valen la pena.

### Default tecnico

Si no hay herramienta nativa instalada para exportar paginas:

1. Crear un entorno temporal aislado fuera del proyecto (por ejemplo en `/tmp`).
2. Instalar `pymupdf` en ese entorno temporal.
3. Renderizar las paginas del PDF a `png`.
4. Guardar las imagenes en una carpeta de la clase, por ejemplo:
   - `src/images/Clase 6/slides/`

### Criterio de seleccion

Conservar solo imagenes que aporten:

- diagramas de jerarquia
- esquemas de autorizacion
- tablas o figuras utiles
- comparativas que se entiendan mejor visualmente

Eliminar capturas auxiliares que no hayan quedado referenciadas en el Markdown final.

---

## 4) Redactar apuntes en Markdown

Armar el Markdown con estructura simple y reutilizable:

```markdown
# <tema principal>

> Definicion o aclaracion corta si suma contexto.

## <subtema>
- ...

## <subtema>
![Descripcion](./images/Clase%206/slides/slide-2.png)
```

### Reglas de escritura

- Explicar conceptos con lenguaje natural de clase.
- Mantener el foco en:
  - que es
  - para que sirve
  - como se modela en GCP
  - riesgos o buenas practicas
- Cuando haya conceptos de seguridad, remarcar:
  - minimo privilegio
  - herencia
  - alcance de permisos
  - diferencias entre identidad, rol y recurso

### No hacer

- No transcribir numeracion de slides.
- No repetir frases identicas si se pueden sintetizar.
- No llenar el apunte con imagenes redundantes.
- No dejar placeholders del tipo `[Insertar foto]`.

---

## 5) Agregar links e imagenes seleccionadas

Incluir links oficiales cuando realmente agreguen valor. Ejemplos tipicos:

- overview del servicio
- documentacion conceptual
- paginas de roles/policies/arquitectura

Usar imagenes locales del PDF cuando:

- la slide resume una idea mejor que el texto
- el diagrama ayuda a estudiar
- la clase previa ya usa imagenes con naturalidad

---

## 6) Wiring en documentacion global

Si la nueva clase forma parte del libro:

- actualizar `src/SUMMARY.md`
- enlazar la clase nueva junto a las existentes

Actualizar `README.md` solo si:

- ya lista las clases
- el cambio mantiene consistencia con la documentacion global
- el usuario lo pidio o el hueco es evidente

---

## 7) Verificacion final

Antes de cerrar:

1. Leer el archivo destino completo.
2. Verificar que las rutas de imagenes existan.
3. Revisar lints de los archivos tocados.
4. Limpiar imagenes generadas pero no usadas.
5. Confirmar si quedaron cambios globales adicionales (por ejemplo `SUMMARY.md`).

## Criterios de calidad (DoD)

- El Markdown final se lee como apunte de clase, no como OCR del deck.
- El tono coincide con las clases ya presentes en `src/`.
- Las imagenes incluidas son pocas pero utiles.
- Hay links oficiales donde aportan contexto real.
- No quedaron slides excluidas por error.
- No quedaron archivos temporales o capturas descartables sin uso.
