(use-package js2-mode
  :mode ("\\.js" . js2-mode)
  :hook (js-mode . (lambda () (add-hook 'before-save-hook #'lsp-format-buffer 0 t)))
  :config
    (setq-default js2-basic-offset 2)
    (setq js-indent-level 2))


(use-package json-mode
  :mode ("\\.json" . json-mode))

(use-package prettier-js
  :ensure t)

(use-package typescript-mode
  :mode ("\\.ts" . typescript-mode)
  :hook (typescript-mode . (lambda () (add-hook 'before-save-hook #'lsp-format-buffer 0 t)))
  :config
    (setq typescript-indent-level 2))

(add-hook 'js2-mode-hook 'prettier-js-mode)
(add-hook 'typescript-mode-hook 'prettier-mode)
(add-hook 'js2-mode-hook 'lsp)
(add-hook 'typescript-mode-hook 'lsp)



;; (use-package lsp-javascript
;;   :demand t
;;   :hook ((js2-mode . lsp)
;; 	 (typescript-mode . lsp))
;;   :ensure lsp-mode
;;   :after (lsp-mode typescript-mode))

 (provide 'config-js)
