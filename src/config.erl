-module (config).

%% API
-export([parse/2, update/3, delete/2, append/2, fetch/2, 
					parse_or_default/3, fetch_or_default/3, fetch_or_default_config/3]).

parse_or_default(Key, Config, Default) ->
	case parse(Key, Config) of
		{} -> Default;
		Val -> Val
	end.
	
parse(Key, Config) ->	get(Key, Config).

fetch_or_default_config(Keys, Config, DefaultConfig) ->
	fetch_or_default_config0(Keys, Config, DefaultConfig, []).

fetch_or_default_config0([], _, _, Acc) -> Acc;
fetch_or_default_config0([Key|Keys], Config, DefaultConfig, Acc) ->
	DefVal = parse_or_default(Key, DefaultConfig, undefined),
	Val = parse_or_default(Key, Config, DefVal),
	fetch_or_default_config0(Keys, Config, DefaultConfig, Acc ++ [Val]).

fetch_or_default(Keys, Config, Defaults) ->
	fetch_or_default0(Keys, Config, Defaults, []).

fetch_or_default0([], _, _, Acc) -> Acc;
fetch_or_default0([Key|Keys], Config, [], Acc) -> fetch_or_default0([Key|Keys], Config, [undefined], Acc);
fetch_or_default0([Key|Keys], Config, [KeyDefault|Defaults], Acc) ->
	Val = parse_or_default(Key, Config, KeyDefault),
	fetch_or_default0(Keys, Config, Defaults, Acc ++ [Val]).

fetch(Keys, Config) ->
	fetch0(Keys, Config, []).

fetch0([], _, Acc) -> Acc;
fetch0([Key|Keys], Config, Acc) ->
	NewAcc = case get(Key, Config) of
		{} -> Acc;
		Val -> Acc ++ [Val]
	end,
	fetch0(Keys, Config, NewAcc).

update(Key, Value, Config) ->
	NewConfig = [ T || T <- Config, element(1, T) =/= Key],
	lists:append(NewConfig, [{Key, Value}]).	
	
delete(Key, Config) ->
	[ T || T <- Config, element(1, T) =/= Key].

append(Config, Other) ->
	DFun = fun(Key, Value, Array) -> lists:append(delete(Key, Array), [{Key, Value}]) end,
	[NewConfig] = [ DFun(Key, Value, Config) || {Key, Value} <- Other ],
	NewConfig.

get(Key, Arr) ->
	Out = [ T || T <- Arr, element(1, T) =:= Key],
	case Out of
		[] ->
			{};
		[Val] ->
			element(2, Val);
		[_Val|Vals] ->
			get(Key, Vals)
	end.