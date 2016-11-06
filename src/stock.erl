%%%-------------------------------------------------------------------
%%% @author tommy
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Nov 2016 12:08
%%%-------------------------------------------------------------------
-module(stock).
-author("tommy").

%% API
-export([run/0, send_order/2, exchange/0]).

send_order(Where, Order) ->
  Where ! Order.

buy({From, Symbol, Quant, Price}) ->
  % internal routing for buy
  io:format("got buy data ~s|~s|~p|~p~n", [From, Symbol, Quant, Price]),
  % check if can execute, if not add to waiting list
  ok.

sell({From, Symbol, Quant, Price}) ->
  % internal routing for sell
  io:format("got sell data ~s|~s|~p|~p~n", [From, Symbol, Quant, Price]),
  % check if can execute, if not add to waiting list
  ok.

exchange() ->
  % routes orders indefinitely
  receive
    {buy, Order} ->
      buy(Order);
    {sell, Order} ->
      sell(Order)
  end,
  exchange().

run() ->
  % testing function, TO DO: move to tests
  Pid = spawn(stock, exchange, []),
  stock:send_order(Pid, {sell, {"Andrew", "TSL", 5, 15}}),
  stock:send_order(Pid, {buy, {"Tomek", "TSL", 100, 20}}),
  stock:send_order(Pid, {sell, {"Tomek", "TSL", 50, 25}}).
