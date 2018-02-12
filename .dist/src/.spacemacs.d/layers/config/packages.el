


(setq config-packages
      '(
        (org :location built-in)
        worf
        solaire-mode
        ))

(defun config/post-init-org ()
  (setq org-directory "~/io"
        org-log-into-drawer 1
        org-default-notes-file (concat org-directory "/inbox.org")
        org-agenda-files (list org-directory
                               (concat org-directory "/notes")
                               (concat org-directory "/work")
                               (concat org-directory "/projects"))
        org-log-done t
        org-startup-with-inline-images t
        org-image-actual-width nil
        org-startup-indented t
        org-html-htmlize-output-type 'css
        org-html-doctype "html5"
        org-html-metadata-timestamp-format "%Y %b %d (%a)"
        )
  (setq org-clock-persist t
        org-clock-persist-query-resume nil
        org-clock-out-remove-zero-time-clocks t)
  (org-clock-persistence-insinuate)
  (setq org-todo-keywords
        (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
                (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")
                )))
  
  (setq org-todo-keyword-faces
        (quote (("TODO" :foreground "red" :weight bold)
                ("IDEA" :foreground "red" :weight bold)
                ("NEXT" :foreground "deep sky blue" :weight bold)
                ("DRAFT" :foreground "deep sky blue" :weight bold)
                ("DONE" :foreground "forest green" :weight bold)
                ("WAITING" :foreground "orange" :weight bold)
                ("HOLD" :foreground "magenta" :weight bold)
                ("PUBLISHED" :foreground "forest green" :weight bold)
                ("CANCELLED" :foreground "forest green" :weight bold))))
  
  (setq org-agenda-custom-commands
        '((" " "Home"
           ((agenda "" nil)
            (todo "NEXT"
                  ((org-agenda-overriding-header "NEXT")))
            (todo "TODO"
                  ((org-agenda-overriding-header "PROJECTS")
                   (org-agenda-files (file-expand-wildcards "~/io/projects/*.org"))
                   (org-agenda-sorting-strategy '(todo-state-up))
                   ))
            (todo "TODO"
                  ((org-agenda-overriding-header "NOTES")
                   (org-agenda-files (file-expand-wildcards "~/io/notes/*.org"))
                   (org-agenda-sorting-strategy '(todo-state-up))
                   ))
            (todo "WAITING|HOLD"
                  ((org-agenda-overriding-header "PENDING")
                   (org-agenda-sorting-strategy '(todo-state-up))
                   ))
            ))
          ("Q" . "Custom Queries")
          ("Qn" "Note Search" search ""
           ((org-agenda-files (file-expand-wildcards "~/io/notes/*.org"))))
          ("w" "Writing"
           ((agenda "")
            (todo "DRAFT" ((org-agenda-overriding-header "Drafts")))
            (todo "IDEA" ((org-agenda-overriding-header "Ideas")))))))
  (setq org-capture-templates
        `(("t" "todo" entry
           (file+headline ,(concat org-directory "/desktop.org") "Inbox")
           (file , "~/.emacs.d/templates/todo.txt")
           ::empty-lines-before 1
           ::empty-lines-after 1)
          ("n" "note" entry
           (file+headline ,(concat org-directory "/desktop.org") "Quick Notes")
           (file , "~/.emacs.d/templates/note.txt")
           ::empty-lines-before 1
           ::empty-lines-after 1)
          ("l" "link" entry
           (file+headline ,(concat org-directory "/desktop.org") "Inbox")
           (file , "~/.emacs.d/templates/link.txt")
           ::empty-lines-before 1
           ::empty-lines-after 1)
          ))
  (setq org-archive-mark-done nil)
  (setq org-archive-location "%s_archive::* Archived Tasks")
  (require 'ox-man)
  (require 'ob)
  (require 'ob-shell)
  (require 'ob-ruby)
  (require 'ob-python)
  (require 'ob-sass)
  (require 'ob-tangle)
  (setq org-src-fontify-natively t)
  (setq org-confirm-babel-evaluate nil)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (emacs-lisp . t)
     (shell . t)
     (ruby . t)
     (sass . t)
     (dot . t)
     (java . t)
     ))
  (defun org-babel-execute:yaml (body params) body)
  
  (defun x/publish-src(x)
    (get-string-from-file (format "%s/.publish/dist/%s" org-directory x)))
  
  (defun x/publish-path (path)
    (concat x/org-publish-root path))
  
  (defun x/org-src (path)
    (concat org-directory path))
  
  (defun x/org-get-preview (file project)
    "Get the preview text of file."
    (let ((file (org-publish--expand-file-name file project)))
      (with-temp-buffer
        (insert-file-contents file)
        (goto-char (point-min))
        (let ((loc (re-search-forward "^#\\+BEGIN_PREVIEW$" nil t)))
          (when loc
            (goto-char loc)
            (let ((beg (org-element-property :contents-begin (org-element-at-point)))
                  (end (org-element-property :contents-end (org-element-at-point))))
              (buffer-substring beg end))
            )))))
  
  (defun x/org-publish-sitemap (title list)
    "site map, as a string.
  TITLE is the the title of the site map.  LIST is an internal
  representation for the files to include, as returned by
  `org-list-to-lisp'.  PROJECT is the current project."
    (concat "#+SETUPFILE: .setup" "\n"
            "#+EXPORT_FILE_NAME: index.html" "\n"
            "#+TITLE: " title "\n\n"
            "#+HTML: <div class=\"index\">" "\n"
            (org-list-to-subtree list)
            "#+HTML: </div>"))
  
  (setq x/org-publish-sitemap-entry-format-post
        (mapconcat
         'identity
         '("[[file:%f][%t]] [%d]"
           "%p"
           "") "\n"))
  (setq x/org-publish-sitemap-entry-format-note
        (mapconcat
         'identity
         '("[[file:%f][%t]]"
           "") "\n"))
  (setq x/org-publish-sitemap-entry-format-setup
        (mapconcat
         'identity
         '("[[file:%f][%t]]"
           "%p"
           "") "\n"))
  
  (defun x/org-publish-sitemap-entry-post (entry style project)
    (x/org-publish-sitemap-entry
     entry style project
     x/org-publish-sitemap-entry-format-post))
  
  (defun x/org-publish-sitemap-entry-note (entry style project)
    (x/org-publish-sitemap-entry
     entry style project
     x/org-publish-sitemap-entry-format-note))
  
  (defun x/org-publish-sitemap-entry-setup (entry style project)
    (x/org-publish-sitemap-entry
     entry style project
     x/org-publish-sitemap-entry-format-setup))
  
  (defun x/org-publish-sitemap-entry (entry style project fmt)
    (cond ((not (directory-name-p entry))
           (format-spec
            fmt
            `((?t . ,(org-publish-find-title entry project))
              (?d . ,(format-time-string "%Y-%m-%d" (org-publish-find-date entry project)))
              (?p . ,(org-publish-find-property entry :description project 'html))
              (?f . ,entry))))
          ((eq style 'tree)
           ;; Return only last subdir.
           (file-name-nondirectory (directory-file-name entry)))
          (t entry)))
  (setq org-html-preamble-format `(("en" ,(x/publish-src "preamble.html"))))
  (setq org-html-postamble-format `(("en" ,(x/publish-src "postamble.html"))))
  
  (setq org-publish-project-alist
        `(
          ("home"
           :base-directory ,(x/org-src "/")
           :base-extension "org"
           :publishing-directory ,(x/publish-path "/")
           :publishing-function org-html-publish-to-html
           :exclude "inbox.org"   ;; regexp
           :headline-levels 3
          
           :with-todo-keywords nil
           :section-numbers nil
           :html-head ,(x/publish-src "head.html")
           :html-preamble t
           :html-postamble t
           :with-toc nil)
          
          ("notes"
           :base-directory ,(x/org-src "/notes/")
           :base-extension "org"
           :publishing-directory ,(x/publish-path "/notes/")
           :publishing-function org-html-publish-to-html
           ;; :exclude "PrivatePage.org"   ;; regexp
          
           ;; sitemap
           :auto-sitemap t
           :sitemap-title "Notes"
           :sitemap-function x/org-publish-sitemap
           :sitemap-date-format "Published: %a %b %d %Y"
           :sitemap-sort-files anti-chronologically
           :sitemap-format-entry x/org-publish-notes-sitemap-entry
           :sitemap-filename ".index.org"
          
           :html-head ,(x/publish-src "head.html")
           :html-preamble t
           :html-postamble t)
          ("posts"
           :base-directory ,(x/org-src "/posts/")
           :base-extension "org"
           :exclude "^\\..+"
           :publishing-directory ,(x/publish-path "/posts/")
           :publishing-function org-html-publish-to-html
          
           ;; sitemap
           :auto-sitemap t
           :sitemap-title "Posts"
           :sitemap-function x/org-publish-sitemap
           :sitemap-date-format "%Y %b %d (%a)"
           :sitemap-sort-files anti-chronologically
           ;; :sitemap-format-entry x/sitemap-entry-format-posts
           :sitemap-format-entry x/org-publish-sitemap-entry-post
           :sitemap-filename ".index.org"
          
           :html-head ,(x/publish-src "head.html")
           :html-preamble t
           :html-postamble t)
          ("projects"
           :base-directory ,(x/org-src "/projects/")
           :base-extension "org"
           :exclude "^\\..+"
           :publishing-directory ,(x/publish-path "/projects/")
           :publishing-function org-html-publish-to-html
          
           ;; sitemap
           :auto-sitemap t
           :sitemap-title "Projects"
           ;:sitemap-function x/org-publish-org-sitemap
           :sitemap-date-format "%a %b %d %Y"
           :sitemap-sort-files anti-chronologically
           ;; :sitemap-format-entry x/sitemap-entry-format-notes
           :sitemap-filename ".index.org"
          
           :html-head ,(x/publish-src "head.html")
           :html-preamble t
           :html-postamble t)
          ("setup"
           :base-directory ,(x/org-src "/setup/")
           :base-extension "org"
           :publishing-directory ,(x/publish-path "/setup/")
           :publishing-function org-html-publish-to-html
          
           ;; sitemap
           :auto-sitemap t
           :sitemap-title "My Setup"
           :sitemap-function x/org-publish-sitemap
           :sitemap-date-format "%a %b %d %Y"
           ;; :sitemap-sort-files anti-chronologically
           :sitemap-format-entry x/org-publish-sitemap-entry-setup
           :sitemap-filename ".index.org"
          
           :html-head ,(x/publish-src "head.html")
           :html-preamble t
           :html-postamble t)
          ("res"
           :base-directory ,(x/org-src "/.publish/dist/")
           :base-extension "css\\|js\\|svg"
           :recursive t
           :publishing-directory ,(x/publish-path "/")
           :publishing-function org-publish-attachment)
  
          ("images"
           :base-directory ,(x/org-src "/img/")
           :base-extension "jpg\\|gif\\|png"
           :publishing-directory ,(x/publish-path "/images/")
           :publishing-function org-publish-attachment)
  
          ("website" :components ("home" "posts" "setup" "images" "res"))))
  (with-eval-after-load 'org
    (require 'ox-extra)
    (ox-extras-activate '(ignore-headlines)))
  )

(defun config/init-worf ()
  (use-package worf
    :diminish worf-mode
    :after org)
  )

(defun config/init-solaire-mode ()
  (use-package solaire-mode
    :config
    ;; brighten buffers (that represent real files)
    (add-hook 'after-change-major-mode-hook #'turn-on-solaire-mode)

    ;; ...if you use auto-revert-mode:
    (add-hook 'after-revert-hook #'turn-on-solaire-mode)

    ;; You can do similar with the minibuffer when it is activated:
    (add-hook 'minibuffer-setup-hook #'solaire-mode-in-minibuffer)

    ;; To enable solaire-mode unconditionally for certain modes:
    (add-hook 'ediff-prepare-buffer-hook #'solaire-mode)
    )
  )
