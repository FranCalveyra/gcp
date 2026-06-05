# AI y BigQuery

## BigQuery

Es un servicio serverless de [data warehousing](https://cloud.google.com/bigquery/docs): te deja correr SQL sobre volúmenes masivos de datos sin administrar infraestructura. Está construido sobre bases de datos **columnares**, que son mucho más eficientes que las relacionales clásicas para queries analíticos.

No solemos cargar datos desde nuestra máquina. Lo típico es traerlos desde una fuente que ya los tenga — un bucket de GCS, un data lake externo, o bien derivarlos de tablas que ya están en BigQuery.

Para cargar datos hay tres caminos:

| Método | Automatizable | Cuándo usarlo |
|---|---|---|
| Console (CSV upload) | No | Exploración rápida, datasets chicos |
| CLI `bq load` desde GCS | Sí | Pipelines batch repetibles |
| DDL `CREATE TABLE AS SELECT` | Sí | Derivar tablas ya en BQ |

### BigQuery ML

Podés entrenar modelos de ML directamente en SQL, sin mover los datos. El trade-off es que tenés menos opciones de modelos que Vertex AI, pero los datos nunca salen de BigQuery — no hay infra de ML que gestionar.

```sql
-- Entrenás el modelo con SQL, sobre datos que ya están en BQ
CREATE OR REPLACE MODEL nyctaxi.fare_model
OPTIONS(model_type='linear_reg', input_label_cols=['fare_amount']) AS
SELECT fare_amount, trip_distance, passenger_count,
  EXTRACT(HOUR FROM pickup_datetime) AS pickup_hour
FROM nyctaxi.2018trips
WHERE fare_amount > 0 AND trip_distance > 0;

-- Y predecís también con SQL
SELECT * FROM ML.PREDICT(MODEL nyctaxi.fare_model,
  (SELECT 5.0 AS trip_distance, 2 AS passenger_count, 18 AS pickup_hour));
```

---

## AI en GCP

**[Agent Platform](https://cloud.google.com/vertex-ai/docs)** (antes Vertex AI, renombrado en 2026) es la plataforma unificada de ML/AI. Dentro tiene Model Garden, Agent Builder, RAG Engine, Notebooks y la Gemini API.

**Agent Studio** (antes Vertex AI Studio) es la UI para prototipar con modelos generativos sin escribir código.

Hay tres niveles de abstracción según cuánto control necesitás:

- **APIs pre-entrenadas** (Vision AI, Speech-to-Text, Document AI, Translation): hacés una llamada a la API y listo. Minutos de setup, el más barato.
- **Modelos generativos** (Gemini, Imagen, Chirp): le pasás un prompt con configuración. También minutos de setup, más caro que las APIs pero mucho más flexible.
- **Modelo propio** (Vertex AI Training, AutoML, BigQuery ML): traés tu propio dataset y entrenás. Horas o días, el más costoso.

La regla práctica es empezar siempre desde el nivel más simple. No tiene sentido entrenar un modelo propio si una API ya resuelve el problema.

### ¿Cuándo uso cada cosa?

- Si la tarea es estándar y bien definida (OCR, traducción, transcripción de audio) → **API pre-entrenada**.
- Si necesitás razonamiento, lenguaje natural o algo creativo → **modelo generativo**.
- Si tenés datos tabulares y querés predecir un número a escala → **modelo propio o BigQuery ML**.

Por ejemplo: para extraer texto de 50.000 facturas, Document AI es más barato y más rápido que Gemini. Para un chatbot que responda sobre tus productos, Gemini con Grounding es la opción correcta. Para detectar fraude en transacciones, Gemini no sirve — necesitás un modelo entrenado con tus datos.

### Gemini: Flash vs Pro

Ambos son de Google, pero tienen trade-offs muy distintos:

| | Flash | Pro |
|---|---|---|
| **Latencia** | ~0.5s | ~2–5s |
| **Costo** | ~$0.05 / 1M tokens | ~$1.25 / 1M tokens (25x más caro) |
| **Razonamiento** | Bueno | Significativamente mejor |

Flash para el 80% de los casos. Pro cuando la calidad del razonamiento lo justifica.

---

## ¿Cómo le doy conocimiento al modelo?

El modelo base no sabe nada de tu empresa. Hay tres formas de dárselo, de más simple a más costoso:

### Grounding

Conectás el modelo a fuentes externas en tiempo de inferencia — Google Search o tus propios documentos. No reentrenás nada; el modelo consulta la fuente al momento de responder y **cita las fuentes**.

Útil para información dinámica (precios, noticias, disponibilidad). Setup en minutos.

```python
from google import genai
from google.genai.types import GenerateContentConfig, Tool, GoogleSearch

client = genai.Client(vertexai=True, project="my-project", location="global")
response = client.models.generate_content(
    model="gemini-2.5-flash",
    contents="¿Cuál es la cotización del dólar en Argentina hoy?",
    config=GenerateContentConfig(tools=[Tool(google_search=GoogleSearch())]),
)
```

Sin Grounding el modelo inventa un número. Con Grounding busca en Google y cita de dónde sacó el dato.

### [RAG](https://cloud.google.com/vertex-ai/generative-ai/docs/rag-overview) — Retrieval Augmented Generation

Procesás tus documentos, los convertís en embeddings, y armás un índice de búsqueda vectorial. Cuando el usuario pregunta algo, el sistema busca los fragmentos más relevantes y se los pasa al modelo como contexto.

```
Tus docs → chunks → embeddings → Vector Search
Pregunta → embedding → chunks similares → LLM responde con ese contexto
```

Más control que Grounding sobre qué se recupera y cómo. Setup en horas. Se usa cuando querés buscar patrones o hacer búsqueda semántica sobre tu propio contenido.

### Fine-tuning

Reentrenás el modelo con pares de input/output propios. A diferencia de RAG, no le estás dando información nueva — le estás cambiando el **comportamiento**. Es carísimo y tarda bastante. Usarlo solo cuando Grounding y RAG ya no alcanzan.

---

## ¿Chatbot o Agente?

Un chatbot genera texto. Un agente **ejecuta acciones**.

La diferencia no es que el agente "acceda" a tus sistemas directamente — el modelo genera un pedido estructurado (ej: `create_booking("CBA", "2026-06-06")`), tu aplicación lo recibe, lo ejecuta, y le devuelve el resultado al modelo para que genere la respuesta final.

```python
def get_weather(location: str) -> dict:
    """Devuelve el clima actual de una ubicación."""
    ...

def book_flight(origin: str, destination: str, date: str) -> dict:
    """Reserva un vuelo entre dos ciudades."""
    ...

response = client.models.generate_content(
    model="gemini-2.5-flash",
    contents="Necesito volar de Buenos Aires a Córdoba el viernes. ¿Cómo va a estar el clima allá?",
    config=GenerateContentConfig(tools=[get_weather, book_flight]),
)
```

Gemini decide qué función usar leyendo el nombre, los type hints y el docstring. El SDK convierte eso a un JSON schema automáticamente. Ver [Function Calling](https://cloud.google.com/vertex-ai/generative-ai/docs/multimodal/function-calling).

---

## Prompt Engineering

Antes de cambiar de modelo, agregar RAG o hacer fine-tuning: **mejorar el prompt es gratis**.

- **System Instructions**: definís el rol y el comportamiento base del modelo. Ej: "Sos un analista financiero. Respondé solo con datos, nunca especules."
- **Output Structuring**: le pedís un formato específico. Ej: "Respondé en JSON con keys: risk_level, factors, recommendation."
- **Few-shot**: le das 2–3 ejemplos de input→output antes del input real. Mejora mucho la precisión en tareas estructuradas.
- **Chain of Thought**: "Antes de responder, razoná paso a paso." Útil para problemas complejos.

### Temperature

El modelo predice el siguiente token calculando probabilidades para cada palabra posible. Temperature escala esas probabilidades:

- **Temp 0**: siempre elige el token más probable → siempre la misma respuesta.
- **Temp baja (0.1–0.3)**: los tokens probables se vuelven aún más probables → enfocado y predecible.
- **Temp alta (> 1)**: tokens menos probables ganan chances → respuestas más variadas, pero más erráticas.

Para extracción de datos usás temperatura baja. Para creatividad, alta. Para Q&A, algo en el medio.

---

## Responsible AI

No es solo ética — son restricciones concretas que afectan cómo diseñás el sistema.

- Los datos del cliente **no se usan** para entrenar modelos de Google.
- Los **Safety Filters** están activos por default y pueden rechazar inputs legítimos — hay que manejar ese caso.
- Las **alucinaciones** son siempre posibles, incluso con modelos buenos. Por eso Grounding y RAG muestran fuentes: el usuario puede verificar.
- No hay determinismo garantizado: la misma pregunta no siempre da la misma respuesta.
- **[SynthID](https://deepmind.google/technologies/synthid/)**: watermark invisible que Google embebe en el contenido generado por IA para que sea identificable.
