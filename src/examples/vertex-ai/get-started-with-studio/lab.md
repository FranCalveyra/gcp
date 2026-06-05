[Link al lab](https://www.skills.google/course_templates/552/labs/604755)

## Recursos identificados

- Servicio principal: `Vertex AI Studio` (parte de Agent Platform).
- Modelos usados:
  - `gemini-2.5-flash` (tareas 1, 2, 3, 4)
  - `Gemini 2.5 Pro` (comparación en tarea 3)
  - `Imagen 4` (generación de imágenes, tarea 5)
  - `Chirp 3 HD Voices` (síntesis de voz, tarea 5 — opcional)
- APIs habilitadas:
  - Vertex AI API
  - Cloud Build API
  - Cloud Run API
  - Cloud Text-to-Speech API (opcional)
- Recursos creados:
  - 5 prompts guardados en Vertex AI Studio
  - 1 aplicación Cloud Run deployada desde la consola
- IAM: roles implícitos del proyecto de lab; Cloud Run con acceso no autenticado.

> Este lab es UI-driven: todos los pasos se hacen desde la consola de Google Cloud. No hay comandos `gcloud` en el flujo principal.

---

## Tarea 1: Crear una aplicación desde un prompt

El objetivo es construir un prototipo de chat para análisis de riesgo de seguros y deployarlo como una app real en Cloud Run, todo desde la UI.

**Pasos:**

1. Desde la consola, ir a **Agent Platform > Studio** (o búscarlo como "Vertex AI Studio").
2. Hacer clic en **New prompt** y elegir tipo **Chat**.
3. Nombrar el prompt: `Insurance Risk Summary - Prototype`.
4. En el campo **System instructions**, escribir algo como:
   > "You are an expert insurance underwriter. Analyze facility risk based on the information provided and produce a concise risk summary."
5. En el área de chat, pegar el siguiente escenario de cliente:
   > "SafeHarbor Warehousing — Facility stores flammable chemicals, located in a flood zone, last inspection 3 years ago."
6. Seleccionar modelo: `gemini-2.5-flash`, región: `Global`.
7. Hacer clic en **Submit** y revisar la respuesta del modelo.
8. Guardar el prompt con **Save**.
9. Ir a **Code > Deploy > Deploy as app** para deployarlo en Cloud Run.
   - Cuando la consola lo pida, habilitar **Cloud Build API** y **Cloud Run API**.
   - Esperar a que el deploy finalice (puede tardar 2-3 minutos).
10. Abrir la URL de la app deployada y probarla con una nueva consulta distinta al escenario original.

**Qué se aprende**: el ciclo completo prompt → prototipo → aplicación productiva, sin escribir una sola línea de código.

---

## Tarea 2: Diseñar prompts efectivos

El objetivo es entender cómo cambia la respuesta del modelo según la técnica de prompting y los parámetros configurados.

**Zero-shot prompting:**

1. Crear un nuevo prompt tipo **Chat**: `Insurance Claim Data Extraction`.
2. En System instructions: definir el rol como extractor de datos estructurados de notificaciones de siniestros.
3. En el chat, pegar una notificación de siniestro en texto libre (ejemplo: un incidente de daño por agua con fecha, descripción y monto estimado).
4. Configurar **Temperature: `0.1`** y **Output Token Limit: `1024`**.
5. Enviar y observar qué extrae el modelo sin ejemplos.

**Few-shot prompting:**

6. Sin cambiar el prompt anterior, agregar un bloque de **ejemplo** antes del caso real:
   - Input de ejemplo: otra notificación de siniestro.
   - Output de ejemplo: la extracción correctamente formateada.
7. Volver a enviar la consulta original y comparar la mejora en estructura y precisión.

**Experimentos con parámetros:**

8. Ajustar **Temperature** a `1.5` y reenviar: notar respuestas más creativas/impredecibles.
9. Cambiar **Output Token Limit** a `500`: la respuesta se corta; con `65535` no se corta.
10. Modificar **Top-P** entre `0.8` y `1.0`: controla qué tan diverso es el vocabulario usado.
11. Explorar (sin modificar) los paneles de: **Safety Filters**, **Thinking Budget**, **Structured Output** y **Grounding**.

**Qué se aprende**: por qué few-shot supera a zero-shot en tareas estructuradas, y cómo temperatura/Top-P/tokens afectan el output de maneras concretas y distintas.

---

## Tarea 3: Gestión y comparación de prompts

El objetivo es usar la feature **Compare** de Vertex AI Studio para evaluar variantes de un mismo prompt en paralelo.

**Pasos:**

1. Crear nuevo prompt: `Insurance Risk Factor Identification`.
2. System instructions: rol de analista de riesgos que identifica factores de riesgo en un negocio.
3. Ingresar como input la descripción de un restaurante (ejemplo: local en zona comercial densa, cocina a gas, sin rociadores).
4. Configurar `gemini-2.5-flash`, temperatura `0.2`.
5. Enviar y guardar.
6. Hacer clic en **Compare** para abrir el panel de comparación lado a lado.
7. Probar estas tres variaciones:
   - **Variación A**: agregar a las instrucciones que el modelo también debe sugerir estrategias de mitigación por cada riesgo.
   - **Variación B**: temperatura `0.2` (original) vs temperatura `2.0` (muy alta): observar la diferencia en coherencia.
   - **Variación C**: `gemini-2.5-flash` vs `Gemini 2.5 Pro`: comparar profundidad y razonamiento en el análisis.

**Qué se aprende**: cómo iterar sobre prompts de forma sistemática en lugar de hacerlo de a uno; la diferencia práctica entre modelos de distinta capacidad.

---

## Tarea 4: Prompts multimodales con Gemini

El objetivo es usar Gemini para analizar una imagen y responder preguntas de razonamiento sobre su contenido.

**Pasos:**

1. Crear nuevo prompt: `Timetable Image Analysis`.
2. En el área de contenido, hacer clic en **Insert > Image from Cloud Storage**.
3. Importar `timetable.png` (imagen de un horario de vuelos, provista por el lab en un bucket público).
4. Configurar `gemini-2.5-flash`, región Global.
5. Junto a la imagen, escribir el prompt:
   > "Provide a title for this image, a short description, and extract all visible text."
6. Enviar y revisar: el modelo describe la imagen y transcribe el texto del horario.
7. Enviar un segundo prompt de razonamiento:
   > "What percentage of departures listed are international flights?"
   El modelo razona sobre los datos que acaba de extraer.
8. Cambiar temperatura a `0.8` y reenviar el segundo prompt: notar variación en el estilo de respuesta.
9. Volver a temperatura `0.2` para respuestas más determinísticas.

**Qué se aprende**: Gemini puede interpretar imágenes y razonar sobre ellas en el mismo contexto conversacional, sin preprocesamiento externo.

---

## Tarea 5: Generación de media

### Imágenes con Imagen 4

1. En Vertex AI Studio, hacer clic en **New > Image**.
2. Escribir un prompt descriptivo. Ejemplo:
   > "A photorealistic macro photograph of a honeybee collecting nectar from lavender flowers, golden hour lighting."
3. Seleccionar modelo: `Imagen 4`.
4. Configurar: aspect ratio `1:1`, cantidad de resultados: `4`.
5. Hacer clic en **Generate** y revisar los cuatro resultados.
6. Seleccionar una imagen y explorar las opciones **Inpaint** (modificar una región de la imagen) y **Outpaint** (expandir el encuadre).
7. Notar el badge de **SynthID**: marca de agua digital que identifica imágenes generadas por IA.

### Voz con Chirp 3 (opcional)

1. Si no está habilitada, activar **Cloud Text-to-Speech API** desde el panel de configuración.
2. Hacer clic en el ícono de audio para abrir la herramienta de síntesis de voz.
3. Ingresar el texto:
   > "Welcome to the world of generative AI on Google Cloud."
4. Seleccionar modelo: `Chirp 3 HD Voices`, idioma: inglés (US).
5. Elegir una variante de voz y hacer clic en **Generate**.
6. Escuchar el audio generado.

**Qué se aprende**: Vertex AI Studio no es solo texto — agrupa en un mismo lugar generación de imágenes (Imagen 4), voz (Chirp) y texto (Gemini), todos accesibles sin código.
