ARG NODE_VERSION=12
ARG PYTHON_VERSION=3.8

#
# --- Build assets with NodeJS
#

FROM node:${NODE_VERSION} AS build

# Superset version to build
ARG SUPERSET_VERSION=1.0.1
ENV SUPERSET_HOME=/var/lib/superset/

# Download source
WORKDIR ${SUPERSET_HOME}

RUN wget -qO /tmp/superset.tar.gz https://github.com/apache/superset/archive/${SUPERSET_VERSION}.tar.gz
RUN tar xzf /tmp/superset.tar.gz -C ${SUPERSET_HOME} --strip-components=1

# Build assets
WORKDIR ${SUPERSET_HOME}/superset-frontend/

# Add customization
COPY customize /tmp/customize/
RUN /tmp/customize/customize.sh

# Build
RUN npm install
RUN npm run build

#
# --- Overide Assets
#
FROM amancevice/superset:1.0.1
USER root
# remove assets
RUN rm -rf /usr/local/lib/python3.8/site-packages/superset/static/assets/
# copy built
COPY --from=build ${SUPERSET_HOME}/superset/static/assets /usr/local/lib/python${PYTHON_VERSION}/site-packages/superset/static/
USER superset
