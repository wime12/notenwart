(in-package #:notenwart)

(defvar *server* (make-instance 'easy-acceptor :port 8082))

(defun start-server ()
  (start *server*))
