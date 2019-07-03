import {resolve} from "path"
import {Command} from "commander"

import COMMANDS from './commands'

CLI = (SDK, config) ->
  (argv) ->
    [name, env] = argv
    program = new Command name

    program
      .command "bucket [subcommand] [name]"
      .option '-a, --all', 'Delete all buckets in your mixin list'
      .allowUnknownOption()
      .action (subcommand, name, options) ->
        bucket = await COMMANDS.bucket SDK, config
        if bucket[subcommand]
          bucket[subcommand] name, options
        else
          console.error "ERROR: unrecognized subcommand of 's3 bucket'"
          program.help()

    program
      .command('*')
      .action  -> program.help()

    # TODO: This should be more detailed, customized for each subcommand, and
    # automatically extended with new commands and flags.  For now, this will
    # need to do.
    program.help = -> console.error COMMANDS.help

    # Begin execution.
    program.parse argv

export default CLI
