#!/bin/bash

export MAVEN_OPTS="-Dmaven.build.cache.enabled=true"
time ./mvnw -pl quarkus/deployment,quarkus/dist -am -DskipTests install
cp ./quarkus/dist/target/keycloak-999.0.0-SNAPSHOT.tar.gz ./quarkus/container/
cd ./quarkus/container/
docker build --build-arg KEYCLOAK_DIST=keycloak-999.0.0-SNAPSHOT.tar.gz -t phk-keycloak .
cd ../../
docker run --name keycloak_nightly -p 127.0.0.1:8090:8080 -e KC_BOOTSTRAP_ADMIN_USERNAME=admin -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin  phk-keycloak start-dev
docker rm keycloak_nightly

