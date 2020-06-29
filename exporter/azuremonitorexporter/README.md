# Azure Monitor Exporter

This exporter sends trace data to [Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/).

## Configuration

The following settings are required:

- `instrumentation_key` (no default): Application Insights instrumentation key, which can be found in the Application Insights resource in the Azure Portal.

The following settings can be optionally configured:

- `endpoint` (default = "https://dc.services.visualstudio.com/v2/track"): The endpoint URL where data will be submitted.
- `maxbatchsize` (default = 1024): The maximum number of telemetry items that can be submitted in each request. If this many items are buffered, the buffer will be flushed before `maxbatchinterval` expires.
- `maxbatchinterval` (default = 10s): The maximum time to wait before sending a batch of telemetry.

Example:

```yaml
exporters:
  azuremonitor:
    instrumentation_key: b1cd0778-85fc-4677-a3fa-79d3c23e0efd
    maxbatchsize: 100
    maxbatchinterval: 10s
```

## Attribute mapping

This exporter maps OpenTelemetry trace data to [Application Insights data model](https://docs.microsoft.com/en-us/azure/azure-monitor/app/data-model-dependency-telemetry) using the following schema.

The OpenTelemetry SpanKind determines the Application Insights telemetry data.

| OpenTelemetry SpanKind | Application Insights telemetry type |
| ---------------------- | ----------------------------------- |
| `CLIENT`, `INTERNAL`   | Dependency                          |
| `SERVER`               | Request                             |

Some attributes are mapped to specific telemetry properties depending on the component.

| Application Insights property | Component | OpenTelemetry attribute                                                                                | Default    |
| ----------------------------- | --------- | ------------------------------------------------------------------------------------------------------ | ---------- |
| Request.Name                  | http      | `http.method`, `http.target` and `http.url`                                                            | span name  |
| Request.Url                   | http      | `http.scheme`, `http.host`, `http.target`, `http.server_name`, `host.name`, `host.port` and `http.url` |            |
| Request.Source                | http      | `http.client_ip`                                                                                       |            |
| Request.ResponseCode          | http      | `http.status_code`                                                                                     | `"0"`      |
| Request.Success               | http      | `http.status_code`                                                                                     | `true`     |
| Request.Name                  | grpc      |                                                                                                        | span name  |
| Request.ResponseCode          | grpc      | `status_code`                                                                                          | `"0"`      |
| Request.Success               | grpc      | `status_code`                                                                                          | `true`     |
| Dependency.Name               |           |                                                                                                        | span name  |
| Dependency.Type               |           |                                                                                                        | `"InProc"` |
| Dependency.Success            |           |                                                                                                        | `true`     |
| Dependency.ResultCode         |           |                                                                                                        | `"0"`      |
| Dependency.Name               | db        |                                                                                                        | span name  |
| Dependency.Data               | db        | `db.statement`                                                                                         |            |
| Dependency.Type               | db        | `db.type`                                                                                              |            |
| Dependency.Target             | db        | `peer.address`                                                                                         |            |
| Dependency.ResultCode         | db        |                                                                                                        | `"0"`      |
| Dependency.Success            | db        |                                                                                                        | `true`     |
| Dependency.Name               | http      | `http.method`, `http.target` and `http.url`                                                            | span name  |
| Dependency.Data               | http      | `http.scheme`, `http.host`, `peer.hostname`, `peer.ip`, `peer.port`, `http.target` and `http.url`      |            |
| Dependency.Type               | http      |                                                                                                        | `"Http"`   |
| Dependency.Target             | http      | `http.host`, `peer.hostname`, `peer.ip`, `peer.port` and `http.url`                                    |            |
| Dependency.ResultCode         | http      | `http.status_code`                                                                                     | `"200"`    |
| Dependency.Success            | http      | `http.status_code`                                                                                     | `true`     |
| Dependency.Name               | grpc      |                                                                                                        | span name  |
| Dependency.Data               | grpc      | `peer.service`                                                                                         |            |
| Dependency.Type               | grpc      |                                                                                                        | `"Grpc"`   |
| Dependency.Target             | grpc      | `peer.hostname` and `peer.port`                                                                        |            |
| Dependency.ResultCode         | grpc      | `status_code`                                                                                          | `"0"`      |
| Dependency.Success            | grpc      | `status_code`                                                                                          | `true`     |

The exact mapping can be found [here](traceexporter.go).

All other attributes are directly mapped to custom properties if they are booleans or strings and mapped to custom measurements if they are ints or doubles.

