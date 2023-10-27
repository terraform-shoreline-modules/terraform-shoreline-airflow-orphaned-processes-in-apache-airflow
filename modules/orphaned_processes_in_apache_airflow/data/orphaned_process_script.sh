

#!/bin/bash



# set the namespace and pod name

NAMESPACE=${NAMESPACE}

POD_NAME=${POD_NAME}



# get the list of running processes in the pod

RUNNING_PROCESSES=$(kubectl exec $POD_NAME -n $NAMESPACE -- ps -ef)



# loop through the processes and identify the orphaned processes

while read -r PROCESS; do

  # get the parent process ID

  PARENT_PID=$(echo $PROCESS | awk '{print $3}')

  # check if the parent process is still running

  if ! kubectl exec $POD_NAME -n $NAMESPACE -- ps -p $PARENT_PID >/dev/null 2>&1; then

    # if the parent process is not running, print the orphaned process

    echo "Orphaned process found: $PROCESS"

  fi

done <<< "$RUNNING_PROCESSES"