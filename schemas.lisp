(in-package #:notenwart)

(defclass library (autoincrement-mixin)
  ((id
    :persistence :integer :primary-key :autoincrement
    :column-name "library_id"
    :accessor id :initarg :id
    :initform nil)
   (address-id
    :persistence :integer
    :column-name "library_address_id"
    :accessor address-id :initarg :address-id)
   (name
    :persistence :text
    :column-name "library_name"
    :accessor name :initarg :name)
   (details
    :persistence :text
    :column-name "library_details"
    :accessor library-details :initarg :details
    :initform nil))
  (:table-name "libraries")
  (:foreign-keys (address address-id id))
  (:metaclass sqlite-persistent-class))

(defmethod print-object ((instance library) stream)
  (print-unreadable-object (instance stream :type t :identity t)
    (format stream "~A ~A" (id instance) (name instance))))

(defclass user (autoincrement-mixin)
  ((id
    :persistence :integer :primary-key :autoincrement
    :column-name "member_id"
    :accessor id :initarg :id
    :initform nil)
   (address-id
    :persistence :integer
    :column-name "member_address_id"
    :accessor address-id :initarg :address-id)
   (gender
    :persistence :text
    :accessor gender :initarg :gender)
   (first-name
    :persistence :text
    :column-name "member_first_name"
    :accessor first-name :initarg :first-name)
   (last-name
    :persistence :text
    :column-name "member_last_name"
    :accessor last-name :initarg :last-name)
   (email-address
    :persistence :text
    :accessor email-address :initarg :email-address
    :initform nil)
   (phone-number
    :persistence :text
    :accessor phone-number :initarg :phone-number
    :initform nil)
   (cell-number
    :persistence :text
    :accessor cell-number :initarg :cell-number
    :initform nil)
   (details
    :persistence :text
    :column-name "other_member_details"
    :accessor details :initarg :details
    :initform nil))
  (:table-name "members")
  (:foreign-keys (address address-id id))
  (:metaclass sqlite-persistent-class))

(defmethod print-object ((instance user) stream)
  (print-unreadable-object (instance stream :type t :identity t)
    (format stream "~A ~A ~A"
	    (id instance) (first-name instance) (last-name instance))))

(defclass address (autoincrement-mixin)
  ((id
    :persistence :integer :primary-key :autoincrement
    :column-name "address_id"
    :accessor id :initarg :id
    :initform nil)
   (line-1
    :persistence :text
    :column-name "line_1_number_building"
    :accessor line-1 :initarg :line-1
    :initform nil)
   (street-and-number
    :persistence :text
    :column-name "line_2_number_street"
    :accessor street-and-number :initarg :street-and-number)
   (line-3
    :persistence :text
    :column-name "line_3_number_area_locality"
    :accessor line-3 :initarg :line-3
    :initform nil)
   (city
    :persistence :text
    :accessor city :initarg :city)
   (zip
    :persistence :text
    :column-name "zip_postcode"
    :accessor zip :initarg :zip)
   (state-province-county
    :persistence :text
    :accessor state-province-county :initarg :state-province-county
    :initform nil)
   (country
    :persistence :text
    :accessor country :initarg :country
    :initform nil)
   (details
    :persistence :text
    :column-name "other_address_details"
    :accessor details :initarg :details
    :initform nil))
  (:metaclass sqlite-persistent-class)
  (:table-name "addresses"))

(defmethod print-object ((instance address) stream)
  (print-unreadable-object (instance stream :type t :identity t)
    (format stream "~A ~A, ~A ~A"
	    (id instance)
	    (street-and-number instance)
	    (zip instance)
	    (city instance))))

(defclass user-request (autoincrement-mixin)
  ((id
    :persistence :integer :primary-key :autoincrement
    :column-name "request_id"
    :accessor id :initarg :id
    :initform nil)
   (user-id
    :persistence :integer
    :accessor user-id :initarg :user-id)
   (sheet-music-id
    :persistence :integer
    :accessor sheet-music-id :initarg :sheet-music-id)
   (date-requested
    :persistence :text
    :accessor date-requested :initarg :date-requested)
   (date-located
    :persistence :text
    :accessor date-located :initarg :date-located
    :initform nil)
   (details
    :persistence :text
    :column-name "other_request_details"
    :accessor details :initarg :details
    :initform nil))
  (:foreign-keys (user user-id id)
		 (sheet-music sheet-music-id id))
  (:table-name "member_requests")
  (:metaclass sqlite-persistent-class))

(defmethod print-object ((instance user-request) stream)
  (print-unreadable-object (instance stream :type t :identity t)
    (format stream "~A :user-id ~A :sheet-music-id ~A"
	    (id instance)
	    (user-id instance)
	    (sheet-music-id instance))))

(defclass sheet-music (autoincrement-mixin)
  ((id
    :persistence :integer :primary-key :autoincrement
    :column-name "sheet_music_id"
    :accessor id :initarg :id
    :initform nil)
   (genre-code
    :persistence :integer
    :accessor genre-code :initarg :genre-code)
   (isbn
    :persistence :text
    :accessor isbn :initarg :isbn
    :initform nil)
   (date-of-publication
    :persistence :text
    :accessor date-of-publication :initarg :date-of-publication
    :initform nil)
   (title
    :persistence :text
    :column-name "music_title"
    :accessor title :initarg :title)
   (description
    :persistence :text
    :column-name "music_description"
    :accessor description :initarg :description
    :initform nil)
   (details
    :persistence :text
    :column-name "other_details"
    :accessor details :initarg :details
    :initform nil))
  (:foreign-keys (music-genre genre-code genre-code))
  (:table-name "sheet_music")
  (:metaclass sqlite-persistent-class))

(defmethod print-object ((instance sheet-music) stream)
  (print-unreadable-object (instance stream :type t :identity t)
    (format stream "~A ~A" (id instance) (title instance))))

(defclass music-at-libraries ()
  ((sheet-music-id
    :persistence :integer
    :accessor sheet-music-id :initarg :sheet-music-id)
   (library-id
    :persistence :integer
    :accessor library-id :initarg :library-id)
   (quantity-in-stock
    :persistence :integer
    :accessor quantity-in-stock :initarg :quantity-in-stock))
  (:foreign-keys (sheet-music sheet-music-id id)
		 (library library-id id))
  (:table-name "music_at_libraries")
  (:metaclass sqlite-persistent-class))

(defmethod print-object ((instance music-at-libraries) stream)
  (print-unreadable-object (instance stream :type t :identity t)
    (format stream "~A :library-id ~A :sheet-music-id ~A"
	    (id instance) (library-id instance) (sheet-music-id instance))))

(defclass music-genre (autoincrement-mixin)
  ((genre-code
    :persistence :integer :primary-key :autoincrement
    :accessor genre-code :initarg :genre-code
    :initform nil)
   (name
    :persistence :text
    :column-name "genre_name"
    :accessor name :initarg :name))
  (:metaclass sqlite-persistent-class)
  (:table-name "music_genres"))

(defmethod print-object ((instance music-genre) stream)
  (print-unreadable-object (instance stream :type t :identity t)
    (format stream "~A ~A" (id instance) (name instance))))

(defclass event (autoincrement-mixin)
  ((id
    :persistence :integer :primary-key :autoincrement
    :column-name "event_id"
    :accessor id :initarg :id
    :initform nil)
   (name
    :persistence :text
    :column-name "event_name"
    :accessor name :initarg :name)
   (description
    :persistence :text
    :column-name "event_description"
    :accessor description :initarg :description
    :initform nil)
   (start-datetime
    :persistence :text
    :column-name "event_start_datetime"
    :accessor start-datetime :initarg :start-datetime)
   (end-datetime
    :persistence :text
    :column-name "event_end_datetime"
    :accessor end-datetime :initarg :end-datetime)
   (details
    :persistence :text
    :column-name "other_details"
    :accessor details :initarg :details
    :initform nil))
  (:metaclass sqlite-persistent-class)
  (:table-name "events"))

(defmethod print-object ((instance event) stream)
  (print-unreadable-object (instance stream :type t :identity t)
    (format stream "~A ~A ~A"
	    (id instance)
	    (name instance)
	    (start-datetime instance))))

(defclass event-music ()
  ((event-id
    :persistence :integer
    :accessor event-id :initarg :event-id)
   (sheet-music-id
    :persistence :integer))
  (:foreign-keys (event event-id id)
		 (sheet-music sheet-music-id id))
  (:table-name "recommended_event_music")
  (:metaclass sqlite-persistent-class))

(defmethod print-object ((instance event-music) stream)
  (format stream ":event-id ~A :sheet-music-id ~A"
	  (event-id instance)
	  (sheet-music-id instance)))

(defclass music-checked-out ()
  ((user-id
    :persistence :integer :primary-key t
    :accessor user-id :initarg :user-id)
   (datetime-checked-out
    :persistence :text :primary-key t
    :accessor datetime-checked-out :initarg :datetime-checked-out)
   (sheet-music-id
    :persistence :integer :primary-key t
    :accessor sheet-music-id :initarg :sheet-music-id)
   (quantity
    :persistence :integer
    :column-name "quantity_checked_out"
    :accessor quantity :initarg :quantity)
   (datetime-returned
    :persistence :text
    :accessor datetime-returned :initarg :datetime-returned
    :initform nil))
  (:foreign-keys (user user-id id)
		 (sheet-music sheet-music-id id))
  (:metaclass sqlite-persistent-class))

(defmethod print-object ((instance music-checked-out) stream)
  (print-unreadable-object (instance stream :type t :identity t)
    (format stream ":user-id ~A :sheet-music-id ~A :checked-out ~A"
	    (user-id instance)
	    (sheet-music-id instance)
	    (datetime-checked-out instance))))

(defclass music-by-composer ()
  ((composer-id
    :persistence :integer :primary-key t
    :accessor composer-id :initarg :composer-id)
   (sheet-music-id
    :persistence :integer :primary-key t
    :accessor sheet-music-id :initarg :sheet-music-id))
  (:foreign-keys (composer composer-id id)
		 (sheet-music sheet-music-id id))
  (:metaclass sqlite-persistent-class))

(defmethod print-object ((instance music-by-composer) stream)
  (print-unreadable-object (instance stream :type t :identity t)
    (format stream ":composer-id ~A :sheet-music-id ~A"
	    (composer-id instance)
	    (sheet-music-id instance))))

(defclass composer (autoincrement-mixin)
  ((id
    :persistence :integer :primary-key :autoincrement
    :column-name "composer_id"
    :accessor id :initarg :id
    :initform nil)
   (first-name
    :persistence :text
    :accessor first-name :initarg :first-name)
   (last-name
    :persistence :text
    :accessor last-name :initarg :last-name)
   (details
    :persistence :text
    :column-name "other_details"
    :accessor details :initarg :details
    :initform nil))
  (:metaclass sqlite-persistent-class)
  (:table-name "composers"))

(defmethod print-object ((instance composer) stream)
  (print-unreadable-object (instance stream :identity t :type t)
    (format stream "~A ~A ~A"
	    (id instance)
	    (first-name instance)
	    (last-name instance))))

(defvar *notenwart-persistent-class-names*
  '(library user address user-request sheet-music music-at-libraries
    music-genre event event-music music-checked-out music-by-composer composer))
