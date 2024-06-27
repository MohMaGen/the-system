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


