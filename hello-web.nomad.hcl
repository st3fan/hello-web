job "hello-web-job" {
  type = "service"

  group "hello-web" {
    count = 1

    network {
      port "http" {}
    }

    service {
      name = "hello-web-service"
      port = "http"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.hello-web.rule=Host(`hello.services.sateh.com`)",
        "traefik.http.routers.hello-web.tls=true",
        "traefik.http.routers.hello-web.tls.certresolver=myresolver"
      ]

      provider = "consul"

      check {
        type     = "http"
        port     = "http"
        path     = "/health"
        interval = "5s"
        timeout  = "2s"
      }
    }

    task "hello-web-task" {
      driver = "docker"

      env {
        MESSAGE = "Hello, Go!"
        PORT = "${NOMAD_PORT_http}"
      }

      config {
        image = "ghcr.io/st3fan/hello-web:v0.0.3"
        ports = ["http"]
      }

      resources {
        cpu = 10
        memory = 64
      }
    }
  }
}

