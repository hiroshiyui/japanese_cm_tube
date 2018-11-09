.PHONY: help

help:
	@echo "Japanese CM Tube"

.check_env_yt_api:
ifneq ($(shell test -f ./.env_yt_api && echo -n yes), yes)
	$(error "File '.env_yt_api' is not found, please copy it from '.env_yt_api.example' and put a valid API key in it")
endif

require-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

save_japanese_cm_videos: .check_env_yt_api
	export $$(cat .env_yt_api | xargs) && ruby ./scripts/save_japanese_cm_videos.rb

save_this_month_japanese_cm_videos: .check_env_yt_api
	export $$(cat .env_yt_api | xargs) && ruby ./scripts/save_japanese_cm_videos.rb this_month

save_last_month_japanese_cm_videos: .check_env_yt_api
	export $$(cat .env_yt_api | xargs) && ruby ./scripts/save_japanese_cm_videos.rb last_month

save_year_month_japanese_cm_videos: .check_env_yt_api require-YEAR require-MONTH
	export $$(cat .env_yt_api | xargs) && ruby ./scripts/save_japanese_cm_videos.rb $(YEAR)-$(MONTH)

import_csv_to_youtube_playlist: .check_env_yt_api
	export $$(cat .env_yt_api | xargs) && ruby ./scripts/import_csv_to_youtube_playlist.rb

irb: .check_env_yt_api
	export $$(cat .env_yt_api | xargs) && irb
