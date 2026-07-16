FROM python:3.11-slim


# Set working directory
WORKDIR /app


# Copy dependencies first for Docker cache optimization
COPY requirements.txt .


# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt


# Create non-root user
RUN useradd -m appuser


# Copy application code
COPY app.py .


# Change ownership of application files
RUN chown -R appuser:appuser /app


# Run container as non-root user
USER appuser


# Flask application port
EXPOSE 5000


# Start Flask application
CMD ["python", "app.py"]
