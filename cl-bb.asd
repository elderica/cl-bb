; vim: set syntax=lisp ts=2 sw=2 et :

(defsystem "cl-bb"
  :version "0.0.1"
  :description "BusyBox in Common Lisp"
  :license "MIT"
  :author "Kazuki Shigemichi"
  :class :package-inferred-system
  :depends-on ("unix-opts"
               "cl-bb/pwd"))
