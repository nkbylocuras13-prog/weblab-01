#
# Test `atenea` server in `weblab-1` assignment.
#
# Usage:
#
#     hurl --test --variable site=domain test-atenea.en.hurl
#
# Usage without a DNS Server:
#
#     hurl --test --variable site=domain --resolve host:port:ip test-atenea.en.hurl
#
# Example:
#
#     hurl --test --variable site=olimpo.test test-atenea.en.hurl
#
# Example without a DNS Server:
#
#     hurl --test \
#       --variable site=olimpo.test \
#       --resolve atenea.olimpo.test:80:192.168.57.11 \
#       test-atenea.en.hurl
#
# Author: Fernando Raya
# Email: fraya@ieszaidinvergeles.org
#

GET http://atenea.{{ site }}/atenea.html
HTTP 200
[Asserts]
body contains "<h1>Atenea site</h1>"

GET http://atenea.{{ site }}
HTTP 403
[Asserts]
body contains "You do not have permission to access atenea.{{ site }}"

GET http://atenea.{{ site }}/index.html
HTTP 404
[Asserts]
body contains "Resource not found on atenea.{{ site }}"

GET http://atenea.{{ site }}/messages/
HTTP 403
[Asserts]
body contains "You do not have permission"
