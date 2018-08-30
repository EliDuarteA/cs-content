########################################################################################################################
#!!
#! @description: Generated flow description.
#!
#! @input hostname: Generated description.
#! @input username: Generated description.
#! @input password: Generated description.
#! @input image: Generated description.
#! @input folder: Generated description.
#!
#! @output output_1: Generated description.
#!
#! @result SUCCESS: Flow completed successfully.
#! @result FAILURE: Failure occurred during execution.
#!!#
########################################################################################################################

namespace: content.io.cloudslang.demo
imports:
  base: io.cloudslang.base
  vm: io.cloudslang.vmware.vcenter.virtual_machines
flow:
  name: deploy_tomcat

  inputs:
    - hostname: "10.0.46.10"
    - username: "capa1\\1033-capa1user"
    - password: "Automation123"
    - image: "Ubuntu"
    - folder: "Students"

  workflow:
    - uuid_generatior:
        do:
          base.utils.uuid_generator: null
        publish:
          - uuid: '${new_uuid}'
        navigate:
          - SUCCESS: trim
    - trim:
        do:
          base.strings.substring:
           - origin_string: '${"ed-"+uuid}'
           - end_index: '11'
        publish:
           - id: '${new_string}'
        navigate:
           - FAILURE: FAILURE
           - SUCCESS: clone_vm
    - clone_vm:
        do:
          vm.clone_virtual_machine:
           - host: '${hostname}'
           - hostname: '10.0.44.8'
           - username: '${username}'
           - password: '${password}'
           - clone_host: '10.0.44.8'
           - clone_data_store: 'datastore2'
           - data_center_name: 'CAPA1 Datacenter'
           - is_template: 'false'
           - virtual_machine_name: '${image}'
           - clone_name: '${id}'
           - folder_name: '${folder}'
        navigate:
           - FAILURE: FAILURE
           - SUCCESS: power_on
    - power_on:
        do:
          vm.power_on_virtual_machine:
           - host: '${hostname}'
           - username: '${username}'
           - password: '${password}'
           - virtual_machine_name: '${id}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: sleep
    - sleep:
        do:
          base.utils.sleep:
           - seconds: '30'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: get_details
    - get_details:
        do:
          vm.get_virtual_machine_details:
           - host: '${hostname}'
           - username: '${username}'
           - password: '${password}'
           - virtual_machine_name: '${id}'
           - hostname: '10.0.44.8'
        publish:
          - details: '${return_result}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: get_ip

    - get_ip:
        do:
          base.json.get_value:
           - json_input: '${details}'
           - json_path: 'ipAddress'
        publish:
          - ip: '${return_result}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: deploy_tomcat

    - deploy_tomcat:
        do:
          base.os.linux.samples.deploy_tomcat_on_ubuntu:
           - host: '${ip}'
           - root_password: 'admin@123'
           - user_password: 'admin@123'
           - java_version: "openjdk-7-jdk"
           - download_url: "http://www-us.apache.org/dist/tomcat/tomcat-8/v8.0.53/bin/apache-tomcat-8.0.53.tar.gz"
           - file_name: "apache-tomcat-8.0.53.tar.gz"
           - source_path: "/opt/apache-tomcat/bin"
           - script_file_name: "startup.sh"
        publish:
          - tomcat_url: '${"http://" + host + ":8080"}'
        navigate:
          - SUCCESS: verify_url
          - INSTALL_JAVA_FAILURE: FAILURE
          - SSH_VERIFY_GROUP_EXIST_FAILURE: FAILURE
          - CHECK_GROUP_FAILURE: FAILURE
          - ADD_GROUP_FAILURE: FAILURE
          - ADD_USER_FAILURE: FAILURE
          - CREATE_DOWNLOADING_FOLDER_FAILURE: FAILURE
          - DOWNLOAD_TOMCAT_APPLICATION_FAILURE: FAILURE
          - UNTAR_TOMCAT_APPLICATION_FAILURE: FAILURE
          - CREATE_SYMLINK_FAILURE: FAILURE
          - INSTALL_TOMCAT_APPLICATION_FAILURE: FAILURE
          - CHANGE_TOMCAT_FOLDER_OWNERSHIP_FAILURE: FAILURE
          - CHANGE_DOWNLOAD_TOMCAT_FOLDER_OWNERSHIP_FAILURE: FAILURE
          - CREATE_INITIALIZATION_FOLDER_FAILURE: FAILURE
          - UPLOAD_INIT_CONFIG_FILE_FAILURE: FAILURE
          - CHANGE_PERMISSIONS_FAILURE: FAILURE
          - START_TOMCAT_APPLICATION_FAILURE: FAILURE

    - verify_url:
        do:
          verify_url:
           - tomcat_url
        publish:
          - status_code
        navigate:
        - SUCCESS: SUCCESS
        - FAILURE: FAILURE

  results:
    - SUCCESS
    - FAILURE