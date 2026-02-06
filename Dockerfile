FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy all application files
COPY . .

# Create necessary directories
RUN mkdir -p uploads static/charts

# Set environment
ENV FLASK_APP=app.py
ENV FLASK_ENV=production
ENV PORT=8080

# Expose port
EXPOSE 8080

# Run app
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]