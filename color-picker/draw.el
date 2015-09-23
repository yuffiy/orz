(require 'ov)
(require 's)


(defvar color-picker-window-width 36)
(defvar color-picker-buffer-name "*Color Picker*")
(setq current-buffer (current-buffer))

(defun insert-text-center (width text)
  "Insert text and center align it."
  (let* ((text-len (string-width text))
	 (space-width (/ (- width text-len) 2)))
    (insert (make-string space-width ?\s))
    (insert text)))

(defun insert-left-space (width len)
  "Keep text center."
  (insert (make-string (/ (- width len) 2) ?\s)))
(defun insert-color-block (width len color)
  "Insert color block."
  ;(insert-left-space width len)
  (ov-set (ov-insert (make-string 7 ?\s)) 'face '(:background "#d32f2f")))

(defun button-click-handle (button)

  (let* ((start (button-start button))
	 (split-start (- start 14))
	 (value (s-trim (buffer-substring split-start start))))

    (set-buffer current-buffer)
    (delete-other-windows)
    (kill-buffer color-picker-buffer-name)
    (insert value)
    )p
  )


(defun yufi/pick-color ()
  ""
  (interactive)
  
  (save-current-buffer
    (when (get-buffer color-picker-buffer-name)
      (kill-buffer color-picker-buffer-name))
    (generate-new-buffer color-picker-buffer-name)
    (set-buffer (get-buffer-create color-picker-buffer-name))
    (font-lock-mode nil)


    (let* ((current-window (selected-window))
	   (current-window-width (window-body-width))
	   (window (split-window-right (- current-window-width color-picker-window-width)))
	   (window-width (+ 2 (window-body-width window)))
	   (title "Material Design Colors")
	   (title-len (string-width title)))

      (set-window-buffer window color-picker-buffer-name)
      (select-window window)

      (newline)
      (insert-text-center window-width title)
      (newline 4)
      (insert "1.")
      (insert "Red")
      (newline 2)
      (insert-left-space window-width 35)
      (ov-set (ov-insert (make-string 7 ?\s)) 'face '(:background "#d32f2f"))
      (newline)
      (insert-left-space window-width 35)
      (ov-set (ov-insert (make-string 7 ?\s)) 'face '(:background "#d32f2f"))
      (insert "   rgb: (255,255,255) [pick]")
      (newline)
      (insert-left-space window-width 35)
      (ov-set (ov-insert (make-string 7 ?\s)) 'face '(:background "#d32f2f"))
      (insert "   rgb: (255,255,255) [pick]")
      (newline)
      (insert-left-space window-width 35)
      (ov-set (ov-insert (make-string 7 ?\s)) 'face '(:background "#d32f2f"))
      (insert "   rgb: (255,255,255) ")
      (insert-button "[pick]" 'action 'button-click-handle)
      (newline)
      (insert-left-space window-width 35)
      (ov-set (ov-insert (make-string 7 ?\s)) 'face '(:background "#d32f2f"))

      
      
      )
    (beginning-of-buffer)
    (read-only-mode t)

    )

  )

