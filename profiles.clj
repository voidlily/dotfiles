{:user
  {:dependencies [[clj-stacktrace "0.2.8"]]
   :injections   [(let [orig (ns-resolve (doto 'clojure.stacktrace require)
                                         'print-cause-trace)
                        new (ns-resolve (doto 'clj-stacktrace.repl require)
                                        'pst)]
                    (alter-var-root orig (constantly (deref new))))]
   :plugins      [
                  [codox "0.10.3"]
                  [lein-marginalia "0.9.1"]
                  [lein-try "0.4.3"]
                  [lein-kibit "0.1.6"]
                  [lein-ancient "0.6.15"]
                  [lein-licenses "0.2.2"]
                  [jonase/eastwood "0.2.5"]
                  [lein-pprint "1.2.0"]
                  [lein-exec "0.3.7"]
                  [lein-simpleton "1.3.0"]
                  ]
   }}
