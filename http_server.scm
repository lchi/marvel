(define (run port)
  (let ((socket (open-tcp-server-socket port)))
    (accept-loop socket)))
    
(define (accept-loop socket)
  (let ((client (tcp-server-connection-accept socket #t #f)))
    (display (read-request client))
    (write-response client)
    (close-port client)
    (accept-loop socket)))


(define (read-request c)
    (read-line c))

(define (write-response c)
   (begin 
    (display "\n> ")
    (display "HTTP/1.0 200 OK\n\n" c)
    (display (read-line (interaction-i/o-port)) c)
    
    ))   
    
    