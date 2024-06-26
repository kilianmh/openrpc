(uiop:define-package #:openrpc-server/docs
  (:use #:cl)
  (:import-from #:40ants-doc
                #:defsection)
  (:import-from #:openrpc-server/api
                #:api
                #:*current-api*
                #:api-methods
                #:api-title
                #:api-version
                #:define-api)
  (:import-from #:openrpc-server
                #:define-rpc-method
                #:return-error
                #:make-info
                #:type-to-schema
                #:transform-result
                #:primitive-type-p
                #:make-clack-app
                #:debug-off
                #:debug-on
                #:slots-to-exclude
                #:app-middlewares))
(in-package #:openrpc-server/docs)


(defsection @server (:title "Server"
                     :ignore-words ("PET"))
  (openrpc-server system)
  (@defining-methods section)
  (@starting-server section)
  (@spec section)
  (@api section))


(defsection @defining-methods (:title "Defining Methods")
  "
Here is an example of openrpc-server ASDF system allows to define
JSON-RPC methods and data-structures they return.

Let's see how we can define an API for usual PetShop example.
"
  (@simple section)
  (@lists section)
  (@pagination section))


(defsection @simple (:title "Simple Example")
  "First, we will operate on usual Common Lisp class:

```
(defclass pet ()
  ((id :initarg :id
       :type integer
       :reader pet-id)
   (name :initarg :name
         :type string
         :reader pet-name)
   (tag :initarg :tag
        :type string
        :reader pet-tag)))
```

Now we can define an RPC method to create a new pet:

```
(openrpc-server:define-rpc-method create-pet (name tag)
  (:summary \"Short method docstring.\")
  (:description \"Lengthy description of the method.\")
  (:param name string \"Pet's name\"
          :description \"This is a long description of the parameter.\")
  (:param tag string \"Old param, don't use it anymore.\" :deprecated t)
  (:result pet)
  (let* ((new-id (get-new-id))
         (pet (make-instance 'pet
                             :id new-id
                             :name name
                             :tag tag)))
    (setf (gethash new-id *pets*)
          pet)
    pet))
```

Here we should explicitly specify type for each parameter and result's type.

Pay attention, the result type is PET. OPENRPC-SERVER system takes care on serializing
objects and you can retrieve an OpenRPC spec for any type, using TYPE-TO-SCHEMA generic-function:

```
CL-USER> (serapeum:toggle-pretty-print-hash-table)
T
CL-USER> (openrpc-server:type-to-schema 'pet)
(SERAPEUM:DICT
  \"type\" \"object\"
  \"properties\" (SERAPEUM:DICT
                 \"id\" (SERAPEUM:DICT
                        \"type\" \"integer\"
                       )
                 \"name\" (SERAPEUM:DICT
                          \"type\" \"string\"
                         )
                 \"tag\" (SERAPEUM:DICT
                         \"type\" \"string\"
                        )
                )
  \"required\" '(\"tag\" \"name\" \"id\")
  \"x-cl-class\" \"PET\"
  \"x-cl-package\" \"COMMON-LISP-USER\"
 )
```

This method is used to render response requests to `/openrpc.json` handle of your API.

There is also a second generic-function which transform class instance into simple datastructures
according to a scheme. For example, here is how we can serialize our pet:

```
CL-USER> (openrpc-server:transform-result
          (make-instance 'pet :name \"Bobik\"))
(SERAPEUM:DICT
  \"name\" \"Bobik\"
 ) 
CL-USER> (openrpc-server:transform-result
          (make-instance 'pet
                         :name \"Bobik\"
                         :tag \"the dog\"))
(SERAPEUM:DICT
  \"name\" \"Bobik\"
  \"tag\" \"the dog\"
 )
```
")


(defsection @lists (:title "Returning Lists")
  "To return result as a list of objects of some kind, use `(:result (list-of pet))` form:

```
(openrpc-server:define-rpc-method list-pets ()
  (:result (list-of pet))
  (retrieve-all-pets))
```
")


(defsection @starting-server (:title "Using Clack to Start Server")
  "Framework is based on Clack. Use MAKE-CLACK-APP to create an application suitable for serving with CLACK:CLACKUP.

Then just start the web application as usual.

```
(clack:clackup (make-clack-app)
               :address interface
               :port port)
```

Also, you might use any Lack middlewares. For example, here is how \"mount\" middleware can be used
to make API work on `/api/` URL path, while the main application is working on other URL paths:


```
(defparameter *app*
  (lambda (env)
    '(200 (:content-type \"text/plain\") (\"Hello, World!\"))))

(clack:clackup
 (lambda (app)
   (funcall (lack.util:find-middleware :mount)
            app
            \"/api\"
            (make-clack-app)))
 *app*)
```
")


(defsection @pagination (:title "Paginated Results")
  "Sometimes your system might operate on a lot of objects and you don't want to return all of them at once.
For this case, framework supports a [keyset pagination](https://use-the-index-luke.com/no-offset). To use
it, your method should accept LIMIT argument and PAGE-KEY argument. And if there are more results, than
method should return as a second value the page key for retrieving the next page.

In this simplified example, we'll return `(list 1 2 3)` for the first page, `(list 4 5 6)` for the second and
`(list 7 8)` for the third. Pay attention how VALUES form is used for first two pages but omitted for the third:

```
(openrpc-server:define-rpc-method list-pets (&key (limit 3) page-key)
  (:param limit integer)
  (:param page-key integer)
  (:result (paginated-list-of integer))

  (cond
    ((null page-key)
     (values (list 1 2 3)
             3))
    ((= page-key 3)
     (values (list 4 5 6)
             6))
    (t
      (list 7 8))))
```

Of cause, in the real world application, you should use PAGE-KEY and LIMIT arguments in the WHERE SQL clause.
")


(defsection @spec (:title "OpenRPC Spec"
                   :ignore-words ("OpenRPC spec"))
  "The key feature of the framework, is an automatic [OpenRPC spec][spec] generation.

When you have your API up and running, spec will be available on `/openrpc.json` path.
For our example project it will looks like:

```json
{
  \"methods\": [
    {
      \"name\": \"rpc.discover\",
      \"params\": [],
      \"result\": {
        \"name\": \"OpenRPC Schema\",
        \"schema\": {
          \"$ref\": \"https://raw.githubusercontent.com/open-rpc/meta-schema/master/schema.json\"
        }
      }
    },
    {
      \"name\": \"list-pets\",
      \"params\": [
        {
          \"name\": \"page-key\",
          \"schema\": {
            \"type\": \"integer\"
          }
        },
        {
          \"name\": \"limit\",
          \"schema\": {
            \"type\": \"integer\"
          }
        }
      ],
      \"result\": {
        \"name\": \"list-pets-result\",
        \"schema\": {
          \"type\": \"object\",
          \"properties\": {
            \"items\": {
              \"type\": \"array\",
...
```


")



(defsection @api (:title "API"
                  :ignore-words ("SERAPEUM:DICT")
                  ;; TODO: investigate why
                  ;; this does not work for docstring of transform-result generic-function
                  :external-links (("SERAPEUM:DICT" . "https://github.com/ruricolist/serapeum/blob/master/REFERENCE.md#dict-rest-keys-and-values")))
  (api class)
  (*current-api* variable)
  (define-api macro)
  (api-methods (reader api))
  (api-title (reader api))
  (api-version (reader api))
  
  (define-rpc-method macro)
  (type-to-schema generic-function)
  (transform-result generic-function)
  (primitive-type-p generic-function)
  (make-info generic-function)
  (return-error function)
  (make-clack-app generic-function)
  (app-middlewares generic-function)
  (debug-on function)
  (debug-off function)
  (slots-to-exclude generic-function))
