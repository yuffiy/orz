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

(defconst cc-re-hex "\\(#\\)\\([0-9a-fA-F]\\{2\\}\\)\\([0-9a-fA-F]\\{2\\}\\)\\([0-9a-fA-F]\\{2\\}\\)"
  "Regex for hex color.")
(defconst cc-re-shex "\\(#\\)\\([0-9a-fA-F]\\{1\\}\\)\\([0-9a-fA-F]\\{1\\}\\)\\([0-9a-fA-F]\\{1\\}\\)"
  "Regex for short hex color.")
(defconst cc-re-rgb "\\(rgb\\)\(\\([0-9]\\{1,3\\}\\),\s?\\([0-9]\\{1,3\\}\\),\s?\\([0-9]\\{1,3\\}\\)\s?\)"
  "Regex for rgb color.")
(defconst cc-re-hsl "\\(hsl\\)\(\\([0-9]\\{1,3\\}\\),\s?\\([0-9]\\{1,3\\}\\)\%,\s?\\([0-9]\\{1,3\\}\\)\%\s?\)"
  "Regex for hsl color.")

(defsubst cc-h-rgb (m1 m2 h0)
  "Compute hue value."
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
  "Convert rgb to hsl color."
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
  "Convert hsl to rgb color."
  ;; http://www.w3.org/TR/css3-color/#hsl-color
  (-let* (((h s l) hsl)
	  (m2 (if (<= l 0.5) (* l (1+ s)) (+ l s (- (* l s)))))
	  (m1 (- (* l 2) m2))
	  (r (cc-h-rgb m1 m2 (+ h (/ 1.0 3))))
	  (g (cc-h-rgb m1 m2 h))
	  (b (cc-h-rgb m1 m2 (- h (/ 1.0 3)))))
    (--map (round (* it 255)) (list r g b))))

(defsubst cc-hex-mate (c)
  "Convert hex format to mate."
  (-if-let* ((li (s-match cc-re-hex c))
	     ((_ _ r g b) li)
	     (rgbl (--map (string-to-number it 16) (list r g b)))
	     (hsll (cc-rgb-hsl rgbl)))
      (-concat rgbl hsll)))

(defsubst cc-shex-mate (c)
  "Convert short hex format to mate."
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
  "Convert rgb format to mate."
  (-if-let* ((li (s-match cc-re-rgb c))
	     ((_ _ r g b) li)
	     (rgbl (-map 'string-to-number (list r g b)))
	     (hsll (cc-rgb-hsl rgbl)))
      (-concat rgbl hsll)))

(defsubst cc-hsl-mate (c)
  "Convert hsl format to mate."
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
  "Convert Any color value to color mate date."
  (--first
   (not (eq it nil))
   (--map (funcall it c)
	  (list
	    'cc-hex-mate
	    'cc-shex-mate
	    'cc-rgb-mate
	    'cc-hsl-mate))))

(defsubst cc-round-float (n)
  "Round float to per cent."
  (round (* n 100)))

(defsubst cc-hex-fmt (m)
  "Output hex color."
  (-let (((r g b) m))
    (format "#%x%x%x" r g b)))

(defun cc-rgb-fmt (m)
  "Output rgb color."
  (-let (((r g b) m))
    (format "rgb(%d, %d, %d)" r g b)))

(defsubst cc-hsl-fmt (m)
  "Output hsl color."
  (-let (((_ _ _ h s l) m))
    (format "hsl(%d, %d%%, %d%%)"
	    (round (* h 360))
	    (cc-round-float s)
	    (cc-round-float l))))

(defun cc-color (c fmt)
  "Format hex|rgb|hsl color."
  (interactive)
  (funcall
   (plist-get
    '(hex cc-hex-fmt rgb cc-rgb-fmt hsl cc-hsl-fmt)
    (intern fmt))
   (cc-mate c)))

(defvar cc-turn-list '("hex" "rgb" "hsl") "List for color format change.")
(defvar cc-turn-dir "next" "Direction of color change turn.")
(defvar cc-darken-value 1 "Darken value per times.")
(defvar cc-lighten-value 1 "Lighten value per times.")

(defun cc-hex-flag (c)
  "Test hex color flag."
  (if (s-match cc-re-hex c) "hex" nil))

(defun cc-shex-flag (c)
  "Test short hexc color flag."
  (if (s-match cc-re-shex c) "hex" nil))

(defun cc-rgb-flag (c)
  "Test rgb color flag."
  (if (s-match cc-re-rgb c) "rgb" nil))

(defun cc-hsl-flag (c)
  "Test hsl color flag."
  (if (s-match cc-re-hsl c) "hsl" nil))

(defun cc-flag (c)
  "Test color flag."
  (--first
   (not (eq it nil))
   (--map (funcall it c)
	  (list
	   'cc-hex-flag
	   'cc-shex-flag
	   'cc-rgb-flag
	   'cc-hsl-flag))))

(defun cc-next (flag turn-list)
  "Next flag form turn list."
  (-let* ((current flag)
	  (len (length turn-list))
	  (idx (-elem-index current turn-list))
	  (cidx (if (>= (1+ idx) len) 0 (1+ idx))))
    (nth cidx turn-list)))

(defun cc-prev (flag turn-list)
  "Prev flag form turn list."
  (-let* ((current flag)
	  (len (length turn-list))
	  (idx (-elem-index current turn-list))
	  (cidx (if (< (1- idx) 0) (1- len) (1- idx))))
    (nth cidx turn-list)))

(defun cc-turn (c)
  "Change color format."
  (interactive)
  (-let* ((flag (cc-flag c))
	  (dir (if  (string= cc-turn-dir "prev") 'cc-prev 'cc-next))
	  (flag-turn (funcall dir flag cc-turn-list)))
    (cc-color c flag-turn)))

(defun cc-find (regexp)
  "Check current regexp."
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

(defun cc-darken-mate (c)
  "draken current color"
  (-let* ((mate (cc-mate c))
	  ((r g b h s l0) mate)
	  (d (/ cc-darken-value 100.0))
	  (l1 (- l0 d))
	  (l (if (<= l1 0) 0 l1))
	  (hsll (list h s l))
	  (rgbl (cc-hsl-rgb hsll)))
    (-concat rgbl hsll)))

(defun cc-lighten-mate (c)
  "draken current color"
  (-let* ((mate (cc-mate c))
	  ((r g b h s l0) mate)
	  (d (/ cc-lighten-value 100.0))
	  (l1 (+ l0 d))
	  (l (if (>= l1 1) 0 l1))
	  (hsll (list h s l))
	  (rgbl (cc-hsl-rgb hsll)))
    (-concat rgbl hsll)))

;;;###autoload
(defun cc-change-turn ()
  "mark color change"
  (interactive)
  (goto-char (line-beginning-position))
  ;; TODO search string

  (-let* ((re (cc-match))
	  (be (re-search-backward re (line-beginning-position) t))
	  (ed (re-search-forward re (line-end-position) t))
	  (color (buffer-substring-no-properties be ed)))
    (delete-region be ed)
    (insert (cc-turn color))))


;;;###autoload
(defun cc-change-darken ()
  "mark color change"
  (interactive)
  (goto-char (line-beginning-position))
  ;; TODO search string

  (-let* ((re (cc-match))
	  (be (re-search-backward re (line-beginning-position) t))
	  (ed (re-search-forward re (line-end-position) t))
	  (color (buffer-substring-no-properties be ed))
	  (flag (cc-flag color)))
    (delete-region be ed)
    (insert (funcall
	     (plist-get
	      '(hex cc-hex-fmt rgb cc-rgb-fmt hsl cc-hsl-fmt)
	      (intern flag))
	     (cc-darken-mate color)))))

;;;###autoload
(defun cc-change-lighten ()
  "mark color change"
  (interactive)
  (goto-char (line-beginning-position))
  ;; TODO search string

  (-let* ((re (cc-match))
	  (be (re-search-backward re (line-beginning-position) t))
	  (ed (re-search-forward re (line-end-position) t))
	  (color (buffer-substring-no-properties be ed))
	  (flag (cc-flag color)))
    (delete-region be ed)
    (insert (funcall
	     (plist-get
	      '(hex cc-hex-fmt rgb cc-rgb-fmt hsl cc-hsl-fmt)
	      (intern flag))
	     (cc-lighten-mate color)))))

(provide 'cc)
;;; c.el end here.
