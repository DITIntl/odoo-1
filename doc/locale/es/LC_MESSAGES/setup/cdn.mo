��          �               <  C   =  �   �  (   /     X  5   o  :   �  �   �  �   �  m   ~  L   �  2   9  2   l  c   �  q        u  m   �  `   �  y  `  C   �  �   	  (   �	     �	  5   
  :   B
  �   }
  �   u  m     L   �  2   �  2   	  c   <  q   �       m   .  `   �   A security error message will also appear in the browser's console: A security restriction in some browsers (Firefox and Chrome at time of writing) prevents a remotely linked CSS file to fetch relative resources on this same external server. Deploying with Content Delivery Networks Deploying with KeyCDN_ Enabling the CORS option in the CDN fixes this issue. Here's what you would see on your homepage in such a case: If you don't activate the CORS option in the CDN zone, the more obvious resulting problem on a default Odoo website will be the lack of font-awesome icons because the font file declared in the font-awesome CSS won't be loaded on the remote server. In the Odoo back end, go to the :guilabel:`Website Settings`: menu, then activate the CDN support and copy/paste your zone URL in the :guilabel:`CDN Base URL` field. Now your website is using the CDN for the resources matching the :guilabel:`CDN filters` regular expressions. Once done, you'll have to wait a bit while KeyCDN_ is crawling your website. Step 1: Create a pull zone in the KeyCDN dashboard Step 2: Configure the odoo instance with your zone This document will guide you through the setup of a KeyCDN_ account with your Odoo powered website. When creating the zone, enable the CORS option in the :guilabel:`advanced features` submenu. (more on that later) Why should I activate CORS? You can have a look to the HTML of your website in order to check if the CDN integration is properly working. a new URL has been generated for your Zone, in this case it is ``http://pulltest-b49.kxcdn.com`` Project-Id-Version: odoo 9.0
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
 A security error message will also appear in the browser's console: A security restriction in some browsers (Firefox and Chrome at time of writing) prevents a remotely linked CSS file to fetch relative resources on this same external server. Deploying with Content Delivery Networks Deploying with KeyCDN_ Enabling the CORS option in the CDN fixes this issue. Here's what you would see on your homepage in such a case: If you don't activate the CORS option in the CDN zone, the more obvious resulting problem on a default Odoo website will be the lack of font-awesome icons because the font file declared in the font-awesome CSS won't be loaded on the remote server. In the Odoo back end, go to the :guilabel:`Website Settings`: menu, then activate the CDN support and copy/paste your zone URL in the :guilabel:`CDN Base URL` field. Now your website is using the CDN for the resources matching the :guilabel:`CDN filters` regular expressions. Once done, you'll have to wait a bit while KeyCDN_ is crawling your website. Step 1: Create a pull zone in the KeyCDN dashboard Step 2: Configure the odoo instance with your zone This document will guide you through the setup of a KeyCDN_ account with your Odoo powered website. When creating the zone, enable the CORS option in the :guilabel:`advanced features` submenu. (more on that later) Why should I activate CORS? You can have a look to the HTML of your website in order to check if the CDN integration is properly working. a new URL has been generated for your Zone, in this case it is ``http://pulltest-b49.kxcdn.com`` 