.PHONY: build
build:
	stack build

.PHONY: generate
generate:
	stack exec generate-elm-api

.PHONY: serve
serve:
	stack exec backend-exe

.PHONY: live
live:
	elm-live --output=elm.js Words/App.elm --pushstate --open --debug
