%%%-------------------------------------------------------------------
%%% @author tommy
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Nov 2016 00:15
%%%-------------------------------------------------------------------
-module(stock_bootstrap).
-author("tommy").

%% API
-export([start/0]).
-include_lib("odbc/include/odbc.hrl").

start() ->
  % odbc:start(),
  % application:load(stock),
  application:start(stock).

