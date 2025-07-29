module tora;
import std::io;
import std::time::datetime;

faultdef NULL_POINTER;

struct LogConfig
{
    bool date;
}

enum LogLevel : int (String name) {
    TRACE = "TRACE",
    DEBUG = "DEBUG",
    INFO  = "INFO",
    WARN  = "WARN",
    ERROR = "ERROR",
}

fn void? log_info(String *msg) => log(null, null, &&LogLevel.INFO, msg) @inline;
fn void? b_log_info(DString* buffer, String *msg) => log(null, buffer, &&LogLevel.INFO, msg) @inline;
fn void? b_log_info_config(LogConfig* config, DString* buffer, String *msg) => log(config, buffer, &&LogLevel.INFO, msg);

fn void? log(LogConfig* config, DString* buffer, LogLevel* lvl, String *msg) @private
{
    if (!msg) {
        return NULL_POINTER?;
    }

    @pool()
    {
        DString output = fmt_output(config, lvl, msg);

        if (buffer) {
            buffer.appendf(output.str_view())!;
        } else {
            io::printn(output.str_view());
        }
    };
}

fn DString fmt_output(LogConfig* config, LogLevel* lvl, String* msg) @private
{
        DString output = dstring::temp();
        output.appendf("[%s] ", lvl.name);

        // No config means include all information.
        if (!config) {
            fmt_date(output);
        } else {
            // User defined config, we need to check each flag and apply formatting.
            if (config.date) {
                fmt_date(output);
            }
        }

        output.appendf("%s", *msg);
        return output;
}

fn void fmt_date(DString output) @private
{
    DateTime now = datetime::now();
    output.appendf("[%d-%s-%s %s:%s:%s] ", now.year, now.month.abbrev, now.day, now.hour, now.min, now.sec);
}
