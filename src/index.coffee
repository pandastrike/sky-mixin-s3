import MIXIN from "panda-sky-mixin"
import {read} from "fairmont"
import preprocess from "./preprocessor"
import cli from "./cli"

do ->
  schema = await read "./schema.yaml"
  template = await read "./template.yaml"

  S3 = new MIXIN {
    schema
    template
    preprocess
    cli
  }
  S3

export default mixin
