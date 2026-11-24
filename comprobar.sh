#!/bin/bash
# Comprobación del laboratorio HTTP 1 (ejecutar en el host, en la carpeta del proyecto)

OK=0; FAIL=0
ok()   { echo "  [OK]    $1"; OK=$((OK+1)); }
fail() { echo "  [FALLO] $1"; FAIL=$((FAIL+1)); }

echo "== 1. Ficheros necesarios =="
for f in Vagrantfile dns-provision.sh apache2-provision.sh comprobar.hurl \
         files/ns1.olimpo.test/named.conf.local \
         files/ns1.olimpo.test/named.conf.options \
         files/ns1.olimpo.test/olimpo.test.dns \
         files/ns1.olimpo.test/192.168.57.dns \
         files/mercurio.olimpo.test/apolo.olimpo.test.conf \
         files/mercurio.olimpo.test/atenea.olimpo.test.conf \
         files/apolo.olimpo.test/apolo.html \
         files/apolo.olimpo.test/messages/404.html \
         files/atenea.olimpo.test/atenea.html \
         files/atenea.olimpo.test/messages/404.html; do
  [ -f "$f" ] && ok "$f" || fail "falta $f"
done

echo "== 2. Arranque de las VMs =="
if vagrant up >/tmp/vagrant-up.log 2>&1; then ok "vagrant up terminó sin error"
else fail "vagrant up falló (ver /tmp/vagrant-up.log)"; fi

echo "== 3. DNS (10 consultas) =="
good=0
for i in $(seq 1 10); do
  r=$(vagrant ssh web -c "dig +short +time=2 +tries=1 apolo.olimpo.test" 2>/dev/null | tr -d '\r')
  echo "$r" | grep -q "192.168.57.11" && good=$((good+1))
done
[ "$good" -eq 10 ] && ok "10/10 consultas resueltas" || fail "solo $good/10 consultas resueltas"

for n in ns1:192.168.57.10 mercurio:192.168.57.11 apolo:192.168.57.11 atenea:192.168.57.11; do
  host=${n%%:*}; ip=${n##*:}
  r=$(vagrant ssh dns -c "dig +short $host.olimpo.test" 2>/dev/null)
  echo "$r" | grep -q "$ip" && ok "$host.olimpo.test -> $ip" || fail "$host.olimpo.test no resuelve a $ip"
done

r=$(vagrant ssh dns -c "dig +short -x 192.168.57.11" 2>/dev/null)
echo "$r" | grep -q "mercurio.olimpo.test" && ok "inversa 192.168.57.11 -> mercurio" || fail "resolución inversa"

echo "== 4. Web (Hurl) =="
if hurl --test \
     --resolve apolo.olimpo.test:80:192.168.57.11 \
     --resolve atenea.olimpo.test:80:192.168.57.11 \
     comprobar.hurl; then ok "pruebas Hurl de apolo y atenea"
else fail "pruebas Hurl (ver salida de arriba)"; fi

echo "== 5. Logs =="
l=$(vagrant ssh web -c "sudo ls /var/log/apache2" 2>/dev/null)
for f in apolo.olimpo.test.access.log apolo.olimpo.test.error.log \
         atenea.olimpo.test.access.log atenea.olimpo.test.error.log; do
  echo "$l" | grep -q "$f" && ok "$f" || fail "falta $f"
done

echo
echo "Resultado: $OK correctas, $FAIL fallidas"
[ "$FAIL" -eq 0 ]
