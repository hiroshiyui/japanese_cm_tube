.check_env_yt_api:
ifneq ($(shell test -f ./.env_yt_api && echo -n yes), yes)
	$(error "File '.env_yt_api' is not found, please copy it from '.env_yt_api.example' and put a valid API key in it")
endif

run: .check_env_yt_api
	export $$(cat .env_yt_api | xargs) && ruby ./scripts/yt_test.rb

irb: .check_env_yt_api
	export $$(cat .env_yt_api | xargs) && irb
