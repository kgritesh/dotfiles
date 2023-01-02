;; Add your custom functions here

;; (defun something
;;    (do-something))

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(global-set-key (kbd "C-x M-k") 'kill-other-buffers)


(defun copy-buffer-path ()
  "Put the current file name on the clipboard"
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (with-temp-buffer
        (insert filename)
        (clipboard-kill-region (point-min) (point-max)))
      (message filename))))


(defun relative-buffer-path ()
  "Copy the buffer path relative to projectile root"
  (interactive)
  (kill-new (file-relative-name buffer-file-name (projectile-project-root))))

 (global-set-key (kbd "C-x c") 'relative-buffer-path)

(provide 'base-functions)
