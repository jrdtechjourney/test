#!/bin/bash

# Create a clean workspace
mkdir -p /app/test-project/src
cd /app/test-project

# 1. Create the 'source' file that the cloner will hold
echo "This content was passed via a bind mount!" > src/hello.txt

# 2. Create the Dockerfile
cat <<EOF > Dockerfile
# Stage 1: The 'cloner' stage
FROM alpine AS cloner
RUN mkdir /src
COPY src/hello.txt /src/

# Stage 2: The build stage
FROM alpine
# We use the mount here to access /src from the 'cloner' stage
RUN --mount=type=bind,from=cloner,source=/src,target=/build \\
    cat /build/hello.txt > /output.txt

# Verify the content exists in the final image
CMD ["cat", "/output.txt"]
EOF

echo "Setup complete. To test, run:"
echo "export DOCKER_BUILDKIT=1"
echo "docker build -t mount-test ."
echo "docker run --rm mount-test"
