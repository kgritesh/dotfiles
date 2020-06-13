
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.component.html$\\'" . js-mode))


(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js-mode-hook
            (lambda ()
              (when (string-equal "js" (file-name-extension buffer-file-name))
                (setup-tide-mode))))


(add-hook 'js-mode-hook
          (lambda ()
            (when (string-match-p ".component.html$" buffer-file-name)
              (setup-tide-mode))))

(add-hook 'js-mode-hook
          (lambda ()
            (when (string-equal "jsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

(add-hook 'js-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

(setq js-indent-level 2)

(require 'flycheck)
(flycheck-add-mode 'javascript-eslint 'js-mode)
(flycheck-add-mode 'typescript-tslint 'js-mode)

(use-package json-mode)

(use-package typescript-mode
  :defer t
  :config
  (add-hook 'typescript-mode-hook 'setup-tide-mode))

(setq typescript-indent-level 2)

(use-package tide
  :init
  :ensure t
  :config
  (flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append)
  (flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)
  (setq tide-imenu-flatten nil)
  (setq tide-completion-fuzzy t)
  (setq tide-always-show-documentation t)
  (setq tide-disable-suggestions t)
  (setq create-lockfiles t)
  (setq tide-root-config-files '("tsconfig.app.json" "tsconfig.json" "jsconfig.json"))
  (setq tide-completion-detailed nil)
  (add-hook 'typescript-mode
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
  )


;; (setq tide-tsserver-executable "~/work/repos/tide/tsserver/tsserver.js")
;; (setq tide-tsserver-executable "/usr/local/bin/tsserver")
;; (setq tide-tsserver-executable nil)


(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode t)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode t)
  (tide-hl-identifier-mode +1)
  ;; (tide-hl-identifier-mode +1)
  (idle-highlight-mode 0)
  (company-mode +1))

;; (setq tide-tsserver-process-environment '())
;; (add-hook 'before-save-hook 'tide-format-before-save)
;; (setq tide-format-options '(:insertSpaceAfterFunctionKeywordForAnonymousFunctions t))
;; (setq tide-completion-ignore-case t)


(flycheck-define-checker yaml-swagger
  "swagger validation"
  :command ("spectral" "lint" "--display-only-failures" source)
  :error-patterns
  ((error line-start (one-or-more space) line ":" column
          (one-or-more space) "error" (one-or-more space) (message) line-end))
  :modes (yaml-mode)
  :predicate (lambda ()
               (string-equal "swagger" (file-name-base buffer-file-name))))

(add-to-list 'flycheck-checkers 'yaml-swagger)
(add-hook 'yaml-mode-hook 'flycheck-mode)

(use-package add-node-modules-path)
(add-hook 'flycheck-mode-hook 'add-node-modules-path)

(add-to-list 'auto-mode-alist '("\\.vert\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.frag\\'" . glsl-mode))

(use-package prettier-js
  :hook (
         (typescript-mode . prettier-js-mode)
         ;; (web-mode . prettier-js-mode)
         (js-mode . prettier-js-mode)
         (json-mode . prettier-js-mode)))

(provide 'lang-javascript)
