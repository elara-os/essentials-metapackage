ARG DEBIAN_DIST=bookworm
FROM debian:${DEBIAN_DIST}

ARG BUILD_VERSION
ARG FULL_VERSION

# Install 'equivs' (which is the main tool needed) and other necessary build utilities.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        equivs \
        ca-certificates \
        xz-utils \
    && rm -rf /var/lib/apt/lists/*

COPY src/elara-essentials /tmp/elara-essentials

RUN VERSION_PART=${FULL_VERSION%%_amd64} && \
    # Update the Version field in the control file
    sed -i "s/^Version:.*/Version: ${BUILD_VERSION}/" /tmp/elara-essentials && \
    # Replace any distribution placeholder
    sed -i "s/DIST_PLACEHOLDER/$DEBIAN_DIST/g" /tmp/elara-essentials || true

RUN equivs-build /tmp/elara-essentials

RUN PACKAGE_NAME=$(grep ^Package: /tmp/elara-essentials | cut -d' ' -f2) && \
    VERSION_PART=${FULL_VERSION%%_amd64} && \
    mv /${PACKAGE_NAME}_${BUILD_VERSION}_amd64.deb /essentials_${FULL_VERSION}.deb
