
#!/bin/bash

set -e

echo "======================================"
echo " Starting Flask Docker Setup"
echo "======================================"

# Navigate to the project directory
cd ~/labs/devnet-src/sample-app

# Remove old container if it exists
docker rm -f samplerunning 2>/dev/null || true

# Create required directories
mkdir -p tempdir/templates
mkdir -p tempdir/static

# Copy application files
cp sample_app.py tempdir/
cp -r templates/. tempdir/templates/
cp -r static/. tempdir/static/

# Create Dockerfile
cat > tempdir/Dockerfile <<'EOF'
FROM python:3.11-slim

WORKDIR /home/myapp

RUN pip install --no-cache-dir --progress-bar off flask

COPY ./static ./static
COPY ./templates ./templates
COPY sample_app.py .

EXPOSE 8080

CMD ["python3", "sample_app.py"]
EOF

echo "Building Docker image..."

# Build image
cd tempdir
docker build -t sampleapp .

echo "Starting Docker container..."

# Run container
docker run -d \
    --name samplerunning \
    -p 8080:8080 \
    sampleapp

echo "======================================"
echo " Docker setup completed!"
echo "======================================"

# Display container status
docker ps

# Test application
echo "Testing Flask application..."
sleep 3
curl -f http://localhost:8080 || {
    echo "Application may still be starting."
    docker logs samplerunning
}
