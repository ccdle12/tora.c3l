module tora;

import std::io;
import std::thread;

const MSG = "Hello, World!";

fn void main()
{
    log_example();
}

fn void log_example()
{
    tora::trace("%s", MSG);
    tora::debug("%s", MSG);
    tora::info("%s", MSG);
    tora::warn("%s", MSG);
    tora::error("%s", MSG);
}
