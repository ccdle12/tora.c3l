module tora;

import std::io;
import std::thread;
import std::os;
import std::time;

fn void test_async_logger() @test
{
    DString out = dstring::temp();

    AsyncLogger alog;
    alog.init(allocator::heap(), out: &out)!!;
    defer alog.free()!!;

    String msg = "foo";
    alog.info("%s", msg)!!;

    thread::sleep_ms(50);

    String view = out.str_view();
    test::@check(view.contains(msg));
    test::@check(view.contains("[INFO]"));
}

// TODO: How to handle this?
//fn void test_passing_tmem() @test
//{
//    LogConfig conf = tora::init_log_conf();
//
//    AsyncLogger alog;
//    alog.init(tmem, conf)!!;
//    defer alog.free()!!;
//}
