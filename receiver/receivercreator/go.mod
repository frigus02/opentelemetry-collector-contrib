module github.com/open-telemetry/opentelemetry-collector-contrib/receiver/receivercreator

go 1.14

require (
	github.com/antonmedv/expr v1.8.9
	github.com/census-instrumentation/opencensus-proto v0.3.0
	github.com/googleapis/gnostic v0.4.1 // indirect
	github.com/open-telemetry/opentelemetry-collector-contrib/extension/observer v0.0.0-00010101000000-000000000000
	github.com/spf13/cast v1.3.1
	github.com/spf13/viper v1.7.1
	github.com/stretchr/testify v1.7.0
	go.opentelemetry.io/collector v0.23.0
	go.uber.org/zap v1.16.0
	sigs.k8s.io/structured-merge-diff/v3 v3.0.0 // indirect
)

replace github.com/open-telemetry/opentelemetry-collector-contrib/internal/common => ../../internal/common

replace github.com/open-telemetry/opentelemetry-collector-contrib/extension/observer => ../../extension/observer

replace github.com/googleapis/gnostic => github.com/googleapis/gnostic v0.3.1
