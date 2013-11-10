(in-package #:notenwart)

(defmacro standard-page ((title) &body body)
  `(with-html-output-to-string (*standard-output* nil :prologue t :indent t)
     (:html :xmlns "http://www.w3.org/1999/xhtml"
	    :xml\:lang "en"
	    :lang "en"
	    (:head
	     (:meta :http-equiv "Content-Type"
		    :content "text/html;charset=utf-8")
	     (:title ,title)
	     (:link :type "text/css"
		    :rel "stylesheet"
		    :href "/notenwart.css"))
	    (:body
	     (:div :id "header"
		   (:img :src "/logo.jpg"
			 :alt "Notenwart"
			 :class "logo")
		   (:span :class "strapline"
			  "A system to manage sheet music"))
	     ,@body))))

(define-easy-handler (new-composer :uri "/notenwart/new-composer") ()
  "Page to create an new composer and put her into the database."
  (standard-page ("Add a composer")
    (:h1 "Add a new composer"
	 (:form :action "/notenwart/add-composer" :method "post"
		(:p "First name"
		    (:input :type "text" :name "first-name" :class "txt"))
		(:p "Last name"
		    (:input :type "text" :name "last-name" :class "txt"))
		(:p "Details"
		    (:input :type "text" :name "details" :class "txt"))
		(:p (:input :type "submit" :value "Add" :class "btn"))))))

(define-easy-handler (add-composer :uri "/notenwart/add-composer")
    (first-name last-name details)
  (with-notenwart
    (insert-record
     (make-instance 'composer
		    :first-name first-name
		    :last-name last-name
		    :details (if (string= details "") nil details))))
  nil)
