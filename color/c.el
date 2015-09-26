;; TODO rgba hsla

(require 'dash)
(require 'dash-functional)
(require 's)

(defvar re-c-hex "^#\\([0-9a-fA-F]\\{2\\}\\)\\([0-9a-fA-F]\\{2\\}\\)\\([0-9a-fA-F]\\{2\\}\\)$"
  "Regex for hex color.")
(defvar re-c-s-hex "^#\\([0-9a-fA-F]\\{1\\}\\)\\([0-9a-fA-F]\\{1\\}\\)\\([0-9a-fA-F]\\{1\\}\\)$"
  "Regex for short hex color.")
(defvar re-c-rgb "^rgb\(\\([0-9]\\{1,3\\}\\),\s?\\([0-9]\\{1,3\\}\\),\s?\\([0-9]\\{1,3\\}\\)\s?\)$"
  "Regex for rgb color.")
(defvar re-c-hsl "^hsl\(\\([0-9]\\{1,3\\}\\),\s?\\([0-9]\\{1,3\\}\\)\%,\s?\\([0-9]\\{1,3\\}\\)\%\s?\)$"
  "Regex for hsl color.")

;; TEST
;;(s-match re-c-hex "#d32f2f")
;;(s-match re-c-s-hex "#ddd")
;;(s-match re-rgb-color "rgb(211, 47, 47)")
;;(s-match re-hsl-color "hsl(0, 65%, 51%)")

(defsubst c-get-list (re color)
  ""
  )
(-map 'string-to-number (cdr (s-match re-rgb-color "rgb(211, 47, 47)")))

(defun c-hex? (c)
  "Return t if color is hex format."
  (if (s-match re-c-hex c)
      t
    nil))
(defun c-shex? (c)
  "Return t if color is short hex format."
  (if (s-match re-c-s-hex c)
      t
    nil))
(defun c-rgb? (c)
  "Return t if color is rgb format."
  ;; FIXME if color number gt 255?
  (if (s-match re-c-rgb c)
      t
    nil))
(defun c-hsl? (c)
  "Return t if color is hsl format."
  ;; FIXME if color number gt 255?
  (if (s-match re-c-hsl c)
      t
    nil))

(c-hex? "#d32f2f")
(c-shex? "#ddd")
(c-rgb? "rgb(0,0,255)")
(c-hsl? "hsl(0,1%,50%)")

(defun c-type (c)
  "Check color type."
  ;; hex|shex|rgb|hsl
  
  )
(defun c-mate (c)
  ""
  )
(defun c-hex (c)
  ""
  )
(defun c-rgb (c)
  ""
  )
(defun c-hsl (c)
  ""
  )
(defun c-darken (c)
  ""
  )
(defun c-lighten (c)
  ""
  )

;; c-type
;; c-mate
;; c-hex
;; c-rgb
;; c-hsl
;; c-darken
;; c-lighten
