# Ejercios Jenkins

---

### Ejercicio 1

---

Para el ejercicio 1 subi el código a un repositorio de GitHub propio: [Repositorio con el código.](https://github.com/hugonico7/EjercicioCI-CD)

He ejecutado Jenkins compilando el Dockerfile proporcionado.

1 Para el primer paso he clonado el código.

```Groovy
stage('Checkout') {
      steps {
        chmod +x gradlew
        git 'https://github.com/hugonico7/EjercicioCI-CD.git'
      }
    }
```

2 Para el segundo paso he compilado el código.

```Groovy
stage('Compile') {
      steps {
        chmod +x gradlew
        sh './gradlew compileJava'
      }
    }
```

3 Para el ultimo paso he ejecutado los test

```Groovy
stage('Unit Tests') {
      steps {
        chmod +x gradlew
        sh './gradlew test'
      }
    }
```

### Ejercicio 2

---

Para el ejercicio 2 he añadido las siguientes lineas al Dockerfile anterior.

Instalo Docker para poder ejecutarlo desde Jenkins

```Dockerfile
## Ejercicio 2

#  install docker-cli
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
    https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
    https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

#  install docker-compose
RUN curl --fail -sL https://api.github.com/repos/docker/compose/releases/latest| grep tag_name | cut -d '"' -f  4 | tee /tmp/compose-version \
    && mkdir -p /usr/lib/docker/cli-plugins \
    && curl --fail -sL -o /usr/lib/docker/cli-plugins/docker-compose https://github.com/docker/compose/releases/download/$(cat /tmp/compose-version)/docker-compose-$(uname -s)-$(uname -m) \
    && chmod +x /usr/lib/docker/cli-plugins/docker-compose \
    && ln -s /usr/lib/docker/cli-plugins/docker-compose /usr/bin/docker-compose \
    && rm /tmp/compose-version
```

He instaldo los 2 plugins necesarios para ejecutar Docker. `Docker` y `Docker Pipeline`

Para ejecutar la Pipeline con Docker he usado el agente de Docker con una imagen de Gradle

```Groovy
pipeline {
  agent {
      docker { image 'gradle:6.6.1-jre14-openj9'}
  }
  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/hugonico7/EjercicioCI-CD.git'
      }
    }
    stage('Compile') {
      steps {
        chmod +x gradlew
        sh './gradlew compileJava'
      }
    }
    stage('Unit Tests') {
      steps {
        chmod +x gradlew
        sh './gradlew test'
      }
    }
  }
}
```