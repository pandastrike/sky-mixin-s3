import getPolicy from "./policy"
import getTemplate from "./template"
import CLI from "./cli"

create = (SDK, global, meta, local) ->
  name = "s3"
  policy = getPolicy local
  vpc = false
  template = await getTemplate SDK, local
  cli = CLI SDK, local

  {name, policy, template, cli}

export default create
