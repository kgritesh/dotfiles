;;; package --- Main init file
;;; Commentary:
;;; This is my init file

;;; Code:

(add-to-list 'load-path (concat user-emacs-directory "elisp"))

(require 'base)
(require 'base-theme)
(require 'base-extensions)
(require 'base-functions)
(require 'base-global-keys)

;;(require 'lang-python)
;;(require 'lang-go)
(require 'lang-javascript)
(require 'lang-yaml)
;;(require 'init-org-mode)
(require 'init-markdown)
;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ## end of OPAM user-setup addition for emacs / base ## keep this line
(require 'lang-reasonml)
(require 'lsp)
(require 'terraform)
(require 'init-docker)
(require 'lsp-python)
