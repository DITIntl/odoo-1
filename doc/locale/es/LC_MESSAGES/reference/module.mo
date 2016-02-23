��                           K       i    �  b   �  z   �  t   m  N   �  |   1     �     �  �   �  f   S  �   �     C  /   X  2   �     �     �     �     		  +   #	     O	     l	     �	  J   �	  #   �	  8   
     @
  %   Z
  A   �
  !   �
  y  �
  K  ^     �    �  b   �  z   3  t   �  N   #  |   r     �     �  �      f   �  �   �     �  /   �  2   �     �          .     J  +   d     �     �     �  J   �  #   $  8   H     �  %   �  A   �  !      Although using `existing categories`_ is recommended, the field is freeform and unknown categories are created on-the-fly. Category hierarchies can be created using the separator ``/`` e.g. ``Foo / Bar`` will create a category ``Foo``, a category ``Bar`` as child category of ``Foo``, and will set ``Bar`` as the module's category. Available manifest fields are: For instance ``sale_crm`` depends on both ``sale`` and ``crm`` and is set to ``auto_install``. When both ``sale`` and ``crm`` are installed, it automatically adds CRM campaigns tracking to sale orders without either ``sale`` or ``crm`` being aware of one another If ``True``, this module will automatically be installed if all of its dependencies are installed. It is a file called ``__openerp__.py`` and contains a single Python dictionary, where each key specifies module metadatum. It is generally used for "link modules" implementing synergic integration between two otherwise independent modules. List of data files which are only installed or updated in *demonstration mode* List of data files which must always be installed or updated with the module. A list of paths from the module root directory Manifest Modules Odoo modules which must be loaded before this one, either because this module uses features they create or because it alters resources they define. The manifest file serves to declare a python package as an Odoo module and to specify module metadata. When a module is installed, all of its dependencies are installed before it. Likewise dependencies are loaded before a module is loaded. ``author`` (``str``) ``auto_install`` (``bool``, default: ``False``) ``category`` (``str``, default: ``Uncategorized``) ``data`` (``list(str)``) ``demo`` (``list(str)``) ``depends`` (``list(str)``) ``description`` (``str``) ``license`` (``str``, defaults: ``LGPL-3``) ``name`` (``str``, required) ``version`` (``str``) ``website`` (``str``) classification category within Odoo, rough business domain for the module. distribution license for the module extended description for the module, in reStructuredText name of the module author the human-readable name of the module this module's version, should follow `semantic versioning`_ rules website URL for the module author Project-Id-Version: odoo 9.0
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
 Although using `existing categories`_ is recommended, the field is freeform and unknown categories are created on-the-fly. Category hierarchies can be created using the separator ``/`` e.g. ``Foo / Bar`` will create a category ``Foo``, a category ``Bar`` as child category of ``Foo``, and will set ``Bar`` as the module's category. Available manifest fields are: For instance ``sale_crm`` depends on both ``sale`` and ``crm`` and is set to ``auto_install``. When both ``sale`` and ``crm`` are installed, it automatically adds CRM campaigns tracking to sale orders without either ``sale`` or ``crm`` being aware of one another If ``True``, this module will automatically be installed if all of its dependencies are installed. It is a file called ``__openerp__.py`` and contains a single Python dictionary, where each key specifies module metadatum. It is generally used for "link modules" implementing synergic integration between two otherwise independent modules. List of data files which are only installed or updated in *demonstration mode* List of data files which must always be installed or updated with the module. A list of paths from the module root directory Manifest Modules Odoo modules which must be loaded before this one, either because this module uses features they create or because it alters resources they define. The manifest file serves to declare a python package as an Odoo module and to specify module metadata. When a module is installed, all of its dependencies are installed before it. Likewise dependencies are loaded before a module is loaded. ``author`` (``str``) ``auto_install`` (``bool``, default: ``False``) ``category`` (``str``, default: ``Uncategorized``) ``data`` (``list(str)``) ``demo`` (``list(str)``) ``depends`` (``list(str)``) ``description`` (``str``) ``license`` (``str``, defaults: ``LGPL-3``) ``name`` (``str``, required) ``version`` (``str``) ``website`` (``str``) classification category within Odoo, rough business domain for the module. distribution license for the module extended description for the module, in reStructuredText name of the module author the human-readable name of the module this module's version, should follow `semantic versioning`_ rules website URL for the module author 