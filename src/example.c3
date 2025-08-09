module tora;

import std::io;
import std::thread;

const MSG = "Hello, World!";

fn void main()
{
    log_example();

    logger_example();

    async_logger_example();
}

fn void log_example()
{
    tora::trace("hello");
    tora::debug("hello");
    tora::info("hello");
    tora::warn("hello");
    tora::error("hello");
}

fn void logger_example()
{
    DString out = dstring::temp();

    tora::Logger log = tora::temp(date: false, out: &out);
    log.trace("Logger: %s", MSG)!!;
    log.debug("Logger: %s", MSG)!!;
    log.info("Logger: %s", MSG)!!;
    log.warn("Logger: %s", MSG)!!;
    log.error("Logger: %s", MSG)!!;

    io::printfn(out.str_view());
}

fn void async_logger_example()
{
    DString out = dstring::temp();

    AsyncLogger log;
    log.init(allocator::heap(), out: &out)!!;
    defer log.free()!!;

    log.trace("AsyncLogger: %s", MSG)!!;
    log.debug("AsyncLogger: %s", MSG)!!;
    log.info("AsyncLogger: %s", MSG)!!;
    log.warn("AsyncLogger: %s", MSG)!!;
    log.error("AsyncLogger: %s", MSG)!!;

    thread::sleep_ms(50);

    io::printfn("%s", out);
}
