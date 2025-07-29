module tora;
import std::io;
import std::time::datetime;

faultdef NULL_POINTER;

enum LogLevel : int (String name) {
    TRACE = "TRACE",
    DEBUG = "DEBUG",
    INFO  = "INFO",
    WARN  = "WARN",
    ERROR = "ERROR",
}

fn void? log_info(String *msg) => log(null, LogLevel.INFO, msg) @inline;
fn void? b_log_info(DString* buffer, String *msg) => log(buffer, LogLevel.INFO, msg) @inline;


fn void? log(DString* buffer, LogLevel lvl, String *msg)
{
    if (!msg) {
        return NULL_POINTER?;
    }

    @pool()
    {
        DString output = fmt_output(&lvl, msg);

        if (buffer) {
            buffer.appendf(output.str_view())!;
        } else {
            io::printn(output.str_view());
        }
    };
}

fn DString fmt_output(LogLevel* lvl, String* msg)
{
        DateTime now = datetime::now();

        DString output = dstring::temp();
        output.appendf("[%s] [%d-%s-%s %s:%s:%s] %s", lvl.name, now.year, now.month.abbrev, now.day, now.hour, now.min, now.sec, *msg);

        return output;
}
