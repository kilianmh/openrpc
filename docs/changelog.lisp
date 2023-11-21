(uiop:define-package #:openrpc-docs/changelog
  (:use #:cl)
  (:import-from #:40ants-doc/changelog
                #:defchangelog))
(in-package #:openrpc-docs/changelog)


(defchangelog (:ignore-words ("40ANTS-DOC"
                              "ASDF"
                              "API"
                              "CL"
                              "HTTP"
                              "JSON"
                              "RPC"
                              "OSX"))
    (0.10.2 2023-10-21
	    "
## Fix

Add necessary helpers for simple example.
")
    (0.10.1 2023-10-17
	    "
## Additions

- Support object and boolean type for required parameters.
- Add regression tests for generated DESCRIBE-OBJECT method.
")
    (0.10.0 2023-10-17
            "
## Changes

Generic-function OPENRPC-SERVER/INTERFACE:MAKE-INFO now accepts only one argument - object of class OPENRPC-SERVER/API:API.
")
  (0.9.3 2023-10-16
	 "
## Fixes

A function `generate-method-descriptions` has been added. This function uses the mop
for generating the method descriptions at run-time. Previously this happend at compile-time.
The `generate-method-descriptions` is called from the generated specialized `describe-object`
method. Now the output of `describe-object` should be correct again and show all generated,
excluding the describe-object method itself.

")
  (0.9.2 2023-10-15
	 "
## Fixes

- Generate additional method with integer class specializer (till now it was
  only double-float) for required parameter of type number.

- Allow required parameter of type array without an items slot.
  The result will not be transformed.
")
  (0.9.1 2023-09-24
         "
## Fixes

Fix support for multiple parameter types, (particularly for required parameters):

```json
\"params\": [
  {
    \"name\": \"name\",
    \"schema\":
    {
      \"type\": [\"string\", \"null\"],
      \"maxLength\": 255
    },
    \"required\": true,
    \"summary\": \"User name.\"
  }
]
```")
  (0.9.0 2023-08-19
         "
## Backward Incompatible Fixes

Fixed how `oneOf` type is processed when there are only two subtypes like that:

```json
\"oneOf\": [
  {
    \"type\": \"null\"
  },
  {
    \"type\": \"object\",
    \"properties\": {
      \"project_name\": {
        \"type\": \"object\",
        \"properties\": {},
        \"required\": [],
        \"x-cl-class\": \"T\",
        \"x-cl-package\": \"COMMON-LISP\"
      },
```

Previously in this case openrpc-client generated code which returned a hash-table.
Now it will return a common-lisp object or NIL.

")
  (0.8.0 2023-08-16
         "
## Backward Incompatible Fixes

Nested dataclasses now handled propertly in the client. Previously, nested objects were parsed as hash-maps.
")
  (0.7.1 2023-08-11
         "
## Fixes

Fixed location for autogenerated generic function and added docstrings taken from OpenRPC spec.
")
  (0.7.0 2023-08-09
         "
## Backward Incompatible Changes

- Generic-function OPENRPC-SERVER/INTERFACE:SLOTS-TO-EXCLUDE now matches slot names before transforming
  them to camel_case. Now you can return slot names as they are given in lisp classes.

## Fixes

- Now client API is generated correctly when you call OPENRPC-CLIENT:GENERATE-CLIENT macro
  with `:export-symbols nil` argument.
")
  (0.6.0 2023-06-09
         "
## Additions

- Float, Double float and Ratio types are supported. They are represented as a \"number\" type in JSON schema.
")
  (0.5.0 2023-05-27
         "
## Changes

- OPENRPC-SERVER/CLACK:MAKE-CLACK-APP now is a generic-function and it requires API instance as a first argument.
  Previously API instance was optional.

## Additions

- Added a way to modify Clack middlewares applied to the app. This way you can add your own middlewares or routes to your application. See details in the OPENRPC-SERVER/CLACK:APP-MIDDLEWARES generic-function documentation.
- Added OPENRPC-SERVER/CLACK:DEBUG-ON and OPENRPC-SERVER/CLACK:DEBUG-OFF functions. They turn on support for `X-Debug-On` HTTP header. Use this header to turn on interative debugger only for choosen requests.
- Added generic-function OPENRPC-SERVER/INTERFACE:SLOTS-TO-EXCLUDE which allows to list some slots to be hidden from all data-structures. For example, you might want to exclude password-hashes or some other sensitive information.
- Added support for `(MEMBER :foo :bar ...)` datatype. Such objects are represented as string with enum values in JSON schema.

# Fixes

- Fixes type of the next-page key in the response of paginated methods.
")
  (0.4.0 2022-11-07
         "- Fixed usage of default API when api is not specified to define-rpc-method macro.
          - Fixed most imports.")
  (0.3.0 2022-10-30
         "- Method and its params now support such metadata as :summary :description and :deprecated.
          - Schemas for CL classes can have :description if documentation id defined for class or its slots.
          - Macro OPENRPC-CLIENT:GENERATE-CLIENT now exports methods, classes and their slot readers by default.
          - All methods, their arguments and object keys now use underscore instead of dash to make them more
            convenient to use from other languages.")
  (0.2.0 2022-10-25
         "- Support client generation from a file on a filesystem.")
  (0.1.0 2022-10-13
         "- Initial version."))
