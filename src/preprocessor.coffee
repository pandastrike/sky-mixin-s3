# Panda Sky Mixin: S3
# This mixin allocates the requested S3 buckets into your CloudFormation stack. # Buckets are retained after stack deletion, so here we scan for them in S3 before adding them to a new CFo template.

import Sundog from "sundog"
import {cat, plainText, camelCase, capitalize, empty} from "fairmont"

import warningMsg from "./warning-messages"

process = (config) ->
  {AWS: {S3: {bucketExists}}} = await Sundog config.region

  _exists = (name) ->
    try
      await bucketExists name
    catch e
      warningMsg e
      throw e

  # Start by extracting out the S3 Mixin configuration:
  {env, tags} = config
  c = config.aws.environments[env].mixins.s3
  c.tags = cat (c.tags || []), tags

  {buckets, tags} = c
  out = []
  out.push b for b in buckets when !(await _exists b)
  out

  # Build out a buckets config array for the CloudFormation template, for
  # buckets that don't already exist.
  buckets:
    for bucket in out
      name: bucket
      resourceTitle: capitalize camelCase plainText bucket
      tags: tags

export default process
