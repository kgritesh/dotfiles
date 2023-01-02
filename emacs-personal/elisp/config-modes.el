(use-package dockerfile-mode
  :mode (("Dockerfile\\'" . dockerfile-mode)))


(use-package yaml-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-hook 'yaml-mode-hook
    '(lambda ()
        (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
)


(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "markdown")
  (add-hook 'markdown-mode-hook 'flyspell-mode))


(use-package terraform-mode
  :mode ("\\.tf" . terraform-mode)
  :config
  (add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)
  (custom-set-variables
   '(terraform-indent-level 4)))


(use-package company-terraform
  :config
  (company-terraform-init))

(use-package protobuf-mode
  :ensure t
  :mode ("\\.proto\\'" . protobuf-mode))

(provide 'config-modes)
