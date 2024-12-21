(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-idle-change-delay 1.0)
 '(ignored-local-variable-values
   '((eval lsp-register-custom-settings
      '(("python.pythonPath" "/home/krg85/.conda/envs/liveth/bin/python" "python.venvPath" "/home/krg85/.conda/envs/liveth")))))
 '(lsp-disabled-clients '(flow-ls))
 '(lsp-log-io t)
 '(lsp-pyright-typechecking-mode "off")
 '(safe-local-variable-values
   '((eval setq-local lsp-clients-typescript-prefer-use-project-ts-server t)
     (eval lsp-register-custom-settings
      '(("python.pythonPath" "/home/krg85/.conda/envs/liveth/bin/python" "python.venvPath" "/home/krg85/.conda/envs/liveth")))
     (undo-tree-auto-save-history)
     (eval progn
      (add-to-list 'exec-path
                   (concat
                    (locate-dominating-file default-directory ".dir-locals.el")
                    "node_modules/.bin/")))))
 '(typescript-indent-level 2)
 '(warning-suppress-log-types '((lsp-mode) (emacs) (defvaralias)))
 '(warning-suppress-types '((emacs) (defvaralias))))
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
