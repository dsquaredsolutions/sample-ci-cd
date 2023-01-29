# sample-ci-cd

## About

## Deploy to AWS

### dev

For the dev environment we will run

```bash
TF_VAR_private_key="$(cat priv.key)" make deploy_dev
```

Our CI/CD tool will also pass in the sensitive private key through an ENV variable.

## Destroy Infrastructure

## CI/CD workflows

## Diagram