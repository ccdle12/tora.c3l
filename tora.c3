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

fn void? Logger.info(&self, String* msg) => log(&self.config, null, &&LogLevel.INFO, msg) @inline;

fn void? Logger.binfo(&self, DString* buffer, String* msg) => log(&self.config, buffer, &&LogLevel.INFO, msg) @inline;


enum LogLevel : int (String name) @private
{
    TRACE = "TRACE",
    DEBUG = "DEBUG",
    INFO  = "INFO",
    WARN  = "WARN",
    ERROR = "ERROR",
}

fn void? log(LogConfig* config, DString* buffer, LogLevel* lvl, String *msg) @private
{
    if (!msg) {
        return NULL_POINTER?;
    }

    @pool()
    {
        DString output = fmt_output(config, lvl, msg)!;

        if (buffer) {
            buffer.appendf(output.str_view())!;
        } else {
            io::printn(output.str_view());
        }
    };
}

fn DString? fmt_output(LogConfig* config, LogLevel* lvl, String* msg) @private
{
        DString output;
        output.tinit(1024);

        // No config means include all information.
        if (!config) {
            fmt_date(output)!;
            fmt_log_lvl(output, lvl)!;
            fmt_path(output)!;
        } else {
            // User defined config, we need to check each flag and apply formatting.
            if (config.date) {
                fmt_date(output)!;
            }

            fmt_log_lvl(output, lvl)!;

            if (config.path) {
                fmt_path(output)!;
            }
        }

        output.appendf("- ", *msg)!;
        output.appendf("%s", *msg)!;
        return output;
}

fn void? fmt_log_lvl(DString output, LogLevel* lvl) @private
{
    output.appendf("[%s] ", lvl.name)!;
}

fn void? fmt_date(DString output) @private
{
    DateTime now = datetime::now();
    output.appendf("[%d-%s-%s %s:%s:%s] ", now.year, now.month.abbrev, now.day, now.hour, now.min, now.sec)!;
}

fn void? fmt_path(DString output) @private
{
        Path cwd = path::tcwd()!;
        String[] split_path = cwd.path_string.tsplit("/");
        String file_name = split_path[^1];

        output.appendf("[%s] ", file_name)!;
}
