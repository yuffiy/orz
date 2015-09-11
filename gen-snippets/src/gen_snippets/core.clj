(ns gen-snippets.core
  ;;(use 'clojure.java.io)
  (:require [gen-snippets.props :as config])
  (:gen-class))

(def out-path "./out/")

(defn join-values
  ""
  [values]
  (if values
    (clojure.string/join
     " " (map-indexed
          #(str "\\${" (inc %1) \: %2 "}") (clojure.string/split
                                      values #" ")))
    "\\$1"))

(defn replace-temp
  ""
  [temp snippet]
  (let [[key name values] snippet]
    [key (->
          temp
          (clojure.string/replace ,,, #"\{\{key\}\}" key)
          (clojure.string/replace ,,, #"\{\{name\}\}" name)
          (clojure.string/replace ,,, #"\{\{values\}\}" (join-values values)))]))

(defn gen-file!
  ""
  [snippet]
  (let [file "./resources/form.hbs"
        reader (slurp file)
        [file-name file-content] (replace-temp reader snippet)]
    (spit
     (str out-path file-name ".snippet") file-content)
    (println (str "generate " file-name ".snippet " "done!"))))



(def css-props
  [
   ;; width height line-height
   ["w" "width"]
   ["h" "height"]
   ["miw" "min-width"]
   ["mih" "min-height"]
   ["maw" "max-width"]
   ["mah" "max-height"]
   ["lh" "line-height"]
   ["w1" "width" "100%"]
   ["h1" "height" "100%"]

   ;; padding margin border
   ["p" "padding"]
   ["pt" "padding-top"]
   ["pr" "padding-right"]
   ["pb" "padding-bottom"]
   ["pl" "padding-left"]
   ["m" "margin"]
   ["mt" "margin-top"]
   ["mr" "margin-right"]
   ["mb" "margin-bottom"]
   ["ml" "margin-left"]
   ["p0" "padding" "0"]
   ["m0" "margin" "0"]
   ["ma" "margin" "auto"]
   ["m0a" "margin" "0 auto"]
   ["bd" "border"]
   ["bdt" "border-top"]
   ["bdr" "border-right"]
   ["bdb" "border-bottom"]
   ["bdl" "border-left"]
   ["bd1" "border" "1px solid #ddd"]
   ["bd1d" "border" "1px dotted #ddd"]

   ;; position float display
   ["pos" "position"]
   ["posr" "position" "relative"]
   ["posa" "position" "absolute"]
   ["t" "top"]
   ["r" "right"]
   ["b" "bottom"]
   ["l" "left"]
   ["t0" "top 0"]
   ["r0" "right 0"]
   ["b0" "bottom 0"]
   ["l0" "left 0"]
   ["z" "z-index"]
   ["z9" "z-index" "9999"]
   ["z8" "z-index" "9998"]
   ["fl" "float"]
   ["fll" "float" "left"]
   ["flr" "float" "right"]
   ["db" "display" "block"]
   ["dib" "display" "inline-block"]

   ;; text-align vertical-align
   ["ta" "text-align" "left"]
   ["tac" "text-align" "center"]
   ["tar" "text-align" "right"]
   ["vam" "vertical-align" "middle"]
   ["vat" "vertical-align" "top"]
   ["vab" "vertical-align" "bottom"]

   ;; background color opacity
   ["bg" "background"]
   ["bgc" "background-color"]
   ["bgi" "background-image" "url(\"\")"]
   ["bgr" "background-repeat"]
   ["bgrn" "bakcground-repeat" "no-repeat"]
   ["bgs" "bakcground-size"]
   ["c" "color"]
   ["bdc" "border-color"]
   ["op" "opacity"]
   ["op1" "opacity" "1"]
   ["op0" "opacity" "0"]

   ;; font text space
   ["fz" "font-size"]
   ["fz+" "font-size" "1.125em"]
   ["fz-" "font-size" "0.875em"]
   ["fw" "font-weight"]
   ["fwb" "font-weight" "bolder"]
   ["fwn" "font-weight" "normal"]
   ["fs" "font-style"]
   ["fsi" "font-style" "italic"]
   ["fsn" "font-style" "normal"]
   ["td" "text-decoration"]
   ["tdn" "text-decoration" "none"]
   ["tdu" "text-decoration" "normal"]
   ["ls" "letter-space"]
   ["ws" "white-space"]
   ["wsn" "white-space" "nowrap"]

   ;; reset
   ["bdn" "border" "none"]
   ["bgn" "background" "transparent"]
   ["box" "box-sizing" "border-box"]
   ["o0" "outline" "0"]

   ;; other
   ["ov" "overflow"]
   ["ovh" "overflow" "hidden"]
   ["ovs" "overflow" "scroll"]
   ["cu" "cursor"]
   ["cup" "cursor" "pointer"]
   ["cud" "cursor" "default"]
   ["cun" "cursor" "not-allow"]
   ["pen" "pointer-events" "none"]

   ;; custom
   ;; ...
   ])

(defn -main
  "I don't do a whole lot ... yet."
  [& args]

  (loop [list config/css-props, wt! nil]
    (if (empty? list)
      (println "done!")
      (recur (next list) (gen-file! (first list))))))
