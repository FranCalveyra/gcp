# Google Cloud Platform + AI Fundamentals - Universidad Austral

> Material completo del curso de GCP + AI Fundamentals, Universidad Austral, año 2026

## Sobre este repositorio

Este repositorio contiene el material completo del curso **GCP + AI Fundamentals** de la Universidad Austral, cursado durante el año 2026. El contenido está organizado en formato de libro digital utilizando [mdBook](https://rust-lang.github.io/mdBook/), facilitando el estudio y la comprensión de los servicios y arquitecturas de Google Cloud Platform, y los servicios de AI que ofrece.

## Criterios de evaluación
- Para aprobar la materia es necesario tener todos los laboratorios aprobados.
	- Algunos van a servir como checkpoint
- Parcial teórico multiple choice al final de la materia
- Es promocionable si te sacas 7 o más
## Contenido

### Clases Teórico-Prácticas

El curso incluye 16 clases que cubren los aspectos fundamentales de GCP:

- **Clase 1**: Introducción a la computación en la nube y AWS
- **Clase 2**: 
- **Clase 3**: 
- **Clase 4**: 
- **Clase 5**: 
- **Clase 6**: 
- **Clase 7**: 
- **Clase 8**: 
- **Clase 9**: 
- **Clase 10**: 
- **Clase 11**: 
- **Clase 12**:
- **Clase 13**:
- **Clase 14**:

### Recursos Adicionales

### Estructura del repositorio

```
aws/
├── book/                    # Carpeta generada con el libro compilado
├── src/                     # Contenido del curso
│   ├── SUMMARY.md          # Índice del libro
│   ├── Clase 1.md          # Introducción a la nube
│   ├── images/             # Imágenes extraídas de las presentaciones
│   ├── presentations/      # PDFs originales de las presentaciones
│   └── examples/           # Ejemplos de código
├── book.toml               # Configuración de mdBook
└── README.md               # Este archivo
```

## Cómo usar este repositorio

### Para estudiar

1. **Visualizar el libro**: Accede al contenido en formato web ejecutando:
   ```bash
   mdbook serve
   ```
   Luego abre `http://localhost:3000` en tu navegador

2. **Leer offline**: Navega directamente por los archivos `.md` en el directorio `src/`

3. **Orden recomendado**: Sigue la secuencia de clases para un aprendizaje progresivo

### Para desarrolladores

- **Requisitos previos**: Instalar mdBook
  ```bash
  cargo install mdbook
  ```

- **Generar el libro**:
  ```bash
  mdbook build
  ```

### Para contribuir

- Si encontrás errores o mejoras, no dudes en crear un issue o pull request
- Las correcciones y ampliaciones son bienvenidas

## Temas principales


## Notas importantes

- Este material contiene las presentaciones del curso transcriptas a formato Markdown
- El contenido está actualizado con las prácticas y servicios de GCP vigentes en 2026
- Los PDFs originales se mantienen en `src/presentations/` para referencia
- Compatible con mdBook para una experiencia de lectura optimizada

---

**Docentes**: Rodrigo Pazos, Mora Villa Abrille  
**Materia**: GCP + AI Fundamentals
**Universidad**: Universidad Austral  
**Año**: 2026