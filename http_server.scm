(define (run port)
  (let ((socket (open-tcp-server-socket port)))
    (accept-loop socket)))
    
(define (accept-loop socket)
  (let ((client (tcp-server-connection-accept socket #t #f)))
    (display (read-char client))
    (close-port client)
    (accept-loop socket)))

