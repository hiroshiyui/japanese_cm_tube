run:
	export $$(cat .env_yt_api | xargs) && ruby ./scripts/yt_test.rb
