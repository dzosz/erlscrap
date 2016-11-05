%%%-------------------------------------------------------------------
%%% @author tommy
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Nov 2016 20:08
%%%-------------------------------------------------------------------
-module(hello).
-author("tommy").

%% API
-export([hello_world/1]).
-export([dodaj/2]).
-export([reverse/1]).

hello_world(Name) -> io:fwrite("helllo, ~s\n", [Name]).

dodaj(X, Y) ->
  X + Y.

reverse(List) ->
  reverse(List, []).

reverse([Head | Rest], Reversed) ->
  reverse(Rest, [Head | Reversed]);

reverse([], Reversed) ->
  Reversed.