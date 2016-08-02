#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################

namespace: io.cloudslang.cloud.amazon_aws.images

imports:
  images: io.cloudslang.cloud.amazon_aws.images
  lists: io.cloudslang.base.lists

flow:
  name: test_add_launch_permissions_to_image_in_region

  inputs:
    - provider: 'amazon'
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        default: ''
        required: false
    - credential:
        default: ''
        required: false
    - proxy_host:
        default: ''
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - debug_mode:
        default: 'false'
        required: false
    - region:
        default: 'us-east-1'
        required: false
    - image_id
    - user_ids_string:
        default: ''
        required: false
    - user_groups_string:
        default: ''
        required: false

  workflow:
    - add_permissions_to_image:
        do:
          images.add_launch_permissions_to_image_in_region:
            - provider
            - endpoint
            - identity
            - credential
            - proxy_host
            - proxy_port
            - debug_mode
            - region
            - image_id
            - user_ids_string
            - user_groups_string
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_results
          - FAILURE: ADD_LAUNCH_PERMISSIONS_TO_IMAGE_FAILURE

    - check_results:
        do:
          lists.compare_lists:
            - list_1: ${[str(return_result), int(return_code), str(exception)]}
            - list_2: ['Launch permissions were successfully added.', 0, '']
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULTS_FAILURE

  results:
    - SUCCESS
    - ADD_LAUNCH_PERMISSIONS_TO_IMAGE_FAILURE
    - CHECK_RESULTS_FAILURE
