import tora;
import std::io;

fn void test_str_null() @test
{
    fault err = @catch(tora::log(null, 0, LogLevel.TRACE, null));
    assert(err, "Passing null pointer for string is an error");
}

fn void test_positive_case() @test
{
    fault err = @catch(tora::log(null, 0, LogLevel.TRACE, &&"foo"));
    assert(!err, "Passing a string should not result in an error");
}

fn void test_info_case() @test
{
    fault err = @catch(tora::log_info(&&"foo"));
    assert(!err, "Calling log functions for specific level should not result in an error");
}

fn void test_rethrowing() @test
{
    fault err = @catch(tora::log_info(null));
    assert(err, "Should rethrow the specific log functions");
}

fn void test_log_output() @test
{
    char[1024] buf;
    tora::b_log_info(&buf[0], $sizeof(buf), &&"foo")!!;

    String result = (String) &buf;
    String expected = "[INFO] foo";

    test::eq(result[:expected.len], expected);
}
