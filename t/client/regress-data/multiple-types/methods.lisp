((defgeneric example
     (openrpc-client/core::client name)
   (:documentation "Example method."))
 (defmethod example ((openrpc-client/core::client the-class) (name string))
   (let* ((#:g1
           (let ((openrpc-client/core::args (make-hash-table :test 'equal)))
             (setf (gethash "name" openrpc-client/core::args) name)
             openrpc-client/core::args)))
     (labels ((openrpc-client/core::retrieve-data (openrpc-client/core::args)
                (let ((openrpc-client/core::raw-response
                       (openrpc-client/core::rpc-call
                        openrpc-client/core::client "example"
                        openrpc-client/core::args)))
                  openrpc-client/core::raw-response)))
       (openrpc-client/core::retrieve-data #:g1))))
 (defmethod example ((openrpc-client/core::client the-class) (name null))
   (let* ((#:g2
           (let ((openrpc-client/core::args (make-hash-table :test 'equal)))
             (setf (gethash "name" openrpc-client/core::args) name)
             openrpc-client/core::args)))
     (labels ((openrpc-client/core::retrieve-data (openrpc-client/core::args)
                (let ((openrpc-client/core::raw-response
                       (openrpc-client/core::rpc-call
                        openrpc-client/core::client "example"
                        openrpc-client/core::args)))
                  openrpc-client/core::raw-response)))
       (openrpc-client/core::retrieve-data #:g2))))
 (defgeneric example2
     (openrpc-client/core::client param1)
   (:documentation "Example method."))
 (defmethod example2 ((openrpc-client/core::client the-class) (param1 null))
   (let* ((#:g3
           (let ((openrpc-client/core::args (make-hash-table :test 'equal)))
             (setf (gethash "param1" openrpc-client/core::args) param1)
             openrpc-client/core::args)))
     (labels ((openrpc-client/core::retrieve-data (openrpc-client/core::args)
                (let ((openrpc-client/core::raw-response
                       (openrpc-client/core::rpc-call
                        openrpc-client/core::client "example2"
                        openrpc-client/core::args)))
                  openrpc-client/core::raw-response)))
       (openrpc-client/core::retrieve-data #:g3))))
 (defmethod example2 ((openrpc-client/core::client the-class) (param1 (eql t)))
   (let* ((#:g4
           (let ((openrpc-client/core::args (make-hash-table :test 'equal)))
             (setf (gethash "param1" openrpc-client/core::args) param1)
             openrpc-client/core::args)))
     (labels ((openrpc-client/core::retrieve-data (openrpc-client/core::args)
                (let ((openrpc-client/core::raw-response
                       (openrpc-client/core::rpc-call
                        openrpc-client/core::client "example2"
                        openrpc-client/core::args)))
                  openrpc-client/core::raw-response)))
       (openrpc-client/core::retrieve-data #:g4))))
 (defmethod example2
            ((openrpc-client/core::client the-class) (param1 hash-table))
   (let* ((#:g5
           (let ((openrpc-client/core::args (make-hash-table :test 'equal)))
             (setf (gethash "param1" openrpc-client/core::args) param1)
             openrpc-client/core::args)))
     (labels ((openrpc-client/core::retrieve-data (openrpc-client/core::args)
                (let ((openrpc-client/core::raw-response
                       (openrpc-client/core::rpc-call
                        openrpc-client/core::client "example2"
                        openrpc-client/core::args)))
                  openrpc-client/core::raw-response)))
       (openrpc-client/core::retrieve-data #:g5)))))
