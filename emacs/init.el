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
(require 'config-html)
(require 'config-golang)
(require 'config-js)
(require 'config-python)
(require 'config-rust)
(require 'config-modes)
(require 'lang-reasonml)
(require 'lang-ocaml)
(put 'downcase-region 'disabled nil)

;;(require 'lang-python)
;;(require 'lang-javascript)


;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
;; ## end of OPAM user-setup addition for emacs / base ## keep this line
