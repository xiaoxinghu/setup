ORG_FILES = fish.org bash.org macos.org spacemacs.org javascript.org tmux.org vim.org
TANGLE=./.dist/bin/tangle.el
LINK=./.dist/bin/link.rb

all:
	@$(LINK)

update: $(ORG_FILES)
	@$(TANGLE) $^

clean:
	@rm -rf .dist/src
