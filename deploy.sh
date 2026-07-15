#!/bin/bash
# Lopcha Deploy Script
# Run from Terminal: bash deploy.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "📁 Carpeta: $SCRIPT_DIR"

# Clone fresh copy of the repo
TMPDIR=$(mktemp -d)
echo "⬇️  Clonando lopcha-landing..."
git clone https://github.com/serartu-cmyk/lopcha-landing.git "$TMPDIR/lopcha-landing"
cd "$TMPDIR/lopcha-landing"

# Copy all HTML pages
echo "📄 Copiando páginas..."
cp "$SCRIPT_DIR/index.html" .
cp "$SCRIPT_DIR/medicare.html" .
cp "$SCRIPT_DIR/aca.html" .
cp "$SCRIPT_DIR/vida.html" .
cp "$SCRIPT_DIR/blog.html" .
cp "$SCRIPT_DIR/ensuro.html" .
cp "$SCRIPT_DIR/privacidad.html" .
cp "$SCRIPT_DIR/terminos.html" .
cp "$SCRIPT_DIR/vercel.json" .
mkdir -p agentes
cp "$SCRIPT_DIR/agentes/daniela.html" agentes/ 2>/dev/null || true
cp "$SCRIPT_DIR/agentes/"*.jpg agentes/ 2>/dev/null || true

# Copy CSS system
echo "🎨 Copiando CSS..."
mkdir -p css
cp "$SCRIPT_DIR/css/tokens.css" css/
cp "$SCRIPT_DIR/css/typography.css" css/
cp "$SCRIPT_DIR/css/components.css" css/

# Copy assets
echo "🖼️  Copiando assets..."
cp "$SCRIPT_DIR/favicon.svg" .
cp "$SCRIPT_DIR/logo.svg" .
cp "$SCRIPT_DIR/robots.txt" .
cp "$SCRIPT_DIR/llms.txt" . 2>/dev/null || true
cp "$SCRIPT_DIR/llms-full.txt" . 2>/dev/null || true
cp "$SCRIPT_DIR/sitemap.xml" . 2>/dev/null || true

# Copy all blog posts (including new 2026 ones)
echo "📝 Copiando blog posts..."
mkdir -p blog
for f in "$SCRIPT_DIR"/blog/*.html; do
  [ -f "$f" ] && cp "$f" blog/
done
# Remove .bak files
rm -f blog/*.bak

# Copy blog images (webp)
echo "🖼️  Copiando imágenes del blog..."
mkdir -p blog/img
cp "$SCRIPT_DIR/blog/img/"*.webp blog/img/
# Quitar del repo las fotos PNG pesadas sin uso
git rm -r --cached "fotos blog" 2>/dev/null || true
rm -rf "fotos blog"
cp "$SCRIPT_DIR/.gitignore" .

# Show what changed
echo ""
echo "=== Cambios ==="
git status --short
echo ""

# Commit and push
git add -A
git commit -m "fix: auditoría jul-2026 — compliance CMS/TCPA, páginas legales, imágenes blog, redirects y headers"

echo ""
echo "🚀 Pushing a GitHub..."
git push origin main

echo ""
echo "✅ Listo! Vercel está desplegando automáticamente."
echo "🌐 Revisa en: https://lopcha-landing.vercel.app"
echo "📄 Nueva página: https://lopcha.com/ensuro"
echo ""
echo "Limpiando carpeta temporal..."
rm -rf "$TMPDIR"
