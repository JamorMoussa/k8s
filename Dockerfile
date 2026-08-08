# Use official Python 3.12 slim image
FROM python:3.12-slim

# Copy uv executable from official astral-sh/uv image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set working directory
WORKDIR /app

# Enable bytecode compilation and unbuffered Python output
ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    PYTHONUNBUFFERED=1

# Copy dependency files and install dependencies (cached layer)
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-install-project --no-dev

# Copy application source code
COPY main.py ./
COPY src/ ./src/ 
COPY alembic.ini ./
COPY alembic/ ./alembic/
COPY setup.sh ./setup.sh

# Complete installation of the project
RUN uv sync --frozen --no-dev

# Make setup.sh executable
RUN chmod +x setup.sh
# Run setup.sh to create db directory
RUN bash setup.sh

# Place virtual environment executables on PATH
ENV PATH="/app/.venv/bin:$PATH"

# Expose port 8000 for FastAPI
EXPOSE 8000

# Start Uvicorn server
CMD ["sh", "-c", "alembic upgrade head && exec uvicorn main:app --host 0.0.0.0 --port 8000"]
