;; Add your custom functions here

;; (defun something
;;    (do-something))

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(global-set-key (kbd "C-x M-k") 'kill-other-buffers)


(provide 'base-functions)
