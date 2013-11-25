;;;; notenwart.asd.newest

(asdf:defsystem #:notenwart
  :serial t
  :description "Describe notenwart here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:hunchentoot #:wm-sqlite #:cl-who #:parenscript)
  :components ((:file "package")
	       (:file "notenwart")
	       (:file "schemas")
	       (:file "handlers")
	       (:file "server")))

(defpackage #:notenwart-configuration
  (:export #:*notenwart-system-path*))

(defparameter notenwart-configuration:*notenwart-system-path*
  (make-pathname :name nil :type nil :defaults *load-truename*))
