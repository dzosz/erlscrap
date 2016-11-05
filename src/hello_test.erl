%%%-------------------------------------------------------------------
%%% @author tommy
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Nov 2016 22:12
%%%-------------------------------------------------------------------
-module(hello_test).
-author("tommy").

-include_lib("eunit/include/eunit.hrl").

simple_test() ->
  ?assert(true).

dodaj_test() ->
  ?assertEqual(5+5, hello:dodaj(5, 5)).

reverse1_test() ->
  ?assertEqual([3,2,1], hello:reverse([1,2,3])).

reverse2_test() ->
  ?assertEqual([], hello:reverse([])).

reverse3_test() ->
  ?assertEqual([1,2], hello:reverse([2,1])).