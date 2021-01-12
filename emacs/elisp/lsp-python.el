;;; lsp python config

(use-package lsp-pyright
  :ensure t
  :config
  (lsp-resgister-custom-settings
   `(("python.venvPath" "/home/krg85/.local/share/virtualenvs/")
     ("python.analysis.autoImportCompletions" t ))
   )
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

(provide 'lsp-python)
