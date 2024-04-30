# multi-channel-smu

Code for multichannel source measurement unit, Nicslab XDAC-40U-R4G8.

This is not an official code from nicslab. 



==> Folder: 'matlab' contains complete matlab implementation.
This method needs some precompiled files to work

==> Folder: 'python' contains complete python implementation

==> Folder: 'matlab_python' contains a hybrid implementation
Here, most of the code is in matlab, and python and pyzmq libraries are used just to interface with the device. 
You need to have python, and the python library 'zmq' installed on your computer, and add it to path for this to work.
(This is done due to the lack of official zmq library for matlab)


