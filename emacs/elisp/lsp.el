
;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
(setq lsp-keymap-prefix "C-l")

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook ((lsp-mode . lsp-enable-which-key-integration))
  :hook ((html-mode . lsp)
         (css-mode . lsp))
  :config (progn
            ;; use flycheck, not flymake
            (setq lsp-prefer-flymake nil)))


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

(setq
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
