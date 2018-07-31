POSIXCUBE_BIN ?= ~/Projects/posixcube/posixcube.sh

.PHONY: build
build:
	stack build

.PHONY: build-elm
build-elm:
	elm-make --output build/elm.js Words/App.elm
	cp index.html build/

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

.PHONY: deploy
deploy:
	rsync -v --recursive --links --progress --delete build/ izidict.com:/var/www/izidict.com
	rsync -v --recursive --links --progress --delete build/ izidict.com:/var/www/izidict.com
	${POSIXCUBE_BIN} -u flog -h izidict.com -e ./production.env -c ./cubes/deploy
