import {collect, project} from "panda-river"

Policy = (config) ->
  # Grant total access to the buckets listed in this mixin.

  names = collect project "name", config.buckets
  resources = []
  for n in names
    resources.push "arn:aws:s3:::#{n}"
    resources.push "arn:aws:s3:::#{n}/*"

  [
    Effect: "Allow"
    Action: [ "s3:*" ]
    Resource: resources
  ]

export default Policy
