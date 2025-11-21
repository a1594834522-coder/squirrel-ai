#!/bin/bash
# Sync rime-ice dictionaries (cn_dicts/en_dicts) and core configs into SharedSupport

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <SharedSupport directory>" >&2
    exit 1
fi

DEST_DIR="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
RIME_ICE_DIR="${REPO_ROOT}/rime-ice"

if [ ! -d "${RIME_ICE_DIR}" ]; then
    echo "rime-ice directory not found at ${RIME_ICE_DIR}" >&2
    exit 1
fi

if [ ! -d "${DEST_DIR}" ]; then
    echo "SharedSupport directory ${DEST_DIR} does not exist" >&2
    exit 1
fi

copy_dict_dir() {
    local dir_name="$1"
    local src="${RIME_ICE_DIR}/${dir_name}"
    local dest="${DEST_DIR}/${dir_name}"

    if [ ! -d "${src}" ]; then
        echo "Missing ${dir_name} in ${RIME_ICE_DIR}" >&2
        exit 1
    fi

    mkdir -p "${dest}"
    rsync -a --delete "${src}/" "${dest}/"
}

copy_dict_dir "cn_dicts"
copy_dict_dir "en_dicts"

# Sync core rime-ice configs so the bundled scheme and shortcuts (Tab、简繁切换等) match upstream
sync_config_file() {
    local name="$1"
    local src="${RIME_ICE_DIR}/${name}"
    local dest="${DEST_DIR}/${name}"

    if [ -f "${src}" ]; then
        cp "${src}" "${dest}"
    else
        echo "Warning: missing rime-ice config ${src}" >&2
    fi
}

sync_config_file "default.yaml"
sync_config_file "squirrel.yaml"
sync_config_file "symbols_v.yaml"
sync_config_file "rime_ice.schema.yaml"
sync_config_file "rime_ice.dict.yaml"

# 复制项目自定义的 default.custom.yaml（启用 AI 拼音方案）
if [ -f "${REPO_ROOT}/data/default.custom.yaml" ]; then
    cp "${REPO_ROOT}/data/default.custom.yaml" "${DEST_DIR}/default.custom.yaml"
fi

# 雾凇自带的九宫格与双拼方案（避免 default.yaml 里列出的 schema 缺失）
for schema in \
  "t9.schema.yaml" \
  "double_pinyin.schema.yaml" \
  "double_pinyin_abc.schema.yaml" \
  "double_pinyin_mspy.schema.yaml" \
  "double_pinyin_sogou.schema.yaml" \
  "double_pinyin_flypy.schema.yaml" \
  "double_pinyin_ziguang.schema.yaml" \
  "double_pinyin_jiajia.schema.yaml"
do
  sync_config_file "${schema}"
done
