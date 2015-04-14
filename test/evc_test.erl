%%%-------------------------------------------------------------------
%%% @author entity
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Jan 2015 13:44
%%%-------------------------------------------------------------------
-module(evc_test).
-author("entity").

-include_lib("eunit/include/eunit.hrl").

base_test() ->
    ?assertEqual(0, evc:get_counter(aaa, evc:new())),
    VC = evc:event(aaa, evc:new()),
    ?assertEqual(1, evc:get_counter(aaa, VC)).

merge_test() ->
    A = evc:new(a),
    B = evc:new(b),
    ?assertEqual(3, maps:size(evc:merge(A, B))),
    A2 = evc:event(a, A),
    M = evc:merge(A2, B),
    ?assertEqual(1, evc:get_counter(a, M)),
    C = evc:new(c),
    M2 = evc:merge(M, evc:event(c, C)),
    M2a = evc:event(a, M2),
    ?assertEqual(2, evc:get_counter(a, M2a)),
    ?assertEqual(1, evc:get_counter(c, M2a)).

older_test() ->
    A = evc:event(a, evc:new(a)),
    B = evc:event(b, evc:new(b)),
    M = evc:merge(A, B),
    ?assert(evc:descends(M, A)),
    C = evc:event(c, evc:new(c)),
    M2 = evc:merge(C, M),
    ?assert(evc:descends(M2, M)).

compare_test() ->
    M = evc:merge(evc:event(a, evc:new(a)), evc:event(b, evc:new(b))),
    A = evc:event(a, M),
    timer:sleep(10),
    B = evc:event(b, M),
    B2 = evc:event(b, B),
    ?assertNot(evc:descends(A, B)),
    ?assertNot(evc:descends(B, A)),
    ?assert(evc:compare(A, B)),
    timer:sleep(10),
    C = evc:event(c, evc:new(c)),
    C2 = evc:event(c, C),
    ?assertNot(evc:descends(A, C)),
    ?assertNot(evc:descends(C, A)),
    ?assertEqual([A, B, B2, C, C2], lists:sort(fun evc:compare/2, [C2, B, A, C, B2])).