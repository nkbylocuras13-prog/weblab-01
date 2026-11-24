# ---------- apolo ----------
GET http://apolo.olimpo.test/
HTTP 200
[Asserts]
body contains "Index of"
body contains "apolo.html"

GET http://apolo.olimpo.test/apolo.html
HTTP 200
[Asserts]
body contains "Apolo"

GET http://apolo.olimpo.test/index.html
HTTP 404
[Asserts]
body contains "Resource not found on apolo.olimpo.test"

GET http://apolo.olimpo.test/messages/404.html
HTTP 200
[Asserts]
body contains "Resource not found on apolo.olimpo.test"

# ---------- atenea ----------
GET http://atenea.olimpo.test/atenea.html
HTTP 200

GET http://atenea.olimpo.test/
HTTP 403
[Asserts]
body contains "You do not have permission to access atenea.olimpo.test"

GET http://atenea.olimpo.test/index.html
HTTP 404
[Asserts]
body contains "Resource not found on atenea.olimpo.test"

GET http://atenea.olimpo.test/messages/
HTTP 403
[Asserts]
body contains "You do not have permission to access atenea.olimpo.test"
