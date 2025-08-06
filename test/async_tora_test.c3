module async_tora;

import std::io;
import std::thread;
import std::os;
import std::time;
import tora;

fn void test_async_logger() @test
{
    DString out = dstring::temp();
    LogConfig conf = { .out = &out };

    AsyncLogger alog;
    alog.init(allocator::heap(), conf)!!;
    defer alog.free()!!;

    String msg = "foo";
    alog.info(msg)!!;

    thread::sleep_ms(50);

    String view = out.str_view();
    test::@check(view.contains(msg));
    test::@check(view.contains("[INFO]"));
}

fn void test_passing_tmem() @test
{
    LogConfig conf = tora::init_log_conf();

    AsyncLogger alog;
    alog.init(allocator::heap(), conf)!!;
    defer alog.free()!!;
}
