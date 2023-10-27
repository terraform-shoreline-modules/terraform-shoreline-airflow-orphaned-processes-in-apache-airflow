
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Orphaned Processes in Apache Airflow
---

This incident type refers to the presence of orphaned processes in Apache Airflow. Orphaned processes are those that have been started by a parent process but are not properly terminated when they are no longer needed. These processes can consume system resources and cause performance issues. In the context of Apache Airflow, orphaned processes can affect the scheduling and execution of tasks, leading to failures or delays in completing workflows. The incident requires identifying and removing these orphaned processes to restore normal system operations.

### Parameters
```shell
export POD_NAME="PLACEHOLDER"

export CONTAINER_NAME="PLACEHOLDER"

export NAMESPACE="PLACEHOLDER"

export PROCESS_NAME="PLACEHOLDER"
```

## Debug

### Get the list of processes running in a specific container
```shell
kubectl exec ${POD_NAME} -c ${CONTAINER_NAME} -- ps -ef
```

### Check the CPU and memory usage of a specific pod
```shell
kubectl top pod ${POD_NAME}
```

### Check the CPU and memory usage of all pods in the default namespace
```shell
kubectl top pod --all-namespaces
```
### Identify the orphaned processes in Apache Airflow using relevant tools and commands.
```shell


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




```

## Repair

### Kill the identified orphaned processes to prevent resource hogging and potential system crashes.
```shell


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


```