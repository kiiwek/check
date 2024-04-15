-module(combined).
-export([main/0, test/0]).

-include_lib("eunit/include/eunit.hrl").

main() ->
    Result1 = check:test2(),
    Result2 = result:main(),
    {Result1, Result2}.

test() ->
    {Result1, Result2} = main(),
    ?assert(is_binary(Result1)),
    ?assert(is_binary(Result2)).
