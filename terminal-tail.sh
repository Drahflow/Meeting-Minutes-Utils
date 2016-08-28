#!/bin/sh

echo -ne '\e[2J\e[?25l'; while sleep 0.05; do echo -ne '\e[1;1H'; tail -c 1024 "$1" | w3m -cols 60 -T text/html -dump | tail -n 16 | sed -e 's/^/[2K/g'; done
