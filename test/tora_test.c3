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

fn void test_no_error() @test
{
    Logger log = temp();

    fault err = @catch(log.info("foo"));
    assert(!err, "Calling log functions for specific level should not result in an error");
}

fn void test_log_fmt() @test
{
    Logger log = temp();

    String foo = "foo";
    fault err = @catch(log.info("%d%d%d %s", 1, 2, 3, &foo));
    assert(!err, "Calling log functions for specific level should not result in an error");
}

fn void test_log_config() @test
{
    DString out = dstring::temp();

    Logger log = temp_with_conf({ .out = &out });
    log.info("foo")!!;

    String result = strip_log_output(out.str_view());
    String expected = "[INFO] - foo";

    test::eq(result, expected);
}

fn void test_file_config() @test
{
    DString out = dstring::temp();

    Logger log = temp_with_conf({ .path = true, .out = &out });
    log.info("foo: %d, %s", 5, "bar")!!;
    String expected = @sprintf("[INFO] [tora_test.c3:%s] - foo: 5, bar", $$LINE-1);

    String result = strip_log_output(out.str_view());
    test::eq(result, expected);
}

fn void test_different_allocator() @test
{
    LibcAllocator alloc;
    DString out = dstring::temp();

    Logger log;
    log.init_conf(&alloc, { .path = true, .out = &out });
    log.info("foo")!!;
    String expected = @sprintf("[INFO] [tora_test.c3:%s] - foo", $$LINE-1);

    String result = strip_log_output(out.str_view());
    test::eq(result, expected);
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

    //test::eq(1, 2);
}
