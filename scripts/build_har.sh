#!/bin/bash

function init_context() {
    HARMONYOS_PROJECT_DIR=$(dirname $(dirname "$0"))
    HARMONYOS_PROJECT_DIR=$(cd "$HARMONYOS_PROJECT_DIR" && pwd)
    ohpm install --all --registry https://ohpm.openharmony.cn/ohpm/ --strict_ssl true
    hvigorw clean --no-daemon
}

function init_JDK() {
    OLD_JAVA_HOME=$JAVA_HOME
    OLD_PATH=$PATH

    export JAVA_HOME=$JAVA_HOME_17
    export PATH=$JAVA_HOME/bin:$PATH
}

function restore_JDK() {
    export JAVA_HOME=$OLD_JAVA_HOME
    export PATH=$OLD_PATH
    # echo "Restored to original JAVA_HOME: $JAVA_HOME"
}

function build_har() {
    local module="framework"
    hvigorw assembleHar --mode module -p product=default -p module=$module@default -p buildMode=release -p debuggable=false --analyze=normal --parallel --incremental --no-daemon

    local har_file="${module}/build/default/outputs/default/${module}.har"
    if [ ! -f "$har_file" ]; then
        echo "Build failed. File $har_file not found!"
        exit 1
    fi

    local size=$(ls -lh "$har_file" | awk '{print $5}')
    local date=$(ls -lh "$har_file" | awk '{print $6, $7, $8}')
    printf "%-30s %-10s %s\n" "$module.har" "$size" "$date"
    echo "----------------------------------------"
}

main() {
    init_context

    local startTime=$(date '+%s')

    init_JDK
    build_har
    restore_JDK

    local endTime=$(date '+%s')
    local elapsedTime=$(expr $endTime - $startTime)
    printf "\nbuild success in ${elapsedTime}s..."
}

main
