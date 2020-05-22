; vim: set ts=2 sw=2 et :
(uiop:define-package :cl-bb/pwd
  (:use :cl
        :uiop
        :unix-opts)
  (:shadow :describe)
  (:export :pwd))
(in-package :cl-bb/pwd)

(defparameter *flag-help* nil)
(defparameter *flag-logical* nil)

(opts:define-opts
  (:name :help
   :description "print this help"
   :short #\h
   :long "help")
  (:name :logical
   :description "use PWD from environment, even if it contains symlinks"
   :short #\L
   :long "logical")
  (:name :physical
   :description "avoid all symlinks"
   :short #\P
   :long "physical"))

(defun usage ()
  (opts:describe
    :prefix "Print the name of the current working directory."
    :usage-of "pwd"))

(defun unknown-options (condition)
  (declare (ignore condition))
  (usage)
  (invoke-restart 'opts:skip-option))

(defmacro when-option ((options opt) &body body)
  `(let ((it (getf ,options ,opt)))
     (when it
       ,@body)))

(defun getcwd-logical ()
  (let ((pwd (uiop:getenv "PWD")))
    (and pwd
         (eql (elt pwd 0) #\/)
         (search "/./" pwd)
         (search "/../" pwd)
         pwd)))

(defun pathname-as-file (name)
  (let ((pathname (pathname name)))
    (when (wild-pathname-p name)
      (error "Can't reliably convert wild pathnames."))
    (if (uiop:directory-pathname-p name)
      (let* ((directory (pathname-directory pathname))
             (name-and-type (pathname (first (last directory)))))
        (make-pathname
          :directory (butlast directory)
          :name (pathname-name name-and-type)
          :type (pathname-type name-and-type)
          :defaults pathname))
      pathname)))

(defun pwd ()
  (when *flag-help*
    (usage)
    (uiop:quit 1))
  (format t "~a~%"
    (pathname-as-file (or (and *flag-logical*
                               (getcwd-logical))
                         (or (uiop:getcwd)
                             (uiop:quit 1)))))
  (uiop:quit 0))

(defun main (&rest args)
  (declare (ignore args))
  (multiple-value-bind (options free-args)
      (handler-case
          (handler-bind ((opts:unknown-option #'unknown-options))
            (opts:get-opts)))
    (declare (ignore free-args))
    (when-option (options :help)
      (setf *flag-help* t))
    (when-option (options :logical)
      (setf *flag-logical* t)))
  (pwd))
