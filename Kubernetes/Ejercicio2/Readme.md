# Ejercicio 2

---

## Monolito

Crear la imagen:

Para crear la imagen he utilizado el **Dockerfile** proporcionado por el repositorio.

```bash
docker build -t hugonico7/todo-app
```

Luego la he subido a **DockerHub**

```bash
docker push hugonico7/todo-app
```

Crear el **StatefulSet**:

**ConfigMap** con la configuracion inicial de la db:

[cm-db.yaml](cm-db.yaml)

Con un archivo con la config `todos_db.sql`

**StorageClass** para el aprovisionamiento dinamico de los recursos de persistencia:

[storageclass.yaml](storageclass.yaml)

He declarado el `provisioner: k8s.io/minikube-hostpath`, le he dado el nombre de **persistant-db**

**PersistentVolume** que hace referencia al **StorageClass** anterior

[PersistentVolume](PersistentVolume.yaml)

Le he declarado la referencia al **StorageClass** `storageClassName: persistant-db`, le he definido la capacidad
a 1Gi, el **accessModes** en modo **ReadWriteOnce**, junto al **hostPath** `path: /data/db`

**PersistentVolumeClaim** que hace referencia al **StorageClass** anterior

[PersistentVolumeClaim](PersistentVolumeClaim.yaml)

He configurado el **resources** parque haga una **request** de `storage: 250Mi`

**Cluster IP Service** para que sean capaces de llegar al **StatefulSet**

[Cluster IP Service](serviceClusterIp.yaml)

Para el servicio, exponiendo el puerto `5432` que hace **targetPort** al `5432`. Usando el selector de `servicio: service-db`

**StatefulSet** donde se define la db

[StatefulSet](statefullset.yaml)

Primero he definido en las **matchLabels** la label del servicio cluster ip `servicio: service-db`, he declarado las replicas a 1, le defino la **spec** para los volumenes, defino la template con las labels necesarias, configuro la spec para el **ConfigMap**, defino el contenedor y le defino los volumenes, el **ConfigMap** y el volumen persistente

Establecer base de datos:

He hecho un exec a un **Pod** del **StatefulSet** con:

```Docker
kubectl exec [postgres-pod-name] -it bash
```

Luego he copiado todo el valor del fichero de configuracion `todos_db.sql` luego lo he ejecutado `psql -U postgres` y he pegado todo el contenido.

Crear todo-app:

**ConfigMap** para alimentar las variables de entorno del **Deployment** :

[ConfigMap](cm-front.yaml)

Para el **ConfigMap** he declarado las labels necesarias `app: cm-front` y las variables de entorno necesarias. Una de las variables de entorno es `DB_HOST=service-db`, ya que directamente le paso el nombre del servicio.

**Deployment** para todo-app:

[Deployment](deploy.yaml)

Para el deployment declaro las matchLabels necesarias `app: todo-app` y especifico el contenedor con la imagen `hugonico7/todo-app:latest`, el puerto `8080` y le especifico las variables de entorno desde el **ConfigMap**

Crear el Servicio de **LoadBalancer**:

Para el LoadBalancer he creado un archivo **Yaml**

```Yaml
apiVersion: v1
kind: Service
metadata:
  name: todo-app
  labels:
    app: todo-app
spec:
  type: LoadBalancer
  ports:
  - port: 3000
    targetPort: 8080
  selector:
    app: todo-app
```

Para el tipo de servicio he usado **LoadBalancer**, hace **targetPort** al `8080` del Pod. Usando el selector de `app: todo-app`

Para probarlo he usado el comando:

```bash
minikube tunnel
```

He obtenido la ip externa que te devuelve le servicio **LoadBalancer** con:

```bash
kubectl get svc
```

Y lo he probado desde el navegador con:

`http://10.96.184.178:8080`