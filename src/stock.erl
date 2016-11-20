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
-export([start/0, send_order/2, exchange/0, db_execute/0, init/0, test_start/0, dispatcher/1]).
-include_lib("odbc/include/odbc.hrl").
-define('CONNECTION_STRING', "DRIVER=PostgreSQL;Servername=192.168.0.50;PORT=5432;Database=tommy").


send_order(Where, Order) ->
  Where ! Order.

buy({Customer, Symbol, Quant, Price}) ->
  io:format("got buy data ~s|~s|~p|~p~n", [Customer, Symbol, Quant, Price]),

  Command1 = io_lib:format(
    "SELECT * FROM sell where price < ~p order by price desc limit 1; "
    "DELETE FROM sell WHERE CUSTOMER IN ("
    "SELECT CUSTOMER FROM sell where price < ~p order by price desc limit 1);",
    [Price, Price]),
  Command2 = io_lib:format("INSERT INTO buy VALUES ('~s', '~s', ~w, ~w);", [Customer, Symbol, Quant, Price]),

  db ! {Command1, Command2},
  ok.

sell({Customer, Symbol, Quant, Price}) ->
  io:format("got sell data ~s|~s|~p|~p~n", [Customer, Symbol, Quant, Price]),

  Command1 = io_lib:format("SELECT * FROM buy where price > ~p order by price asc limit 1; "
    "DELETE FROM buy WHERE CUSTOMER IN "
    "(SELECT CUSTOMER FROM buy where price > ~p order by price asc limit 1);",
    [Price, Price]),
  Command2 = io_lib:format("INSERT INTO sell VALUES('~s', '~s', ~w, ~w);", [Customer, Symbol, Quant, Price]),


  db ! {Command1, Command2},
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

dispatcher(Ans) ->
  case lists:last(Ans) of
    {updated, 1} ->
      io:format("Case updated ~n", []);
    {error, Message} ->
      io:format("Case error ~s~n", [Message]),
      error;
    {selected, _, [{Customer, Symbol, Quant, Price}]} ->
      io:format("Order was realised: ~s, ~s, ~w, ~w ~n", [Customer, Symbol, Quant, Price]),
      error;
    [{selected, _, [{Customer, Symbol, Quant, Price}]}|_] ->
      io:format("Order was realised: ~s, ~s, ~w, ~w ~n", [Customer, Symbol, Quant, Price]),
      error;
    Any ->
      io:format("ans: ~w~n", [Ans]),
      error
  end.

db_execute() ->
  Connection = connect(),
  receive
    {Command1, Command2} ->
      io:format("Got cmd in db execute: ~s~n", [Command1]),
      Ans = odbc:sql_query(Connection, Command1),

      Got = dispatcher(Ans),
      io:format("Got from dispatcher: ~w~n", [Got]),
      case Got of
        error ->
          io:format("Executing second command~n", []),
          Ans2 = odbc:sql_query(Connection, Command2),
          io:format("Ans2: ~w~n", [Ans2]);
        Any -> ok
      end,
      db_execute()
  end.

connect() ->
  {ok, Conn} = odbc:connect(?CONNECTION_STRING, []),
  Conn.

send_orders(Pid) ->
  % testing function, TO DO: move to tests
  stock:send_order(Pid, {buy, {"Tomek", "TSL", 100, 20}}),
  stock:send_order(Pid, {buy, {"Romek", "TSL", 100, 21}}),
  stock:send_order(Pid, {sell, {"Andrew", "TSL", 5, 19}}),
  %
  stock:send_order(Pid, {sell, {"Andy", "TSL", 50, 24}}),
  receive
    after (1000 * 5) -> ok
  end.

init() ->
  odbc:start(),
  db_execute().

start() ->
  register(db, spawn(stock, init, [])),
  % Pid = spawn(stock, exchange, []).
  exchange().

test_start() ->
  Pid = spawn(stock, start, []),
  send_orders(Pid).
