import Sundog from "sundog"
import {empty} from "fairmont"
import Interview from "panda-interview"

import {emptyQuestion, deleteQuestion, noBuckets, badBucket} from "./msg"

Bucket = (config, mixinConfig) ->
  {AWS: {S3}} = await Sundog config.aws.region
  {bucketExists, bucketTouch, bucketEmpty, bucketDel} = S3

  validateOperation = (name, options, buckets) ->
    noBuckets() if empty buckets
    badBucket() if name && !options.all && name not in buckets

  ask = (question) ->
    {ask: _ask} = new Interview()
    answers = await _ask question
    process.exit() if !answers.confirm

  add = (name, options) ->
    validateOperation name, options, mixinConfig.buckets
    console.error "Adding bucket(s)..."
    names = if options.all then mixinConfig.buckets else [name]
    await bucketTouch n for n in names
    console.error "Done.\n"

  _empty = (names, options) ->
    validateOperation name, options, mixinConfig.buckets
    names = if options.all then mixinConfig.buckets else [name]
    await ask emptyQuestion names
    console.error "Emptying bucket(s)..."
    await bucketEmpty n for n in names
    console.error "\nDone.\n"

  ls = ->
    validateOperation null, null, mixinConfig.buckets
    console.log "Scanning AWS for mixin buckets..."
    {buckets} = mixinConfig
    for b in buckets.sort()
      status = if await bucketExists b then "Ready" else "Not Found"
      console.error "  - #{b} : #{status}"
    console.error "\nDone.\n"

  _delete = (names, options) ->
    validateOperation name, options, mixinConfig.buckets
    names = if options.all then mixinConfig.buckets else [name]
    await ask deleteQuestion names
    console.error "Deleting bucket(s)..."
    for n in names
      await bucketEmpty n
      await bucketDel n
    console.error "\nDone.\n"

  {
    add
    empty: _empty
    ls
    list: ls
    delete: _delete
  }

export default Bucket
