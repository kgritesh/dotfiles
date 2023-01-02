(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((eval progn
           (dap-register-debug-template "Run Offer Service"
                                        (list :type "go" :request "launch" :name "Launch File" :mode "auto" :program nil :buildFlags nil :args nil :env
                                              '(("ENV" . "LOCAL")
                                                ("CONFIG_FILE" . ".local.internal")))))))
 '(warning-suppress-log-types '((emacs) (defvaralias)))
 '(warning-suppress-types '((emacs) (defvaralias))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
