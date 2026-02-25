#!/bin/bash
# Script para iniciar Ollama accesible desde Android

echo "⚠️  IMPORTANTE: Detén Ollama manualmente primero si está corriendo"
echo "   Encuentra el PID con: pgrep -f ollama"
echo "   Detén con: kill <PID>"
echo ""
echo "Presiona Enter cuando hayas detenido Ollama..."
read

echo "Iniciando Ollama en 0.0.0.0:11434 (accesible desde Android)..."
OLLAMA_HOST=0.0.0.0:11434 ollama serve &

sleep 3
echo ""
echo "✓ Ollama iniciado. Verifica con:"
echo "  ss -tlnp | grep 11434"
echo "  (Deberías ver 0.0.0.0:11434 en lugar de 127.0.0.1:11434)"
echo ""
echo "Ahora ejecuta desde el proyecto:"
echo "  flutter run"
