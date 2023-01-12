# Ejercicio 1

---

## Monolito en Memoria

Crear la imagen:

Para crear la imagen he utilizado el **Dockerfile** proporcionado por el repositorio.

```bash
docker build -t hugonico7/lc-todo-monolith
```

Me he logueado en **DockerHub**

```bash
docker login
```

Luego la he subido a **DockerHub**

```bash
docker push hugonico7/lc-todo-monolith 
```

Crear el **Deployment**:

Para el Deployment he creado un archivo **Yaml**

```Yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: todo-app
  labels:
    app: todo-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: todo-app
  template:
    metadata:
      labels:
        app: todo-app
    spec:
      containers:
      - name:  todo-app
        image: hugonico7/lc-todo-monolith
        env:
        - name: PORT
          value: "8080"
        - name: NODE_ENV
          value: "production"
        ports:
        - containerPort: 8080
```

Para las **Labels** he usado `app: todo-app` para el servicio de **LoadBalancer**. Para la imagen he usado la que previamente he creado. He alimentado el contenedor con 2 variables de entorno `PORT=8080` para cambiar el puerto de la app y `NODE_ENV=production` para el entorno en qeu se ejecuta el contenedor. Para los **Port** he usado el `8080` el puerto por el que va a escuchar el contenedor.

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

Para el tipo de servicio he usado **LoadBalancer**, exponiendo el puerto `3000` que hace **targetPort** al `8080` del Pod. Usando el selector de `app: todo-app`

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