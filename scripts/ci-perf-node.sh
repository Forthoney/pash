#! /usr/bin/env bash

# Run performance tests

main() {
    set -Eex;

    local pash_d="$(get_pash_dir)";

    cd "$pash_d";

    local initial_revision="$(get_revision HEAD)";
    local latest_main_revision="$(get_revision main)";
    local revision="${1:-$latest_main_revision}";

    local output_dir="${2:-/tmp/results}";
    local output_revision_directory="${output_dir}/$revision";
    echo "Will write to $output_revision_directory";

    # Use subshell for new working directory and
    # visual distinction in `set -e`
    echo "Running performance tests for $revision"

    mkdir -p "$output_revision_directory";
    cp -r "$pash_d/evaluation/results/." "$output_revision_directory/"

    summarize_suite() {
        local heading="$1";
        local summary_name="$2";
        local subdir="$3";
        local tests="$4";
        local width="$5";
        local variant="$6";
        local summary_file="${output_dir}/summary_${summary_name}";
        local heading_arg=$(
            if [ ! -f "$summary_file" ]; then
                printf "$heading, --width $width ($variant)";
            else
                printf ''
            fi
        )

        node "$pash_d/scripts/remote/controller/perf-analysis/report.js" \
             "$revision" \
             "$output_revision_directory/$subdir" \
             "$tests" \
             "$width" \
             "$variant" \
             "$heading_arg" \
             1>> "$summary_file" \
             2>"$summary_file.stderr";
    }

    echo "Summarizing results";
    local eurosys_tests='bigrams,diff,minimal_grep,minimal_sort,set-diff,spell,topn,wf'

    summarize_suite "EuroSys One-liners" \
                    "eurosys_small" \
                    "eurosys_small" \
                    "$eurosys_tests" \
                    "2" \
                    "distr_auto_split";

    # Generate index page so others can review available summaries
    # through web server.
    ls "${output_dir}"/summary_* > "${output_dir}/index";
}

get_pash_dir() {
    local here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";
    git -C "$here" rev-parse --show-toplevel;
}

get_revision() {
    git rev-parse --short "${1:-HEAD}";
}


main "$@"