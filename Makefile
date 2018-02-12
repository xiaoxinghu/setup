# ORG_FILES := $(shell find . -name '*.org')
# ORG_FILES := $(wildcard *.org)
ORG_FILES = fish.org bash.org spacemacs.org

TANGLE=./.dist/bin/tangle.el

update: $(ORG_FILES)
	@$(TANGLE) $^

clean:
	@rm -rf .dist
