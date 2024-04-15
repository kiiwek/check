% -module(file_checker_a).
% -export([main/0, extract_number/1, find_non_numeric_position/2, read_file_content/1]).

% main() ->
%     {ok, FileList} = file:list_dir("."), % Đọc danh sách các file trong thư mục hiện tại
%     process_files(FileList).

% process_files([]) -> % Nếu danh sách file rỗng, kết thúc.
%     ok;
% process_files([FileName | Rest]) ->
%     case filelib:is_regular(FileName) of
%         true ->
%             case extract_number(FileName) of
%                 {ok, NumberString} ->
%                     %% In ra kết quả
%                     io:format("Phần số từ chuỗi là: ~s~n", [NumberString]),
%                     %% Đọc nội dung của file và kiểm tra từng dòng
%                     read_file_content(FileName);
%                 {error, Reason} ->
%                     io:format("File ~s: ~s~n", [FileName, Reason])
%             end;
%         false ->
%             ok
%     end,
%     process_files(Rest). % Đệ quy để xử lý tiếp các file còn lại

% extract_number(FileName) ->
%     case find_non_numeric_position(FileName, 1) of
%         {ok, Position} ->
%             %% Trích xuất phần số từ đầu đến vị trí đó
%             NumberString = lists:sublist(FileName, Position - 1),
%             %% Kiểm tra xem phần số chỉ chứa ký tự số hay không
%             case lists:all(fun(C) -> C >= $0 andalso C =< $9 end, NumberString) of
%                 true ->
%                     {ok, NumberString};
%                 false ->
%                     {error, "Tên file chứa ký tự không phải số"}
%             end;
%         {error, Reason} ->
%             {error, Reason}
%     end.

% read_file_content(FileName) ->
%     {ok, IoDevice} = file:open(FileName, [read]),
%     read_lines(IoDevice),
%     file:close(IoDevice).

% read_lines(IoDevice) ->
%     case io:get_line(IoDevice, "") of
%         eof -> ok;
%         Line ->
%             case is_binary(Line) of
%                 true ->
%                     io:format("Dòng: ~s là binary~n", [Line]);
%                 false ->
%                     io:format("Dòng: ~s không phải là binary~n", [Line])
%             end,
%             read_lines(IoDevice)
%     end.

% find_non_numeric_position([Char | Rest], Index) when Char >= $0, Char =< $9 ->
%     find_non_numeric_position(Rest, Index + 1);
% find_non_numeric_position(_, Index) ->
%     {ok, Index}.
