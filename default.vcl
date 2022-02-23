vcl 4.0;

import std;
import topvar;

sub vcl_init {
  new reqCount = topvar.int();
  new reqLog = topvar.string();
}

backend default {
  .host = "nginx";
}

sub vcl_backend_response {
  set beresp.do_esi = true;
}

sub vcl_recv {
  if (req.url == "/esi-log") {
    return(synth(200));
  }
}

sub vcl_deliver {
  reqLog.set(reqLog.get("") + "Level " + req.esi_level + "<br/>");
  reqCount.set(reqCount.get(0) + 1);
}

sub vcl_synth {
  if (req.url == "/esi-log") {
    synthetic("count: " + reqCount.get(0) + "<div>" + reqLog.get("empty") + "</div>");
    return (deliver);
  }
}