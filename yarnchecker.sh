#!/bin/bash
# check if yarn is installed in ruby builders

july15th=$(date --date 2022-07-15 +%s%3N)

curl --silent "https://us.gcr.io/v2/gae-runtimes/buildpacks/tags/list" | jq -r '.child[] | select(. | startswith("ruby"))' | while read -r runtime; do
	image_name="us.gcr.io/gae-runtimes/buildpacks/$runtime/builder"
	curl --silent "https://us.gcr.io/v2/gae-runtimes/buildpacks/$runtime/builder/tags/list" | jq ".manifest[] | select((.timeUploadedMs | tonumber) > $july15th) | .tag[]" | jq -s "sort_by(.)" | jq -r ".[]" | while read -r tag; do
		echo "$image_name:$tag"
		docker run --rm "$image_name:$tag" yarn --version
	done
done
