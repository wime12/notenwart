;;;; notenwart.lisp.newest

(in-package #:notenwart)

(defvar *notenwart*
  (merge-pathnames "data/notenwart.db" *notenwart-system-path*))

(defclass autoincrement-mixin ()
  ())

(defmethod insert-record :after ((instance autoincrement-mixin)
				 &optional (database *default-database*))
  (declare (ignore database))
  (unless (id instance)
    (setf (id instance) (last-insert-rowid))))

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

