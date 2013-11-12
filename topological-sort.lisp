(in-package #:notenwart)

(defun tsort (edges &key (test #'equal))
  (let* ((leaders (delete-duplicates (mapcar #'first edges) :test test))
         (followers (delete-duplicates (mapcar #'second edges) :test test))
         (neighbors (mapcar #'list leaders))
         (visited '())
         (ordering '()))
    (mapc #'(lambda (e)
	      (push (second e) (rest (assoc (first e) neighbors :test test))))
          edges)
    (labels ((dfs (v)
               (pushnew v visited :test test)
               (mapc #'(lambda (n)
			 (when (not (member n visited :test test))
			   (dfs n)))
                     (rest (assoc v neighbors :test test)))
               (push v ordering)))
      (mapc #'dfs (set-difference leaders followers :test test)))
    ordering))

(defun foreign-key-edges (schema)
  (destructuring-bind (schema-name &rest attributes) schema
      (mapcan (lambda (attribute)
		(destructuring-bind (name &key type primary-key foreign-key)
		    attribute
		  (declare (ignore name type primary-key))
		  (when foreign-key
		    (list (list schema-name (first foreign-key))))))
	      attributes)))

(defun all-foreign-key-edges (schemas)
  (mapcan #'foreign-key-edges schemas))

(defun sort-foreign-keys (schemas)
  (let ((sf (nreverse (tsort (all-foreign-key-edges schemas) :test #'string=))))
    (values
     sf
     (set-difference (mapcar #'first schemas) sf :test #'string=))))

(defun schema-sql (schema)
  (destructuring-bind (table-name &rest attributes) schema
    (with-output-to-string (*standard-output*)
      (princ table-name)
      (princ "(")
      (maplist
       (lambda (attributes)
	 (destructuring-bind (attribute-name &key type primary-key foreign-key)
	     (first attributes)
	   (princ attribute-name)
	   (when type
	     (princ " ")
	     (princ (string-downcase type)))
	   (when primary-key
	     (princ " primary key"))
	   (when foreign-key
	     (destructuring-bind (foreign-table foreign-attribute) foreign-key
	       (format t " references ~A(~A)" foreign-table foreign-attribute)))
	   (when (rest attributes)
	     (princ ", "))))
       attributes)
      (princ ")"))))

(defun create-schema (db schema)
  (exec (prepare db "create table")))
