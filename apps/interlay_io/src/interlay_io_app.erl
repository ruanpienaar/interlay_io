-module(interlay_io_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-include("interlay_io.hrl").

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    true = net_kernel:connect('il_work@localhost'),
    interlay_io_sup:start_link().

stop(_State) ->
    ok.
