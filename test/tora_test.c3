module tora;

import std::io;
import std::time;
import std::core::dstring;

fn void test_positive_case() @test
{
    Logger log = temp();

    fault err = @catch(log.info("foo"));
    assert(!err, "Passing a string should not result in an error");
}

fn void test_info() @test
{
    Logger log = temp();

    fault err = @catch(log.info("foo"));
    assert(!err, "Calling log functions for specific level should not result in an error");
}

fn void test_log_config() @test
{
    DString result = dstring::temp();

    Logger log = temp_with_conf({ .out = &result });
    log.info("foo")!!;

    String expected = "[INFO] - foo";
    test::eq(result.str_view(), expected);
}

fn void test_file_config() @test
{
    DString result = dstring::temp();

    Logger log = temp_with_conf({ .path = true, .out = &result });
    log.info("foo")!!;

    String expected = "[INFO] [tora.c3l] - foo";
    test::eq(result.str_view(), expected);
}

fn void test_different_allocator() @test
{
    LibcAllocator alloc;
    DString result = dstring::temp();

    Logger log;
    log.init_conf(&alloc, { .path = true, .out = &result });
    log.info("foo")!!;

    String expected = "[INFO] [tora.c3l] - foo";
    test::eq(result.str_view(), expected);
}

// NOTE: Kind of a hacky test, File implements flush(), so I'm forcing that
// branch to be called and shouldn't crash.
fn void test_log_flush() @test
{
    LibcAllocator alloc;

    LogConfig conf = init_log_conf();
    conf.date = false;

    Logger log;
    log.init_conf(&alloc, conf);
    log.info("foo")!!;
}
