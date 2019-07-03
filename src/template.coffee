import {resolve} from "path"
import {toJSON} from "panda-parchment"
import {read as _read} from "panda-quill"
import {yaml} from "panda-serialize"
import PandaTemplate from "panda-template"
import AJV from "ajv"

import preprocess from "./preprocess"

ajv = new AJV()
T = new PandaTemplate()

read = (name) ->
  yaml await _read resolve __dirname, "..", "files", name

getTemplate = (SDK, local) ->
  schema = await read "schema.yaml"
  schema.definitions = await read "definitions.yaml"
  template = await read "template.yaml"

  unless ajv.validate _schema, await preprocess SDK, local
    console.error toJSON ajv.errors, true

  T.render template, local
