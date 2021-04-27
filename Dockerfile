ARG NODE_VERSION=12
ARG PYTHON_VERSION=3.8

#
# --- Build assets with NodeJS
#

FROM node:${NODE_VERSION} AS build

# Superset version to build
ARG SUPERSET_VERSION=1.1.0
ENV SUPERSET_HOME=/var/lib/superset/

# Download source
WORKDIR ${SUPERSET_HOME}

RUN wget -qO /tmp/superset.tar.gz https://open-public-sandbox.oss-cn-beijing.aliyuncs.com/superset-1.1.0.tar.gz
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
FROM amancevice/superset:1.1.0
USER root
# remove assets
RUN rm -rf /usr/local/lib/python3.8/site-packages/superset/static/assets/
# copy built
COPY --from=build ${SUPERSET_HOME}/superset/static/assets /usr/local/lib/python3.8/site-packages/superset/static/assets
# overide translation
COPY zh /usr/local/lib/python3.8/site-packages/superset/translations/zh
# overide api
COPY superset/charts/api.py /usr/local/lib/python3.8/site-packages/superset/charts/api.py
COPY superset/views/core.py /usr/local/lib/python3.8/site-packages/superset/views/core.py
USER superset
