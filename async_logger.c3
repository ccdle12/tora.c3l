module tora;

import std::io;
import std::thread;
import std::collections;

alias BufChan = channel::BufferedChannel{BufEvent};

struct AsyncLogger
{
    Allocator allocator;
    Thread thread;

    BufChan chan;
    bool done;

    Logger logger;

    bool initialized;
}

struct BufEvent
{
    String msg;
    String file;
    isz line_num;
    LogLevel lvl;
}

<*
 @require !self.initialized : "AsyncLogger must not already be initialized"
 @require allocator != null

 @param [&inout] allocator
*>
fn AsyncLogger*? AsyncLogger.init(&self, Allocator allocator, bool date=true, bool path=true, OutStream out=io::stdout())
{
    *self = { .allocator = allocator };

    self.chan.init(self.allocator)!;
    self.logger.init(self.allocator, date, path, out);
    self.thread.create((ThreadFn) &worker_thread, self)!;
    self.initialized = true;

    return self;
}

fn void? AsyncLogger.trace(&self, String msg, args..., String file=$$FILE, isz line_num=$$LINE) => self.push_event(LogLevel.TRACE, string::tformat(msg, ...args), file, line_num) @inline;
fn void? AsyncLogger.debug(&self, String msg, args..., String file=$$FILE, isz line_num=$$LINE) => self.push_event(LogLevel.DEBUG, string::tformat(msg, ...args), file, line_num) @inline;
fn void? AsyncLogger.info(&self, String msg, args..., String file=$$FILE, isz line_num=$$LINE) => self.push_event(LogLevel.INFO, string::tformat(msg, ...args), file, line_num) @inline;
fn void? AsyncLogger.warn(&self, String msg, args..., String file=$$FILE, isz line_num=$$LINE) => self.push_event(LogLevel.WARN, string::tformat(msg, ...args), file, line_num) @inline;
fn void? AsyncLogger.error(&self, String msg, args..., String file=$$FILE, isz line_num=$$LINE) => self.push_event(LogLevel.ERROR, string::tformat(msg, ...args), file, line_num) @inline;

fn void? AsyncLogger.push_event(&self, LogLevel lvl, String fmt_msg, String file, isz line_num) @private
{
    self.chan.push({ .msg = fmt_msg,
                     .file = file,
                     .line_num = line_num,
                     .lvl = lvl })!;
}


fn void? AsyncLogger.free(&self)
{
    if (!self) return;

    // Ensure the worker_thread unblocks and exits.
    self.done = true;
    self.chan.push({ .msg = "\n", .lvl = LogLevel.ERROR })!;

    self.chan.close()!;
    allocator::free(self.allocator, (void *) self.chan);

    self.thread.join()!;
}

fn void? worker_thread(AsyncLogger* alog) @private
{
    @pool_init(alog.allocator, 1024)
    {
        while (!alog.done)
        {
            BufEvent event = alog.chan.pop()!;
            if (alog.done) return;

            switch (event.lvl)
            {
                case TRACE:
                    alog.logger.trace(event.msg, file: event.file, line_num: event.line_num)!;
                case DEBUG:
                    alog.logger.debug(event.msg, file: event.file, line_num: event.line_num)!;
                case INFO:
                    alog.logger.info(event.msg, file: event.file, line_num: event.line_num)!;
                case WARN:
                    alog.logger.warn(event.msg, file: event.file, line_num: event.line_num)!;
                case ERROR:
                    alog.logger.error(event.msg, file: event.file, line_num: event.line_num)!;
                default:
                    alog.logger.error(event.msg, file: event.file, line_num: event.line_num)!;
            }
        }
    };
}
