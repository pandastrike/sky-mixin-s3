import {resolve} from "path"
import MIXIN from "panda-sky-mixin"
import {read} from "fairmont"
import {yaml} from "panda-serialize"

import getPolicyStatements from "./policy"
import preprocess from "./preprocessor"
import cli from "./cli"

mixin = do ->
  schema = yaml await read resolve __dirname, "..", "files", "schema.yaml"
  schema.definitions = yaml await read resolve __dirname, "..", "files", "definitions.yaml"
  template = await read resolve __dirname, "..", "files", "template.yaml"

  S3 = new MIXIN {
    name: "s3"
    schema
    template
    preprocess
    cli
    getPolicyStatements
  }
  S3

export default mixin
