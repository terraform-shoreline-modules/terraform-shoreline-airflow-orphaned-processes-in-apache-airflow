resource "shoreline_notebook" "orphaned_processes_in_apache_airflow" {
  name       = "orphaned_processes_in_apache_airflow"
  data       = file("${path.module}/data/orphaned_processes_in_apache_airflow.json")
  depends_on = [shoreline_action.invoke_orphaned_process_script,shoreline_action.invoke_kill_orphaned_processes]
}

resource "shoreline_file" "orphaned_process_script" {
  name             = "orphaned_process_script"
  input_file       = "${path.module}/data/orphaned_process_script.sh"
  md5              = filemd5("${path.module}/data/orphaned_process_script.sh")
  description      = "Identify the orphaned processes in Apache Airflow using relevant tools and commands."
  destination_path = "/tmp/orphaned_process_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "kill_orphaned_processes" {
  name             = "kill_orphaned_processes"
  input_file       = "${path.module}/data/kill_orphaned_processes.sh"
  md5              = filemd5("${path.module}/data/kill_orphaned_processes.sh")
  description      = "Kill the identified orphaned processes to prevent resource hogging and potential system crashes."
  destination_path = "/tmp/kill_orphaned_processes.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_orphaned_process_script" {
  name        = "invoke_orphaned_process_script"
  description = "Identify the orphaned processes in Apache Airflow using relevant tools and commands."
  command     = "`chmod +x /tmp/orphaned_process_script.sh && /tmp/orphaned_process_script.sh`"
  params      = ["POD_NAME","NAMESPACE"]
  file_deps   = ["orphaned_process_script"]
  enabled     = true
  depends_on  = [shoreline_file.orphaned_process_script]
}

resource "shoreline_action" "invoke_kill_orphaned_processes" {
  name        = "invoke_kill_orphaned_processes"
  description = "Kill the identified orphaned processes to prevent resource hogging and potential system crashes."
  command     = "`chmod +x /tmp/kill_orphaned_processes.sh && /tmp/kill_orphaned_processes.sh`"
  params      = ["POD_NAME","NAMESPACE","PROCESS_NAME"]
  file_deps   = ["kill_orphaned_processes"]
  enabled     = true
  depends_on  = [shoreline_file.kill_orphaned_processes]
}

