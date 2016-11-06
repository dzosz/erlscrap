%%%-------------------------------------------------------------------
%%% @author tommy
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Nov 2016 12:53
%%%-------------------------------------------------------------------
-module(stock_test).
-author("tommy").

-include_lib("eunit/include/eunit.hrl").

run_stock_test() ->
  Pid = spawn(stock, exchange, []),
  stock:send_order(Pid, {buy, {"Robert", "TSL", 100}}),
  % to do, verify this order was added to pool of orders
  ?assert(true).

