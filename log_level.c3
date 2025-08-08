module tora;

const String COLOR_RESET = "\u001B[0m";

// TODO: Update colors for TRACE, DEBUG, WARN.
<*
 The LogLevels available for logging.
*>
enum LogLevel : uint (String name, String color)
{
    TRACE = {"TRACE", "\u001B[90m"},
    DEBUG = {"DEBUG", "\u001B[34m"},
    INFO  = {"INFO", "\u001B[32m"},
    WARN  = {"WARN", "\u001B[33m"},
    ERROR = {"ERROR", "\u001B[31m"}
}
