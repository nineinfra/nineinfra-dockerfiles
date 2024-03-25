#!/bin/sh

KAFKA_BROKER_ID=${POD_NAME##*-}
if grep -q "advertised.listeners" "$KAFKA_HOME/conf/server.properties"; then
  exec "$KAFKA_HOME/bin/kafka-server-start.sh" "$KAFKA_HOME/conf/server.properties" --override broker.id="${KAFKA_BROKER_ID}"
else
  ADVERTISED_LISTENERS=$(printf "%s://%s:%d,%s://%s:%d" "${INTERNAL_PORT_NAME}" "${POD_IP}" "${INTERNAL_PORT}" "${EXTERNAL_PORT_NAME}" "${POD_IP}" "${EXTERNAL_PORT}")
  LISTENERS=$(printf "%s://%s:%d,%s://%s:%d" "${INTERNAL_PORT_NAME}" "${POD_IP}" "${INTERNAL_PORT}" "${EXTERNAL_PORT_NAME}" "${POD_IP}" "${EXTERNAL_PORT}")
  exec "$KAFKA_HOME/bin/kafka-server-start.sh" "$KAFKA_HOME/conf/server.properties" \
                --override broker.id="${KAFKA_BROKER_ID}"  \
                --override advertised.listeners="${ADVERTISED_LISTENERS}" \
                --override listeners="${LISTENERS}"
fi