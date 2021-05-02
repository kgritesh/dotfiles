(use-package web-mode
  :bind (("C-c ]" . emmet-next-edit-point)
         ("C-c [" . emmet-prev-edit-point)
         ("C-c o b" . browse-url-of-file))
  :mode ("\\.html\\'" "\\.css\\'" "\\.php\\'" "\\.tmpl\\'")
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
	web-mode-enable-engine-detection t)

  (setq web-mode-engines-alist
      '(("php"    . "\\.phtml\\'")
        ("blade"  . "\\.blade\\.")
	("go"  . "\\.tmpl\\."))

  )

 (use-package web-mode-edit-element
   :config (add-hook 'web-mode-hook 'web-mode-edit-element-minor-mode))

  (defadvice company-tern (before web-mode-set-up-ac-sources activate)
    "Set `tern-mode' based on current language before running company-tern."
    (message "advice")
    (if (equal major-mode 'web-mode)
	(let ((web-mode-cur-language
	       (web-mode-language-at-pos)))
	  (if (or (string= web-mode-cur-language "javascript")
		  (string= web-mode-cur-language "jsx"))
	      (unless tern-mode (tern-mode))
	    (if tern-mode (tern-mode -1))))))
  (add-hook 'web-mode-hook 'company-mode)
)

(use-package lsp-html
  :demand t
  :hook ((web-mode . lsp))
  :ensure lsp-mode)

(provide 'config-html)
