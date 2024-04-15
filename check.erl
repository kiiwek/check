-module(check).
-include_lib("eunit/include/eunit.hrl").
-export([readlines/1, process/1, remove_not_applicable/1, convert_list2bin/1, test2/0]).

-define(FILE_1, "1001.txt").
-define(FILE_2, "1002a.txt").

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try get_list(Device)
      after file:close(Device)
    end.

get_list(Device) -> get_all_lines(Device, []).

get_all_lines(Device, Acc) ->
    Temp = io:get_line(Device, ""),
    case Temp of
        eof  -> Acc;
        _ -> get_all_lines(Device, Acc ++ [Temp])
    end.

process(Content) ->
    lists:map(fun(Func) -> func2(Func) end, Content).

func2(Line) ->
    [Caller, Callee] = string:tokens(Line, "\t"),
    case is_binary(Callee) of
        true -> [Caller, binary_to_list(Callee)];
        false -> [Caller, Callee]
    end.

remove_not_applicable(List) -> lists:filter(fun([_, Callee]) -> is_binary(Callee) end, List).

convert_list2bin(List) -> lists:map(fun(X) -> list_to_binary(X) end, List).

test2() ->
    ?assertEqual([<<"1002">>], test2(?FILE_1)),
    ?assertEqual([<<"1002">>], test2(?FILE_2)).

test2(FileName) ->
    Content = readlines(FileName),
    Processed = process(Content),
    Clean = remove_not_applicable(Processed),
    convert_list2bin(Clean).
