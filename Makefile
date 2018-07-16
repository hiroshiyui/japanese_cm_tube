run:
ifeq ($(shell test -f ./.env_yt_api && echo -n yes), yes)
	export $$(cat .env_yt_api | xargs) && ruby ./scripts/yt_test.rb
else
	$(error "File '.env_yt_api' is not found, please copy it from '.env_yt_api.example' and put a valid API key in it")
endif
