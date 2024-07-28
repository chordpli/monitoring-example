from fastapi import FastAPI
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import SimpleSpanProcessor, ConsoleSpanExporter

from app.api.test.routers.test import router as test_router

app = FastAPI()

tracer = TracerProvider()
tracer.add_span_processor(
    SimpleSpanProcessor(ConsoleSpanExporter())
)
FastAPIInstrumentor.instrument_app(app, tracer_provider=tracer)


app.include_router(test_router)