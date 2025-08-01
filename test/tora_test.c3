module tora;

import std::io;
import std::time;
import std::core::dstring;

fn void test_positive_case() @test
{
    Logger log = temp();

    fault err = @catch(log.info(&&"foo"));
    assert(!err, "Passing a string should not result in an error");
}

fn void test_info() @test
{
    Logger log = temp();

    fault err = @catch(log.info(&&"foo"));
    assert(!err, "Calling log functions for specific level should not result in an error");
}

fn void test_log_config() @test
{
    Logger log = temp_with_conf({ .date = false, .path = false});

    DString result = dstring::temp();
    log.binfo(&result, &&"foo")!!;

    String expected = "[INFO] - foo";
    test::eq(result.str_view(), expected);
}

fn void test_file_config() @test
{
    Logger log = temp_with_conf({ .path = true });

    DString result = dstring::temp();
    log.binfo(&result, &&"foo")!!;

    String expected = "[INFO] [tora.c3l] - foo";
    test::eq(result.str_view(), expected);
}

fn void test_different_allocator() @test
{
    LibcAllocator alloc;

    Logger log;
    log.init_conf(&alloc, { .path = true, .date = false});

    DString result = dstring::temp();
    log.binfo(&result, &&"foo")!!;

    String expected = "[INFO] [tora.c3l] - foo";
    test::eq(result.str_view(), expected);
}

// NOTE: Kind of a hacky test, File implements flush(), so I'm forcing that
// branch to be called and shouldn't crash.
fn void test_log_flush() @test
{
    LibcAllocator alloc;

    Logger log;
    log.init_conf(&alloc, { .path = true, .date = false});

    File* file = io::stdout();
    log.binfo(file, &&"foo")!!;
}
