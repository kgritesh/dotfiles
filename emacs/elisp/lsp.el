
;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
(setq lsp-keymap-prefix "C-l")

(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-l")
  :commands (lsp lsp-deferred)
  :hook ((html-mode . lsp)
         (css-mode . lsp)
	 (lsp-mode . lsp-enable-which-key-integration)
         (lsp-after-open . lsp-origami-try-enable))
  :bind (
	 ("M-j" . lsp-ui-imenu)
	 ("M-?" . lsp-find-references)
	 ("C-c C-e" . flycheck-list-errors)
	 ("C-c C-r" . lsp-workspace-restart)
	 ("C-c C-a" . lsp-execute-code-action)
	 )
  :custom
    (lsp-eldoc-render-all t)
    (lsp-idle-delay 0.6)
    (lsp-prefer-flymake nil)
    (lsp-rust-analyzer-server-display-inlay-hints t)
  :config
    (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
)


(use-package lsp-origami)

(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-peek-enable t)
  (lsp-ui-sideline-enable t)
  (lsp-ui-imenu-enable t)
  (lsp-ui-flycheck-enable t)
  :init
)

;;

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;;amount of data emacs read from process
(setq read-process-output-max (* 1024 1024)) ;
;; completion-backend
(setq lsp-completion-provider :capf)

(setq lsp-modeline-code-actions-mode t)

(with-eval-after-load 'lsp-mode
  ;; :global/:workspace/:file
  (setq lsp-modeline-diagnostics-scope :workspace))


(provide 'lsp)
