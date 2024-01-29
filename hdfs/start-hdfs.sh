#!/bin/bash
set -e

check_service_ports() {
    local NODE_LIST_VAR=$1  # 接收环境变量名称作为参数
    local SERVICE_PORT_VAR=$2  # 接收服务端口环境变量名称作为参数
    local SERVICE_NAME=$3  # 接收服务名称作为参数

    # 从环境变量中获取节点列表和服务端口
    IFS=',' read -ra NODE_ARRAY <<< "${NODE_LIST_VAR}"
    SERVICE_PORT=${SERVICE_PORT_VAR}

    # 定义变量来跟踪是否所有节点都成功探测
    all_nodes_successful=false

    # 循环探测直到所有节点都成功为止
    while [ "$all_nodes_successful" = false ]
    do
        all_nodes_successful=true  # 假设所有节点都成功探测
        for node in "${NODE_ARRAY[@]}"
        do
            echo "Checking $node:$SERVICE_PORT for $SERVICE_NAME"
            if nc -zv $node $SERVICE_PORT; then
                echo "$node:$SERVICE_PORT is reachable for $SERVICE_NAME"
            else
                echo "$node:$SERVICE_PORT is not reachable for $SERVICE_NAME"
                all_nodes_successful=false  # 如果有节点探测失败，则将标志设置为false
            fi
        done

        if [ "$all_nodes_successful" = false ]; then
            echo "Not all nodes are reachable for $SERVICE_NAME. Retrying in 10 seconds..."
            sleep 10  # 等待10秒后再次尝试探测
        fi
    done

    echo "All nodes are reachable for $SERVICE_NAME"
}

# Initialize the NameNode if necessary
if [ $HDFS_ROLE = "namenode" ]; then
  NAMENODE_FORMATTED_FLAG_FILE=$HDFS_DATA_PATH/.hdfs-namenode-formatted
  ZKFC_FORMATTED_FLAG_FILE=$HDFS_DATA_PATH/.hdfs-zkfc-formatted
  NAMENODE_ID=${POD_NAME##*-}
  if [ "$NAMENODE_ID" == "0" ]; then
    if [ ! -e "$NAMENODE_FORMATTED_FLAG_FILE" ]; then
      echo "Initializing HDFS NameNode..."
      hdfs namenode -format -nonInteractive
      if [ $? -ne 0 ]; then
        echo "hdfs namenode -format failed"
        exit 1
      fi
      echo "HDFS NameNode Initialized Successfully!"
      touch $NAMENODE_FORMATTED_FLAG_FILE
      if [ $? -ne 0 ]; then
        echo "touch $NAMENODE_FORMATTED_FLAG_FILE failed"
        exit 1
      fi
      echo "Touch $NAMENODE_FORMATTED_FLAG_FILE Successfully!"
    fi
    if [ $HDFS_HA = "true" ]; then
      if [ ! -e "$ZKFC_FORMATTED_FLAG_FILE" ]; then
        check_service_ports $ZK_NODES $ZK_CLIENT_PORT "Zookeeper"
        echo "Initializing HDFS NameNode ZKFC..."
        hdfs zkfc -formatZK -nonInteractive
        if [ $? -ne 0 ]; then
          echo "hdfs zkfc -formatZK failed"
          exit 1
        fi
        echo "HDFS NameNode ZKFC Formatted Successfully!"
        touch $ZKFC_FORMATTED_FLAG_FILE
        if [ $? -ne 0 ]; then
          echo "touch $ZKFC_FORMATTED_FLAG_FILE failed"
          exit 1
        fi
        echo "Touch $ZKFC_FORMATTED_FLAG_FILE Successfully!"
      fi
    fi
  elif [ "$NAMENODE_ID" == "1" ]; then
    if [ ! -e "$NAMENODE_FORMATTED_FLAG_FILE" ]; then
      echo "Initializing HDFS NameNode In Standby Mode..."
      hdfs namenode -bootstrapStandby -nonInteractive
      if [ $? -ne 0 ]; then
        echo "hdfs namenode -bootstrapStandby failed"
        exit 1
      fi
      echo "HDFS NameNode In Standby Mode Initialized Successfully!"
      touch $NAMENODE_FORMATTED_FLAG_FILE
      if [ $? -ne 0 ]; then
        echo "touch $NAMENODE_FORMATTED_FLAG_FILE failed"
        exit 1
      fi
      echo "Touch $NAMENODE_FORMATTED_FLAG_FILE Successfully!"
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
    echo "Start Zookeeper Fail-over Controller Successfully!"
  fi
  check_service_ports $JN_NODES $JN_RPC_PORT "JournalNode"
fi

# Start the HDFS NameNode process
echo "Starting HDFS $HDFS_ROLE..."
exec hdfs $HDFS_ROLE
