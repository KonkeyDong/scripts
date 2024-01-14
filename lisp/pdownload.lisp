(load "constants.lisp")
(ql:quickload '("lparallel" "serapeum" "uiop" "iterate" "split-sequence" "str"))
(use-package :iterate)

(defconstant +number-of-threads+ (serapeum:count-cpus))

(defun exc (cmds)
    (let* ((split-cmd (split-sequence:split-sequence #\Space cmds))
            (url (first split-cmd))
            (flag (second split-cmd))
            (file-name (str:replace-using '("-" "_") 
                                           (third split-cmd)))
            (args (list url flag file-name)))
        (unless (probe-file file-name) ; only continue if we don't have a file written already
            (sb-ext:run-program constants:+yt-dlp+ args :output t :wait t)))
    nil)

(defun execute-command (cmds)
    "execute the command via shell in parallel"
    (setf lparallel:*kernel* (lparallel:make-kernel +number-of-threads+)) ; start up the number of threads specified
    (lparallel:pmap 'vector
                    #'exc
                    cmds)
    (lparallel:end-kernel))

(defun loop-through-file (file)
    "Loop through a file of bash commands and execute them in parallel"
    (let* ((cmds (uiop:read-file-lines file)))
        (execute-command cmds)))

(defun main()
    (let* ((cmd-arg (second sb-ext:*posix-argv*)))
        (if (uiop:file-exists-p (uiop:ensure-pathname cmd-arg))
            (loop-through-file cmd-arg)
            (execute-command cmd-arg))))

; creates the compiled executable
(sb-ext:save-lisp-and-die "pdownload.exe"
                          :executable t
                          :toplevel 'main)
(exit)