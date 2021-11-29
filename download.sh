#!/bin/bash

URL_META=https://tcgbusfs.blob.core.windows.net/blobtcmsv/TCMSV_alldesc.json
URL_INFO=https://tcgbusfs.blob.core.windows.net/blobtcmsv/TCMSV_allavailable.json
TZ="Asia/Taipei"

cd "$(dirname "$0")"

if [[ $1 == "meta" ]]; then
    META_PAYLOAD=$(curl -sS $URL_META)
    META_TIME=$(echo -nE "$META_PAYLOAD" | jq -r .data.UPDATETIME)
    META_TIME=$(date --date="$META_TIME" --iso-8601=seconds)
    META_MD5=$(echo -nE "$META_PAYLOAD" | md5sum | awk '{print $1}')

    echo -nE "$META_PAYLOAD" | gzip > "data/${META_TIME}_meta_${META_MD5}.gz"
elif [[ $1 == "info" ]]; then
    INFO_PAYLOAD=$(curl -sS $URL_INFO)
    INFO_TIME=$(echo -nE "$INFO_PAYLOAD" | jq -r .data.UPDATETIME)
    INFO_TIME=$(date --date="$INFO_TIME" --iso-8601=seconds)
    INFO_MD5=$(echo -nE "$INFO_PAYLOAD" | md5sum | awk '{print $1}')

    echo -nE "$INFO_PAYLOAD" | gzip > "data/${INFO_TIME}_info_${INFO_MD5}.gz"
fi
