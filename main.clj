;; read config
;; read template
;; match map
;; replace template
;; white file out path

;;(ns css.snippets)
;;(:require [clojure.string as string])
(def out-path "~/.emacs.d/snippets/")

;; [key name valus..]
(defn replace-temp
  "replace template."
  [temp props]
  (let [[key name & values] props]
    (-> 
     (string/replace temp #"({{key}})" "key")
     (string/replace temp #"({{name}})" "name")
     (string/replace temp #"({{values}})" (reduce #((str "${1:" % "}")) values)))))
