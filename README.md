# Varnish topvar test

Trivial setup for testing topvar from [varnish-objvar](https://code.uplex.de/uplex-varnish/varnish-objvar) plugin from
UPLEX. Runs nginx in a docker container with some sample HTML files with ESI, and Varnish in a separate container.

Run nginx using command 
```
docker run --rm --name varnishtest-nginx -v `pwd`/nginx:/usr/share/nginx/html:ro nginx
```

Run varnish using command
```
docker run --rm --name varnish -p 80:80 -v `pwd`/default.vcl:/etc/varnish/default.vcl:ro --tmpfs /var/lib/varnish:exec --add-host nginx:`docker exec varnishtest-nginx hostname -I` `docker build -q .` varnishd -f /etc/varnish/default.vcl -F
```
This builds Varnish from the local Dockerfile, mounts (and uses) default.vcl and adds nginx-container IP to /etc/hosts.

When both containers are running you should be able to load the test page on http://localhost. This includes a couple of divs included
using ESI, and a log built using topvar. This _should_ include a request counter of 6 (working), and a list of ESI-levels encountered,
currently not working. The counter is topvar.int() and the log is topvar.string().