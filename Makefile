.PHONY: serve
serve:
	stack exec backend-exe

.PHONY: live
live:
	elm-live --output=elm.js Words/App.elm --pushstate --open --debug
