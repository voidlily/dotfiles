{:user
  {:dependencies [[clj-stacktrace "0.2.7"]]
   :injections   [(let [orig (ns-resolve (doto 'clojure.stacktrace require)
                                         'print-cause-trace)
                        new (ns-resolve (doto 'clj-stacktrace.repl require)
                                        'pst)]
                    (alter-var-root orig (constantly @new)))]
   :plugins      [[codox "0.6.4"]
                  [lein-marginalia "0.7.1"]
                  [lein-try "0.3.2"]
                  [lein-ancient "0.4.4"]]}}