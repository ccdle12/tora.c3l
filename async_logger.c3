module async_tora;

import std::io;
import std::thread;
import std::collections;
import tora;

alias BufChan = channel::BufferedChannel{BufMsg};

struct AsyncLogger
{
    Allocator allocator;
    Thread thread;

    BufChan chan;
    bool done;

    Logger logger;

    bool initialized;
}

struct BufMsg
{
    String msg;
    LogLevel lvl;
}

<*
 @require !self.initialized : "AsyncLogger must not already be initialized"
 @require allocator != null

 @param [&inout] allocator
 @param conf: `The LogConfig for writing out via the Logger`
*>
fn AsyncLogger*? AsyncLogger.init(&self, Allocator allocator, LogConfig conf)
{
    *self = { .allocator = allocator };

    self.chan.init(self.allocator)!;
    self.logger.init_conf(self.allocator, conf);
    self.thread.create((ThreadFn) &worker_thread, self)!;
    self.initialized = true;

    return self;
}

fn void? AsyncLogger.info(&self, String msg) {
    self.chan.push({ .msg = msg, .lvl = LogLevel.INFO })!;
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
            BufMsg buf_msg = alog.chan.pop()!;
            if (alog.done) return;

            switch (buf_msg.lvl)
            {
                case INFO:
                    alog.logger.info(buf_msg.msg)!;
                default:
                   io::printfn("error for now");
            }
        }
    };
}
