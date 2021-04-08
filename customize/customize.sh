#! /usr/bin/env bash
set -e

# working in ${SUPERSET_HOME}/superset/assets
# overide logo, setup, and viz

cp /tmp/customize/MainPreset.js ./src/visualizations/presets/MainPreset.js
cp /tmp/customize/package.json ./package.json
cp /tmp/superset-logo-horiz.png ./images/superset-logo-horiz.png
