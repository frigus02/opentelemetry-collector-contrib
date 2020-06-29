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

| Application Insights property | OpenTelemetry attribute                                                                                                           | Default                          |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| Request.Name                  | `http.method`, `http.target` and `http.url`                                                                                       | span name                        |
| Request.Url                   | `http.scheme`, `http.host`, `http.target`, `http.server_name`, `host.name`, `host.port` and `http.url`                            |                                  |
| Request.Source                | `http.client_ip`                                                                                                                  |                                  |
| Request.ResponseCode          | `http.status_code` and `status_code`                                                                                              | `"0"`                            |
| Request.Success               | `http.status_code` and `status_code`                                                                                              | `true`                           |
| Dependency.Name               | `http.method`, `http.target` and `http.url`                                                                                       | span name                        |
| Dependency.Data               | `http.scheme`, `http.host`, `peer.hostname`, `peer.ip`, `peer.port`, `http.target`, `http.url`, `db.statement` and `peer.service` |                                  |
| Dependency.Type               | `db.type`                                                                                                                         | `"Http"`, `"Grpc"` or `"InProc"` |
| Dependency.Target             | `http.host`, `peer.hostname`, `peer.ip`, `peer.port`, `http.url` and `peer.address`                                               |                                  |
| Dependency.ResultCode         | `http.status_code` and `status_code`                                                                                              | `"200"`                          |
| Dependency.Success            | `http.status_code` and `status_code`                                                                                              | `true`                           |

The exact mapping can be found [here](traceexporter.go).

All other attributes are directly mapped to custom properties if they are booleans or strings and mapped to custom measurements if they are ints or doubles.

