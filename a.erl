-module(a).
-export([main/1]).

main(FileName) ->
    %% Tách phần số từ tên file
    NumberString = extract_number(FileName),
    
    %% In ra kết quả
    io:format("Phần số từ chuỗi là: ~s~n", [NumberString]).

extract_number(FileName) ->
    %% Tìm vị trí đầu tiên của ký tự không phải số
    Position = find_non_numeric_position(FileName, 1),
    %% Trích xuất phần số từ đầu đến vị trí đó
    lists:sublist(FileName, Position - 1).

find_non_numeric_position([Char | Rest], Index) when Char >= $0, Char =< $9 ->
    find_non_numeric_position(Rest, Index + 1);
find_non_numeric_position(_, Index) ->
    Index.
