#!/bin/bash

# Скрипт базовой настройки iptables для Hardening
# ВАЖНО: Убедитесь, что порт SSH (22022) указан верно, иначе вы потеряете доступ!

SSH_PORT="22022"

echo "[*] Очистка текущих правил..."
iptables -F
iptables -X

echo "[*] Установка политик по умолчанию (Default Deny)..."
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

echo "[*] Разрешение локального интерфейса (loopback)..."
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

echo "[*] Разрешение уже установленных соединений..."
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

echo "[*] Открытие порта SSH ($SSH_PORT)..."
iptables -A INPUT -p tcp --dport $SSH_PORT -j ACCEPT

# Раскомментируйте, если нужен веб-сервер
echo "[*] Открытие портов HTTP/HTTPS..."
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

echo "[*] Сохранение правил..."
netfilter-persistent save

echo "[+] Готово! Текущие правила:"
iptables -L INPUT -n -v
