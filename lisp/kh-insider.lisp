(ql:quickload '("dexador" "plump" "lquery" "lparallel" "cl-ppcre" "iterate" "uiop"))
(use-package :iterate)

;;; Regex constants
(defconstant +song-size-regex+ (ppcre:create-scanner "\\d+\\.\\d+\\s[MK]B" :case-insensitive-mode t)) ; Ex: 750.3 MB
(defconstant +song-length-regex+ (ppcre:create-scanner "\\d+:\\d+")) ; Ex: 1:27
(defconstant +ends-with-mp3-regex+ (ppcre:create-scanner "\\.mp3$" :case-insensitive-mode t))
(defconstant +number-of-songs-regex+ (ppcre:create-scanner "number of files: (\\d+)" :case-insensitive-mode t)) ; Ex: number of files: 36
(defconstant +multiple-spaces-regex+ (ppcre:create-scanner "\\s+"))
(defconstant +ending-underscore-regex+ (ppcre:create-scanner "_$"))
(defconstant +two-to-four-numbers-regex+ (ppcre:create-scanner "_\\d{2,4}_"))

;;; structs
(defstruct song-information
  title url)

(defun get-metadata (parsed-content)
  "Locates metadata information inside of a <p> tag.
  Returns the multi-line text as a result. The result
  may look like this:

      Platforms: PS4, PS5, Switch

      Year: 2020
      Catalog Number: MRD0001~3
    Published by: Nippon Ichi Software

  Number of Files: 36
  Total Filesize: 239 MB
  Date Added: Oct 30th, 2021
      Album type: Soundtrack"
  (second
      (elt
        (lquery:$ parsed-content "p"
          (combine (attr "align" "left")
          (text)))
        0)))

(defun get-album-name (parsed-content)
  "Find and return the album name as a string."
  (elt (lquery:$ parsed-content "h2" (text))
        0))

(defun get-number-of-songs (parsed-content)
  "Finds the number of songs after the string 'number of files: '
  from the result of the get-metadata function."
  (let* ((metadata (get-metadata parsed-content)))
    (multiple-value-bind (a b start-index end-index) (ppcre:scan +number-of-songs-regex+ metadata)
    (declare (ignore a)) ; not used
    (declare (ignore b)) ; not used
    (subseq metadata
            (elt start-index 0)
            (elt end-index 0)))))

(defun get-songlist (parsed-content)
  "Finds all items in the HTML with the ID songlist.
  Returns a vector of PLUMP-DOM:ELEMENT td objects."
  (lquery:$ parsed-content "#songlist .clickable-row"))

(defun is-a-song-name-p (text)
  "Checks if text fails the +song-length-regex+ and +song-size-regex+ regex.
  If both both regexes fail, text is a song name."
  (and (null (ppcre:scan +song-length-regex+ text))
       (null (ppcre:scan +song-size-regex+ text))))

(defun add-mp3-to-end-if-necessary (song-name)
  "adds '.mp3' to the end of a song name if '.mp3' isn't there."
  (if (null (ppcre:scan +ends-with-mp3-regex+ song-name))
      ; ~(~a~) == toLowerCase()
      (format nil "~(~a~).mp3" song-name)
      song-name))

(defun remove-bad-characters (song-name)
  "Remove characters that linux shells don't like."
  (let* ((pass1 (substitute #\LEFT_PARENTHESIS #\LEFT_SQUARE_BRACKET song-name))
         (pass2 (substitute #\RIGHT_PARENTHESIS #\RIGHT_SQUARE_BRACKET pass1))
         (pass3 (remove #\' pass2))
         (pass4 (substitute #\SPACE #\- pass3))
         (pass5 (ppcre:regex-replace-all +multiple-spaces-regex+ pass4 "_"))
         (final-result (ppcre:regex-replace-all +ending-underscore-regex+ pass5 "")))
    final-result))

(defun build-url (song-item)
  "Returns the URL from the <a> href attribute."
  (let* ((href-vector (lquery:$ song-item "a" (attr :href)))
         (href-data (elt href-vector 0)))
    (format nil "https://downloads.khinsider.com~a" href-data)))

(defun has-track-numbers-p (song-information-vector)
  "Randomly select 10 songs and check if any of them have some sort of index number."
  (dotimes (i 10)
    (let* ((index (random (length song-information-vector)))
           (song (elt song-information-vector index)))
      (when (ppcre:scan +two-to-four-numbers-regex+ (song-information-title song))
        (return-from has-track-numbers-p t)))) ; found a song with what appears to be an index
  nil) ; did not find an index

(defun add-track-numbers (song-information-vector)
  "Tacks on a track number to the front of the song title."
  (let ((vector (make-array (length song-information-vector) :fill-pointer 0)))
    (dotimes (n (length song-information-vector))
      (let* ((song-item (elt song-information-vector n))
             (title (song-information-title song-item))
             (url (song-information-url song-item)))
        (vector-push (make-song-information :title (format nil "~3,'0d_~a" (+ n 1) title)
                                            :url url)
                      vector)))
    vector))

(defun pre-download (parsed-content)
  "First pass to parse an HTML data table for song names and URL destinations.
  Returns a vector of structs of type song-information."
  (let* ((songlist (get-songlist parsed-content))
         (vector-result (make-array (length songlist) :fill-pointer 0)))
    (iter (for song-item in-vector songlist)
      (let* ((text-value (elt (lquery:$ song-item (text))
                               0)))
        (when (is-a-song-name-p text-value)
          (vector-push
            (make-song-information :title (add-mp3-to-end-if-necessary (remove-bad-characters text-value))
                                   :url (build-url song-item))
            vector-result))))
    (if (has-track-numbers-p vector-result)
         vector-result
         (add-track-numbers vector-result))))

(defun get-direct-song-url (url)
  "Given a url to a song page, parse the page for a direct URL to the song for download."
  (let* ((request (dex:get url))
         (parsed-content (lquery:$ (initialize request)))
         (new-url (lquery:$ parsed-content "audio"
                            (combine (attr "src")
                            (text)))))
    (first (elt new-url 0))))

(defun build-file-pathname (album-name title)
  "Build a file pathname that both the OS and Common Lisp will understand."
  (uiop:ensure-pathname (format nil "./~a/~a" album-name title)))

(defun download (url)
  "Download all songs, thirty at a time"
  (let* ((request (dex:get url))
         (parsed-content (lquery:$ (initialize request)))
         (album-name (get-album-name parsed-content)) 
         (song-information-vector (pre-download parsed-content)))
    (ensure-directories-exist (uiop:ensure-directory-pathname album-name))
    (lparallel:pmap 'vector
      (lambda (song)
        (let*  ((title (song-information-title song))
                (url (song-information-url song))
                (direct-url (get-direct-song-url url))
                (raw-data (dex:get direct-url)))
          (print (format nil "now downloading: [~a] (of ~a)" title (length song-information-vector)))
          (with-open-file (stream (build-file-pathname album-name title)
                          :direction :output
                          :element-type 'unsigned-byte
                          :if-exists :supersede
                          :if-does-not-exist :create)
          (write-sequence raw-data stream))))
        song-information-vector)
    (print (format nil "finished downloading [~a]!" album-name))))

(defun loop-through-file (file)
  "Loop through a file of URLs and download each album into separate folders."
  (iter (for url in (uiop:read-file-lines file))
    (print (format nil "now downloading from url [~a]" url))
    (download url)))

(defun main()
  (let* ((number-of-threads 30)
         (cmd-arg (second sb-ext:*posix-argv*)))
    (setf lparallel:*kernel* (lparallel:make-kernel number-of-threads))
    (if (uiop:ensure-pathname cmd-arg)
        (loop-through-file cmd-arg)
        (download cmd-arg))))

; creates the compiled executable
(sb-ext:save-lisp-and-die "kh-insider.exe"
                          :executable t
                          :toplevel 'main)
