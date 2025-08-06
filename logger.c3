module tora;

import std::io;
import std::time::datetime;

<*
 Logger is the main struct for logging outputs.
*>
struct Logger
{
    Allocator allocator;
    LogConfig config;
}

<*
 Quick tmem initialization of logger.

 @return  `A Logger with default LogConfig and initialized with tmem`
*>
fn Logger temp()
{
   Logger log;
   log.tinit();

   return log;
}

<*
 Quick tmem initialization of logger with conf.

 @param conf
 @return  `A Logger with a custom LogConfig`
*>
fn Logger temp_with_conf(LogConfig conf)
{
   Logger log;
   log.tinit_with_conf(conf);

   return log;
}

<*
 Init the Logger with an Allocator.

 @require allocator != null
 @param [&inout] allocator
 @return  `A Logger with default config and specific Allocator`
*>
fn Logger* Logger.init(&self, Allocator allocator)
{
    *self = { .allocator = allocator, .config = init_log_conf() };
    return self;
}

<*
 Init the Logger with an Allocator and custom LogConfig.

 @param [&inout] allocator
 @param config
 @return  `A Logger with a custom LogConfig and specific Allocator`
*>
fn Logger* Logger.init_conf(&self, Allocator allocator, LogConfig config)
{
    *self = { .allocator = allocator, .config = config };
    return self;
}

<*
 Init the Logger with tmem.

 @param [in] self
 @return  `A Logger with default LogConfig and initialized with tmem`
*>
fn Logger* Logger.tinit(&self) => self.init(tmem) @inline;

<*
 Init the Logger with tmem and a custom LogConfig.

 @param [in] self
 @param config
 @return  `A Logger with a custom LogConfig with tmem as the Allocator.`
*>
fn Logger* Logger.tinit_with_conf(&self, LogConfig config) => self.init_conf(tmem, config) @inline;

<*
 The default info level logging.

 @param [in] self
 @param [in] msg: `The input message for logging.`
*>
fn void? Logger.info(&self, String msg) => self.log(LogLevel.INFO, msg) @inline;

<*
 Internal log function implementation.

 @param [in] self
 @param lvl: `The log level for the logging output.`
 @param [in] msg: `The input message for logging.`
*>
fn void? Logger.log(&self, LogLevel lvl, String msg) @private
{
    DString output = self.fmt_output(&lvl, msg)!;
    defer output.free();

    self.config.out.write(output.str_view())!;
    if (&self.config.out.flush) self.config.out.flush()!;
}

<*
 Formats the main output for the logger.

 @param [in] self
 @param [&in] lvl: `The log level for the logging output.`
 @param [in] msg: `The input message for logging.`
*>
fn DString? Logger.fmt_output(&self, LogLevel* lvl, String msg) @private
{
    DString output;
    output.init(self.allocator, 1024);

    if (self.config.date) {
        self.fmt_date(output)!;
    }

    self.fmt_log_lvl(output, lvl)!;

    if (self.config.path) {
        self.fmt_path(output)!;
    }

    output.appendf("- ")!;
    output.appendf("%s", msg)!;

    return output;
}

<*
 Formats the log level.

 @param [in] self
 @param [&out] output: `The output buffer for writing log level.`
 @param [&in] lvl: `The log level.`
*>
fn void? Logger.fmt_log_lvl(&self, DString output, LogLevel* lvl) @private
{
    output.appendf("[%s] ", lvl.name)!;
}

fn void? Logger.fmt_date(&self, DString output) @private
{
    DateTime now = datetime::now();
    output.appendf("[%d-%s-%s %s:%s:%s] ", now.year, now.month.abbrev, now.day, now.hour, now.min, now.sec)!;
}

<*
 Formats the path for the logging output.

 @param [in] self
 @param [&out] output: `The output buffer for writing log level.`
*>
fn void? Logger.fmt_path(&self, DString output) @private
{
    Path cwd = path::cwd(self.allocator)!;
    defer cwd.free();

    String[] split_path = cwd.path_string.tsplit("/");
    String file_name = split_path[^1];

    output.appendf("[%s] ", file_name)!;
}
