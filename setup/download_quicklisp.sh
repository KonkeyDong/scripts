#!/bin/bash

# Installing QuickLisp libraries
CWD=`pwd` # store
cd $HOME
sudo apt install sbcl
curl -O https://beta.quicklisp.org/quicklisp.lisp

echo ""
echo "========================================================================"
echo "You are about to enter an sbcl session. Run the following immediately:"
echo "(quicklisp-quickstart:install)"
echo 'then, run: (load "~/quicklisp/setup.lisp")'
echo "followed by: (ql:add-to-init-file)"
echo "========================================================================"
echo ""

echo "waiting 3 seconds before entering sbcl session..."
sleep 3 # 3 seconds
sbcl --load quicklisp.lisp
echo "install complete!"
cd $CWD # restore
