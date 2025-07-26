module yule;
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

fn int main(String[] args)
{
    LogLevel lvl = LogLevel.TRACE;
    String hello = "Hello, World!";

    fault excuse = @catch(log(lvl, &hello));
    if (excuse) {
        io::printn(excuse);
    }

	return 0;
}
