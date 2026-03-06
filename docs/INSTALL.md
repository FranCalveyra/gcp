# Guía de Instalación

Esta guía te va a ayudar a configurar el entorno de desarrollo necesario para trabajar con este repositorio de GCP + AI Fundamentals.

## Instalación de Dependencias

### 1. Rust (Requerido para mdBook)

#### En Linux/macOS:
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
```

#### En Windows (PowerShell):
```powershell
Invoke-WebRequest -Uri https://win.rustup.rs/x86_64 -OutFile rustup-init.exe
.\rustup-init.exe
```

#### Verificar instalación:
```bash
rustc --version
cargo --version
```

### 2. mdBook

**IMPORTANTE**: Instalar la versión 0.4.48 para compatibilidad con los plugins:

```bash
cargo install mdbook --version 0.4.48
```

#### Verificar instalación:
```bash
mdbook --version
# Debe mostrar: mdbook v0.4.48
```

### 3. mdbook-katex (Plugin para fórmulas matemáticas)

```bash
cargo install mdbook-katex
```

#### Verificar instalación:
```bash
mdbook-katex --version
```

### 4. mdbook-mermaid (Plugin para diagramas)

**IMPORTANTE**: Instalar la versión 0.14.0 para compatibilidad con mdbook 0.4.48:

```bash
cargo install mdbook-mermaid --version 0.14.0
```

#### Verificar instalación:
```bash
mdbook-mermaid --version
# Debe mostrar: mdbook-mermaid 0.14.0
```

#### Instalar assets de mermaid:
Después de instalar mdbook-mermaid, ejecutar en el directorio del proyecto:
```bash
mdbook-mermaid install .
```

Este comando copia los archivos JavaScript necesarios (`mermaid.min.js` y `mermaid-init.js`) y actualiza la configuración en `book.toml`.

## Configuración del Proyecto

### 1. Clonar el repositorio
```bash
git clone <url-del-repositorio>
cd distributed-systems
```

### 2. Configurar template de commit
```bash
git config commit.template .gitmessage
```

### 3. Verificar configuración
```bash
# Verificar que mdBook funciona
mdbook build

# Verificar que el plugin katex funciona
mdbook-katex --help
```

## Comandos Útiles

### Desarrollo
```bash
# Servir el libro en modo desarrollo (con hot-reload)
mdbook serve

# Construir el libro
mdbook build

# Limpiar archivos generados
mdbook clean
```

### Estructura de archivos generados
```
book/                    # Archivos HTML generados
├── index.html          # Página principal
├── assets/             # Recursos estáticos
└── ...
```

## Solución de Problemas

### Error: "mdbook: command not found"
- Asegurate de que Rust esté instalado correctamente
- Verificá que `~/.cargo/bin` esté en tu PATH
- Reiniciá tu terminal después de la instalación

### Error: "mdbook-katex: command not found"
- Instalá mdbook-katex: `cargo install mdbook-katex`
- Verificá que esté en el PATH: `which mdbook-katex`

### Error de permisos en Linux/macOS
```bash
# Dar permisos de ejecución si es necesario
chmod +x ~/.cargo/bin/mdbook
chmod +x ~/.cargo/bin/mdbook-katex
```

### Problemas con fórmulas matemáticas
- Asegurate de que mdbook-katex esté instalado
- Verificá que las fórmulas estén en formato LaTeX correcto
- Revisá la configuración en `book.toml`

### Problemas con diagramas Mermaid
- Verificá que mdbook-mermaid versión 0.14.0 esté instalado
- Ejecutá `mdbook-mermaid install .` en el directorio del proyecto
- Asegurate de que los archivos `mermaid.min.js` y `mermaid-init.js` existan en el directorio raíz
- Los diagramas se renderizan en el navegador (client-side), no necesitan herramientas externas

### Incompatibilidades de versiones
Si ves errores como "Unable to parse the input" o advertencias sobre versiones de mdbook:
- Asegurate de usar mdbook 0.4.48: `cargo install mdbook --version 0.4.48 --force`
- Asegurate de usar mdbook-mermaid 0.14.0: `cargo install mdbook-mermaid --version 0.14.0 --force`
- Reinstalá los assets: `mdbook-mermaid install .`

## Configuración Avanzada

### Variables de entorno (opcional)
```bash
# Agregar al ~/.bashrc o ~/.zshrc
export PATH="$HOME/.cargo/bin:$PATH"
```

### Configuración de mdBook
El archivo `book.toml` contiene la configuración del libro. Las opciones principales incluyen:

```toml
[book]
title = "GCP + AI Fundamentals"
authors = ["Francisco Calveyra"]
language = "es"

[output.html]
default-theme = "light"
preferred-dark-theme = "navy"

[preprocessor.katex]
```

## Verificación Final

Para verificar que todo está funcionando correctamente:

1. **Construir el libro**:
   ```bash
   mdbook build
   ```

2. **Servir en modo desarrollo**:
   ```bash
   mdbook serve
   ```

3. **Abrir en el navegador**: http://localhost:3000

4. **Verificar fórmulas matemáticas**: Buscá páginas con ecuaciones LaTeX

## Recursos Adicionales

- [Documentación oficial de mdBook](https://rust-lang.github.io/mdBook/)
- [mdbook-katex plugin](https://github.com/lzanini/mdbook-katex)
- [Rust installation guide](https://doc.rust-lang.org/book/ch01-01-installation.html)

---

Si encontrás problemas durante la instalación, no dudes en crear un issue en el repositorio.