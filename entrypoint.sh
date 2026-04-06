#!/bin/bash
set -e

export OPENCLAW_STATE_DIR="${OPENCLAW_STATE_DIR:-/data/.openclaw}"
export OPENCLAW_WORKSPACE_DIR="${OPENCLAW_WORKSPACE_DIR:-/data/workspace}"
SEED_DIR="/app/workspace-seed"

mkdir -p /data
mkdir -p "$OPENCLAW_STATE_DIR"
mkdir -p "$OPENCLAW_WORKSPACE_DIR"

chown -R openclaw:openclaw /data
chmod 700 /data

if [ ! -d /data/.linuxbrew ]; then
  cp -a /home/linuxbrew/.linuxbrew /data/.linuxbrew
fi

rm -rf /home/linuxbrew/.linuxbrew
ln -sfn /data/.linuxbrew /home/linuxbrew/.linuxbrew

if [ -d "$SEED_DIR" ] && [ -z "$(ls -A "$OPENCLAW_WORKSPACE_DIR" 2>/dev/null || true)" ]; then
  echo "Workspace is empty. Seeding from $SEED_DIR"
  cp -a "$SEED_DIR"/. "$OPENCLAW_WORKSPACE_DIR"/
fi

chown -R openclaw:openclaw "$OPENCLAW_STATE_DIR" "$OPENCLAW_WORKSPACE_DIR"

echo "OPENCLAW_STATE_DIR=$OPENCLAW_STATE_DIR"
echo "OPENCLAW_WORKSPACE_DIR=$OPENCLAW_WORKSPACE_DIR"

exec gosu openclaw node src/server.js