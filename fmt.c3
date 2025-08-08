module tora;

<*
 Formats the main output for the logger.

 @param [&in] lvl: `The log level for the logging output.`
 @param [in] msg: `The input message for logging.`
*>
fn DString? fmt_output(Allocator allocator, LogConfig* config, LogLevel* lvl, String msg, String file, isz line_num) @private
{
    DString output;
    output.init(allocator, 1024);

    output.appendf("%s", get_level_color(lvl));

    if (config.date) {
        fmt_date(output)!;
    }

    fmt_log_lvl(output, lvl)!;

    if (config.path) {
        fmt_path(output, file, line_num)!;
    }

    output.appendf("- ")!;
    output.appendf("%s\n", msg)!;

    output.appendf("%s", COLOR_RESET);
    return output;
}

<*
 Formats the log level.

 @param [&out] output: `The output buffer for writing log level.`
 @param [&in] lvl: `The log level.`
*>
fn void? fmt_log_lvl(DString output, LogLevel* lvl) @private
{
    output.appendf("[%s] ", lvl.name)!;
}

fn void? fmt_date(DString output) @private
{
    output.appendf("[%s %s] ", $$DATE, $$TIME);
}

<*
 Formats the path for the logging output.

 @param [&out] output: `The output buffer for writing log level.`
*>
fn void? fmt_path(DString output, String file, isz line_num) @private
{
    output.appendf("[%s:%s] ", file, line_num)!;
}
