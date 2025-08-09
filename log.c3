module tora;

import std::io;

const FORMAT_STR = "%s[%s %s] [%s] [%s:%s] - %s%s\n";

fn void trace(String msg, args..., String file=$$FILE, isz line_num=$$LINE) => log_print(string::tformat(msg, args), LogLevel.TRACE, file, line_num) @inline;

fn void debug(String msg, args..., String file=$$FILE, isz line_num=$$LINE) => log_print(string::tformat(msg, args), LogLevel.DEBUG, file, line_num) @inline;

fn void info(String msg, args..., String file=$$FILE, isz line_num=$$LINE) => log_print(string::tformat(msg, args), LogLevel.INFO, file, line_num) @inline;

fn void warn(String msg, args..., String file=$$FILE, isz line_num=$$LINE) => log_print(string::tformat(msg, args), LogLevel.WARN, file, line_num) @inline;

fn void error(String msg, args..., String file=$$FILE, isz line_num=$$LINE) => log_print(string::tformat(msg, args), LogLevel.ERROR, file, line_num) @inline;

fn void log_print(String msg, LogLevel lvl, String file, isz line_num)
{
    if (lvl.str == "ERROR") {
        io::eprintfn(FORMAT_STR, lvl.color, $$DATE, $$TIME, lvl.str, file, line_num, msg, COLOR_RESET);
    } else {
        io::printfn(FORMAT_STR, lvl.color, $$DATE, $$TIME, lvl.str, file, line_num, msg, COLOR_RESET);
    }
}
