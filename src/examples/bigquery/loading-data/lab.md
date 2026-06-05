[Link al lab](https://www.skills.google/focuses/19280?parent=catalog)

## Recursos identificados

- Servicio principal: `BigQuery`.
- Dataset: `nyctaxi` (región por defecto del proyecto).
- Tablas:
  - `2018trips` — cargada desde CSV local y luego desde Cloud Storage.
  - `january_trips` — creada con DDL (`CREATE TABLE ... AS SELECT`).
- Fuentes de datos:
  - CSV local descargado al entorno del lab.
  - GCS: `gs://cloud-training/OCBL013/nyc_tlc_yellow_trips_2018_subset_2.csv`.
- APIs habilitadas: BigQuery API.
- IAM: usa credenciales del proyecto de lab (sin service account explícita).

## Comandos ejecutados

### Crear dataset desde consola
Se crea el dataset `nyctaxi` con configuración predeterminada desde BigQuery Studio.

### Crear tabla desde CSV local (consola)
Se descarga `nyc_tlc_yellow_trips_2018_subset_1.csv` y se carga con Auto Detect de esquema.

### Consultar los viajes más caros
```sql
SELECT * FROM nyctaxi.2018trips ORDER BY fare_amount DESC LIMIT 5
```

### Cargar segunda parte del dataset desde Cloud Storage
```bash
bq load \
  --source_format=CSV \
  --autodetect \
  --noreplace \
  nyctaxi.2018trips \
  gs://cloud-training/OCBL013/nyc_tlc_yellow_trips_2018_subset_2.csv
```

### Crear tabla de enero con DDL
```sql
CREATE TABLE nyctaxi.january_trips AS
SELECT * FROM nyctaxi.2018trips
WHERE EXTRACT(Month FROM pickup_datetime) = 1;
```

### Consultar el viaje más largo de enero
```sql
SELECT * FROM nyctaxi.january_trips
ORDER BY trip_distance DESC LIMIT 1
```
