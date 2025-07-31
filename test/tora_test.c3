module tora;

import std::io;
import std::time;
import std::core::dstring;

fn void test_positive_case() @test
{
    tora::Logger log;
    log.tinit();

    fault err = @catch(log.info(&&"foo"));
    assert(!err, "Passing a string should not result in an error");
}

fn void test_info() @test
{
    tora::Logger log;
    log.tinit();

    fault err = @catch(log.info(&&"foo"));
    assert(!err, "Calling log functions for specific level should not result in an error");
}

fn void test_log_config() @test
{
    tora::LogConfig conf = { .date = false, .path = false };
    tora::Logger log;
    log.tinit_conf(conf);

    DString buf = dstring::temp();
    log.binfo(&buf, &&"foo")!!;

    String expected = "[INFO] - foo";
    test::eq(buf.str_view(), expected);
}

fn void test_file_config() @test
{
    tora::LogConfig conf = { .path = true };
    tora::Logger log;
    log.tinit_conf(conf);

    DString buf = dstring::temp();
    log.binfo(&buf, &&"foo")!!;

    String expected = "[INFO] [tora.c3l] - foo";
    test::eq(buf.str_view(), expected);
}

fn void test_different_allocator() @test
{
    LibcAllocator alloc;

    tora::LogConfig conf = { .path = true, .date = false };
    tora::Logger log;
    log.init_conf(&alloc, conf);

    DString buf = dstring::temp();
    log.binfo(&buf, &&"foo")!!;

    String expected = "[INFO] [tora.c3l] - foo";
    test::eq(buf.str_view(), expected);
}
