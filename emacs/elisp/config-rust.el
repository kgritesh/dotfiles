(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
	      ("C-l C-s" . lsp-rust-analyzer-status))
  :config
  (setq rustic-format-on-save t)
  (setq lsp-rust-server 'rust-analyzer)
  (setq lsp-rust-analyzer-server-display-inlay-hints t)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm
  (setq-local buffer-save-without-query t))

(provide 'config-rust)
