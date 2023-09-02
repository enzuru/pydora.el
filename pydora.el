(require 'url)
(require 'url-http)
(require 'image-mode)

(defun handle-tcp-message (process message)
  (message "Received TCP message: %s" message)
  (pydora-display-art message))

(defun pydora-connect (host port)
  (interactive "sHost: \nnPort: ")
  (if (get-buffer "*TCP*")
      (kill-buffer "*TCP*"))
  (let* ((buffer (generate-new-buffer "*TCP*"))
         (connection (open-network-stream "TCP" buffer host port)))
    (set-process-filter connection #'handle-tcp-message)))

 (defun pydora-send (data)
   (let ((process (get-buffer-process "*TCP*")))
    (if process
        (process-send-string process data)
      (message "TCP connection not found"))))

(defun display-remote-image (url)
  "Display the remote image at URL in an Emacs buffer."
  (interactive "sEnter the URL of the image: ")
  (let* ((buffer (url-retrieve-synchronously url))
         (data (with-current-buffer buffer (buffer-string))))
    (kill-buffer buffer)
    (let ((image (create-image data 'jpeg t)))
      (switch-to-buffer (get-buffer-create "*Image*"))
      (image-mode)
      (erase-buffer)
      (insert-image image))))

(defun get-first-line-in-buffer (buffer)
  "Get the first line of the specified BUFFER as a string."
  (with-current-buffer buffer
    (save-excursion
      (goto-char (point-min))
      (buffer-substring (line-beginning-position) (line-end-position)))))

(defun create-new-buffer (name)
  "Create a new buffer with the specified NAME."
  (let ((buffer (generate-new-buffer name)))
    (switch-to-buffer buffer)
    buffer))

(defun pydora-start ()
  (interactive)
  (pydora-connect "localhost" 9999)
  (pydora-send "vu"))

(defun pydora-display-art (image)
  (let ((filename (car (last (split-string image "/")))))
    (debug)
    (message "test")
    (message filename)
    (url-copy-file image (concat "~/" filename))
    (create-new-buffer "*Pydora*")
    (insert-image (create-image "~/album.jpeg"))))
