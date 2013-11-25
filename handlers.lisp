(in-package #:notenwart)

(defvar *jquery-path*
  (merge-pathnames
   (make-pathname :directory "resources"
		  :name "jquery-2.0.3.min"
		  :type "js")
   *notenwart-system-path*))

(defmacro standard-page ((title) &body body)
  `(with-html-output-to-string (*standard-output* nil :prologue t :indent t)
     (:html
      :xmlns "http://www.w3.org/1999/xhtml"
      :xml\:lang "en"
      :lang "en"
      (:head
       (:meta :http-equiv "Content-Type"
	      :content "text/html;charset=utf-8")
       (:title ,title)
       (:link :type "text/css"
	      :rel "stylesheet"
	      :href "/notenwart/notenwart.css"))
      (:body
       (:script :src "/jquery.js" :type "text/javascript")
       #+nil(:script (str
		 (ps
		   (setf (@ window onload)
			 (lambda ()
			   (alert "Welcome!"))))) )
       (:div :id "header"
	     (:img :src "/logo.jpg"
		   :alt "Notenwart"
		   :class "logo")
	     (:span :class "strapline"
		    "A system to manage sheet music"))
       (:div :id "toolbar"
	     ((:p :class "toolbar")
	      "[" (:a :href "/notenwart/new-composer" "New Composer") "] "
	      "[" (:a :href "/notenwart/list-composers" "Composers") "] "
	      "[" (:a :href "/notenwart/list-users" "Users") "] "))
       ,@body))))

(define-easy-handler (notenwart :uri "/notenwart") ()
  (standard-page ("Main Page")))

(define-easy-handler (new-composer :uri "/notenwart/new-composer") ()
  "Page to create an new composer and put her into the database."
  (standard-page ("Add a composer")
    (:h1 "Add a new composer")
    (:form :action "/notenwart/add-composer" :method "post"
		(:p "First name"
		    (:input :type "text" :name "first-name" :class "txt"))
		(:p "Last name"
		    (:input :type "text" :name "last-name" :class "txt"))
		(:p "Details"
		    (:input :type "text" :name "details" :class "txt"))
		(:p (:input :type "submit" :value "Add" :class "btn")))))

(define-easy-handler (add-composer :uri "/notenwart/add-composer")
    (first-name last-name details)
  (with-notenwart (insert-record t (make-instance 'composer
						  :first-name first-name
						  :last-name last-name
						  :details details)))
  (redirect "/notenwart/list-composers"))

(define-easy-handler (list-composers :uri "/notenwart/list-composers") ()
  (standard-page ("All Composers")
    (:h1 "All Composers")
    (:table :border "2"
     (:tr (:th "First name") (:th "Last name") (:th "Details"))
     (with-notenwart
       (with-open-query (q 'composer)
	 (do ((composer (read-row q nil) (read-row q nil)))
	     ((null composer))
	   (htm (:tr (:td (str (first-name composer)))
		     (:td (str (last-name composer)))
		     (:td (str (details composer)))))))))))

(define-easy-handler (list-users :uri "/notenwart/list-users") ()
  (standard-page ("All Users")
    (:h1 "All Users")
    (:table :border "2"
	    (:tr (:th "First name")
		 (:th "Last name")
		 (:th "Gender")
		 (:th "Phone number")
		 (:th "Cell number")
		 (:th "Email address")
		 (:th "Details"))
	    (with-notenwart
	      (with-open-query (q 'user)
		(do ((user (read-row q nil) (read-row q nil)))
		    ((null user))
		  (htm (:tr (:td (str (first-name user)))
			    (:td (str (last-name user)))
			    (:td (str (gender user)))
			    (:td (str (phone-number user)))
			    (:td (str (cell-number user)))
			    (:td (str (email-address user)))
			    (:td (str (details user)))))))))))



