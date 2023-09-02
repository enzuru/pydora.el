(if (get-buffer "*TCP*")
    (kill-buffer "*TCP*"))

(defun my-connect-to-tcp-port (host port)
  (interactive "sHost: \nnPort: ")
  (let ((buffer (generate-new-buffer "*TCP*")))
    (open-network-stream "TCP" buffer host port)
    (switch-to-buffer buffer)))

 (defun my-send-data-over-tcp (data)
   (let ((process (get-buffer-process "*TCP*")))
    (if process
        (process-send-string process data)
      (message "TCP connection not found"))))

(my-connect-to-tcp-port "localhost" 9999)
(my-send-data-over-tcp "a")
