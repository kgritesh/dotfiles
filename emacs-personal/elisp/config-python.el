;;; lsp python config

(use-package python
  :mode ("\\.py" . python-mode)
  :custom
  (python-shell-interpreter "ipython")
  (python-shell-interpreter-args "-i --simple-prompt")
  (python-indent-guess-indent-offset-verbose nil)

  :bind ( :map python-mode-map
	       ("C-c r" . python-indent-shift-right)
	       ("C-c l" . python-indent-shift-left))
  :hook
   (python-mode . flycheck-mode)
   (python-mode . lsp-deferred)
   (python-mode . (lambda () (setq-local fill-column 88))))

(use-package lsp-pyright
  :ensure t
  :after lsp-mode
  :custom
  (lsp-pyright-auto-import-completions t)
  (lsp-pyright-auto-search-paths t)
  (lsp-pyright-typechecking-mode "off")

  :config
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

(use-package blacken
  :commands blacken-mode blacken-buffer)

(provide 'config-python)
