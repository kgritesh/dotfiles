;;; lsp python config

(use-package lsp-pyright
  :ensure t
  :config
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

(provide 'lsp-python)
