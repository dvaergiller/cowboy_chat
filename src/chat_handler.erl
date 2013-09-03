-module(chat_handler).
-export([init/4, stream/3, info/3, terminate/2]).

init(_Transport, Req, _Opts, _Active) ->
    chat_server:connected(),
    {ok, Req, not_authenticated}.

stream(<<"ping">>, Req, State) ->
    io:format("got ping~n"),
    {ok, Req, State};
stream(Data, Req, State) ->
    chat_server:got_message(Data),
    {ok, Req, State}.

info(Message, Req, State) ->
    {reply, Message, Req, State}.

terminate(_Req, _State) ->
    chat_server:disconnected(),
    ok.
