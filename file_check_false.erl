-module(file_check_false).
-export([main/0, extract_number/1, find_non_numeric_position/2, is_valid_filename/1, process_files/1]).

main() ->
    {ok, FileList} = file:list_dir("."), % Đọc danh sách các file trong thư mục hiện tại
    TxtFiles = lists:filter(fun(F) -> is_txt_file(F) end, FileList), % Lọc các file với đuôi .txt
    process_files(TxtFiles).

process_files([]) ->
    ok;
process_files([FileName | Rest]) ->
    io:format("~nKiểm tra file ~s:~n", [FileName]),
    case is_valid_filename(FileName) of
        true ->
            io:format("File hợp lệ.~n"),
            case extract_number(FileName) of
                {ok, NumberString} ->
                    io:format("Phần số từ chuỗi là: ~s~n", [NumberString]);
                {error, Reason} ->
                    io:format("Lỗi khi trích xuất phần số: ~s~n", [Reason])
            end;
        false ->
            io:format("File không hợp lệ.~n")
    end,
    process_files(Rest).

extract_number(FileName) ->
    case find_non_numeric_position(FileName, 1) of
        {ok, Position} ->
            %% Trích xuất phần số từ đầu đến vị trí đó
            NumberString = lists:sublist(FileName, Position - 1),
            %% Kiểm tra xem phần số chỉ chứa ký tự số hay không
            case lists:all(fun(C) -> C >= $0 andalso C =< $9 end, NumberString) of
                true ->
                    {ok, NumberString};
                false ->
                    {error, "Tên file chứa ký tự không phải số"}
            end;
        {error, Reason} ->
            {error, Reason}
    end.

find_non_numeric_position([Char | Rest], Index) when Char >= $0, Char =< $9 ->
    find_non_numeric_position(Rest, Index + 1);
find_non_numeric_position(_, Index) ->
    {ok, Index}.

is_valid_filename(FileName) ->
    lists:all(fun(C) -> C >= $0 andalso C =< $9 end, FileName).

is_txt_file(FileName) ->
    case filename:extension(FileName) of
        {ok, Extension} -> Extension == ".txt";
        _ -> false
    end.
