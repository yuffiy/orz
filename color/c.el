;;; c.el color change for css.

;; Copyright (C) 2012-2015 Free Software Foundation, Inc.

;; Author: Yufi <yfhj1990@hotmail.com>
;; Version: 0.0.1
;; Keywords: color css


;; TODO rgba hsla

;;; Code:

(require 'dash)
(require 'dash-functional)
(require 's)

(defvar c-re-hex "^\\(#\\)\\([0-9a-fA-F]\\{2\\}\\)\\([0-9a-fA-F]\\{2\\}\\)\\([0-9a-fA-F]\\{2\\}\\)$"
  "Regex for hex color.")
(defvar c-re-shex "^\\(#\\)\\([0-9a-fA-F]\\{1\\}\\)\\([0-9a-fA-F]\\{1\\}\\)\\([0-9a-fA-F]\\{1\\}\\)$"
  "Regex for short hex color.")
(defvar c-re-rgb "^\\(rgb\\)\(\\([0-9]\\{1,3\\}\\),\s?\\([0-9]\\{1,3\\}\\),\s?\\([0-9]\\{1,3\\}\\)\s?\)$"
  "Regex for rgb color.")
(defvar c-re-hsl "^\\(hsl\\)\(\\([0-9]\\{1,3\\}\\),\s?\\([0-9]\\{1,3\\}\\)\%,\s?\\([0-9]\\{1,3\\}\\)\%\s?\)$"
  "Regex for hsl color.")

;;
;; Convert with rgb color and hsl color.
;;
(defsubst c-h-rgb (m1 m2 h0)
  "Compute middle value."
  (-let* ((h1 (when (< h0 0) (1+ h0)))
	  (h2 (when (> h0 1) (1- h0)))
	  (h (--first (not (eq it nil)) (list h1 h2 h0))))
    (cadr (--first
     (not (eq (car it) nil))
     (list
      (list (< (* h 6) 1) (+ m1 (* (- m2 m1) h 6)))
      (list (< (* h 2) 1) m2)
      (list (< (* h 3) 2) (+ m1 (* (- m2 m1) (- (/ 2 3) h) 6)))
      (list t m1))))))

(defsubst c-rgb-hsl (rgb)
  "Convert rgb to hsl."
  ;; http://en.wikipedia.org/wiki/HSL_and_HSV#Conversion_from_RGB_to_HSL_or_HSV
  (-let* ((rgbl (--map (/ it 255.0) rgb))
	  (ma (-max rgbl))
	  (mi (-min rgbl))
	  (d (- ma mi))
	  ((r g b) rgbl)
	  (h (cadr (--max-by
	      (> (car it) (car other))
	      (list
	       (list mi 0)
	       (list r (+ 0 (* 60 (- g b) (/ 1 d))))
	       (list g (+ 120 (* 60 (- b r) (/ 1 d))))
	       (list b (+ 240 (* 60 (- r g) (/ 1 d))))))))
	  (l (/ (+ ma mi) 2))
	  (s (if (< l 0.5) (/ d 2 (/ 1 l)) (/ d (- 2 (* 2 l))))))
    (list h s l)))


(defsubst c-hsl-rgb (hsl)
  "Convert hsl to rgb."
  ;; http://www.w3.org/TR/css3-color/#hsl-color
  (-let* (((h s l) hsl)
	  (m2 (if (<= l 0.5) (* l (1+ s)) (+ l s (- (* l s)))))
	  (m1 (- (* l 2) m2))
	  (r (c-h-rgb m1 m2 (/ (+ h 1.0) 3)))
	  (g (c-h-rgb m1 m2 h))
	  (b (c-h-rgb m1 m2 (/ (- h 1.0) 3))))
    (--map (round (* it 255)) (list r g b))))

;;
;; Convert color to mate date
;;
(defsubst c-hex-mate (c)
  "Check hex format color."
  (-if-let* ((li (s-match c-re-hex c))
	     ((_ _ r g b) li)
	     (rgbl (--map (string-to-number it 16) (list r g b)))
	     (hsll (c-rgb-hsl rgbl)))
      (-concat rgbl hsll)))

(defsubst c-shex-mate (c)
  "Check short hex format color."
  (-if-let* ((li (s-match c-re-shex c))
	     ((_ _ r g b) li)
	     (rgbl (--map
		    (string-to-number it 16)
		    (list
		     (format "%s%s" r r)
		     (format "%s%s" g g)
		     (format "%s%s" b b))))
	     (hsll (c-rgb-hsl rgbl)))
      (-concat rgbl hsll)))

(defsubst c-rgb-mate (c)
  "Check rgb format color."
  (-if-let* ((li (s-match c-re-rgb c))
	     ((_ _ r g b) li)
	     (rgbl (-map 'string-to-number (list r g b)))
	     (hsll (c-rgb-hsl rgbl)))
      (-concat rgbl hsll)))

(defsubst c-hsl-mate (c)
  "Check hsl format color."
  (-if-let* ((li (s-match c-re-hsl c))
	     ((_ _ h0 s0 l0) li)
	     (hsll1 (-map 'string-to-number (list h0 s0 l0)))
	     ((h1 s1 l1) hsll1)
	     (h (/ h1 360.0))
	     (s (/ s1 100.0))
	     (l (/ l1 100.0))
	     (hsll (list h s l))
	     (rgbl (c-hsl-rgb hsll)))
      (-concat rgbl hsll)))

(defsubst c-mate (c)
  "Convert color value to color mate date."
  (--first
   (not (eq it nil))
   (--map (funcall it c)
	  (list
	    'c-hex-mate
	    'c-shex-mate
	    'c-rgb-mate
	    'c-hsl-mate))))

;;
;; Output color
;;
(defun c-round-float (n)
  "Round float to per cent."
  (round (* n 100)))

(defun c-hex-fmt (m)
  "Output hex color."
  (-let (((r g b) m))
    (format "#%x%x%x" r g b)))

(defun c-rgb-fmt (m)
  "Output rgb color."
  (-let (((r g b) m))
    (format "rgb(%d, %d, %d)" r g b)))

(defun c-hsl-fmt (m)
  "Output hsl color."
  (-let (((_ _ _ h s l) m))
    (format "hsl(%d, %d%%, %d%%)"
	    (round h)
	    (c-round-float s)
	    (c-round-float l))))

(defun c-color (c fmt)
  "Convert color hex|rgb|hsl"
  (interactive)
  (funcall
   (plist-get
    '(hex c-hex-fmt rgb c-rgb-fmt hsl c-hsl-fmt)
    (intern fmt))
   (c-mate c)))


;;
;; Color value change loop.
;; 
(defvar c-trun-list '("hex" "rgb" "hsl") "List for color format change.")
(defvar c-trun-dir "next" "Direction of color change trun.")

(defun c-hex-flag (c)
  "Make hex color flag."
  (when (s-match c-re-hex c) "hex"))

(defun c-shex-flag (c)
  "Make short hexc color flag."
  (when (s-match c-re-shex c) "hex"))

(defun c-rgb-flag (c)
  "Make rgb color flag."
  (when (s-match c-re-rgb c) "rgb"))

(defun c-hsl-flag (c)
  "Make hsl color flag."
  (when (s-match c-re-hsl c) "hsl"))

(defun c-flag (c)
  "Make color flag."
  (--first
   (not (eq it nil))
   (--map (funcall it c)
	  (list
	   'c-hex-flag
	   'c-rgb-flag))))

(defun c-next (flag trun-list)
  "Next flag form trun list."
  (-let* ((current flag)
	  (len (length trun-list))
	  (idx (-elem-index current trun-list))
	  (cidx (if (>= (1+ idx) len) 0 (1+ idx))))
    (nth cidx trun-list)))

(defun c-prev (flag trun-list)
  "Prev flag form trun list."
  (-let* ((current flag)
	  (len (length trun-list))
	  (idx (-elem-index current trun-list))
	  (cidx (if (< (1- idx) 0) (1- len) (1- idx))))
    (nth cidx trun-list)))

(defun c-trun (c)
  "Change color format."
  (interactive)
  (-let* ((flag (c-flag c))
	  (dir (if  (string= c-trun-dir "prev") 'c-prev 'c-next))
	  (flag-trun (funcall dir flag c-trun-list)))

    (c-color c flag-trun)
    ))

(c-trun "#d32f2f")
(c-trun "rgb(211, 47, 47)")


;; func
(defun c-darken (c)
  ""
  )
(defun c-lighten (c)
  ""
  )


(provide 'c)

;;; c.el end here.
