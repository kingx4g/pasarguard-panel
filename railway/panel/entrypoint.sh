#!/bin/sh
set -e

CERT_DIR=/var/lib/pasarguard/certs
CERT=$CERT_DIR/ssl_cert.pem
KEY=$CERT_DIR/ssl_key.pem
mkdir -p "$CERT_DIR"

if [ ! -f "$CERT" ] || [ ! -f "$KEY" ]; then
  echo ">> ساخت گواهی SSL پنل..."
  openssl req -x509 -newkey rsa:2048 -nodes -days 3650 \
    -keyout "$KEY" -out "$CERT" -subj "/CN=panel" 2>/dev/null
fi

echo ">> آپدیت جدول‌های دیتابیس..."
alembic upgrade head

echo ">> ساخت کد ورود موقت مالک..."
python pasarguard-cli.py generate-temp-key || true

echo ">> استارت پنل..."
exec python main.py
