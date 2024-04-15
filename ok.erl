% -module(combined).
% -export([main/0, test/0]).

% -include_lib("eunit/include/eunit.hrl").

% main() ->
%     {Result1, Result2} = check:test2(),
%     io:format("Result of FILE_1: ~p~n", [Result1]),
%     io:format("Result of FILE_2: ~p~n", [Result2]).

% test() ->
%     {Result1, Result2} = main(),
%     ?assert(is_binary(Result1)),
%     ?assert(is_binary(Result2)).


-module(ok).
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
    case is_number(Callee) of
        true -> [Caller, list_to_binary(Callee)];
        false -> [Caller, invalid_value]
    end.

is_number(String) ->
    case string:to_integer(String) of
        {ok, _} -> true;
        _ -> false
    end.

remove_not_applicable(List) -> lists:filter(fun([_, Callee]) -> is_binary(Callee) end, List).

convert_list2bin(List) -> lists:map(fun(X) -> list_to_binary(X) end, List).

test2() ->
    ?assert(is_binary(test2(?FILE_1))),
    ?assert(is_binary(test2(?FILE_2))).

test2(FileName) ->
    Content = readlines(FileName),
    Processed = process(Content),
    Clean = remove_not_applicable(Processed),
    Converted = convert_list2bin(Clean),
    lists:nth(1, Converted). % Trả về phần tử đầu tiên của danh sách, vì chỉ có một phần tử

test() ->
    ?assert(is_binary_list(test2(?FILE_1))),
    ?assert(is_binary_list(test2(?FILE_2))).

is_binary_list(Binary) ->
    is_binary(Binary).

is_binary(Binary) ->
    is_binary(Binary, 1).

is_binary(_, _) -> true;
is_binary(<<_:1/binary>>, _) -> true;
is_binary(_, _) -> false.
