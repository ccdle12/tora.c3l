module tora;
import std::io;

faultdef NULL_POINTER;

enum LogLevel : int {
    TRACE,
    DEBUG,
    INFO,
    WARN,
    ERROR,
}

fn void? log_trace(String *msg)
{
    return log(LogLevel.TRACE, msg)!;
}

fn void? log_debug(String *msg)
{
    return log(LogLevel.DEBUG, msg)!;
}

fn void? log_info(String *msg)
{
    return log(LogLevel.INFO, msg)!;
}

fn void? log_warn(String *msg)
{
    return log(LogLevel.WARN, msg)!;
}

fn void? log_error(String *msg)
{
    return log(LogLevel.ERROR, msg)!;
}

fn void? log(LogLevel lvl, String *msg)
{
    if (!msg) {
        return NULL_POINTER?;
    }

    io::printn(*msg);
}
