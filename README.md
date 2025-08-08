Welcome to the tora logging library.

## Example

### Quick Use

```c
import tora;

fn void main()
{
    String hello = "Hello, World!";

    tora::Logger log = tora::temp();
    log.info("%s", hello)!!;
}

>>> [2025-08-07 15:10:34] [INFO] [main.c3:8] - Hello, World!
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
    log.init(allocator::heap(), &out)!!;
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
