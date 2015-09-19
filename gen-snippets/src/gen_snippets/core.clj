(ns gen-snippets.core
  (:refer-clojure :exclude [replace])
  (:require [clojure.java.io :as io])
  (:use [clojure.string :only (replace split join)])
  (:require [gen-snippets.props :as config])
  (:require [cheshire.core :refer :all])
  (:gen-class))

;(def out-path "./out/")

;(defn join-values
;  ""
;  [values]
;  (if values
;    (clojure.string/join
;     " " (map-indexed
;          #(str "\\${" (inc %1) \: %2 "}") (clojure.string/split
;                                      values #" ")))
;    "\\$1"))

;(defn replace-temp
;  ""
;  [temp snippet]
;  (let [[key name values] snippet]
;    [key (->
;          temp
;          (clojure.string/replace ,,, #"\{\{key\}\}" key)
;          (clojure.string/replace ,,, #"\{\{name\}\}" name)
;          (clojure.string/replace ,,, #"\{\{values\}\}" (join-values values)))]))

;(defn gen-file!
;  ""
;  [snippet]
;  (let [file "./resources/form.hbs"
;        reader (slurp file)
;        [file-name file-content] (replace-temp reader snippet)]
;    (spit
;     (str out-path file-name ".snippet") file-content)
;    (println (str "generate " file-name ".snippet " "done!"))))


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
      (->> values
       (.split #"\s")
       (map-indexed #(str "\\${" (inc %1) \: %2 "}"))
       (join #" "))
      "\\$1"))


(defn -main
  "Main"
  [& args]

  ;;(loop [list config/css-props, wt! nil]
  ;;  (if (empty? list)
  ;;    (println "done!")
  ;;    (recur (next list) (gen-file! (first list)))))
  
  (println helper)

  (if-let [out-path (first args)]

    (dir-exist?
     out-path
     (let [template (slurp "./resources/form.hbs")
           snippets (parse-string (slurp "./resources/snippets.json") true)]       

       (doseq [[key [name values]] snippets]

         (spit (str out-path "/" (replace key #":" "") ".snippet") (-> template
             (replace ,,, #"\{\{key\}\}" (replace key #":" ""))
             (replace ,,, #"\{\{name\}\}" name)
             (replace ,,, #"\{\{values\}\}" (replace-values values))
              
             ))
         )
       ))
    
    )
  )

;; helper info
;; check path name
;; read template file
;; map snippets list ( replace temp -> write files )
