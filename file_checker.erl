-module(file_checker).
-export([main/0]).

-define(FILE_NAMES, ["1001.txt", "1002a.txt"]).

main() ->
    lists:foreach(
        fun(FileName) ->
            case is_txt_file(FileName) of
                true ->
                    case separate_numeric_part(FileName) of
                        {ok, NumericPart} ->
                            case convert_to_binary(NumericPart) of
                                {ok, BinaryName} ->
                                    case is_binary(BinaryName) of
                                        true ->
                                            io:format("File ~s: là binary~n", [FileName]);
                                        false ->
                                            io:format("File ~s: không phải là binary~n", [FileName])
                                    end;
                                {error, Reason} ->
                                    io:format("File ~s: ~s~n", [FileName, Reason])
                            end;
                        {error, Reason} ->
                            io:format("File ~s: ~s~n", [FileName, Reason])
                    end;
                false ->
                    io:format("File ~s không phải là file .txt~n", [FileName])
            end
        end, ?FILE_NAMES
    ).

is_txt_file(FileName) ->
    case filename:extension(FileName) of
        {ok, ".txt"} -> true;
        _ -> false
    end.

separate_numeric_part(FileName) ->
    case string:to_integer(string:substr(filename:basename(FileName), 1, 4)) of
        {ok, NumericPart} -> {ok, NumericPart};
        _ -> {error, "Cannot extract numeric part"}
    end.

convert_to_binary(NumericPart) ->
    case is_integer(NumericPart) of
        true ->
            BinaryName = list_to_binary(integer_to_list(NumericPart)),
            {ok, BinaryName};
        false ->
            {ok, NumericPart}  % Return the name as it is
    end.
