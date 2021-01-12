(use-package terraform-mode
  :mode ("\\.tf" . terraform-mode)
  :config
  (add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)
  (custom-set-variables
   '(terraform-indent-level 4)))


(use-package company-terraform
  :config
  (company-terraform-init))

(provide 'terraform)
