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
    tora::trace("hello");
    tora::debug("hello");
    tora::info("hello");
    tora::warn("hello");
    tora::error("hello");
}
