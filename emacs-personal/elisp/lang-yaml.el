(use-package yaml-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-hook 'yaml-mode-hook
    '(lambda ()
        (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
)

(provide 'lang-yaml)
