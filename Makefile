NAME := the-system


CCWARNINGS := -Wall -Werror -pedantic -pedantic-errors
CCDEBUG := -g -v
CCRELEASE := -O3

TARGET_DIR := target/


mk_dirs:
	bash ./mk_dirs.sh

build-debug: mk_dirs the-system-debug the-system-cli-debug

build-release: mk_dirs the-system-release the-system-cli-release


#       _   _ _
# _   _| |_(_) |___
#| | | | __| | / __|
#| |_| | |_| | \__ \
# \__,_|\__|_|_|___/
#
# jump utils
UTILS_SOURCE_DIR := utils/
UTILS_BUILD_DIR := $(TARGET_DIR)utils/
UTILS_SOURCES := $(wildcard $(UTILS_SOURCE_DIR)*.c)
UTILS_DEBUG_OBJECTS := $(patsubst $(UTILS_SOURCE_DIR)%.c,$(UTILS_BUILD_DIR)debug/%.o,$(UTILS_SOURCES))
UTILS_RELEASE_OBJECTS := $(patsubst $(UTILS_SOURCE_DIR)%.c,$(UTILS_BUILD_DIR)release/%.o,$(UTILS_SOURCES))
UTILS_LD_FLAGS :=
UTILS_DEBUG_LD_FLAGS := $(UTILS_LD_FLAGS)
UTILS_DEBUG_FLAGS := $(CCWARNINGS) $(CCDEBUG) -I $(UTILS_INCLUDE)
UTILS_DEBUG = $(UTILS_BUILD_DIR)debug/utils.a
UTILS_RELEASE = $(UTILS_BUILD_DIR)release/utils.a
UTILS_INCLUDE = $(UTILS_SOURCE_DIR)inc/

utils-debug: $(UTILS_DEBUG_OBJECTS)
	$(AR) rcs $(UTILS_DEBUG) $(UTILS_DEBUG_OBJECTS)

utils-release: $(UTILS_RELEASE_OBJECTS)
	$(AR) rcs $(UTILS_RELEASE) $(UTILS_RELEASE_OBJECTS)

$(UTILS_DEBUG_OBJECTS): $(UTILS_BUILD_DIR)debug/%.o: $(UTILS_SOURCE_DIR)%.c
	$(CC) -o $@ -c $< $(CCWARNINGS) $(CCDEBUG) $(UTILS_LD_FLAGS) -I $(UTILS_INCLUDE)

$(UTILS_RELEASE_OBJECTS): $(UTILS_BUILD_DIR)release/%.o: $(UTILS_SOURCE_DIR)%.c
	$(CC) -o $@ -c $< $(CCWARNINGS) $(CCRELEASE) $(UTILS_LD_FLAGS) -I $(UTILS_INCLUDE)


#  _   _                              _                            _ _
# | |_| |__   ___       ___ _   _ ___| |_ ___ _ __ ___         ___| (_)
# | __| '_ \ / _ \_____/ __| | | / __| __/ _ \ '_ ` _ \ _____ / __| | |
# | |_| | | |  __/_____\__ \ |_| \__ \ ||  __/ | | | | |_____| (__| | |
#  \__|_| |_|\___|     |___/\__, |___/\__\___|_| |_| |_|      \___|_|_| |___/
# jump the system cli
THESYSTEM_CLI_SOURCE_DIR := the-system-cli/
THESYSTEM_CLI_BUILD_DIR := $(TARGET_DIR)the-system-cli/
THESYSTEM_CLI_SOURCES := $(wildcard $(THESYSTEM_CLI_SOURCE_DIR)*.c)
THESYSTEM_CLI_DEBUG_OBJECTS := $(patsubst $(THESYSTEM_CLI_SOURCE_DIR)%.c,$(THESYSTEM_CLI_BUILD_DIR)debug/%.o,$(THESYSTEM_CLI_SOURCES))
THESYSTEM_CLI_RELEASE_OBJECTS := $(patsubst $(THESYSTEM_CLI_SOURCE_DIR)%.c,$(THESYSTEM_CLI_BUILD_DIR)release/%.o,$(THESYSTEM_CLI_SOURCES))
THESYSTEM_CLI_LD_FLAGS := -lutils
THESYSTEM_CLI_DEBUG_LD_FLAGS := -L./$(THESYSTEM_CLI_BUILD_DIR)debug/ $(THESYSTEM_CLI_LD_FLAGS)
THESYSTEM_CLI_RELEASE_LD_FLAGS := -L./$(THESYSTEM_CLI_BUILD_DIR)release/ $(THESYSTEM_CLI_LD_FLAGS)
THESYSTEM_CLI_INCLUDE_FLAGS := -I $(UTILS_INCLUDE)
THESYSTEM_CLI_DEBUG_FLAGS = $(CCWARNINGS) $(CCDEBUG) $(THESYSTEM_CLI_INCLUDE_FLAGS)
THESYSTEM_CLI_RELEASE_FLAGS = $(CCWARNINGS) $(CCRELEASE)  $(THESYSTEM_CLI_INCLUDE_FLAGS)

the-system-cli-run: the-system-cli-debug
	$(THESYSTEM_CLI_BUILD_DIR)debug/the-system

the-system-cli-gdb: the-system-cli-debug
	gdb $(THESYSTEM_CLI_BUILD_DIR)debug/the-system

the-system-cli-debug: link-the-system-cli-libs-debug utils-debug $(THESYSTEM_CLI_DEBUG_OBJECTS)
	$(CC) -o $(THESYSTEM_CLI_BUILD_DIR)debug/the-system $(THESYSTEM_CLI_DEBUG_OBJECTS) $(THESYSTEM_CLI_DEBUG_FLAGS) $(THESYSTEM_CLI_DEBUG_LD_FLAGS)

the-system-cli-release: link-the-system-cli-libs-release utils-release $(THESYSTEM_CLI_RELEASE_OBJECTS)
	$(CC) -o $(THESYSTEM_CLI_BUILD_DIR)release/the-system $(THESYSTEM_CLI_RELEASE_OBJECTS) $(THESYSTEM_CLI_RELEASE_FLAGS) $(THESYSTEM_CLI_RELEASE_LD_FLAGS)

$(THESYSTEM_CLI_DEBUG_OBJECTS): $(THESYSTEM_CLI_BUILD_DIR)debug/%.o: $(THESYSTEM_CLI_SOURCE_DIR)%.c
	$(CC) -o $@ -c $< $(THESYSTEM_CLI_DEBUG_FLAGS)

$(THESYSTEM_CLI_RELEASE_OBJECTS): $(THESYSTEM_CLI_BUILD_DIR)release/%.o: $(THESYSTEM_CLI_SOURCE_DIR)%.c
	$(CC) -o $@ -c $< $(THESYSTEM_CLI_DEBUG_FLAGS)

link-the-system-cli-libs-debug:
	ln -f $(UTILS_DEBUG) $(THESYSTEM_CLI_BUILD_DIR)debug/libutils.a

link-the-system-cli-libs-release:
	ln -f $(UTILS_RELEASE) $(THESYSTEM_CLI_BUILD_DIR)release/libutils.a

#  _   _                              _
# | |_| |__   ___       ___ _   _ ___| |_ ___ _ __ ___
# | __| '_ \ / _ \_____/ __| | | / __| __/ _ \ '_ ` _ \
# | |_| | | |  __/_____\__ \ |_| \__ \ ||  __/ | | | | |
#  \__|_| |_|\___|     |___/\__, |___/\__\___|_| |_| |_|
#                           |___/
# jump the system
THESYSTEM_SOURCE_DIR := the-system/
THESYSTEM_BUILD_DIR := $(TARGET_DIR)the-system/
THESYSTEM_SOURCES := $(wildcard $(THESYSTEM_SOURCE_DIR)*.c)
THESYSTEM_DEBUG_OBJECTS := $(patsubst $(THESYSTEM_SOURCE_DIR)%.c,$(THESYSTEM_BUILD_DIR)debug/%.o,$(THESYSTEM_SOURCES))
THESYSTEM_RELEASE_OBJECTS := $(patsubst $(THESYSTEM_SOURCE_DIR)%.c,$(THESYSTEM_BUILD_DIR)release/%.o,$(THESYSTEM_SOURCES))
THESYSTEM_LD_FLAGS := -lutils
THESYSTEM_DEBUG_LD_FLAGS := -L./$(THESYSTEM_BUILD_DIR)debug/ $(THESYSTEM_LD_FLAGS)
THESYSTEM_RELEASE_LD_FLAGS := -L./$(THESYSTEM_BUILD_DIR)release/ $(THESYSTEM_LD_FLAGS)
THESYSTEM_INCLUDE_FLAGS := -I./$(UTILS_INCLUDE)
THESYSTEM_DEBUG_FLAGS = $(CCWARNINGS) $(CCDEBUG) $(THESYSTEM_INCLUDE_FLAGS)
THESYSTEM_RELEASE_FLAGS = $(CCWARNINGS) $(CCRELEASE)  $(THESYSTEM_INCLUDE_FLAGS)

the-system-run: the-system-debug
	$(THESYSTEM_BUILD_DIR)debug/the-system

the-system-gdb: the-system-debug
	gdb $(THESYSTEM_BUILD_DIR)debug/the-system

the-system-debug: utils-debug link-the-system-libs-debug $(THESYSTEM_DEBUG_OBJECTS)
	$(CC) -o $(THESYSTEM_BUILD_DIR)debug/the-system $(THESYSTEM_DEBUG_OBJECTS) $(THESYSTEM_DEBUG_FLAGS) $(THESYSTEM_DEBUG_LD_FLAGS)

the-system-release: utils-release link-the-system-libs-release $(THESYSTEM_RELEASE_OBJECTS)
	$(CC) -o $(THESYSTEM_BUILD_DIR)release/the-system $(THESYSTEM_RELEASE_OBJECTS) $(THESYSTEM_RELEASE_FLAGS) $(THESYSTEM_RELEASE_LD_FLAGS)

$(THESYSTEM_DEBUG_OBJECTS): $(THESYSTEM_BUILD_DIR)debug/%.o: $(THESYSTEM_SOURCE_DIR)%.c
	$(CC) -o $@ -c $< $(THESYSTEM_DEBUG_FLAGS)

$(THESYSTEM_RELEASE_OBJECTS): $(THESYSTEM_BUILD_DIR)release/%.o: $(THESYSTEM_SOURCE_DIR)%.c
	$(CC) -o $@ -c $< $(THESYSTEM_RELEASE_FLAGS)

link-the-system-libs-debug:
	ln -f $(UTILS_DEBUG) $(THESYSTEM_BUILD_DIR)debug/libutils.a

link-the-system-libs-release:
	ln -f $(UTILS_RELEASE) $(THESYSTEM_BUILD_DIR)release/libutils.a



#                            _ _
#   ___ ___  _ __ ___  _ __ (_) | ___     ___ ___  _ __ ___  _ __ ___   __ _ 
#  / __/ _ \| '_ ` _ \| '_ \| | |/ _ \   / __/ _ \| '_ ` _ \| '_ ` _ \ / _` |
# | (_| (_) | | | | | | |_) | | |  __/  | (_| (_) | | | | | | | | | | | (_| |
#  \___\___/|_| |_| |_| .__/|_|_|\___|___\___\___/|_| |_| |_|_| |_| |_|\__,_|
#                     |_|           |_____|
#            _        _
#  _ __   __| |___   (_)___  ___  _ __
# | '_ \ / _` / __|  | / __|/ _ \| '_ \
# | | | | (_| \__ \_ | \__ \ (_) | | | |
# |_| |_|\__,_|___(_)/ |___/\___/|_| |_|
#                   |__/

COMPILE_COMMANDS_THESYSTEM_S = $(THESYSTEM_DEBUG_OBJECTS)
COMPILE_COMMANDS_THESYSTEM = $(patsubst $(THESYSTEM_BUILD_DIR)debug/%.o, CC_THESYSTEM_%.o, $(COMPILE_COMMANDS_THESYSTEM_S))

COMPILE_COMMANDS_THESYSTEM_CLI_S = $(THESYSTEM_CLI_DEBUG_OBJECTS)
COMPILE_COMMANDS_THESYSTEM_CLI = $(patsubst $(THESYSTEM_CLI_BUILD_DIR)debug/%.o, CC_THESYSTEM_CLI_%.o, $(COMPILE_COMMANDS_THESYSTEM_CLI_S))

COMPILE_COMMANDS_UTILS_S = $(UTILS_DEBUG_OBJECTS)
COMPILE_COMMANDS_UTILS = $(patsubst $(UTILS_BUILD_DIR)debug/%.o, CC_UTILS_%.o, $(COMPILE_COMMANDS_UTILS_S))

compile-commands.json: reset-compile-commands.json $(COMPILE_COMMANDS_THESYSTEM) $(COMPILE_COMMANDS_THESYSTEM_CLI) $(COMPILE_COMMANDS_UTILS)
	cat ./compile_commands.json | head -n -1 > tmp.json; mv tmp.json ./compile_commands.json
	echo "  }" >> ./compile_commands.json
	echo "]" >> ./compile_commands.json
	@echo "done compile commands"

reset-compile-commands.json:
	echo "[" > ./compile_commands.json

$(COMPILE_COMMANDS_THESYSTEM): CC_THESYSTEM_%.o: $(THESYSTEM_BUILD_DIR)debug/%.o
	bash ./push_comile_commands_obj.sh $< $(THESYSTEM_DEBUG_FLAGS) $(THESYSTEM_DEBUG_LD_FLAGS)

$(COMPILE_COMMANDS_THESYSTEM_CLI): CC_THESYSTEM_CLI_%.o: $(THESYSTEM_CLI_BUILD_DIR)debug/%.o
	bash ./push_comile_commands_obj.sh $< $(THESYSTEM_CLI_DEBUG_FLAGS) $(THESYSTEM_CLI_DEBUG_LD_FLAGS)

$(COMPILE_COMMANDS_UTILS): CC_UTILS_%.o: $(UTILS_BUILD_DIR)debug/%.o
	bash ./push_comile_commands_obj.sh $< $(UTILS_DEBUG_FLAGS) $(UTILS_DEBUG_LD_FLAGS)
