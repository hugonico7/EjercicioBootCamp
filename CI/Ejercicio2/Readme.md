# Ejercicios GitLab

---

## Ejercicio 1

---

Para ejecutar GitLab en local he usado el `docker-compose.yaml` de la sesion de GitLab.

He modificado el archivo `/etc/docker/daemon.json` para añadir un registry inseguro a docker

`{"insecure-registries" : ["gitlab.local:5001", "gitlab.local:8888"]}`

Tambien he tenido que modificar el archivo `/etc/hosts` en Linux y añadir una nueva entrada que apunte mi IP a "github.local"
`192.168.1.175 github.local`

He creado la siguiente Pipeline:

```yaml
before_script:
  - apt-get update && apt-get install -y docker.io
  - docker version

stages:
  - build
  - test
  - dockerize
  - deploy

maven_build:
  image: maven:3-eclipse-temurin-8-focal
  stage: build
  script:
    - mvn clean package
  artifacts:
    when: on_success
    paths:
      - "target/*.jar"

maven_test:
  image: maven:3-eclipse-temurin-8-focal
  stage: test
  script:
    - mvn verify
  artifacts:
    when: on_success
    paths:
      - "target/*.jar"

docker_build:
  stage: dockerize
  script:
    - docker build -t spring-app -f src/Dockerfile .

deploy:
  stage: deploy
  script:
    - docker run -d -p 8080:8080 spring-app
```

![GitLab](GitLab.png)

![GitLab](Terminal.png)

## Ejercicio 2

---

He creado el usuario Developer2 para hacer las preubas

Para el rol `Guest`, no puedes hacer commits, no puedes ejecutar manualmente las Pipelines, no puedes hacer push, pero pull si porque el repositorio es publico, no puedes hacer Merge Request, no pudes acceder a la administracion.

Para el rol `Reporter`, no puedes hacer commits, no puedes ejecutar manualmente las Pipelines, pull si, Merge Request si, no pudes acceder a la administracion. 

Para el rol `Developer`, si commits, Pipelines si , pull si, Merge Request si, no pudes acceder a la administracion.

Para el rol `Maintainer`, si commits, Pipelines si , pull si, Merge Request si, si pudes acceder a la administracion.

## Ejercicio 3

---

Con el metodo CI Job Permissions he usado la siguiente Pipeline:

```yaml
stages:
    - cloneProject

cloneProject:
    image:
        name: bitnami/git:latest
    stage: cloneProject
    script:
        - echo $CI_JOB_TOKEN
        - git clone http://gitlab-ci-token:${CI_JOB_TOKEN}@gitlab.local:8888/developer1/springapp.git
```

![GitLab](GitLab-clone.png)


Para el metodo Deploy Keys he usado la siguiente Pipeline:

```yaml
stages:
  - cloneProject

cloneProject:springapp:
  image:
    name: bitnami/git:latest
  stage: cloneProject
  before_script:
    - "command -v ssh-agent >/dev/null || ( apt-get update -y && apt-get install openssh-client -y )"
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - ssh-keyscan gitlab.local >> ~/.ssh/known_hosts
    - chmod 644 ~/.ssh/known_hosts
  script:
    - ssh git@gitlab.local
    - git clone git@gitlab.local:developer1/springapp.git
```

![GitLab](GitLab-Clone-Ssh.png)