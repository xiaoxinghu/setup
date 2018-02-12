#!/usr/bin/env emacs --script

(require 'org)

(dolist (file argv)
  (message "---> %s" file)
  (find-file file)
  (org-babel-tangle)
  (kill-buffer))
