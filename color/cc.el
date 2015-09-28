;;; cc.el color change for css.

;; Copyright (C) 2012-2015 Free Software Foundation, Inc.

;; Author: Yufi <yfhj1990@hotmail.com>
;; Version: 0.0.1
;; Keywords: color css


;; TODO rgba hsla

;;; Code:

(require 'dash)
(require 'dash-functional)
(require 's)

(defvar cc-re-hex "\\(#\\)\\([0-9a-fA-F]\\{2\\}\\)\\([0-9a-fA-F]\\{2\\}\\)\\([0-9a-fA-F]\\{2\\}\\)"
  "Regex for hex color.")
(defvar cc-re-shex "\\(#\\)\\([0-9a-fA-F]\\{1\\}\\)\\([0-9a-fA-F]\\{1\\}\\)\\([0-9a-fA-F]\\{1\\}\\)"
  "Regex for short hex color.")
(defvar cc-re-rgb "\\(rgb\\)\(\\([0-9]\\{1,3\\}\\),\s?\\([0-9]\\{1,3\\}\\),\s?\\([0-9]\\{1,3\\}\\)\s?\)"
  "Regex for rgb color.")
(defvar cc-re-hsl "\\(hsl\\)\(\\([0-9]\\{1,3\\}\\),\s?\\([0-9]\\{1,3\\}\\)\%,\s?\\([0-9]\\{1,3\\}\\)\%\s?\)"
  "Regex for hsl color.")

;;
;; Convert with rgb color and hsl color.
;;
(defsubst cc-h-rgb (m1 m2 h0)
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

(defsubst cc-rgb-hsl (rgb)
  "Convert rgb to hsl."
  ;; http://en.wikipedia.org/wiki/HSL_and_HSV#Conversion_from_RGB_to_HSL_or_HSV
  (-let* ((rgbl (--map (/ it 255.0) rgb))
	  (ma (-max rgbl))
	  (mi (-min rgbl))
	  (d (- ma mi))
	  ((r g b) rgbl)
	  (h (/ (cadr (--max-by
	      (> (car it) (car other))
	      (list
	       (list mi 0)
	       (list r (+ (if (< g b) 6 0) (* (- g b) (/ 1 d))))
	       (list g (+ 2 (* (- b r) (/ 1 d))))
	       (list b (+ 4 (* (- r g) (/ 1 d))))))) 6))
	  (l (/ (+ ma mi) 2))
	  (s (if (< l 0.5) (/ d 2 (/ 1 l)) (/ d (- 2 (* 2 l))))))
    (list h s l)))

(defsubst cc-hsl-rgb (hsl)
  "Convert hsl to rgb."
  ;; http://www.w3.org/TR/css3-color/#hsl-color
  (-let* (((h s l) hsl)
	  (m2 (if (<= l 0.5) (* l (1+ s)) (+ l s (- (* l s)))))
	  (m1 (- (* l 2) m2))
	  (r (cc-h-rgb m1 m2 (+ h (/ 1.0 3))))
	  (g (cc-h-rgb m1 m2 h))
	  (b (cc-h-rgb m1 m2 (- h (/ 1.0 3)))))
    (--map (round (* it 255)) (list r g b))))

;;
;; Convert color to mate date
;;
(defsubst cc-hex-mate (c)
  "Check hex format color."
  (-if-let* ((li (s-match cc-re-hex c))
	     ((_ _ r g b) li)
	     (rgbl (--map (string-to-number it 16) (list r g b)))
	     (hsll (cc-rgb-hsl rgbl)))
      (-concat rgbl hsll)))

(defsubst cc-shex-mate (c)
  "Check short hex format color."
  (-if-let* ((li (s-match cc-re-shex c))
	     ((_ _ r g b) li)
	     (rgbl (--map
		    (string-to-number it 16)
		    (list
		     (format "%s%s" r r)
		     (format "%s%s" g g)
		     (format "%s%s" b b))))
	     (hsll (cc-rgb-hsl rgbl)))
      (-concat rgbl hsll)))

(defsubst cc-rgb-mate (c)
  "Check rgb format color."
  (-if-let* ((li (s-match cc-re-rgb c))
	     ((_ _ r g b) li)
	     (rgbl (-map 'string-to-number (list r g b)))
	     (hsll (cc-rgb-hsl rgbl)))
      (-concat rgbl hsll)))

(defsubst cc-hsl-mate (c)
  "Check hsl format color."
  (-if-let* ((li (s-match cc-re-hsl c))
	     ((_ _ h0 s0 l0) li)
	     ((h1 s1 l1) (-map 'string-to-number (list h0 s0 l0)))
	     (h (/ h1 360.0))
	     (s (/ s1 100.0))
	     (l (/ l1 100.0))
	     (hsll (list h s l))
	     (rgbl (cc-hsl-rgb hsll)))
      (-concat rgbl hsll)))


(defsubst cc-mate (c)
  "Convert color value to color mate date."
  (--first
   (not (eq it nil))
   (--map (funcall it c)
	  (list
	    'cc-hex-mate
	    'cc-shex-mate
	    'cc-rgb-mate
	    'cc-hsl-mate))))

;;
;; Output color
;;
(defun cc-round-float (n)
  "Round float to per cent."
  (round (* n 100)))

(defun cc-hex-fmt (m)
  "Output hex color."
  (-let (((r g b) m))
    (format "#%x%x%x" r g b)))

(defun cc-rgb-fmt (m)
  "Output rgb color."
  (-let (((r g b) m))
    (format "rgb(%d, %d, %d)" r g b)))

(defun cc-hsl-fmt (m)
  "Output hsl color."
  (-let (((_ _ _ h s l) m))
    (format "hsl(%d, %d%%, %d%%)"
	    (round (* h 360))
	    (cc-round-float s)
	    (cc-round-float l))))

(defun cc-color (c fmt)
  "Convert color hex|rgb|hsl"
  (interactive)
  (funcall
   (plist-get
    '(hex cc-hex-fmt rgb cc-rgb-fmt hsl cc-hsl-fmt)
    (intern fmt))
   (cc-mate c)))

;;
;; Color value change loop.
;; 
(defvar cc-trun-list '("hex" "rgb" "hsl") "List for color format change.")
(defvar cc-trun-dir "next" "Direction of color change trun.")

(defun cc-hex-flag (c)
  "Make hex color flag."
  (if (s-match cc-re-hex c) "hex" nil))

(defun cc-shex-flag (c)
  "Make short hexc color flag."
  (if (s-match cc-re-shex c) "hex" nil))

(defun cc-rgb-flag (c)
  "Make rgb color flag."
  (if (s-match cc-re-rgb c) "rgb" nil))

(defun cc-hsl-flag (c)
  "Make hsl color flag."
  (if (s-match cc-re-hsl c) "hsl" nil))

(defun cc-flag (c)
  "Make color flag."
  (--first
   (not (eq it nil))
   (--map (funcall it c)
	  (list
	   'cc-hex-flag
	   'cc-shex-flag
	   'cc-rgb-flag
	   'cc-hsl-flag))))

(defun cc-next (flag trun-list)
  "Next flag form trun list."
  (-let* ((current flag)
	  (len (length trun-list))
	  (idx (-elem-index current trun-list))
	  (cidx (if (>= (1+ idx) len) 0 (1+ idx))))
    (nth cidx trun-list)))

(defun cc-prev (flag trun-list)
  "Prev flag form trun list."
  (-let* ((current flag)
	  (len (length trun-list))
	  (idx (-elem-index current trun-list))
	  (cidx (if (< (1- idx) 0) (1- len) (1- idx))))
    (nth cidx trun-list)))

(defun cc-trun (c)
  "Change color format."
  (interactive)
  (-let* ((flag (cc-flag c))
	  (dir (if  (string= cc-trun-dir "prev") 'cc-prev 'cc-next))
	  (flag-trun (funcall dir flag cc-trun-list)))
    
    (cc-color c flag-trun)
    ))


;; func
(defun cc-darken (c)
  ""
  )
(defun cc-lighten (c)
  ""
  )


(defun cc-find (regexp)
  ""
  (when (re-search-forward regexp (line-end-position) t) regexp))

(defun cc-match ()
  "Match string."
  (--first
   (not (eq it nil))
   (--map (funcall 'cc-find it)
	  (list
	   cc-re-hex
	   cc-re-shex
	   cc-re-rgb
	   cc-re-hsl))))

;;;###autoload
(defun cc-change ()
  "mark color change"
  (interactive)
  (goto-char (line-beginning-position))
  ;; TODO search string

  (-let* ((re (cc-match))
	  (be (re-search-backward re (line-beginning-position) t))
	  (ed (re-search-forward re (line-end-position) t))
	  (color (buffer-substring-no-properties be ed)))
    (delete-region be ed)
    (insert (cc-trun color))))

(provide 'cc)

;;; c.el end here.
