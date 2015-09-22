(ns css-snippets.core
  (:refer-clojure :exclude [replace])
  (:require [clojure.java.io :as io])
  (:use [clojure.string :only (replace split join)])
  (:require [cheshire.core :refer :all])
  (:gen-class))


(def helper "
  
-------------------------------------------------  

              Generate css snippets.

-------------------------------------------------

eg: java -jar gen-snippet.jar ~/.emacs.d/snippets/

")

(defn- dir-exist?
  "Check if dir exist"
  [path fn]
  (when-not (.isDirectory (io/file path))
    (.mkdir (io/file path)))
  fn)

(defn- replace-values
  "Replace values"
  [values]
  (if values
    ;;(->> values
    ;;   (.split #"\s")
    ;;(map-indexed #(str "\\${" (inc %1) \: %2 "}"))
    ;;      (join #" "))
    ;; if haven't values
    (str values ";`\\(newline-and-indent\\)`\\$0")
    "\\$1;`\\(newline-and-indent\\)`\\$0"))

(defn- replace-template
  "Replace template"
  [template key name values]
  (-> template
      (replace ,,, #"\{\{key\}\}" key)
      (replace ,,, #"\{\{name\}\}" name)
      (replace ,,, #"\{\{values\}\}" (replace-values values))))
      

(defn -main
  "Main"
  [& args]

  (println helper)


  (if-let [out-path (first args)]
    (dir-exist?
     out-path
     (let [template (slurp "./resources/form.hbs")
           snippets (parse-string (slurp "./resources/snippets.json") true)]

       (doseq [[keye [name values]] snippets
               :let [key (replace keye #":" "")
                     filename (str out-path "/" key ".snippet")
                     templatec (replace-template template key name values)]]

         (spit filename templatec)
         (println (str "info: file " filename " create."))


         )))))
