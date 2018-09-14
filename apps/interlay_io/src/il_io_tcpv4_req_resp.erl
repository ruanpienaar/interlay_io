-module(il_io_tcpv4_req_resp).
-behaviour(eda_incomming_proto_cb).
-export([
    recv_data/3
]).

recv_data(Pid, _SocketOpts, Data) ->
    % timer:sleep(1000),
    io:format("recv_data Pid: ~p, Data: ~p~n", [Pid, Data]),
    % Queue Job
    {ok, WordNode} = application:get_env(interlay_io, work_node),
    %% TODO: rpc can be used, but we can also use nimby ....
    JobResponse = rpc:call(WordNode, queue_workers_ets_api, run_job, [example_ets_job_table, Data]),
    JobResponseBin = ens_bin(JobResponse),
    ok = gen_server:cast(Pid, {reply, JobResponseBin}),
    ok.

    % Reply with answer

ens_bin(V) when is_pid(V) ->
    list_to_binary(pid_to_list(V));
ens_bin(V) when is_atom(V) ->
    list_to_binary(atom_to_list(V));
ens_bin(V) when is_list(V) ->
    list_to_binary(V);
ens_bin(V) when is_binary(V) ->
    V;
ens_bin(V) when is_integer(V) ->
    list_to_binary(integer_to_list(V));
ens_bin(V) when is_tuple(V) ->
    ens_bin(io_lib:format("~p", [V])).