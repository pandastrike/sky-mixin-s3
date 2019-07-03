import Sundog from "sundog"
import {plainText, camelCase, capitalize, empty} from "panda-parchment"
import warningMsg from "./warning-messages"

templateCase = (string) -> capitalize camelCase plainText string

preprocess = (SDK, local) ->
  {bucketExists} = (Sundog SDK).AWS.S3()

  {buckets, tags={}} = local

  needed = []
  for b in buckets
    unless await bucketExists b.name
      needed.push b.name

  tags = {Key, Value} for Key, Value of tags

  buckets =
    if empty needed
      []
    else
      for bucket in needed
        name: bucket
        resourceTitle: templateCase bucket
        tags: tags

  {buckets}

export default preprocess
