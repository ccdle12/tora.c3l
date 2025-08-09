Welcome to the tora logging library.

## Quick Use

```c
import tora;

fn void main()
{
    tora::trace("hello");
    tora::debug("hello");
    tora::info("hello");
    tora::warn("hello");
    tora::error("hello");
}

>>> [2025-08-08 18:23:48] [TRACE] [main.c3:5] - hello
>>> [2025-08-08 18:23:48] [DEBUG] [main.c3:6] - hello
>>> [2025-08-08 18:23:48] [INFO] [main.c3:7] - hello
>>> [2025-08-08 18:23:48] [WARN] [main.c3:8] - hello
>>> [2025-08-08 18:23:48] [ERROR] [main.c3:9] - hello

```

## Logging with Configuration

If you would like more control and configuration on the output format and logging
destination, use the `Logger` struct.

The current three configurable parameters are:

- `bool date`: To show the date and time on logs
- `bool file`: To show the file and line of where the log is called
- `OutStream out`: To redirect the output to any implementation of OutStream (defaults to stdout and stderr for ERROR level).

```c
import tora;
import std::io;

const MSG = "Hello, World!";

fn void main()
{
    DString out = dstring::temp();

    tora::Logger log = tora::temp(date:false, out: &out);
    log.trace("Logger: %s", MSG)!!;
    log.debug("Logger: %s", MSG)!!;
    log.info("Logger: %s", MSG)!!;
    log.warn("Logger: %s", MSG)!!;
    log.error("Logger: %s", MSG)!!;

    io::printfn(out.str_view());

}

>>> [TRACE] [example.c3:31] - Logger: Hello, World!
>>> [DEBUG] [example.c3:32] - Logger: Hello, World!
>>> [INFO] [example.c3:33] - Logger: Hello, World!
>>> [WARN] [example.c3:34] - Logger: Hello, World!
>>> [ERROR] [example.c3:35] - Logger: Hello, World!
```

## Async Logger

A simple Async Logger that creates a background thread to handle writing to the
output.

```c
import tora;
import std::thread;
import std::io;

fn void main()
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

>>> [2025-08-09 10:05:58] [TRACE] [example.c3:48] - AsyncLogger: Hello, World!
>>> [2025-08-09 10:05:58] [DEBUG] [example.c3:49] - AsyncLogger: Hello, World!
>>> [2025-08-09 10:05:58] [INFO] [example.c3:50] - AsyncLogger: Hello, World!
>>> [2025-08-09 10:05:58] [WARN] [example.c3:51] - AsyncLogger: Hello, World!
>>> [2025-08-09 10:05:58] [ERROR] [example.c3:52] - AsyncLogger: Hello, World!
```

## Run the example

```sh
c3c run
```

## Installation

Clone the repository with
```git clone http://github.com/ccdle12/tora.c3l```
to the `./lib` folder of your C3 project and add the following to
`project.json`:

```json
{
    "dependency-search-paths": [ "lib" ],
    "dependencies": [ "tora" ]
}
```

If you didn't clone it into the `lib` folder, adjust your
`dependency-search-paths` accordingly.
