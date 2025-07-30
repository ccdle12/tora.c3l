module tora;

import std::io;
import std::time::datetime;

faultdef NULL_POINTER;

struct Logger
{
    Allocator allocator;
    LogConfig config;
}

struct LogConfig
{
    bool date;
    bool path;
}

fn Logger* Logger.init(&self, Allocator allocator, LogConfig config)
{
    *self = { .allocator = allocator, .config = config };
    return self;
}

fn Logger* Logger.tinit(&self)
{
    LogConfig config = { .date = true, .path = true };
    return self.init(tmem, config) @inline;
}

fn Logger* Logger.tinit_conf(&self, LogConfig config) => self.init(tmem, config) @inline;

fn void? Logger.info(&self, String* msg) => self.log(null, &&LogLevel.INFO, msg) @inline;

fn void? Logger.binfo(&self, DString* buffer, String* msg) => self.log(buffer, &&LogLevel.INFO, msg) @inline;


enum LogLevel : int (String name) @private
{
    TRACE = "TRACE",
    DEBUG = "DEBUG",
    INFO  = "INFO",
    WARN  = "WARN",
    ERROR = "ERROR",
}

fn void? Logger.log(&self, DString* buffer, LogLevel* lvl, String *msg) @private
{
    if (!msg) {
        return NULL_POINTER?;
    }

    DString output = self.fmt_output(lvl, msg)!;
    defer output.free();

    if (buffer) {
        buffer.appendf(output.str_view())!;
    } else {
        io::printn(output.str_view());
    }
}

fn DString? Logger.fmt_output(&self, LogLevel* lvl, String* msg) @private
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

    output.appendf("- ", *msg)!;
    output.appendf("%s", *msg)!;
    return output;
}

fn void? Logger.fmt_log_lvl(&self, DString output, LogLevel* lvl) @private
{
    output.appendf("[%s] ", lvl.name)!;
}

fn void? Logger.fmt_date(&self, DString output) @private
{
    DateTime now = datetime::now();
    output.appendf("[%d-%s-%s %s:%s:%s] ", now.year, now.month.abbrev, now.day, now.hour, now.min, now.sec)!;
}

fn void? Logger.fmt_path(&self, DString output) @private
{
    Path cwd = path::cwd(self.allocator)!;
    defer cwd.free();

    String[] split_path = cwd.path_string.tsplit("/");
    String file_name = split_path[^1];

    output.appendf("[%s] ", file_name)!;
}
