#!/bin/bash
set -e

# Initialize the NameNode if necessary
if [ $HDFS_ROLE = "namenode" ]; then
  NAMENODE_FORMATTED_FLAG_FILE=$HDFS_DATA_PATH/.hdfs-namenode-formatted
  ZKFC_FORMATTED_FLAG_FILE=$HDFS_DATA_PATH/.hdfs-zkfc-formatted
  NAMENODE_ID=${POD_NAME##*-}
  if [ "$NAMENODE_ID" == "0" ]; then
    if [ ! -d "$NAMENODE_FORMATTED_FLAG_FILE" ]; then
      echo "Initializing HDFS NameNode..."
      hdfs namenode -format -nonInteractive
      if [ $? -ne 0 ]; then
        echo "hdfs namenode -format failed"
        exit 1
      fi
      touch $NAMENODE_FORMATTED_FLAG_FILE
    fi
    if [ $HDFS_HA = "true" ]; then
      if [ ! -d "$ZKFC_FORMATTED_FLAG_FILE" ]; then
        echo "Initializing HDFS NameNode..."
        hdfs zkfc -formatZK -nonInteractive
        if [ $? -ne 0 ]; then
          echo "hdfs zkfc -formatZK failed"
          exit 1
        fi
        touch $ZKFC_FORMATTED_FLAG_FILE
      fi
    fi
  elif [ "$NAMENODE_ID" == "1" ]; then
    if [ ! -d "$NAMENODE_FORMATTED_FLAG_FILE" ]; then
      echo "Initializing HDFS NameNode In Standby Mode..."
      hdfs namenode -bootstrapStandby -nonInteractive
      if [ $? -ne 0 ]; then
        echo "hdfs namenode -bootstrapStandby failed"
        exit 1
      fi
      touch $NAMENODE_FORMATTED_FLAG_FILE
    fi
  else
    echo "Unsupported NameNode Index: $NAMENODE_ID"
    exit 1
  fi
  if [ $HDFS_HA = "true" ]; then
    echo "Starting Zookeeper Fail-over Controller..."
    hdfs --daemon start zkfc
    if [ $? -ne 0 ]; then
      echo "hdfs --daemon start zkfc failed"
      exit 1
    fi
  fi
fi

# Start the HDFS NameNode process
echo "Starting HDFS $HDFS_ROLE..."
exec hdfs $HDFS_ROLE
