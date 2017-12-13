# Panda Sky Mixin: S3
# This mixin allocates the requested S3 buckets into your CloudFormation stack. # Buckets are retained after stack deletion, so here we scan for them in S3 before adding them to a new CFo template.

import Sundog from "sundog"
import {cat, isObject, plainText, camelCase, capitalize, empty} from "fairmont"

import warningMsg from "./warning-messages"

process = (_AWS_, config) ->
  {AWS: {S3: {bucketExists}}} = Sundog _AWS_

  _exists = (name) ->
    try
      await bucketExists name
    catch e
      warningMsg e
      throw e

  # Start by extracting out the S3 Mixin configuration:
  {env, tags=[]} = config
  c = config.aws.environments[env].mixins.s3
  c = if isObject c then c else {}
  c.tags = cat (c.tags || []), tags

  {buckets=[], tags} = c
  needed = []
  needed.push b for b in buckets when !(await _exists b)

  # Build out a buckets config array for the CloudFormation template, for
  # buckets that don't already exist.
  buckets =
    if empty needed
      []
    else
      for bucket in needed
        name: bucket
        resourceTitle: capitalize camelCase plainText bucket
        tags: tags

  {buckets}


export default process
