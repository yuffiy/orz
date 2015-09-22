;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;
(point)


(let ((s "Javascript"))
      (put-text-property 0 (length s) 'face '(:background "cyan") s)
      (insert s))

(make-face 'temp-face)
(set-face-background 'temp-face "cyan")

(make-face 'test-face)
(set-face-background 'test-face "#d32f2f")

(read-color "#229057053")

(color-defined-p "mdl-red-700")

(window-body-width)


(put-text-property 1 83 'face 'temp-face)

(put-text-property 83 (1+ (* 82 2)) 'face 'test-face)


(buffer-string)


