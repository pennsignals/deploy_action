#!/bin/bash

INPUT_DEPLOY=${INPUT_DEPLOY:-TRUE}

# echo all the variabls
echo "INPUT_ADDR: $INPUT_VERSION"
echo "INPUT_CONFIG: $INPUT_CONFIG"
echo "INPUT_NOMAD_ADDR: $INPUT_NOMAD_ADDR"
echo "INPUT_DEPLOY: $INPUT_DEPLOY"

# export NOMAD_ADDR for deployment
export "NOMAD_ADDR=$INPUT_NOMAD_ADDR"

# render
for dir in */ ; do
    if [ -d "${dir}nomad" ]; then

    echo "Deploying jobs from: ${dir}nomad."
    for file in ${dir}nomad/*; do
        matched=$([[ $file =~ ^.*.nomad.hcl$ ]] && echo "true" || echo "false")

        # only deploy *.nomad.hcl (jobs)
        if [ $matched = "true" ]; then
        echo "levant render -var TAG=${INPUT_VERSION} -var DEPLOY=staging -var-file=${INPUT_CONFIG} -out=nomad/$(basename $file) ${file}"
        levant render -var TAG=${INPUT_VERSION} -var DEPLOY=staging -var-file=${INPUT_CONFIG} -out=nomad/$(basename $file) ${file}
        fi

    done
    fi
done

# deploy
if [ $INPUT_DEPLOY = "TRUE" ]; then
    for dir in */ ; do
        if [ -d "${dir}nomad" ]; then

        echo "Deploying jobs from: ${dir}nomad."
        for file in ${dir}nomad/*; do
            matched=$([[ $file =~ ^.*.nomad.hcl$ ]] && echo "true" || echo "false")

            # only deploy *.nomad.hcl (jobs)
            if [ $matched = "true" ]; then
            echo "levant deploy -var TAG=${INPUT_VERSION} -ignore-no-changes -var DEPLOY=staging -var-file=${INPUT_CONFIG} ${file}"
            levant deploy -var TAG=${INPUT_VERSION} -ignore-no-changes -var DEPLOY=staging -var-file=${INPUT_CONFIG} ${file}
            fi

        done
        fi
    done
fi