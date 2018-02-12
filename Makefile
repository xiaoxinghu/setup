ORG_FILES = fish.org bash.org spacemacs.org javascript.org tmux.org vim.org
TANGLE=./.dist/bin/tangle.el

update: $(ORG_FILES)
	@$(TANGLE) $^

clean:
	@rm -rf .dist/src
