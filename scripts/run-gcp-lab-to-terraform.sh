#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 4 ]]; then
  echo "Uso:"
  echo "  $0 \"<lab_1_url>\" \"<lab_1_markdown>\" \"<lab_2_url>\" \"<lab_2_markdown>\""
  exit 1
fi

LAB1_URL="$1"
LAB1_MD="$2"
LAB2_URL="$3"
LAB2_MD="$4"

read -r -d '' PROMPT_TEMPLATE <<'EOF' || true
Aplicá la skill gcp-lab-to-terraform para este repo.

1. Extraé únicamente los comandos ejecutados del Lab 1:
__LAB1_URL__
y volcálos en:
__LAB1_MD__

2. Hacé lo mismo para el Lab 2:
__LAB2_URL__
y volcálos en:
__LAB2_MD__

3. Antes de cada comando agregá un H3 y una breve explicación en español.
4. Identificá recursos por cada lab y agregalos en cada markdown.
5. Creá un ejemplo Terraform por cada lab dentro de:
src/examples/cloud-run/
6. Aplicá buenas prácticas (variables, locals, outputs, sin duplicación).
7. Cableá links en src/SUMMARY.md y README.md.
8. Actualizá src/examples/README.md con resumen de prácticas y link remoto.
9. Ejecutá terraform fmt donde corresponda.
EOF

PROMPT="${PROMPT_TEMPLATE//__LAB1_URL__/$LAB1_URL}"
PROMPT="${PROMPT//__LAB1_MD__/$LAB1_MD}"
PROMPT="${PROMPT//__LAB2_URL__/$LAB2_URL}"
PROMPT="${PROMPT//__LAB2_MD__/$LAB2_MD}"

echo "----- Prompt listo para pegar -----"
echo "$PROMPT"
echo "-----------------------------------"

if command -v pbcopy >/dev/null 2>&1; then
  printf "%s" "$PROMPT" | pbcopy
  echo "Prompt copiado al clipboard con pbcopy."
fi
