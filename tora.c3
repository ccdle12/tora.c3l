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

fn String get_log_string(LogLevel lvl) @private
{
    switch (lvl)
    {
        case INFO:
            return "[INFO] ";
        default:
            return "";
    }
}

fn void? log_info(String *msg)
{
    return log(null, 0, LogLevel.INFO, msg)!;
}

fn void? b_log_info(char* buffer, int buf_size, String *msg)
{
    return log(buffer, buf_size, LogLevel.INFO, msg)!;
}

fn void? log(char* buf, int buf_size, LogLevel lvl, String *msg)
{
    if (!msg) {
        return NULL_POINTER?;
    }

    String lvl_fmt = get_log_string(lvl);
    String output = String.tconcat(lvl_fmt, *msg);

    if (buf) {
        io::bprintf(buf[:buf_size], output);
    } else {
        io::printn(output);
    }
}
