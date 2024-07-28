FROM python:3.11-buster as builder
ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

WORKDIR /app

RUN pip install poetry==1.8.3

COPY . /app

RUN poetry install --no-root && rm -rf $POETRY_CACHE_DIR

FROM python:3.11-slim-buster as runtime

RUN apt-get update \
    && apt-get install -y default-mysql-client pkg-config curl

ENV VIRTUAL_ENV=/app/.venv \
    PATH="/app/.venv/bin:$PATH"

COPY --from=builder /app /app

WORKDIR /app
