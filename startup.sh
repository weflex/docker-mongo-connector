#!/bin/bash

expect="\"ismaster\" : true"

check_mongo() {
  echo "rs.isMaster()" > ismaster
  actual=`mongo --host ${MONGO} < ismaster`
  rm -f ismaster
}

log() {
  echo " \033[36m$1\033[0m : \033[90m$2\033[0m"
}

next() {
  log "warn" "waiting for mongod node to assume primary status..."
  sleep 2
  check_mongo
}

finish() {
  log "info" "connected to primary"
  log "info" "start running mongo-connector"
}

while true
do
  check_mongo
  if [ "${actual/$expect}" = "$actual" ] ; then
    next
  else
    finish
    break
  fi
done

sleep 1

mongo="${MONGO:-mongo}"
elasticsearch="${ELASTICSEARCH:-elasticsearch}"

mongo-connector --auto-commit-interval=0 \
  --oplog-ts=./oplog.ts \
  --main ${mongo}:27017 \
  --target-url ${elasticsearch}:9200 \
  --doc-manager elastic_doc_manager \
  --admin-username ${MONGO_USERNAME} \
  --password ${MONGO_PASSWORD} \

