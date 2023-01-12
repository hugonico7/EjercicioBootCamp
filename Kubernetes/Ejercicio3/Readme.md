Crear las imagenes:

Para crear la imagenes he utilizado el **Dockerfile** proporcionado por el repositorio.

```bash
docker build -t hugonico7/todo-api:latest
```

y

```bash
docker build -t hugonico7/todo-front:latest
```

Luego la he subido a **DockerHub**

```bash
docker push hugonico7/todo-api:latest 
```

y

```bash
docker push hugonico7/todo-front:latest
```

**Services**:

[ClusterIp Api](serviceCI-todo-api.yaml)

Creo el servicio cluster ip con el selector app: todo-api, con el port 8090 y el targetport 8090

[ClusterIp Front](serviceCI-todo-front.yaml)

Creo el servicio cluster ip con el selector app: todo-front, con el port 8080 y el targetport 80

**ConfigsMaps**:

[ConfigMap Api](cm-api.yaml)

Especifico el puerto y el entorno

[ConfigMap Front](cm-front.yaml)

Especifico la direccion de la api, en este caso al servicio que esta apuntando.

**Deployments**

[Deployment Todo-Api](deploy-todo-api.yaml)

Defino un deployment para la api en la que uso la imagen hugonico7/todo-api:latest, expongo el puerto 3000 y se alimenta de un configmap cm-todo-api

[Deployment Todo-Front](deploy-todo-front.yaml)

Defino un deployment para el front en la que uso la imagen hugonico7/todo-front:latest, expongo el puerto 80 y se alimenta de un configmap cm-todo-front

**Ingress**

[Ingress](ingress.yaml)

En el servicio Ingress defino el host a utilizar, los diferentes path, al servicio y el puerto al que pertenecen.

**Probar**

Para probar el modo Ingress, primero tienes que averiguar la ip externa que te da el cluster de minikube con:

`minikube ip`

Una vez sabiendo la ip del cluster, en mi caso he modificado el archivo /etc/hosts y apuntar el host a la ip del cluster

`192.168.49.2    testhugo.xyz`

Y lo he probado desde el navegador con:

`http://testhugo.xyz:8080/`

y

`http://testhugo.xyz:8090/api/`