-module(result).
-export([main/0]).

main() ->
    FilePath = "1001.txt",
    FullPath = filename:absname_join(".", FilePath),
    case file:read_file(FullPath) of
        {ok, Content} ->
            process_content(Content);
        {error, Reason} ->
            io:format("Error reading file: ~p~n", [Reason])
    end.

process_content(Content) ->
    Lines = string:split(binary_to_list(Content), "\n"),
    NewLines = lists:map(fun remove_non_binary/1, Lines),
    NewContent = string:join(NewLines, "\n"),
    io:format("~s~n", [NewContent]).

remove_non_binary(Line) ->
    BinaryLine = lists:filter(fun is_binary_char/1, Line),
    lists:flatten(BinaryLine).

is_binary_char(Char) ->
    case Char of
        $0 -> true; $1 -> true; $2 -> true; $3 -> true; $4 -> true;
        $5 -> true; $6 -> true; $7 -> true; $8 -> true; $9 -> true;
        _ -> false
    end.
