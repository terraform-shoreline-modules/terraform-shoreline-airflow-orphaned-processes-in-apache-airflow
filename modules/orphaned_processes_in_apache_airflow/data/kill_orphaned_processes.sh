

#!/bin/bash



# Set the namespace and pod name where the orphaned processes are running

NAMESPACE=${NAMESPACE}

POD_NAME=${POD_NAME}



# Get the process IDs of the orphaned processes in the pod

ORPHANED_PIDS=$(kubectl exec -n $NAMESPACE $POD_NAME -- ps -ef | grep ${PROCESS_NAME} | grep -v grep | awk '{print $2}')



# Kill the orphaned processes

if [ ! -z "$ORPHANED_PIDS" ]; then

  kubectl exec -n $NAMESPACE $POD_NAME -- kill -9 $ORPHANED_PIDS

  echo "Orphaned processes have been killed."

else

  echo "No orphaned processes found."

fi