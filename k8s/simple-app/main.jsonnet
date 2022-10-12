local k = import "github.com/jsonnet-libs/k8s-libsonnet/1.25/main.libsonnet";

{
  _config:: error "Must provide deploy config",

  local deploy = k.apps.v1.deployment,
  local service = k.core.v1.service,
  local container = k.core.v1.container,
  local port = k.core.v1.containerPort,

  deployment: deploy.new(
    name="simple-app",
    replicas=3,
    containers=[
      container.new(
        name="simple-app-containers",
        image="juanpablosgu/hello-world-app:latest"
      ) + 

      container.withPorts(
        [
          port.new(8000) 
        ]
      ) +

      container.resources.withLimits(limits=({cpu: 300, memory: 500})) +
      container.resources.withRequests(requests=({cpu: 300, memory: 500}))
    ]
  ),

  service: service.new(
    name="simple-app-service",
    selector={
      "name": "simple-app"
    },
    ports=[{"port": 80, "targetPort": 80}]
  )
}
