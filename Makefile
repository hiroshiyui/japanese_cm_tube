.PHONY: help

help:
	@echo "Japanese CM Tube"

.check_env_yt_api:
ifneq ($(shell test -f ./.env_yt_api && echo -n yes), yes)
	$(error "File '.env_yt_api' is not found, please copy it from '.env_yt_api.example' and put a valid API key in it")
endif

save_japanese_cm_videos: .check_env_yt_api
	export $$(cat .env_yt_api | xargs) && ruby ./scripts/save_japanese_cm_videos.rb

save_last_month_japanese_cm_videos: .check_env_yt_api
	export $$(cat .env_yt_api | xargs) && ruby ./scripts/save_japanese_cm_videos.rb last_month

irb: .check_env_yt_api
	export $$(cat .env_yt_api | xargs) && irb
