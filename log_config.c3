module tora;

import std::io;

<*
 LogConfig allows the caller to be able choose the level detail in the log
 formatting.
*>
struct LogConfig
{
    bool date;
    bool path;
    OutStream out;
}

<*
 Creates a default log configuration.
*>
fn LogConfig init_log_conf(bool date=true, bool path=true, OutStream out=io::stdout())
{
    return { .date = date, .path = path, .out = out };
}
