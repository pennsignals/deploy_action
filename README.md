# Levant Deploy

A GitHub Action that finds all nomad jobs and deploys them
## Features

Searches all subdirectories accoring to `config`. All matched files will be rendered and deployed to Nomad.

## Example Usage
```
    - name: deploy
      uses: pennsignals/deploy_actio@v1.0.0
      with:
        version: '0.2.6-rc.1' # required
        config: './deploy_config.yml' # required
        nomad_addr: 'http://10.146.0.5:4646'

```