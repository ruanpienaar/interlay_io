-module(il_io_tcpv4).
-behaviour(eda_incomming_proto_cb).
-export([
    recv_data/3
]).

recv_data(Pid, _SocketOpts, Data) ->
    % timer:sleep(1000),
    io:format("recv_data Pid: ~p, Data: ~p~n", [Pid, Data]),
    % Queue Job
    {ok, WordNode} = application:get_env(interlay_io, work_node),
    rpc:call(WordNode, queue_workers_ets_api, queue_job, [example_ets_job_table, Data]),
    ok.