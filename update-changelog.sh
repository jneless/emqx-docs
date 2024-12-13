#!/usr/bin/env bash

set -euo pipefail

DEV_CHANGES_DIR=$1
EMQX_VERSION=$2

[ -z "${DEBUG:-}" ] || set -x

process_changes() {
    edition=$1
    if ! grep -q "$EMQX_VERSION" en_US/changes/changes-$edition-v5.md; then
        gsed -i "3i # $EMQX_VERSION\n" en_US/changes/changes-$edition-v5.md
        gsed -i "5i ## Enhancements\n" en_US/changes/changes-$edition-v5.md
        gsed -i "7i ## Bug Fixes\n" en_US/changes/changes-$edition-v5.md
    fi

    enhancements_ln=$(grep -n Enhancements en_US/changes/changes-$edition-v5.md | head -n 1 | cut -d: -f1)
    enhancements_ln=$((enhancements_ln + 1))

    shopt -s nullglob

    for f in $DEV_CHANGES_DIR/$edition/fix-*.md $DEV_CHANGES_DIR/$edition/feat-*.md; do
        pr_num="$(echo "${f}" | gsed -E 's/.*-([0-9]+)\.[a-z]+\.md$/\1/')"
        if ! grep -q $pr_num en_US/changes/changes-$edition-v5.md; then
            {
                echo "- [#${pr_num}](https://github.com/emqx/emqx/pull/${pr_num}) $(head -n 1 "$f")"
                tail -n +2 "$f" | sed '/^$/!s/^/  /'
                echo ""
            } > /tmp/$pr_num.md

            if [[ "$f" =~ ^$DEV_CHANGES_DIR/$edition/feat-.*\.md ]]; then
                gsed -i "${enhancements_ln}r /tmp/$pr_num.md" en_US/changes/changes-$edition-v5.md
            elif [[ "$f" =~ ^$DEV_CHANGES_DIR/$edition/fix-.*\.md ]]; then
                bugfixes_ln=$(grep -n 'Bug Fixes' en_US/changes/changes-$edition-v5.md | head -n 1 | cut -d: -f1)
                bugfixes_ln=$((bugfixes_ln + 1))
                gsed -i "${bugfixes_ln}r /tmp/$pr_num.md" en_US/changes/changes-$edition-v5.md
            fi
        fi
    done
}

process_changes ce
process_changes ee
