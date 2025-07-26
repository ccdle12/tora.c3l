module tora;
import std::io;

enum LogLevel : int {
    TRACE,
    DEBUG,
    INFO,
    WARN,
    ERROR,
}

fn void? log(LogLevel lvl, String *msg) {
    if (!msg) {
        return io::FILE_NOT_FOUND?;
    }

    io::printn(*msg);
}
