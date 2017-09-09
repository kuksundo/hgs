Fuzzy Text Matching Plugin for ABC-View Manager
===============================================

General
=======
The fuzzy text matching plugin allows to detect text files that closely
match but differ by just a few characters. ABC-View manager can be used
as a tool to select the text files and start the plugin. 

Requirements
============

ABC-View Manager

In order to work with the plugin, you must first install and register
ABC-View Manager. ABC-View Manager can be downloaded here:
http://www.abc-view.com/abcdnl.html

It can be obtained here (multiple options, US$29):
http://www.abc-view.com/abcbuy.html

Fuzzy Text Matching plugin

The fuzzy text matching plugin is available in two versions. One is
an "educational version" which you may use if the plugin is used for
academic or scientific purposes. The other commercial license is for
usage by commercially oriented companies.

Educational license (Eur 99):
https://secure.shareit.com/shareit/checkout.html?PRODUCT[300007262]=1

Commercial license: (Eur 495):
https://secure.shareit.com/shareit/checkout.html?PRODUCT[300007260]=1

Installation
============

1) After obtaining a license you will receive a zip file with 
"AbcFuzzyText.dll" in it. Copy the file AbcFuzzyText.dll to the folder:
c:\program files\abc-view manager\plugins

2) Open ABC-View Manager, click on View > Options, select "Plugins" tab

3) Click "Add New Plugin", click on the small "folder open" icon in the
dialog, browse to the Plugins folder, select AbcFuzzyText.dll and open.

4) Click Load.. the plugin will state "Not Authorized".

5) Click on Authorize, enter your full first and last name and click
Calculate

6) You will get a client code, send this by email to n.haeck@simdesign.nl,
and you will receive a registration key from us.

7) Enter the registration key in the edit box, and click Register. If all
goes well, you will get a thank you message and the plugin is authorised.

Using the plugin
================

1) First of all, you must familiarize yourself with the use of
ABC-View Manager. It is a general file management tool. A long
introduction can be found here:
http://www.abc-view.com/articles/article4.html

2) When you want to use the plugin, first make sure to have all the files
that you want to check selected. You can create a custom selection of
files by multi-selecting them and then rightclick in the file window, and
choosing "Send to > My Selection".

3) Choose a selection in the left top corner (either "All Items" or "My
Selection" or any other.

4) Rightclick on the selection and choose Add filter > Fuzzy text match
filter.

5) Choose a tolerance level and then click OK

6) The files will be analysed, and after a while the plugin will return
and display a list of all matching files


Specific settings
=================

1) Click View > Options, go to the plugins tab and select the plugin,
then Edit Plugin

2) In the dialog, click on Setup

3) Change settings here:

( ) Auto-index in background
(*) Index files when filtering

Auto-index will cause ABCVM to automatically index all files it comes
across. "Index file when filtering" only starts this when the filter is
started (recommended)

Max filesize difference

By specifying a maximum difference in file size, you can speed up the
search. Only files that have not more than X bytes length difference
will be compared.

File Type filter

Here you can specify which kind of files are going to be processed.
Use the second option to specify a number of extensions. All extensions
must start with a dot and end with a semi-colon!

Limits per tolerance level

Here you can specify how many characters may be different for a certain
tolerance level. The tolerance level is specified when starting the
filter. Thus you can customize the tolerance levels here.

Allowing a higher number of characters to be different will cause more
files to show up as a match.













