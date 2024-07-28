.PHONY: lint
lint:
	poetry run ruff check . --fix
	poetry run ruff format .

.PHONY: lint-check
lint-check:
		poetry run ruff check . --output-format=github .


.PHONY: api
api:
	PYTHON_APP=api poetry run uvicorn app.cmd.api:app \
		--host=0.0.0.0 --port=8000 --loop uvloop --http h11 \
		--proxy-headers --reload --reload-dir ./app --log-level debug \
		--no-access-log --no-use-colors --no-server-header --no-date-header \
		--timeout-keep-alive 20 --timeout-graceful-shutdown 20

.PHONY: log
log: api
	export OTEL_PYTHON_LOGGING_AUTO_INSTRUMENTATION_ENABLED=true && \
	export OTEL_PYTHON_DISABLED_INSTRUMENTATIONS=aws-lambda && \
	poetry run opentelemetry-instrument \
		--traces_exporter console \
		--metrics_exporter console \
		--logs_exporter console \
		--service_name dice-server \

.PHONY: create_all_table
create_all_table:
	mysql.server start
	poetry run create_all_table