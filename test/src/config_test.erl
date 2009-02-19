-module (config_test).

-include_lib("../include/eunit/include/eunit.hrl").

parse_test_() ->
	Config = [{pig, 1}, {cow, "betsy"}],
	[
		?_assert( 1 == config:parse(pig, Config) ),
		?_assert( "betsy" == config:parse(cow, Config) )
	].

update_test_() ->
	Config = [{pig, "bob"}, {cow, "betsy"}],
	[
		?_assert( [{cow, "betsy"},{pig, 10}] == config:update(pig, 10, Config) ),
		?_assert( [{pig, "bob"}, {cow, "betsy"}, {dave, "dave"}] == config:update(dave, "dave", Config) )
	].

delete_test_() ->
	Config = [{pig, "bob"}, {cow, "betsy"}],
  [
    ?_assert( [{pig, "bob"}] == config:delete(cow, Config) ),
		?_assert( Config == config:delete(bird, Config) )
  ].

append_test_() ->
	Config = [{pig, "bob"}, {cow, "betsy"}],
	Other = [{pig, "park"}],
  [
    ?_assert( [{cow, "betsy"}, {pig, "park"}] == config:append(Config, Other) ),
		?_assert( [{pig, "bob"}, {cow, "betsy"}, {bird, "ned"}] == config:append(Config, [{bird, "ned"}]) )
  ].

fetch_test_() ->
  [		
    ?_assert( [1,2] == config:fetch([pig, cow], [{pig, 1}, {cow, 2}, {horse, 3}]) ),
		?_assert( [1] == config:fetch([pig], [{pig, 1}, {cow, 2}, {horse, 3}]) ),
		?_assert( [1,3] == config:fetch([pig, donkey, horse], [{pig, 1}, {cow, 2}, {horse, 3}]) ),
		?_assert( [] == config:fetch([duck, goose], [{pig, 1}, {cow, 2}, {horse, 3}]) )
  ].

parse_or_default_test_() ->
  [
    ?_assert( 1 == config:parse_or_default(duck, [{duck, 1}, {cow, 2}], 4) ),
		?_assert( 4 == config:parse_or_default(hen, [{duck, 1}, {cow, 2}], 4) )
  ].

fetch_or_default_test_() ->
  [
    ?_assert( [1,2] == config:fetch_or_default([pig, cow], [{pig, 1}, {cow, 2}, {horse, 3}], ["hat", "box"])),
		?_assert( [1,2,"hat"] == config:fetch_or_default([pig, cow, bird], [{pig, 1}, {cow, 2}, {horse, 3}], ["hat", "box", "hat"]) ),
		?_assert( [1,2,undefined] == config:fetch_or_default([pig, cow, bird], [{pig, 1}, {cow, 2}, {horse, 3}], ["hat", "box"]) )
  ].

fetch_or_default_config_test_() ->
	DefaultConfig = [{bird, "frank"}, {dog, "joe"}, {cow, "patsy"}],
	Config = [{cow, "jerk"}],
	[
		?_assert( ["frank", "joe"] == config:fetch_or_default_config([bird, dog], Config, DefaultConfig) ),
		?_assert( ["frank", "jerk"] == config:fetch_or_default_config([bird, cow], Config, DefaultConfig) ),
		?_assert( [undefined, "jerk"] == config:fetch_or_default_config([penguin, cow], Config, DefaultConfig) )
	].