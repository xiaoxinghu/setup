#!/usr/bin/env emacs --script

(package-initialize)
(require 'org)
(require 'ob)
(require 'ob-shell)

(org-babel-do-load-languages
 'org-babel-load-languages
'(
   (shell . t)
   ))

(setq org-confirm-babel-evaluate nil)

(dolist (file argv)
  (message "---> %s" file)
  (find-file file)
  (org-babel-execute-buffer)
  (kill-buffer))
