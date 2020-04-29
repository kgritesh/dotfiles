(use-package org
  :config
  (setq org-directory "~/Documents/orgmode"
        org-default-notes-file (concat org-directory "/todo.org"))

  (setq org-log-done 'time)
  (setq org-use-speed-commands t)
  (setq org-return-follows-link t)
  (setq org-enforce-todo-dependencies t)

  :bind
  ("C-c l" . org-store-link)
  ("C-c a" . org-agenda)

)

(use-package org-projectile
  :config
  (org-projectile-per-project)
  (setq org-projectile-per-project-filepath "todo.org"
	org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
  :bind
  ("C-c c" .  'org-capture)
  ("C-c n p" . org-projectile-project-todo-completing-read))

(use-package org-bullets
  :config
  (setq org-hide-leading-stars t)
  (add-hook 'org-mode-hook
            (lambda ()
              (org-bullets-mode t))))


;; (use-package org-sticky-header-mode
;;   :requires org
;;   :config
;;   (add-hook 'org-mode-hook (lambda () (org-sticky-header-mode))))

(use-package org-journal
  :bind
  ("C-c n j" . org-journal-new-entry)
  :custom
  (org-journal-date-prefix "#+TITLE: ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-dir "~/Documents/orgmode/daily-journals")
  (org-journal-date-format "%A, %d %B %Y")
)

(defun pc/new-buffer-p ()
    (not (file-exists-p (buffer-file-name))))

  (defun pc/insert-journal-template ()
    (let ((template-file (expand-file-name "templates/journal.org" org-directory)))
      (when (pc/new-buffer-p)
        (save-excursion
          (goto-line 2)
	  (kill-line)
          (insert-file-contents template-file)))))

  (add-hook 'org-journal-after-entry-create-hook #'pc/insert-journal-template)


(provide 'init-org-mode)
