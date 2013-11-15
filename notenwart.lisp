;;;; notenwart.lisp.newest

(in-package #:notenwart)

(defvar *notenwart*
  (merge-pathnames "data/notenwart.db" *notenwart-system-path*))

(defclass autoincrement-mixin ()
  ())

(defmethod insert-record ((database database)
			  (instance autoincrement-mixin))
  (call-next-method)
  (unless (id instance)
    (setf (id instance) (last-insert-rowid database)))
  instance)

(defclass notenwart-database (statement-caching-mixin database)
  ())

(defmethod initialize-instance :after
    ((instance notenwart-database) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (exec (prepare instance "pragma foreign_keys = ON")))

(defmethod open-notenwart-database ()
  (open-database *notenwart* :class 'notenwart-database))

(defmacro with-notenwart (&body body)
  `(with-open-database (*default-database* *notenwart*
					   :class 'notenwart-database)
     ,@body))



;;; "notenwart" goes here. Hacks and glory await!

