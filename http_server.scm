(define (run port)
  (let ((socket (open-tcp-server-socket port)))
    (accept-loop socket)))

(define (accept-loop socket)
  (let* ((client (tcp-server-connection-accept socket #t #f))
	(request (read-total-request client ""))
	(request-path (acquire-GET-path request)))
    (display request-path)
    (newline)
    (handle-request client request-path)
    (close-port client)
    (accept-loop socket)))

(define (handle-request client request-path)
  (cond ((string=? "" request-path) (handle-request client "index.html"))
	((not (file-exists? request-path)) (display "HTTP/1.0 404 WAAT?\n\nGO AWAY! (404)" client))
	(else (write-response client request-path))))

(define (read-total-request client response)
    (let ((line (read-line client)))
      (if (string=? "" line)
	  response
	  (read-total-request client (string-append response line)))))

(define (acquire-GET-path request-string)
  (let* ((slash-index (string-search-forward "/" request-string))
	 (space-index (substring-search-forward " " request-string slash-index (string-length request-string))))
    (substring request-string (+ slash-index 1) space-index)))

(define (write-response client request-path)
   (begin
     (display "HTTP/1.0 200 OK\n\n" client)
     (send-file client request-path)))

(define (send-file client filename)
  (let ((file (open-input-file filename)))
    (let loop ((ch (read-char file)))
      (if (eof-object? ch)
	  '()
	  (begin
	    (display ch client)
	    (loop (read-char file)))))))

