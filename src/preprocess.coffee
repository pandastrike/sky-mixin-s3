import Sundog from "sundog"
import {plainText, camelCase, capitalize, isEmpty, merge} from "panda-parchment"

templateCase = (string) -> capitalize camelCase plainText string

preprocess = (SDK, local) ->
  {bucketExists} = (Sundog SDK).AWS.S3()

  {buckets, tags={}} = local

  needed = []
  for bucket in buckets
    unless await bucketExists bucket.name
      needed.push bucket

  buckets =
    for bucket in needed
      name: bucket.name
      resourceTitle: templateCase bucket.name
      tags: ({Key, Value} for Key, Value of merge tags, bucket.tags)

  if isEmpty buckets
    false
  else
    {buckets}

export default preprocess
