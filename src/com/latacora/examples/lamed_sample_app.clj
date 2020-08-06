(ns com.latacora.examples.lamed-sample-app
  (:require
   [clojure.java.io :as io]
   [com.latacora.lamed :as l]
   [cheshire.core :as json])
  (:gen-class
   :implements [com.amazonaws.services.lambda.runtime.RequestStreamHandler]))

(defn- handle-request
  "do something with the received lambda request"
  [in-stream out-stream context]
  (let [in-str (slurp in-stream)
        in-json (json/parse-string in-str true)
        out-json (assoc in-json :an-extra-key "This was added to the input!")]
      (with-open [writer (io/writer out-stream)]
        (json/generate-stream out-json writer))))

(defn -handleRequest
  "java/uberjar handler"
  [this in-stream out-stream context]
  (handle-request in-stream out-stream context))

(defn -main
  "set up lamed handler by passing your lambda handler to l/delegate!"
  []
  (l/delegate! handle-request))
