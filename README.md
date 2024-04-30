# multi-channel-smu

Code for multichannel source measurement unit, Nicslab XDAC-40U-R4G8.

This is not an official code from nicslab. 

You need to have python, and the python library 'zmq' installed on your computer, and add it to path.

Folder- matlab contains complete matlab implementation which needs some compiled files.

Folder- python contains complete python implementation

Folder- matlab_python contains hybrid implementation, where most of the code is in matlab, and python and pyzmq libraries are used just to interface with the device. (This is done due to the lack of official zmq library for matlab)


