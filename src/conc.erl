%%%-------------------------------------------------------------------
%%% @author tommy
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Nov 2016 10:22
%%%-------------------------------------------------------------------
-module(conc).
-author("tommy").

%% API
-export([start/0, say_something/2]).

say_something(What, 0) ->
  done;
say_something(What, Times) ->
  io:format("~p~n", [What]),
  say_something(What, Times-1).

start() ->
  spawn(conc, say_something, [hello, 3]),
  spawn(conc, say_something, [goodbye, 4]).