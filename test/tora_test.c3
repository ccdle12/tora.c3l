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

fn void test_simple_formatting() @test
{
    Logger log = temp();

    String foo = "foo";
    fault err = @catch(log.info("%d%d%d %s", 1, 2, 3, &foo));
    assert(!err, "Calling log functions for specific level should not result in an error");
}

fn void test_expected_formatting() @test
{
    DString out = dstring::temp();
    Logger log = temp(config: init_log_conf(out: &out));

    log.info("foo: %d, %s", 5, "bar")!!;
    String expected = @sprintf("[INFO] [tora_test.c3:%s] - foo: 5, bar", $$LINE-1);

    test::@check(out.str_view().contains(expected));
}

fn void test_different_allocator() @test
{
    LibcAllocator alloc;
    DString out = dstring::temp();

    Logger log;
    log.init(&alloc, config: init_log_conf(out: &out));

    log.info("foo")!!;
    String expected = @sprintf("[INFO] [tora_test.c3:%s] - foo", $$LINE-1);

    test::@check(out.str_view().contains(expected));
}

// NOTE: Kind of a hacky test, File implements flush(), so I'm forcing that
// branch to be called and shouldn't crash.
fn void test_log_flush() @test
{
    LibcAllocator alloc;

    Logger log;
    log.init(&alloc);
    log.info("foo")!!;

    //test::eq(1, 2);
}
