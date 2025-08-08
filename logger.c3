module tora;

import std::io;

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
fn Logger temp(OutStream out=io::stdout())
{
   Logger log;
   log.tinit(out);

   return log;
}

<*
 Init the Logger with an Allocator.

 @require allocator != null
 @param [&inout] allocator
 @return  `A Logger with default config and specific Allocator`
*>
fn Logger* Logger.init(&self, Allocator allocator, OutStream out=io::stdout())
{
    *self = { .allocator = allocator, .config = init_log_conf(out:out) };
    return self;
}

<*
 Init the Logger with tmem.

 @param [in] self
 @return  `A Logger with default LogConfig and initialized with tmem`
*>
fn Logger* Logger.tinit(&self, OutStream out) => self.init(tmem, out) @inline;

<*
 The default info level logging.

 @param [in] self
 @param [in] msg: `The input message for logging.`
*>
fn void? Logger.info(&self, String msg, args..., String file=$$FILE, isz line_num=$$LINE) => self.log(LogLevel.INFO, string::tformat(msg, ...args), file, line_num) @inline;

<*
 Internal log function implementation.

 @param      lvl: `The log level for the logging output.`
 @param [in] msg: `The input message for logging.`
 @param      file: `The file name of the caller.`
 @param      line_num: `The line number of where the logger is called.`
*>
fn void? Logger.log(&self, LogLevel lvl, String msg, String file, isz line_num) @private
{
    DString output = fmt_output(self.allocator, &self.config, &lvl, msg, file, line_num)!;
    defer output.free();

    self.config.out.write(output.str_view())!;
    if (&self.config.out.flush) self.config.out.flush()!;
}
