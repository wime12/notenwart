;;;; notenwart.lisp.newest

(in-package #:notenwart)

(defvar *notenwart*
  (merge-pathnames "data/notenwart.db" *notenwart-system-path*))

(defclass notenwart-database (statement-caching-mixin database)
  ())

(defmethod initialize-instance :after
    ((instance notenwart-database) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (exec (prepare instance "pragma foreign_keys = ON")))

(defun open-notenwart-database ()
  (open-database *notenwart* :class 'notenwart-database))

(defmacro with-notenwart (&body body)
  `(with-open-database (*default-database* *notenwart*
					   :class 'notenwart-database)
     ,@body))

