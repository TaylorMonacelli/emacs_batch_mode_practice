;; ------------------------------

(require 'package)
;; Add the original Emacs Lisp Package Archive
(add-to-list 'package-archives '("elpa" . "http://tromey.com/elpa/"))
;; Add the user-contributed repository
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

;; ------------------------------

(fset 'yes-or-no-p 'y-or-n-p) ;; Make all "yes or no" prompts show "y or n" instead

(custom-set-variables '(truncate-lines t))

;; ------------------------------

(remove-hook 'find-file-hooks 'vc-find-file-hook)

;; ------------------------------

(load-theme (quote tango-dark) nil nil)

;; ------------------------------

;; don't prompt to kill subshell
;; don't ask about killing subprocesses when killing emacs, just kill
;; off all children without question
;; http://stackoverflow.com/questions/2706527/make-emacs-stop-asking-active-processes-exist-kill-them-and-exit-anyway
(add-hook 'comint-exec-hook
	  (lambda () (process-kill-without-query (get-buffer-process (current-buffer)))))

;; ------------------------------

(defun tm-dir-shell-here()
  (interactive)
  (let ((cbuff (buffer-name))
	(cdcmd (concat "cd \'" (expand-file-name (file-name-as-directory default-directory)) "\'")))
    (progn
      (shell)
      (goto-char (point-max))
      (move-beginning-of-line 1)
      (insert "# ") (comint-send-input)
      (goto-char (point-max))
      (insert cdcmd) (comint-send-input)
      ;; it seems better not to split window and switch
      ;; (switch-to-buffer-other-window cbuff)
      ;; (other-window 1)
      (kill-new cbuff)
      )))
(global-set-key "e" (quote tm-dir-shell-here))

;; ;; ------------------------------
;; ;; backup-dir
;; ;; ------------------------------
;; 					; http://www.emacswiki.org/cgi-bin/wiki?BackupDirectory
;; (require 'backup-dir)
;; ;; localize it for safety.
;; (make-variable-buffer-local 'backup-inhibited)
;; (if (not (file-directory-p "~/.emacs.d")) (make-directory "~/.emacs.d"))
;; (if (not (file-directory-p "~/.emacs.d/backups")) (make-directory "~/.emacs.d/backups"))
;; (setq bkup-backup-directory-info '((t "~/.emacs.d/backups" ok-create full-path prepend-name)))
;; (setq delete-old-versions t
;;       kept-old-versions 1
;;       kept-new-versions 3
;;       version-control t)


;; ------------------------------

;; There is a small bug in Emacs24’s package.el such that the
;; dependency order comes out backwards. The problem is patched by
;; some advice.

;; http://melpa.milkbox.net/#/getting-started

 (defadvice package-compute-transaction
  (before package-compute-transaction-reverse (package-list requirements) activate compile)
    "reverse the requirements"
    (setq requirements (reverse requirements))
    (print requirements))

;; ------------------------------
