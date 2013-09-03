-module(chat_server).

-behaviour(gen_server).

-export([start_link/0, connected/0, disconnected/0, got_message/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

%% API

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

connected() ->
    gen_server:call(?MODULE, connected).

disconnected() ->
    gen_server:call(?MODULE, disconnected).

got_message(Message) ->
    gen_server:call(?MODULE, {message, Message}).

%% gen_server callbacks

init(_) ->
    {ok, []}.

handle_call({message, Message}, _Sender, Users) ->
    lists:foreach(fun(U) -> U ! Message end, Users),
    {reply, ok, Users};
handle_call(connected, {Sender, _Tag}, Users) ->
    {reply, ok, [Sender|Users]};
handle_call(disconnected, {Sender, _Tag}, Users) ->
    {reply, ok, [ U || U <- Users, U /= Sender]}.

handle_cast(_, Users) ->
    {noreply, Users}.

handle_info(_, Users) ->
    {noreply, Users}.

terminate(_, _) ->
    ok.

code_change(_, Users, _) ->
    {ok, Users}.
