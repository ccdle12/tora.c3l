module tora;

const String COLOR_RESET = "\u001B[0m";
const String COLOR_ERROR = "\u001B[31m";
const String COLOR_INFO  = "\u001B[94m";

<*
 The LogLevels available for logging.
*>
enum LogLevel : int (String name)
{
    TRACE = "TRACE",
    DEBUG = "DEBUG",
    INFO  = "INFO",
    WARN  = "WARN",
    ERROR = "ERROR",
}

fn String get_level_color(LogLevel* lvl)
{
    switch (*lvl)
    {
        case LogLevel.ERROR:
            return COLOR_ERROR;
        case LogLevel.INFO:
            return COLOR_INFO;
        default:
            return COLOR_RESET;
    }
}
