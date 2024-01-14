(load "constants.lisp")
(ql:quickload "split-sequence")

(defun split (string)
    "Split a string on the period character and return as a list."
  (split-sequence:split-sequence #\period string))

(defun split-file-name (file-name)
    "Separate the file name from the extension on the period character.
    Ex: example.mp4 => ('example' 'mp4')"
    (let* ((split-file-name (split file-name))
           (file (first (butlast split-file-name)))
           (ext (first (last split-file-name))))
        (list file ext)))

(defun chomp (str)
  "Remove trailing whitespace characters, including newlines, from a string."
  (string-right-trim '(#\Newline) str))

(defun run-shell-command (exe args)
    "Run a shell command and return the output as a string."
  (chomp
    (with-output-to-string (s)
     (sb-ext:run-program exe args :output s))))

(defun make-directory (dir)
    "Create a directory, but only if the directory doesn't already exist."
  (unless (probe-file dir)
    (ensure-directories-exist (format nil "~a/" dir)))

(defun move-file (source destination)
    "Move file from source to destination using the mv command."
  (sb-ext:run-program constants:+mv+ (list source destination) :wait t))

(defun process-file (file-name)
  (let* ((file-info (split-file-name file-name))
         (file (first file-info))
         (extension (second file-info))
         (exe constants:+ffprobe+)
         (cmd (list "-v" "error" "-select_streams" "v:0" "-show_entries" "stream=height" "-of" "csv=s=x:p=0" (format nil "~A" file-name)))
         (resolution (run-shell-command exe cmd))
         (rename (format nil "~A_~Ap.~A" file resolution extension))
         (dest "./completed"))
    (make-directory dest)
    ;(print (format nil "~A/~A" dest rename))))
    (move-file file-name (format nil "~A/~A" dest rename))))

(defun main ()
    "Ignore the first argument (sbcl) and check if we have at least one list of files."
    (let* ((argv (rest sb-ext:*posix-argv*)))
        (if (= (length argv) 0)
            (progn
                (format t "not enough args -- please provide a file or type *.mp4 for a list~%")
                'fail)
            (loop for file-name in argv
                    do (process-file file-name)))))

; creates the compiled executable
(sb-ext:save-lisp-and-die "add_video_resolution.exe"
                          :executable t
                          :toplevel 'main)
(exit)
