module tora;

import std::io;

<*
 Logger struct for configurable and flexible logging.
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
fn Logger temp(bool date=true, bool path=true, OutStream out=io::stdout())
{
   Logger log;
   log.tinit(date, path, out);

   return log;
}

<*
 Init the Logger with an Allocator.

 @require allocator != null
 @param [&inout] allocator
 @return  `A Logger with default config and a specific Allocator`
*>
fn Logger* Logger.init(&self, Allocator allocator, bool date=true, bool path=true, OutStream out=io::stdout())
{

    LogConfig config = init_log_conf(date, path, out);
    *self = { .allocator = allocator, .config = config };
    return self;
}

<*
 Init the Logger with tmem.

 @param [in] self
 @return  `A Logger with default LogConfig and initialized with tmem`
*>
fn Logger* Logger.tinit(&self, bool date=true, bool path=true, OutStream out=io::stdout()) => self.init(tmem, date, path, out) @inline;

fn void? Logger.trace(&self, String msg, args..., String file=$$FILE, isz line_num=$$LINE) => self.log(LogLevel.TRACE, string::tformat(msg, ...args), file, line_num) @inline;
fn void? Logger.debug(&self, String msg, args..., String file=$$FILE, isz line_num=$$LINE) => self.log(LogLevel.DEBUG, string::tformat(msg, ...args), file, line_num) @inline;
fn void? Logger.info(&self, String msg, args..., String file=$$FILE, isz line_num=$$LINE) => self.log(LogLevel.INFO, string::tformat(msg, ...args), file, line_num) @inline;
fn void? Logger.warn(&self, String msg, args..., String file=$$FILE, isz line_num=$$LINE) => self.log(LogLevel.WARN, string::tformat(msg, ...args), file, line_num) @inline;
fn void? Logger.error(&self, String msg, args..., String file=$$FILE, isz line_num=$$LINE) => self.log(LogLevel.ERROR, string::tformat(msg, ...args), file, line_num) @inline;

<*
 Internal log function implementation.

 @param      lvl: `The log level for the logging output.`
 @param [in] msg: `The input message for logging.`
 @param      file: `The file name of the caller.`
 @param      line_num: `The line number of where the logger was called.`
*>
fn void? Logger.log(&self, LogLevel lvl, String msg, String file, isz line_num) @private
{
    DString output = self.fmt_output(&lvl, msg, file, line_num)!;
    defer output.free();

    self.config.out.write(output.str_view())!;
    if (&self.config.out.flush) self.config.out.flush()!;
}

<*
 Formats the main output for the logger.

 Caller is responsible for freeing the allocated DString.

 @param [in] self
 @param [&in] lvl: `The log level for the logging output.`
 @param [in] msg: `The input message for logging.`
 @param      file: `The file name of the caller.`
 @param      line_num: `The line number of where the logger was called.`
*>
fn DString? Logger.fmt_output(&self, LogLevel* lvl, String msg, String file, isz line_num) @private
{
    DString output;
    output.init(self.allocator, 1024);

    output.appendf("%s", lvl.color)!;

    if (self.config.date) {
        output.appendf("[%s %s] ", $$DATE, $$TIME)!;
    }

    output.appendf("[%s] ", lvl.name)!;

    if (self.config.path) {
        output.appendf("[%s:%s] ", file, line_num)!;
    }

    output.appendf("- ")!;
    output.appendf("%s\n", msg)!;

    output.appendf("%s", COLOR_RESET)!;
    return output;
}
