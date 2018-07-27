.PHONY: serve
serve:
	stack exec backend-exe

.PHONY: live
live:
	elm-live Words/App.elm --pushstate --open --debug
