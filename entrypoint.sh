#!/bin/bash

DEPLOY=${DEPLOY:-TRUE}

# echo all the variabls
echo "VERSION: $VERSION"
echo "DEPLOY_CONFIG: $DEPLOY_CONFIG"
echo "NOMAD_ADDR: $NOMAD_ADDR"
echo "DEPLOY: $DEPLOY"

# render
for dir in */ ; do
    if [ -d "${dir}nomad" ]; then

    echo "Deploying jobs from: ${dir}nomad."
    for file in ${dir}nomad/*; do
        matched=$([[ $file =~ ^.*.nomad.hcl$ ]] && echo "true" || echo "false")

        # only deploy *.nomad.hcl (jobs)
        if [ $matched = "true" ]; then
        echo "levant render -var TAG=${VERSION} -var DEPLOY=staging -var-file=${DEPLOY_CONFIG} -out=nomad/$(basename $file) ${file}"
        levant render -var TAG=${VERSION} -var DEPLOY=staging -var-file=${DEPLOY_CONFIG} -out=nomad/$(basename $file) ${file}
        fi

    done
    fi
done

# deploy
if [ $DEPLOY = "TRUE" ]; then
    for dir in */ ; do
        if [ -d "${dir}nomad" ]; then

        echo "Deploying jobs from: ${dir}nomad."
        for file in ${dir}nomad/*; do
            matched=$([[ $file =~ ^.*.nomad.hcl$ ]] && echo "true" || echo "false")

            # only deploy *.nomad.hcl (jobs)
            if [ $matched = "true" ]; then
            echo "levant deploy -var TAG=${VERSION} -ignore-no-changes -var DEPLOY=staging -var-file=${DEPLOY_CONFIG} ${file}"
            levant deploy -var TAG=${VERSION} -ignore-no-changes -var DEPLOY=staging -var-file=${DEPLOY_CONFIG} ${file}
            fi

        done
        fi
    done
fi