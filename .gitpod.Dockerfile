FROM gitpod/workspace-full

USER gitpod

# Install necessary system dependencies
RUN sudo apt-get update && sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable /workspace/flutter

# Set Flutter in PATH
ENV PATH="/workspace/flutter/bin:${PATH}"

# Pre-cache Flutter dependencies (optional, but faster builds)
RUN flutter precache
