(define (run port)
  (let ((socket (open-tcp-server-socket port)))
    (accept-loop socket)))
    
(define (accept-loop socket)
  (let ((client (tcp-server-connection-accept socket #t #f)))
;;    (display (read-request client))
    (display (acquire-GET-path (read-total-request client "")))
    (write-response client)
    (close-port client)
    (accept-loop socket)))

;; allow a default value for a response string
(define (read-total-request client response)
    (let ((line (read-line client)))
      (if (string=? "" line)
	  response
	    (read-total-request client (string-append response line)))))

(define (acquire-GET-path request-string)
  (let* ((slash-index (string-search-forward "/" request-string))
	 (space-index (substring-search-forward " " request-string slash-index (string-length request-string))))
    (substring request-string slash-index space-index)))
    

(define (write-response c)
   (begin 
    (display "\n> ")
    (display "HTTP/1.0 200 OK\n\n" c)
    (display (read-line (interaction-i/o-port)) c)
    ))   
    


    