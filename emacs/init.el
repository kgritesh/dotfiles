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

(require 'lsp)
(require 'lang-javascript)
(require 'lang-yaml)
(require 'init-markdown)
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
(require 'lang-reasonml)
(require 'lsp-golang)
(require 'terraform)
(require 'init-docker)
(require 'lsp-python)
