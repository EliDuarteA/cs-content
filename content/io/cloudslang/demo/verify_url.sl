########################################################################################################################
#!!
#! @description: Generated Python operation description.
#!
#! @input tomcat_url: Generated description
#!
#! @output status_code: Generated description
#!
#! @result SUCCESS: Operation completed successfully.
#! @result FAILURE: Failure occurred during execution.
#!!#
########################################################################################################################

namespace: content.io.cloudslang.demo

operation:
  name: verify_url

  inputs:
    - tomcat_url

  python_action:
    script: |
      import requests
      try:
           r = requests.head(tomcat_url)
           status_code = str(r.status_code)
           print("Status code: "+status_code)
      except requests.ConnectionError:
           print("Failed to connect")

  outputs:
    - status_code

  results:
    - SUCCESS: ${status_code == '200'}
    - FAILURE