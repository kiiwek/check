-module(file_operations).
-export([process_file/1]).

process_file(FileName) ->
    case check_file_extension(FileName) of
        {ok, Prefix} ->
            case contains_only_digits(Prefix) of
                true ->
                    {ok, binary_conversion(Prefix)};
                false ->
                    {error, "File name contains non-numeric characters"}
            end;
        {error, Reason} ->
            {error, Reason}
    end.

check_file_extension(FileName) ->
    case filename:extension(FileName) of
        ".txt" ->
            {ok, filename:rootname(FileName)};
        _ ->
            {error, "File extension is not .txt"}
    end.

contains_only_digits(String) ->
    lists:all(fun is_digit/1, String).

is_digit(Char) ->
    Char >= $0 andalso Char =< $9.

binary_conversion(String) ->
    list_to_binary(String).
