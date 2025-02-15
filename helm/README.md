# Test

utilities to test helm and kubectl related commands locally within docker-compose.

    docker-compose up -d

    docker-compose exec helm bash

    helm template /chart -f /example/my-values.yaml > /generated/out.yaml
