#!/bin/sh

if [ -z "$HIVE_HOME" ]; then
  HIVE_HOME="/opt/hive"
fi

# DB_TYPE values should in <derby|mysql|postgres>
if [ -z "$DB_TYPE" ]; then
  DB_TYPE="mysql"
fi

${HIVE_HOME}/bin/schematool -dbType ${DB_TYPE} -validate
if [ "$?" -eq "0" ]
then
  echo "Validation Success"
else
  echo "Failed Validation "
  ${HIVE_HOME}/bin/schematool -dbType ${DB_TYPE}  -initSchema
  echo "Init Completed "
fi

echo "Starting Hive metastore "
${HIVE_HOME}/bin/hive --service metastore
