.PHONY: all build test package clean

LUA_SRC := src/lua
BUILD_DIR := build
LOVE_FILE := $(BUILD_DIR)/game.love
PACKAGE_DIR := $(BUILD_DIR)/package
RUNTIME_WIN32 := buildmaterial/lovewin32
RUNTIME_WIN64 := buildmaterial/lovewin64

all: build test package

build:
	@mkdir -p $(BUILD_DIR)
	@echo "Packaging Lua sources from $(LUA_SRC)"
	@cd $(LUA_SRC) && zip -r ../game.love .
	@mv $(LUA_SRC)/../game.love $(LOVE_FILE)

# Placeholder for tests

test:
	@echo "No tests defined"

package: build
	@rm -rf $(PACKAGE_DIR)
	@mkdir -p $(PACKAGE_DIR)
	@cp $(LOVE_FILE) $(PACKAGE_DIR)/
	@if [ -d $(RUNTIME_WIN32) ]; then \
	  cp -r $(RUNTIME_WIN32)/* $(PACKAGE_DIR)/; \
	fi
	@if [ -d $(RUNTIME_WIN64) ]; then \
	  cp -r $(RUNTIME_WIN64)/* $(PACKAGE_DIR)/; \
	fi
	@if [ -f $(PACKAGE_DIR)/love.exe ]; then \
	  cat $(PACKAGE_DIR)/love.exe $(PACKAGE_DIR)/game.love > $(PACKAGE_DIR)/tm.exe; \
	  rm $(PACKAGE_DIR)/love.exe; \
	fi
	@zip -r $(BUILD_DIR)/tm.zip $(PACKAGE_DIR)

clean:
	@rm -rf $(BUILD_DIR)
