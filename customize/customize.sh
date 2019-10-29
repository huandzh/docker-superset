#! /usr/bin/env bash
set -e

# working in ${SUPERSET_HOME}/superset/assets
# overide logo, setup, and viz

cp ./customize/superset-logo@2x.png ./images/superset-logo@2x.png
cp ./customize/setupPluginsExtra.js ./src/setup/setupPluginsExtra.js
cat ./customize/viz_append.py >> ../viz.py
npm install @dmicros/superset-ui-preset-chart-echarts-basic@0.0.3
