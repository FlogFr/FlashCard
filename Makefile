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
build-elm:
	elm-make --output build/elm.js Words/App.elm
	sed -i 's#http://127.1:8080#https://api.izidict.com#g' build/elm.js
	cp index.html build/
	cp sitemap.xml build/
	cp robots.txt build/

.PHONY: serve
serve:
	stack exec backend-exe

.PHONY: live
live:
	elm-live --output=elm.js Words/App.elm --pushstate --open --debug

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
