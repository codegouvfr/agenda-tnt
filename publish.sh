#!/usr/bin/env sh

":"; exec emacs --quick --script "$0" -- "$@" # -*- mode: emacs-lisp; lexical-binding: t; -*-

(require 'org)
(add-to-list 'load-path "~/ox-html-timeline/")
(require 'ox-html-timeline)

(setq make-backup-files nil debug-on-error t)

(dolist (org-file (directory-files-recursively "." "\\.org$"))
  (let ((html-file (file-name-with-extension org-file "html")))
    (if (and (file-exists-p html-file)
             (file-newer-than-file-p html-file org-file))
        (message " [skipping] unchanged %s" org-file)
      (message "[exporting] %s" org-file)
      (with-current-buffer (find-file-noselect org-file)
        (condition-case err
            (org-html-timeline-export-to-html-timeline)
          (error (message (error-message-string err))))))))
