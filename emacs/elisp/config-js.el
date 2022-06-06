(use-package js2-mode
  :mode ("\\.js" . js2-mode)
  :config
    (setq-default js2-basic-offset 2)
    (setq js-indent-level 2))


(use-package json-mode
  :mode ("\\.json" . json-mode))

(use-package prettier-js
  :ensure t)

(use-package typescript-mode
  :mode ("\\.ts" . typescript-mode)
  :config
    (setq typescript-indent-level 2))

(add-hook 'js2-mode-hook 'prettier-js-mode)
(add-hook 'typescript-mode-hook 'prettier-mode)
(add-hook 'js2-mode-hook 'lsp)
(add-hook 'typescript-mode-hook 'lsp)
(setq prettier-js-args '(
  "--tab-width" "2"
))

(setq lsp-javascript-format-enable nil)




;; (use-package lsp-javascript
;;   :demand t
;;   :hook ((js2-mode . lsp)
;; 	 (typescript-mode . lsp))
;;   :ensure lsp-mode
;;   :after (lsp-mode typescript-mode))

 (provide 'config-js)
