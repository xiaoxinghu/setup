CONFIG_FILES = macos.org fish.org bash.org spacemacs.org javascript.org tmux.org vim.org
SCRIPT_FILES = macos.org fish.org
TANGLE=./.dist/bin/tangle.el
RUN=./.dist/bin/run.el
LINK=./.dist/bin/link.rb

all: bootstrap

update: $(CONFIG_FILES)
	@$(TANGLE) $^
	@$(LINK)

bootstrap: $(SCRIPT_FILES)
	@$(RUN) $^
	@$(LINK)

clean:
	@rm -rf .dist/src
