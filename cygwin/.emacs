

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)


(server-start)

; ----------------------------------------------------------------------
; define what we consider a word, etc. for easier forward-backward motion

(progn
  (let ((char 0))
    (while (< char ?!)
      (modify-syntax-entry char " " text-mode-syntax-table)
      (setq char (1+ char)))
    (while (< char 256)
      (modify-syntax-entry char "w" text-mode-syntax-table)
      (setq char (1+ char)))))

; ----------------------------------------------------------------------

(setq temporary-file-directory "c:/temp/emacs-backups/")

(setq backup-directory-alist
          `((".*" . ,temporary-file-directory)))
    (setq auto-save-file-name-transforms
          `((".*" ,temporary-file-directory t)))

; ----------------------------------------------------------------------

(display-time)
(defun mememe ()
  (select-frame-set-input-focus (window-frame (selected-window)))
  (raise-frame)
)

(add-hook 'server-visit-hook 'mememe)

(setq server-raise-frame t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Info-additional-directory-list (quote ("c:\\emacs\\info" "c:\\emacs\\share\\info")))
 '(column-number-mode t)
 '(compilation-read-command nil)
 '(completion-cycle-threshold t)
 '(display-time-mode t)
 '(inhibit-startup-screen t)
 '(isearch-lazy-highlight nil)
 '(package-selected-packages (quote (magit ranger)))
 '(read-buffer-completion-ignore-cash nil)
 '(safe-local-variable-values
   (quote
    ((MyRelDir . "demo/arith")
     (makefile-dir . "../../")
     (make-target . "1demo DSRC=demo/arith/cordic-circ-demo.cc")
     (make-target2 . "1demo DSRC=demo/arith/cordic-circ-demo.cc DEMOFLAGS=-DTIMING")
     (checkdoc-permit-comma-termination-flag . t)
     (checkdoc-force-docstrings-flag))))
 '(tool-bar-mode nil)
 '(tooltip-mode nil)
 '(verilog-auto-lineup (quote ignore))
 '(verilog-auto-newline nil)
 '(verilog-minimum-comment-distance 5)
 '(words-include-escapes nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight normal :height 120 :width normal))))
 '(font-lock-string-face ((((class color) (min-colors 88) (background light)) nil))))

(global-font-lock-mode t)               ; Turn on font-lock in all modes that support it
(setq font-lock-maximum-decoration t)   ; Maximum colors
(setq inhibit-startup-message t)        ; Dont show the GNU splash screen
(setq search-highlight t)               ; highlight incremental search
(setq query-replace-highlight t)        ; highlight during query
(setq tab-width 3)                      ; tab = 3 spaces
(setq-default indent-tabs-mode nil)     ; use spaces (not tabs) for indenting
(setq default-major-mode 'text-mode)    ; default mode is text mode
(setq next-screen-context-lines 1)      ; # of lines of overlap when scrolling
(setq auto-save-interval 300)           ; autosave every N characters typed
(setq scroll-preserve-screen-position t); make pgup/dn remember current line
(setq next-line-add-newlines nil)       ; don't scroll past end of file
(setq default-truncate-lines t)         ; each line gets one display line
(setq default-fill-column 76)           ; the column beyond which do word wrap
(setq version-control 'never)           ; don't use version numbers for backup files
;(setq mouse-wheel-scroll-amount 10)     ; vertical distance for scroll wheel
(setq vc-handle-cvs nil)
(setq auto-save-default nil)
(setq transient-mark-mode t)
(setq display-time-day-and-date t )
(setq-default truncate-lines t)         ; each line gets one display line



(setq auto-mode-alist (append '(("\\.f" . text-mode) 
                                ("\\.F" . text-mode)
                                ("\\.asm" . text-mode)
                                ("\\.ASM" . text-mode))
                              auto-mode-alist))

(setq truncate-partial-width-windows nil)

(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(fset 'yes-or-no-p 'y-or-n-p)           ; Replace yes-or-no question responses with y-or-n responses

(column-number-mode t)                  ; turn on column and line numbers
(line-number-mode t)

(global-auto-revert-mode 1)             ; autorevert buffers if files change

(setq mode-require-final-newline nil)   ; needs both?
(setq require-final-newline nil)          ; always terminate last line in file

; ----------------------------------------------------------------------

(defun audit-file-saving ()
  "keep an audit trail of the names of saved files in a fixed location"
  (interactive)
  (setq this (format "%s %s\n" (format-time-string "%D %-I:%M %p") ( buffer-file-name)))
  (write-region this nil "c:/local/saves.txt" t)
)

(add-hook 'before-save-hook 'audit-file-saving)

; ----------------------------------------------------------------------

(defun upcase-rectangle () (interactive)
       (if (< (point) (mark)) (exchange-point-and-mark))
       (kill-rectangle (mark) (point))
       (switch-to-buffer "*upcase")
       (yank-rectangle)
       (upcase-region (mark) (point))
       (kill-rectangle (mark) (point))
       (kill-buffer)
       (if (< (mark) (point)) (exchange-point-and-mark))
       (yank-rectangle)
       )

(defun downcase-rectangle () (interactive)
       (if (< (point) (mark)) (exchange-point-and-mark))
       (kill-rectangle (mark) (point))
       (switch-to-buffer "*upcase")
       (yank-rectangle)
       (downcase-region (mark) (point))
       (kill-rectangle (mark) (point))
       (kill-buffer)
       (if (< (mark) (point)) (exchange-point-and-mark))
       (yank-rectangle)
       )

; ----------------------------------------------------------------------


(defun now ()
  "Insert string for the current time formatted like '2:34 PM'."
  (interactive)                 ; permit invocation in minibuffer
  (insert (format-time-string "%D %-I:%M %p")))

(defun today ()
  "Insert string for today's date nicely"
  (interactive)                 ; permit invocation in minibuffer
  (insert (format-time-string "%e %b %Y")))

(defun jao-toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (if selective-display nil (or column 1))))

; ----------------------------------------------------------------------

(defun color8 ()  (interactive)  (set-background-color "#c0c0c0"))
(defun color1 ()  (interactive)  (set-background-color "#ffc0c0"))
(defun color2 ()  (interactive)  (set-background-color "#c0d0c0"))
(defun color3 ()  (interactive)  (set-background-color "#ffffc0"))
(defun color4 ()  (interactive)  (set-background-color "#c0c0ff"))
(defun color5 ()  (interactive)  (set-background-color "#ffc0ff"))
(defun color6 ()  (interactive)  (set-background-color "#c0ffff"))
(defun color7 ()  (interactive)  (set-background-color "#ffffff"))


; ----------------------------------------------------------------------
; use (current-frame-configuration) to see what things are right now...

(setq default-frame-alist 
      '(                   
        (width             . 80)       ; frame width and height
        (height            . 60)
        (top               . 30)
        (left              . 8)
        (cursor-color . "Red") ; foreground, background, and cursor colors 
        (foreground-color . "black")
        (background-color . "#ffffd0")
        )
      )

; places top left corner of initial frame at location (0, 80) on screen 
(setq initial-frame-alist
      '(
        (background-color . "#d0ffff")
        (width             . 80)
        (height            . 60)
        (top               . 30)
        (left              . 10)
        (main              . t)
        )
      )

(defun frame1 ()
   (interactive)
   (make-frame '(
     (background-color . "#d0ffff")
     (top . 30) 
     (left . 840) 
     (width . 80) 
     (height . 60)
     )))



(defun my-delete-frame ()
  (interactive)
  )
;   (if (assq 'main (frame-parameters)) () (delete-frame)))

(defun numbers (start end width) (interactive "NStart \nNEnd \nNWidth ")
  (setq temp next-line-add-newlines)
  (setq next-line-add-newlines t)
  (save-excursion
    
    (setq blah (format "%%0%dd " width))
    (while (<= start end)
      (move-beginning-of-line 1)
      (insert (format blah start))
      (setq start (1+ start))
      (next-line 1)
     )
    )
  (setq next-line-add-newlines temp)
  )

; ----------------------------------------------------------------------
; tab management

(defun tab (&optional arg)
  "set the tab width for the active buffer to the specified
argument."
  (interactive "p")

  (if (= arg 1) ()
    (setq tab-width arg))
)

(defun untab  (&optional arg)
  "set the tab width for the active buffer to the specified
argument, then untab the entire buffer."
  (interactive "p")

  (if (= arg 1) ()
    (setq tab-width arg))
  (untabify (point-min) (point-max))
  (indent-region (point-min) (point-max))
)


(defun re-indent ()
  (interactive)
  (indent-region (point-min) (point-max))
)  


                                        

; ------------------------------------------------------------------------
; forth comment management

(defun this-line-is-empty ()
  (interactive)
   (let (thisblank)
     (save-excursion
       (beginning-of-line)
       (setq thisblank (looking-at "[ \t]*$"))
       )
     thisblank
     )
   )

(defun kill-regx-current-line (arg)
  (interactive)
  (save-excursion
    (move-end-of-line 1)
    (setq end1 (point))
    (beginning-of-line)
    (setq beg1 (point))
    (setq foo (buffer-substring beg1 end1))
    (kill-line)
    (setq bar (replace-regexp-in-string arg "" foo))
    )
  bar
  )

(defun comment-line (ch text)
  (interactive)
  (let (foo item)
    (setq del (if (= (length text) 0) "=" " " ))
    (setq item (format "%s ==========%s%s%s" ch del text del))
    (insert item)
    (insert-char ?= (- 72 (length item)))
    )
  )

(defun rich-block ()
  (interactive)
  (comment-line "{" (if (this-line-is-empty) "" (kill-regx-current-line "[=-]+")))
  (insert "\n")
  (insert "\n")
  (insert-char ?= 70) (insert " }\n")
  (previous-line 2)
  )

(defun rich-line ()
  (interactive)
  (comment-line "\\" (if (this-line-is-empty) "" (kill-regx-current-line "[=-]+")))
  (next-line 1)
  (beginning-of-line)
  )

(defun rich-header ()
  (interactive)
  (beginning-of-buffer)
  (open-line 1)
  (comment-line "{" (file-name-nondirectory (buffer-file-name)))(insert "\n")
  (insert (format-time-string "   (C) %Y Stratolaunch LLC ---- %e%b%Y rcw/rcvn\n"))
  (insert "\n")
  (insert "\n")
  (insert-char ?= 70)(insert " }\n")
  (previous-line 2)
  )

;;;; ----------------------------------------------------------------------
;;;; i own these comment styles

(defun forth-block-comment (&optional arg)
  (interactive "p")
  (if (= arg 1) (beginning-of-line)
    (let ()  (beginning-of-buffer) (open-line 1) )
    )
  (insert "{ ")  (insert-char ?- 70) (insert "\n")
  (insert "\n")
  (if (= arg 1) ()
    (insert (format-time-string "Rick VanNorman  %e%b%Y  rick@neverslow.com\n"))
    )
  (insert-char ?- 70) (insert " }\n")  
  (insert "\n")
  (if (= arg 1) (previous-line 3) (previous-line 4))
  )

(defun forth-line-comment ()
  (interactive)
  (insert "\\ ") (insert-char ?- 70) (insert "\n")
)

(setq dashes3 "\\ ======================================================================\n")

(defun double-backslash ()
  (interactive)
  (beginning-of-line)
  (forth-line-comment)
  (insert "\\\\ \\\\\\\\ \n")
  (insert "\\\\\\ \\\\\\ \n")
  (insert "\\\\\\\\ \\\\ \n")
  (insert "\\\\\\\\\\ \\ \n")
  (insert "\n")
  (previous-line 5)
  (move-end-of-line 1)
)



(global-set-key "\M--" 'delete-horizontal-space)
(global-set-key "\M-\\" 'forth-line-comment)
(global-set-key "\M-\]" 'forth-block-comment)
(global-set-key  "\C-\M-\\"  'double-backslash)         
(global-set-key  "\C-\\"  'rich-line)         
(global-set-key "\C-\]" 'rich-block)
(global-set-key "\C-\M-\]" 'rich-header)

(setq block-marker "^ *[\\{=#+][ =#+][=#+\-][=#+\-]")

(defun block-pgdn ()
   (interactive)
   (end-of-line)
   (if (re-search-forward block-marker nil t) 
       (recenter 0) (end-of-buffer))
   (beginning-of-line)
)

(defun block-pgup ()
   (interactive)
   (if (eq (current-column) 0)
      (backward-char))
   (if (re-search-backward block-marker nil t)
       (recenter 0) (beginning-of-buffer))      
   (beginning-of-line)
)


(defun boxify ()
   "draw an open-ended box around text between point and mark"
   (interactive)
   (save-excursion
     (if (< (mark) (point)) (exchange-point-and-mark) ())   ;; point is first
     (beginning-of-line)
     (insert "   ." (make-string 70 ?-) "\n") 
     (while (< (point) (mark))
       (insert "   | ")
       (next-line 1)
       (beginning-of-line)
       )
     (insert "   `" (make-string 70 ?-) "\n")    
     )
   )

;;----------------------------------------------------------------------

;;ASCII table function
(defun ascii-table ()
  "Print the ascii table. Based on a defun by Alex Schroeder <asc@bsiag.com>"
  (interactive)  (switch-to-buffer "*ASCII*")  (erase-buffer)
  (insert (format "ASCII characters up to number %d.\n" 254))  (let ((i 0))
    (while (< i 254)      (setq i (+ i 1))
      (insert (format "%4d %c\n" i i))))  (beginning-of-buffer))

; ----------------------------------------------------------------------
; picked up from comp.emacs

(defun printfile ()
  "Print _from disk_ the file named the same as the current buffer
using the great PrintFile freeware program.  Be sure to save the file
first to print with the latest changes."
  (interactive)
  (shell-command
   (format "c:/bin/prfile32 %s"
           (buffer-file-name))))

;----------------------------------------------------------------------
; grep current buffer and display results

(defun grep ()
  (interactive)
  (setq args (read-from-minibuffer "grep args? "))
  (shell-command
   (format "c:/bin/grep \"%s\" %s"
           args (buffer-file-name)))
  (switch-to-buffer "*Shell Command Output*")
  (delete-other-windows)
)

(defun srr ()
  (interactive)
  (shell-command
   (format "c:/bin/grep \"@W\" %s"
            buffer-file-name))
  (switch-to-buffer "*Shell Command Output*")
  (delete-other-windows)
)

;----------------------------------------------------------------------

(defun saveall () 
   "save all buffers, alias for save-some-buffers"
   (interactive)
   (save-some-buffers t)
   )

(defun retop() 
   (interactive)
   (recenter 0))

(defun nextbuf ()
   (interactive)
   (switch-to-buffer (cadr (buffer-list))))

; ----------------------------------------------------------------------
; display settings

; Set titles for frame and icon (%f == file name, %b == buffer name)
(setq-default frame-title-format (list "Emacs " emacs-version " %f"))
(setq-default icon-title-format "Emacs - %b")

; Display settings
; default size and color options for all frames

; repeatdly execute the following line to build a list of
; monospaced fonts of interest in the lisp interaction buffer
; then, those strings can be included in the font_strings variable

; get all fonts supported via "set-default-font" and typing "?"
; sort the fonts to a useful set by grepping out all except "-c-" then 
; stripping duplicates. modify the height parameter to specific values, 12 & 14
; and let rip
;
; (insert (prin1-to-string (w32-select-font)))

(setq font_strings '(
"-outline-Consolas-normal-r-normal-normal-12-*-96-96-c-*-*-*"
"-outline-Consolas-normal-r-normal-normal-14-*-96-96-c-*-*-*"
"-outline-Consolas-bold-r-normal-normal-12-*-96-96-c-*-*-*"
"-outline-Consolas-bold-r-normal-normal-14-*-96-96-c-*-*-*"

"-outline-Bitstream Vera Sans Mono-bold-r-normal-normal-12-*-96-96-c-*-*-*"
"-outline-Bitstream Vera Sans Mono-bold-r-normal-normal-14-*-96-96-c-*-*-*"
"-outline-Bitstream Vera Sans Mono-normal-r-normal-normal-12-*-96-96-c-*-*-*"
"-outline-Bitstream Vera Sans Mono-normal-r-normal-normal-14-*-96-96-c-*-*-*"

"-outline-Courier New-bold-r-normal-normal-*-*-96-96-c-*-*-*"
"-outline-Courier New-normal-r-normal-normal-*-*-96-96-c-*-*-*"

"-outline-DejaVu Sans Mono-bold-r-normal-normal-12-*-96-96-c-*-*-*"
"-outline-DejaVu Sans Mono-bold-r-normal-normal-14-*-96-96-c-*-*-*"
"-outline-DejaVu Sans Mono-normal-r-normal-normal-12-*-96-96-c-*-*-*"
"-outline-DejaVu Sans Mono-normal-r-normal-normal-14-*-96-96-c-*-*-*"

"-outline-Lucida Console-normal-r-normal-normal-*-*-96-96-c-*-*-*"
"-outline-Lucida Sans Typewriter-demibold-r-normal-normal-*-*-96-96-c-*-*-*"
"-outline-Lucida Sans Typewriter-normal-r-normal-normal-*-*-96-96-c-*-*-*"

"-raster-Courier-normal-r-normal-normal-13-97-96-96-c-*-*-*"
"-raster-Courier-normal-r-normal-normal-16-120-96-96-c-*-*-*"
"-raster-Fixedsys-normal-r-normal-normal-12-90-96-96-c-*-*-*"
"-raster-Terminal-normal-r-normal-normal-12-90-96-96-c-*-ms-oem"
"-raster-Terminal-normal-r-normal-normal-16-120-96-96-c-*-ms-oem"

))



(setq font_index 0)

(defun next_font () (interactive)
  (setq font_index (+ font_index 1))
  (set-frame-font (elt font_strings 
                       (% font_index (length font_strings))))
  (message (cdr (assoc 'font (frame-parameters))))
  )

(defun prev_font () (interactive)
  (setq font_index (- font_index 1))
  (set-frame-font (elt font_strings 
                       (% font_index (length font_strings))))
  (message (cdr (assoc 'font (frame-parameters))))
  )

; ----------------------------------------------------------------------

(global-set-key [\C-kp-add]       'next_font)
(global-set-key [\C-kp-subtract]  'prev_font)

(global-set-key [C-M-left] 'hide-subtree)
(global-set-key [C-M-home] 'show-all)
(global-set-key [C-M-right] 'show-subtree)

;;----------------------------------------------------------------------
;; Set up some f-key shortcuts

(global-set-key [mouse-2] 'nil)   ; sorry, but i press the middle button when
                                  ; i don't mean to...

(define-key global-map "\M-`" 'other-frame)

(global-set-key "\C-xri" 'string-insert-rectangle)
(global-set-key "\C-xrl" 'downcase-rectangle)
(global-set-key "\C-xru" 'upcase-rectangle)

(global-set-key "\C-x\C-s" 'saveall)
(global-set-key "\C-x\C-z"  'my-delete-frame)
(global-set-key "\C-z" 'undo)

(global-set-key [\C-tab] 'nextbuf)

(global-set-key [C-next] 'block-pgdn)
(global-set-key [C-prior] 'block-pgup)

(global-set-key [home] 'beginning-of-line)     (global-set-key [C-home] 'beginning-of-buffer)
(global-set-key [end] 'end-of-line)            (global-set-key [C-end] 'end-of-buffer)
(global-set-key [M-home] 'retop)

(global-set-key  "\M-s" 'isearch-forward-regexp) 
(global-set-key  "\C-\M-s" 'replace-regexp) 

(global-set-key  "\M-g" 'goto-line)              
(global-set-key  "\C-x\C-g" 'goto-line)              
(global-set-key  "\C-xg" 'goto-line)              

(global-set-key "\M-n" 'frame1)       
(global-set-key [M-f6] 'delete-other-windows)  
                                               
(global-set-key [C-M-f1] 'color1)
(global-set-key [C-M-f2] 'color2)
(global-set-key [C-M-f3] 'color3)
(global-set-key [C-M-f4] 'color4)
(global-set-key [C-M-f5] 'color5)
(global-set-key [C-M-f6] 'color6)
(global-set-key [C-M-f7] 'color7)
(global-set-key [C-M-f8] 'color8)

(global-set-key "\M-z" 'zap-up-to-char)


(global-set-key [C-right] 'forward-word)

(global-set-key [f5] 'other-frame)
(global-set-key [f6] 'previous-buffer)
(global-set-key [f7] 'next-buffer)
(global-set-key [f12] 'ranger)
(global-set-key (kbd "C-;") 'previous-buffer)
(global-set-key (kbd "C-'") 'next-buffer)
(global-set-key (kbd "M-o") 'overwrite-mode)

; --------------------------------------------------------------------------------

(defun f-comment () (interactive)
       (insert "( -- ) f")
       (move-end-of-line 1)
       (re-search-forward "( ")
       (backward-char 2)
       )

(global-set-key [f11] 'f-comment)

(global-set-key (kbd "<f8>") 'toggle-truncate-lines)