��    X      �              �  G   �  �   �  H   w  \   �       g   0  S   �     �  �   �    �     �	  J   �	  �   
  U     �   c  A   �  n   &  :   �  #   �     �  &     Y   -  �   �  ;   )  8   e     �  T   �  �        �  3   �       R        f     �  6   �     �  b   �     -  �   A  5   �  �   
  m   �  #   ,  }   P  c   �  ;   2  S  n  5   �  �   �     �  -   �  _   �     6  O   F  8   �  {   �  �   K     6    L  h   b  �   �  k   N  T   �  V     R   f  3   �  !   �  A        Q  �   n  '     J  ?  �   �     S!  �   r"  Q   �"     K#    Y#     f$  �   y$  �   !%  �   �%  N   �&  s   �&     F'  P   W'  Q   �'  y  �'  G   t)  �   �)  H   N*  \   �*     �*  g   +  S   o+     �+  �   �+    ,     �-  J   �-  �   �-  U   �.  �   :/  A   �/  n   �/  :   l0  #   �0     �0  &   �0  Y   1  �   ^1  ;    2  8   <2     u2  T   �2  �   �2     �3  3   �3     �3  R   �3     =4     Y4  6   b4     �4  b   �4     5  �   5  5   �5  �   �5  m   �6  #   7  }   '7  c   �7  ;   	8  S  E8  5   �:  �   �:     a;  -   ;  _   �;     <  O   <  8   m<  {   �<  �   "=     >    #>  h   9?  �   �?  k   %@  T   �@  V   �@  R   =A  3   �A  !   �A  A   �A     (B  �   EB  '   �B  J  C  �   aD    *E  �   IF  Q   �F     "G    0G     =H  �   PH  �   �H  �   �I  N   ZJ  s   �J     K  P   .K  Q   K   :class:`~collections.Mapping` of context values for the current request :class:`~collections.Mapping` of request parameters, not generally useful as they're provided directly to the handler method as keyword arguments :class:`~openerp.sql_db.Cursor` initialized for the current method call. A sequence of http methods this route applies to. If not specified, all methods are allowed. ASCII token string Accessing the cursor when the current request uses the ``none`` authentication will raise an exception. Also exposes all the attributes and methods of :class:`werkzeug.wrappers.Response`. CSRF Protection CSRF protection is enabled by default and applies to *UNSAFE* HTTP methods as defined by :rfc:`7231` (all methods other than ``GET``, ``HEAD``, ``TRACE`` and ``OPTIONS``). CSRF protection is implemented by checking requests using unsafe methods for a value called ``csrf_token`` as part of the request's form data. That value is removed from the form as part of the validation and does not have to be taken in account by your own form processing. Controllers Controllers are created by :ref:`inheriting <python:tut-inheritance>` from Controllers need to provide extensibility, much like :class:`~openerp.models.Model`, but can't use the same mechanism as the pre-requisites (a database with loaded modules) may not be available yet (e.g. no database created, or no database selected). Controllers thus provide their own extension mechanism, separate from that of models: Decorator marking the decorated method as being a handler for requests. The method must be part of a subclass of ``Controller``. Defaults to ``True``. See :ref:`CSRF Protection <csrf>` for more. Forces the rendering of the response's template, sets the result as response body and unsets :attr:`.template` Generates and returns a CSRF token for the current session HTTP headers to set on the response HTTP session data Handler for the ``http`` request type. Helper for non-HTML responses, or HTML responses with custom response headers or cookies. In addition to the :class:`werkzeug.wrappers.Response` parameters, this class's constructor can take the following additional parameters for QWeb Lazy Rendering. In case of name conflict, routing parameters have priority. Indicates whether the current request is in "debug" mode Lazy render of a QWeb template. Odoo implements token-based `CSRF protection <https://en.wikipedia.org/wiki/CSRF>`_. Parent class for all Odoo Web request types, mostly deals with initialization and setup of the request object (the dispatching itself has to be handled by the subclasses) Rendering context to use Renders the Response's template, returns the result Request Request handler for `JSON-RPC 2 <http://www.jsonrpc.org/specification>`_ over HTTP Request producing a error:: Response Response object passed through controller route chain. Routing Shortcut for a `HTTP 404 <http://tools.ietf.org/html/rfc7231#section-6.5.4>`_ (Not Found) response Sucessful request:: The :class:`~openerp.api.Environment` bound to current request. Raises a :class:`RuntimeError` if the current requests is not bound to a database. The Access-Control-Allow-Origin cors directive value. The actual rendering of the given template will occur at then end of the dispatching. Meanwhile, the template and/or qcontext can be altered or even replaced by a static response. The database linked to this request. Can be ``None`` if the current request uses the ``none`` authentication. The handler method's result can be: The registry to the database linked to this request. Can be ``None`` if the current request uses the ``none`` authentication. The request object is automatically set on :data:`openerp.http.request` at the start of the request The type of authentication method, can on of the following: The type of authentication method, can on of the following:  * ``user``: The user must be authenticated and the current request   will perform using the rights of the user. * ``public``: The user may or may not be authenticated. If she isn't,   the current request will perform using the shared Public user. * ``none``: The method is always active, even if there is no   database. Mainly used by the framework and authentication   modules. There request code will not have any facilities to access   the database nor have any configuration indicating the current   database nor the current user. The type of request, can be ``'http'`` or ``'json'``. To *override* a controller, :ref:`inherit <python:tut-inheritance>` from its class and override relevant methods, re-exposing them if necessary:: Use :attr:`.session` instead. Use the ``sid`` attribute on :attr:`.session` User id to use for the ir.ui.view render call, ``None`` to use the request's user (the default) Web Controllers When adding a new controller for an unsafe method (mostly POST for e.g. forms): Whether CSRF protection should be enabled for the route. Whether CSRF protection should be enabled for the route.  Defaults to ``True``. See :ref:`CSRF Protection <csrf>` for more. While handlers can just return the HTML markup of a page they want to send as a string if non-HTML data is returned they need to create a complete response object, or the returned data will not be correctly interpreted by the clients. ``method`` is ignored ``none``: The method is always active, even if there is no database. Mainly used by the framework and authentication modules. There request code will not have any facilities to access the database nor have any configuration indicating the current database nor the current user. ``params`` must be a JSON object (not an array) and is passed as keyword arguments to the handler method ``public``: The user may or may not be authenticated. If she isn't, the current request will perform using the shared Public user. ``user``: The user must be authenticated and the current request will perform using the rights of the user. a :class:`OpenERPSession` holding the HTTP session data for the current http session a ``str`` or ``unicode``, will be wrapped in a Response object and interpreted as HTML a falsy value, in which case the HTTP response will be an `HTTP 204`_ (No Content) a werkzeug Response object, which is returned as-is a wrapped werkzeug Request object and defining methods decorated with :func:`~openerp.http.route`:: cookies to set on the client decorating with :func:`~openerp.http.route` is necessary to keep the method (and route) visible: if the method is redefined without decorating, it will be "unpublished" forwarded to werkzeug's Response object if the endpoint can be called by external parties (not from Odoo) as e.g. it is a REST API or a `webhook <https://en.wikipedia.org/wiki/Webhook>`_, CSRF protection must be disabled on the endpoint. If possible, you may want to implement other methods of request validation (to ensure it is not called by an unrelated third-party). if the form is generated in Javascript, the CSRF token is added by default to the QWeb (js) rendering context as ``csrf_token`` and is otherwise available as ``csrf_token`` on the ``web.core`` module: if the form is generated in Python, a csrf token is available via :meth:`request.csrf_token() <openerp.http.WebRequest.csrf_token`, the :data:`~openerp.http.request` object is available by default in QWeb (python) templates, it may have to be added explicitly if you are not using QWeb. matched routing parameters, query string parameters, form_ parameters and files are passed to the handler method as keyword arguments. opaque identifier for the :class:`OpenERPSession` instance of the current request response body string or array. The route part that will determine which http requests will match the decorated method. Can be a single string or an array of strings. See werkzeug's routing documentation for the format of route expression ( http://werkzeug.pocoo.org/docs/routing/ ). template to render the CSRF token should only be valid for the specified duration (in second), by default 1h, ``None`` for the token to be valid as long as the current user's session is. the decorators of all methods are combined, if the overriding method's decorator has no argument all previous ones will be kept, any provided argument will override previously defined ones e.g.:: the handler method's result is returned as JSON-RPC ``result`` and wrapped in the `JSON-RPC Response <http://www.jsonrpc.org/specification#response_object>`_ the original :class:`werkzeug.wrappers.Request` object provided to the request these attributes are available as parameters on the Response object and can be altered at any time before rendering use :attr:`.env` whether the template rendering should be deferred until the last possible moment will change ``/some_url`` from public authentication to user (requiring a log-in) Project-Id-Version: odoo 9.0
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2016-02-22 23:10-0600
PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE
Last-Translator: FULL NAME <EMAIL@ADDRESS>
Language: es
Language-Team: es <LL@li.org>
Plural-Forms: nplurals=2; plural=(n != 1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Generated-By: Babel 2.2.0
 :class:`~collections.Mapping` of context values for the current request :class:`~collections.Mapping` of request parameters, not generally useful as they're provided directly to the handler method as keyword arguments :class:`~openerp.sql_db.Cursor` initialized for the current method call. A sequence of http methods this route applies to. If not specified, all methods are allowed. ASCII token string Accessing the cursor when the current request uses the ``none`` authentication will raise an exception. Also exposes all the attributes and methods of :class:`werkzeug.wrappers.Response`. CSRF Protection CSRF protection is enabled by default and applies to *UNSAFE* HTTP methods as defined by :rfc:`7231` (all methods other than ``GET``, ``HEAD``, ``TRACE`` and ``OPTIONS``). CSRF protection is implemented by checking requests using unsafe methods for a value called ``csrf_token`` as part of the request's form data. That value is removed from the form as part of the validation and does not have to be taken in account by your own form processing. Controllers Controllers are created by :ref:`inheriting <python:tut-inheritance>` from Controllers need to provide extensibility, much like :class:`~openerp.models.Model`, but can't use the same mechanism as the pre-requisites (a database with loaded modules) may not be available yet (e.g. no database created, or no database selected). Controllers thus provide their own extension mechanism, separate from that of models: Decorator marking the decorated method as being a handler for requests. The method must be part of a subclass of ``Controller``. Defaults to ``True``. See :ref:`CSRF Protection <csrf>` for more. Forces the rendering of the response's template, sets the result as response body and unsets :attr:`.template` Generates and returns a CSRF token for the current session HTTP headers to set on the response HTTP session data Handler for the ``http`` request type. Helper for non-HTML responses, or HTML responses with custom response headers or cookies. In addition to the :class:`werkzeug.wrappers.Response` parameters, this class's constructor can take the following additional parameters for QWeb Lazy Rendering. In case of name conflict, routing parameters have priority. Indicates whether the current request is in "debug" mode Lazy render of a QWeb template. Odoo implements token-based `CSRF protection <https://en.wikipedia.org/wiki/CSRF>`_. Parent class for all Odoo Web request types, mostly deals with initialization and setup of the request object (the dispatching itself has to be handled by the subclasses) Rendering context to use Renders the Response's template, returns the result Request Request handler for `JSON-RPC 2 <http://www.jsonrpc.org/specification>`_ over HTTP Request producing a error:: Response Response object passed through controller route chain. Routing Shortcut for a `HTTP 404 <http://tools.ietf.org/html/rfc7231#section-6.5.4>`_ (Not Found) response Sucessful request:: The :class:`~openerp.api.Environment` bound to current request. Raises a :class:`RuntimeError` if the current requests is not bound to a database. The Access-Control-Allow-Origin cors directive value. The actual rendering of the given template will occur at then end of the dispatching. Meanwhile, the template and/or qcontext can be altered or even replaced by a static response. The database linked to this request. Can be ``None`` if the current request uses the ``none`` authentication. The handler method's result can be: The registry to the database linked to this request. Can be ``None`` if the current request uses the ``none`` authentication. The request object is automatically set on :data:`openerp.http.request` at the start of the request The type of authentication method, can on of the following: The type of authentication method, can on of the following:  * ``user``: The user must be authenticated and the current request   will perform using the rights of the user. * ``public``: The user may or may not be authenticated. If she isn't,   the current request will perform using the shared Public user. * ``none``: The method is always active, even if there is no   database. Mainly used by the framework and authentication   modules. There request code will not have any facilities to access   the database nor have any configuration indicating the current   database nor the current user. The type of request, can be ``'http'`` or ``'json'``. To *override* a controller, :ref:`inherit <python:tut-inheritance>` from its class and override relevant methods, re-exposing them if necessary:: Use :attr:`.session` instead. Use the ``sid`` attribute on :attr:`.session` User id to use for the ir.ui.view render call, ``None`` to use the request's user (the default) Web Controllers When adding a new controller for an unsafe method (mostly POST for e.g. forms): Whether CSRF protection should be enabled for the route. Whether CSRF protection should be enabled for the route.  Defaults to ``True``. See :ref:`CSRF Protection <csrf>` for more. While handlers can just return the HTML markup of a page they want to send as a string if non-HTML data is returned they need to create a complete response object, or the returned data will not be correctly interpreted by the clients. ``method`` is ignored ``none``: The method is always active, even if there is no database. Mainly used by the framework and authentication modules. There request code will not have any facilities to access the database nor have any configuration indicating the current database nor the current user. ``params`` must be a JSON object (not an array) and is passed as keyword arguments to the handler method ``public``: The user may or may not be authenticated. If she isn't, the current request will perform using the shared Public user. ``user``: The user must be authenticated and the current request will perform using the rights of the user. a :class:`OpenERPSession` holding the HTTP session data for the current http session a ``str`` or ``unicode``, will be wrapped in a Response object and interpreted as HTML a falsy value, in which case the HTTP response will be an `HTTP 204`_ (No Content) a werkzeug Response object, which is returned as-is a wrapped werkzeug Request object and defining methods decorated with :func:`~openerp.http.route`:: cookies to set on the client decorating with :func:`~openerp.http.route` is necessary to keep the method (and route) visible: if the method is redefined without decorating, it will be "unpublished" forwarded to werkzeug's Response object if the endpoint can be called by external parties (not from Odoo) as e.g. it is a REST API or a `webhook <https://en.wikipedia.org/wiki/Webhook>`_, CSRF protection must be disabled on the endpoint. If possible, you may want to implement other methods of request validation (to ensure it is not called by an unrelated third-party). if the form is generated in Javascript, the CSRF token is added by default to the QWeb (js) rendering context as ``csrf_token`` and is otherwise available as ``csrf_token`` on the ``web.core`` module: if the form is generated in Python, a csrf token is available via :meth:`request.csrf_token() <openerp.http.WebRequest.csrf_token`, the :data:`~openerp.http.request` object is available by default in QWeb (python) templates, it may have to be added explicitly if you are not using QWeb. matched routing parameters, query string parameters, form_ parameters and files are passed to the handler method as keyword arguments. opaque identifier for the :class:`OpenERPSession` instance of the current request response body string or array. The route part that will determine which http requests will match the decorated method. Can be a single string or an array of strings. See werkzeug's routing documentation for the format of route expression ( http://werkzeug.pocoo.org/docs/routing/ ). template to render the CSRF token should only be valid for the specified duration (in second), by default 1h, ``None`` for the token to be valid as long as the current user's session is. the decorators of all methods are combined, if the overriding method's decorator has no argument all previous ones will be kept, any provided argument will override previously defined ones e.g.:: the handler method's result is returned as JSON-RPC ``result`` and wrapped in the `JSON-RPC Response <http://www.jsonrpc.org/specification#response_object>`_ the original :class:`werkzeug.wrappers.Request` object provided to the request these attributes are available as parameters on the Response object and can be altered at any time before rendering use :attr:`.env` whether the template rendering should be deferred until the last possible moment will change ``/some_url`` from public authentication to user (requiring a log-in) 