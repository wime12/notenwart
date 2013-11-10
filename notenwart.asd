;;;; notenwart.asd.newest

(asdf:defsystem #:notenwart
  :serial t
  :description "Describe notenwart here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:HUNCHENTOOT #:WM-SQLITE)
  :components ((:file "package")
	       (:file "schemas")
	       #+nil (:file "topological-sort")
               (:file "notenwart")))

(defpackage #:notenwart-configuration
  (:export #:*notenwart-system-path*))

(defparameter notenwart-configuration:*notenwart-system-path*
  (make-pathname :name nil :type nil :defaults *load-truename*))
