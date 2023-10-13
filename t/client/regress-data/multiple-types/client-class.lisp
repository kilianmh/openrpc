((defclass the-class (jsonrpc/class:client) nil)
 (defun make-the-class () (make-instance 'the-class))
 (defmethod describe-object ((openrpc-client/core::client the-class) stream)
   (format stream "Supported RPC methods:~2%")
   (format stream "- ~S~%" '(example ((name string)) ((name null))))
   (format stream "- ~S~%"
           '(example2 ((param1 null)) ((param1 (eql t)))
             ((param1 hash-table))))))
