%% General timeout value.
-define(TIMEOUT, 100000).

%% Application information.
-define(APP, lasp).

%% Peer service port.
-define(PEER_PORT, 9000).

%% Code which connects the storage backends to the implementation.
-define(CORE, lasp_core).

%% Default set implementation for Lasp internal state tracking.
-define(SET, orset).

-record(read, {id :: id(),
               type :: type(),
               value :: value(),
               read_fun :: function()}).

-record(dv, {value :: value(),
             waiting_delta_threads = [] :: list(pending_threshold()),
             waiting_threads = [] :: list(pending_threshold()),
             lazy_threads = [] :: list(pending_threshold()),
             type :: type(),
             metadata :: metadata(),
             delta_counter :: non_neg_integer(),
             delta_map :: orddict:orddict(),
             delta_ack_map :: orddict:orddict(),
             delta_eager_map = [] :: list(crdt())}).

-type variable() :: #dv{}.

%% @doc Generate a request id.
-define(REQID(), erlang:phash2(erlang:now())).

%% @doc Wait for a response.
%%
%%      Helper function; given a `ReqId', wait for a message within
%%      `Timeout' seconds and return the result.
%%
-define(WAIT(ReqId, Timeout),
        receive
            {ReqId, ok} ->
                ok;
            {ReqId, ok, Val} ->
                {ok, Val}
        after Timeout ->
            {error, timeout}
        end).

%% @doc Garbage collection will happen after the certain number
%%      (MAX_GC_COUNTER) of times of exchanges.
-define(MAX_GC_COUNTER, 7).

%% General types.
-type file() :: iolist().
-type registration() :: preflist | global.
-type id() :: binary() | {binary(), type()}.
-type idx() :: term().
-type not_found() :: {error, not_found}.
-type result() :: term().
-type type() :: term().
-type value() :: term().
-type func() :: atom().
-type args() :: list().
-type bound() :: true | false.
-type supervisor() :: pid().
-type stream() :: list(#dv{}).
-type store() :: ets:tid() | atom() | reference() | pid().
-type threshold() :: value() | {strict, value()}.
-type pending_threshold() :: {threshold, read | wait, pid(), type(), threshold()}.
-type operation() :: {atom(), value()} | {atom(), value(), value()} | atom().
-type operations() :: list(operation()).
-type actor() :: term().
-type error() :: {error, atom()}.
-type metadata() :: orddict:orddict().

%% @doc Result of a read operation.
-type var() :: {id(), type(), metadata(), value()}.

%% @doc Only CRDTs are able to be processed.
-type crdt() :: type:crdt().

%% @doc Output of program must be a CRDT.
-type output() :: crdt().

%% @doc Any state that needs to be tracked from one execution to the
%%      next execution.
-type state() :: term().

%% @doc The type of objects that we can be notified about.
-type object() :: crdt().

%% Test identifiers.
-define(ADS, {<<"ads">>, ?SET_TYPE}).
-define(CONTRACTS, {<<"contracts">>, ?SET_TYPE}).
-define(ADS_CONTRACTS, {<<"ads_contracts">>, ?SET_TYPE}).
-define(ADS_WITH_CONTRACTS, {<<"ads_with_contracts">>, ?SET_TYPE}).
-define(BOOLEAN_TYPE, boolean).
-define(COUNTER_TYPE, gcounter).
-define(GMAP_TYPE, gmap).
-define(SET_TYPE, lasp_config:get(set, orset)).
-define(PAIR_TYPE, pair).

%% Simulation status tracking code.
-define(SIM_STATUS_TRACKING, <<"status_tracking">>).

-define(SIM_STATUS_STRUCTURE,
        {?GMAP_TYPE, [
            {?PAIR_TYPE, [
                ?BOOLEAN_TYPE, %% observed ads disabled
                ?BOOLEAN_TYPE  %% logs pushed
            ]}
        ]}).

-define(SIM_STATUS_ID,
        {?SIM_STATUS_TRACKING, ?SIM_STATUS_STRUCTURE}).

%% Simulation helpers.
-define(AAE_INTERVAL, 10000).
-define(IMPRESSION_INTERVAL, 500).
-define(STATUS_INTERVAL, 1000).
-define(EVAL_NUMBER, 1).
-define(MAX_IMPRESSIONS, 50).
-define(LOG_INTERVAL, 10000).
-define(VOTING_INTERVAL, 1000).
-define(ADS_NUMBER, 5).

-define(DEFAULT_DISTRIBUTION_BACKEND, lasp_default_broadcast_distribution_backend).

%% Lexer and parser.
-define(SQL_LEXER, lasp_sql_lexer).
-define(SQL_PARSER, lasp_sql_parser).

-record(ad, {id, name, image, counter}).
-record(contract, {id}).
