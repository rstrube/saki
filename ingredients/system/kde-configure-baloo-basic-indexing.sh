#!/bin/bash
#|#./ingredients/system/kde-configure-baloo-basic-indexing.sh #Configure Baloo file indexer to only perform basic indexing (performance improvement)

kwriteconfig5 --file baloofilerc --group General --key "only basic indexing" "true"