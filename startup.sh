#!/bin/bash

expect="\"ismaster\" : true"

check_mongo() {
  echo "rs.isMaster()" > ismaster
  actual=`mongo --host ${MONGO} < ismaster`
  rm -f ismaster
}

next() {
  echo "waiting for mongod node to assume primary status..."
  sleep 2
  check_mongo
}

finish() {
  echo "connected to primary"
  echo "start running mongo-connector"
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
  --continue-on-error
  --oplog-ts=/data/oplog.ts \
  --main ${mongo}:27017 \
  --target-url ${elasticsearch}:9200 \
  --doc-manager elastic_doc_manager \
  --admin-username ${MONGO_USERNAME} \
  --password ${MONGO_PASSWORD} \

