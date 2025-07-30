module tora::log;

import std::io;
import std::time;
import std::core::dstring;

fn void test_str_null() @test
{
    fault err = @catch(log::log(null, null, &&LogLevel.TRACE, null));
    assert(err, "Passing null pointer for string is an error");
}

fn void test_positive_case() @test
{
    fault err = @catch(log::log(null, null, &&LogLevel.TRACE, &&"foo"));
    assert(!err, "Passing a string should not result in an error");
}

fn void test_info() @test
{
    fault err = @catch(log::info(&&"foo"));
    assert(!err, "Calling log functions for specific level should not result in an error");
}

fn void test_rethrowing() @test
{
    fault err = @catch(log::info(null));
    assert(err, "Should rethrow the specific log functions");
}

fn void test_log_config() @test
{
    LogConfig conf = { .date = false, .path = false };
    DString buf = dstring::temp();

    log::binfo_config(&conf, &buf, &&"foo")!!;

    String expected = "[INFO] - foo";
    test::eq(buf.str_view(), expected);
}

fn void test_file_config() @test
{
    LogConfig conf = { .path = true };
    DString buf = dstring::temp();

    log::binfo_config(&conf, &buf, &&"foo")!!;

    String expected = "[INFO] [tora.c3l] - foo";
    test::eq(buf.str_view(), expected);
}
