module tora;

import std::io;

fn void info(String msg, args..., String file=$$FILE, isz line_num=$$LINE)
{
    io::printfn("%s[%s %s] [%s] [%s:%s] - %s%s\n", LogLevel.INFO.color, $$DATE, $$TIME, LogLevel.INFO.name, file, line_num, string::tformat(msg, ...args), COLOR_RESET);
}
