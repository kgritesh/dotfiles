;; Add your keys here, as such

;(global-set-key (kbd "[SHORTCUT]") '[FUNCTION])

(global-set-key [f8] 'neotree-toggle)
(global-set-key (kbd "C-x \\") 'comment-region)
(global-set-key (kbd "C-x /") 'uncomment-region)
(global-set-key (kbd "M-;") 'xref-find-definitions-other-window)
(global-set-key (kbd "M-.") 'xref-find-definitions)
(provide 'base-global-keys)
