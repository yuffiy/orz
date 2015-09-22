(defproject css-snippets "0.1.0-SNAPSHOT"
  :description "Generate css snippet files."
  :url "https://github.com/blisss/orz/"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.7.0"]
                 [cheshire "5.5.0"]]
  :main ^:skip-aot css-snippets.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
