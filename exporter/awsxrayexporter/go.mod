module github.com/open-telemetry/opentelemetry-collector-contrib/exporter/awsxrayexporter

go 1.14

replace github.com/open-telemetry/opentelemetry-collector-contrib/internal/common/awsxray => ../../internal/common/awsxray

require (
	github.com/aws/aws-sdk-go v1.35.5
	github.com/open-telemetry/opentelemetry-collector-contrib/internal/common/awsxray v0.0.0-00010101000000-000000000000
	github.com/open-telemetry/opentelemetry-proto v0.4.0
	github.com/stretchr/testify v1.6.1
	go.opentelemetry.io/collector v0.17.0
	go.uber.org/zap v1.16.0
	golang.org/x/net v0.0.0-20201021035429-f5854403a974
	google.golang.org/grpc/examples v0.0.0-20200728194956-1c32b02682df // indirect
)
