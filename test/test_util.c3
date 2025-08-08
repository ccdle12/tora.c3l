module tora;

fn String strip_log_output(String msg) @private
{
    return msg.strip(COLOR_ERROR)
              .strip(COLOR_INFO)
              .strip_end(COLOR_RESET)
              .strip_end("\n");
}
