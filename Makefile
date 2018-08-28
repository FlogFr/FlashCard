POSIXCUBE_BIN ?= ~/Projects/posixcube/posixcube.sh

.PHONY: ghci
ghci:
	# ghci accepts --test / --bench and --flag parameters
	stack ghci app/main.hs

.PHONY: test
test:
	pg_virtualenv -s $(MAKE) fulltest

.PHONY: fulltest
fulltest:
	./bin/setup_database.sh
	stack test

.PHONY: clean
clean:
	stack clean

.PHONY: deb
deb: clean build-elm
	dpkg-buildpackage -us -uc

.PHONY: build
build:
	stack build

.PHONY: build-elm
build-elm: elm
	uglifyjs www/elm.js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=www/elm.min.js
	sed -i 's#http://127.1:8080#https://api.izidict.com#g' build/elm.js
	cp www/elm.min.js build/elm.js
	cp www/index.html build/
	cp www/sitemap.xml build/
	cp www/robots.txt build/

.PHONY: serve
serve:
	stack exec backend-exe

.PHONY: elm
elm:
	elm make Words/App.elm --output www/elm.app.js

.PHONY: live
live: elm
	http-server -p 8000 www

.PHONY: generate
generate:
	stack exec generate-elm-api

.PHONY: deploybaseconfiguration
deploybaseconfiguration:
	${POSIXCUBE_BIN} -u root -h izidict.com -c ./cubes/base_configuration

.PHONY: deploydehydrated
deploydehydrated:
	${POSIXCUBE_BIN} -u root -h izidict.com -e ./production.env -c ./cubes/dehydrated

.PHONY: deployprimarydb
deployprimarydb:
	${POSIXCUBE_BIN} -u flog -h izidict.com -c ./cubes/postgresql

.PHONY: deploynginx
deploynginx:
	${POSIXCUBE_BIN} -u flog -h izidict.com -e ./production.env -c ./cubes/nginx

BACKEND_BIN=$(stack exec -- which backend-exe)

.PHONY: deploy
deploy:
	${POSIXCUBE_BIN} -u flog -h izidict.com -e ./production.env -c ./cubes/deploy
	scp ../izidict_0.1_amd64.deb root@izidict.com:~/
	ssh root@izidict.com -- dpkg -i izidict_0.1_amd64.deb </dev/null
	ssh root@izidict.com -- systemctl restart izidict </dev/null
