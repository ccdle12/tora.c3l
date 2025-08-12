# Tora Logging Library

- Built on version: `C3 Compiler Version:       0.7.4 (Pre-release, Jan  1 1980 00:00:00)`

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

If you need to use a configurable logger or an async logger, there is an implementation
on [feat-logger-and-async-logger](https://github.com/ccdle12/tora.c3l/tree/feat-logger-and-async-logger)

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
