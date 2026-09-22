#!/usr/bin/env bash

set -e

readonly MAX_LENGTH=80

starts_with_comment() {
    [[ "$1" =~ ^[[:space:]]*// ]]
}

failed=0

while IFS= read -r -d '' file; do
    line_number=0

    while IFS= read -r line || [[ -n "$line" ]]; do
        ((++line_number))

        if starts_with_comment "$line" && (( ${#line} > MAX_LENGTH )); then
            printf '%s:%d: comment exceeds %d characters\n' \
                "$file" "$line_number" "$MAX_LENGTH"
            failed=1
        fi
    done < "$file"
done < <(
    find . \
        -type d -name target -prune -o \
        -type f -name '*.rs' -print0
)

exit "$failed"
