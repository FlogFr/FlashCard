POSIXCUBE_BIN ?= ~/Projects/posixcube/posixcube.sh

.PHONY: ghcid
ghcid:
	# http://www.parsonsmatt.org/2018/05/19/ghcid_for_the_win.html
	ghcid --command "cabal new-repl backend-exe" --test "main"

.PHONY: test
test:
	pg_virtualenv -s $(MAKE) fulltest

.PHONY: fulltest
fulltest:
	./bin/setup_database.sh
	stack test

.PHONY: clean
clean:
	cabal new-clean

.PHONY: deb
deb: build clean
	dpkg-buildpackage -us -uc

.PHONY: build
build: clean
	cabal new-build

.PHONY: serve
serve:
	stack exec backend-exe

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
	scp ../izidict_0.1_all.deb root@izidict.com:~/
	ssh root@izidict.com -- dpkg -i izidict_0.1_amd64.deb </dev/null
	ssh root@izidict.com -- systemctl restart izidict </dev/null
