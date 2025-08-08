module tora;

import std::io;

fn void trace(String msg, args..., String file=$$FILE, isz line_num=$$LINE)
{
    log_print(string::tformat(msg, args), LogLevel.TRACE, file, line_num);
}

fn void debug(String msg, args..., String file=$$FILE, isz line_num=$$LINE)
{
    log_print(string::tformat(msg, args), LogLevel.DEBUG, file, line_num);
}

fn void info(String msg, args..., String file=$$FILE, isz line_num=$$LINE)
{
    log_print(string::tformat(msg, args), LogLevel.INFO, file, line_num);
}

fn void warn(String msg, args..., String file=$$FILE, isz line_num=$$LINE)
{
    log_print(string::tformat(msg, args), LogLevel.WARN, file, line_num);
}

fn void error(String msg, args..., String file=$$FILE, isz line_num=$$LINE)
{
    log_print(string::tformat(msg, args), LogLevel.ERROR, file, line_num);
}

fn void log_print(String msg, LogLevel lvl, String file, isz line_num)
{
    if (lvl.name == "ERROR") {
        io::eprintfn("%s[%s %s] [%s] [%s:%s] - %s%s\n", lvl.color, $$DATE, $$TIME, lvl.name, file, line_num, msg, COLOR_RESET);
    } else {
        io::printfn("%s[%s %s] [%s] [%s:%s] - %s%s\n", lvl.color, $$DATE, $$TIME, lvl.name, file, line_num, msg, COLOR_RESET);
    }
}
