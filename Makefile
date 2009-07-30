VERSION					= 0.0.1
CC							= erlc
ERL							= erl
EBIN						= ebin
CFLAGS					= -I include -pa $(EBIN)
COMPILE					= $(CC) $(CFLAGS) -o $(EBIN)

all: ebin compile
compile:
	@$(ERL) -pa $(EBIN_DIRS) -noinput +B -eval 'case make:all() of up_to_date -> halt(0); error -> halt(1) end.'

ebin:
	@mkdir ebin

clean:
	rm -rf ebin/*.beam ebin/erl_crash.dump erl_crash.dump ebin/*.boot ebin/*.rel ebin/*.script 

clean_mochiweb:
	rm -rf deps/mochiweb/ebin/*.beam