Welcome to the tora logging library.

## Example

### Quick Use

```c
import tora;

fn void main()
{
    String hello = "Hello, World!";
    tora::info("%s", hello)!!;
}

>>> [2025-08-07 15:10:34] [INFO] [main.c3:8] - Hello, World!
```

### Logging with Configuration

If you would like more control and configuration on the output format and logging
destination, use the `Logger` struct and `LogConfig`.

Omitting assignment to `OutStream out` in the `LogConfig` defaults to `stdout`.

```c
import tora;
import std::io;

fn void main()
{
    tora::Logger log;
    log.init(allocator::heap(), tora::init_log_conf(path: false));
    log.info("Hello, World!")!!;
}

>>> [2025-08-08 16:33:19] [INFO] - Hello, World!
```

```c
import tora;
import std::io;

fn void main()
{
    DString output = dstring::temp();
    LogConfig conf = tora::init_log_conf(date: false, out: &out);

    tora::Logger log = tora::temp(conf);
    log.info("Hello, World!")!!;

    io::printfn(output.str_view());
}

>>> [INFO] [main.c3:11] - Hello, World!
```

### Async Logger

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
    log.init(allocator::heap(), tora::init_log_conf(out=&out))!!;
    defer log.free()!!;

    log.info("Hello, World!")!!;

    thread::sleep_ms(50);

    io::printfn("%s", out);
}

>>> [2025-08-07 20:55:56] [INFO] [main.c3:13] - Hello, World!
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
