; *********************************************
; *  341 Programming Languages                *
; *  Fall 2019                                *
; *  Author: Yakup Genc                       *
; *********************************************

;Yusuf Patoglu
;151044027


;;;-----------------------------------------------------------------PLEASE READ THIS----------------------------------------------------------------------------------------------------;;;
;;Notes to Ozgu Hoca:
;;I prepared a test version of my code for smaller alphabet. Simply I created my own alphabet and encoding it via singleDecode-test function. Also added my own word dictionary and document.
;;
;;You can download it on: https://drive.google.com/drive/folders/1LNQxIf3HyIxHWZYd0hWniGzOwY3Gue-Y?usp=sharing
;;;-----------------------------------------------------------------PLEASE READ THIS----------------------------------------------------------------------------------------------------;;;



;; utility functions 
(load "include.lisp") ;; "c2i and "i2c"





;; -----------------------------------------------------
;; HELPERS
;; *** PLACE YOUR HELPER FUNCTIONS BELOW ***
(defun count-times (list element)
  (loop for value in list count (equal value element)))

(defun set-hash-table()
    (defvar wordtable (make-hash-table :test 'equal)) ;required global value here. Otherwise lots of memory will be consumed.
    (let ((in (open "dictionary2.txt" :if-does-not-exist nil)))
    (when in
      (loop for line = (read-line in nil)
        while line do 
            (setf(gethash line wordtable) 1))
    (close in))))

(defun list-to-string (lst)
    (format nil "~{~A~}" lst))

;returns random permutation of a list.
;https://stackoverflow.com/questions/49490551/how-to-shuffle-list-in-lisp 
(defun nshuffle (sequence)
  (loop for i from (length sequence) downto 2
        do (rotatef (elt sequence (random i))
                    (elt sequence (1- i))))
  sequence)

;Flattens the nested list.
;https://rosettacode.org/wiki/Flatten_a_list#Common_Lisp
(defun flatten (structure)
  (cond ((null structure) nil)
        ((atom structure) (list structure))
        (t (mapcan #'flatten structure))))

;gets nth element of list.
(defun get-nth-element (list number)
    (nth number list))
;gets the list size.
(defun list-size (list)
    (if(= (list-length list) 0 )
        0
        (+ 1 (list-size (cdr list))
        )))
;gets the index.
(defun get-index (character list)
    (position list character))
;reset the number value
(defun reset-value (number)
    (setq number 0)
    number)
;find number of occurencies of specific element in a list.
(defun find-occur-count (list element)
  (loop for value in list count (equal value element)))
;reads the whole file as a nested character list. 
(defun read-as-list (filename)
    (setq currentcharcount 0)
    (setq charcount 0)
    (with-open-file (stream filename)
        (do ((char (read-char stream nil)
            (read-char stream nil)))((null char))
            (setq charcount (+ charcount 1)))(close stream))

    (setq letterlist '())
    (setq wordlist '())
    (setq paraglist '())
    (with-open-file (stream filename)
        (do ((char (read-char stream nil)
        (read-char stream nil)))((null char))
        (setq char(singleDecode-test char))
        (setq currentcharcount (+ currentcharcount 1))
        (if (alpha-char-p char)
            (progn
                (setq letterlist(cons char letterlist))))
        (if(eql char #\Space)
            (progn
                (setq letterlist(reverse letterlist))
                (setq wordlist(append wordlist(list letterlist)))
                (setq letterlist '())))
        (if(eql char #\Newline)
            (progn
                (setq letterlist(reverse letterlist))
                (setq wordlist(append wordlist(list letterlist)))
                (setq paraglist(append paraglist(list wordlist)))
                (setq wordlist '())
                (setq letterlist '())))
        (if(eql currentcharcount charcount)
            (progn
                (setq letterlist(reverse letterlist))
                (setq wordlist(append wordlist(list letterlist)))
                (setq paraglist(append paraglist(list wordlist)))
                (setq wordlist '())
                (setq letterlist '()))))
                (close stream))
                paraglist)
;Decodes the paragraph aka line with the help of decoded alphabet
(defun line-decoder (decodedalphabet line)

    (setq originalalphabet '(#\a #\b #\c #\d #\e #\f #\g))
    ;(setq decodedalphabet '(#\d #\e #\f #\p #\q #\a #\b #\k #\l #\c #\r #\s #\t #\g #\y #\z #\h #\i #\j #\m #\n #\o #\u #\v #\w #\x))
    (setq originalkey (mapcar #'c2i originalalphabet))
    (setq decodedkey (mapcar #'c2i decodedalphabet))
    (setq keymap (mapcar #'- decodedkey originalkey))
    (setq wordcounter 0)
    (setq lettercounter 0)
    (setq wordlist '())
    (setq letterlist '())
    (loop while (< wordcounter (list-size line)) 
        do
        (loop while (< lettercounter(list-size(nth wordcounter line)))
            do
            (setq currentchar(nth lettercounter(nth wordcounter line)))
            (setq currentpositionindecoded (position currentchar decodedalphabet))
            (setq decrementkey (nth currentpositionindecoded keymap))
            (setq charvalue (c2i currentchar))
            (setq decodedval (- charvalue decrementkey))
            (setq finalletter (i2c decodedval))
            (setq finalletter(intern (string finalletter)))
            (setq letterlist (cons finalletter letterlist))
            (setq lettercounter (+ lettercounter 1))
        )
        (setq letterlist (reverse letterlist))
        (setq wordlist(append wordlist (list letterlist)))
        (setq letterlist'())
        (setq lettercounter 0)
        (setq wordcounter (+ wordcounter 1)))

        wordlist)


;encodes the file for testing (smaller alphabet.)
(defun singleDecode-test (dechar)
    (cond
    ((eql dechar #\a )
        (setq dechar #\f))  
    ((eql dechar #\b )
        (setq dechar #\c))
    ((eql dechar #\c )
        (setq dechar #\b))
    ((eql dechar #\d )
        (setq dechar #\a))
    ((eql dechar #\e )
        (setq dechar #\g))
    ((eql dechar #\f )
        (setq dechar #\d))
    ((eql dechar #\g )
        (setq dechar #\e))
    ((eql dechar #\Space )
        (setq dechar #\Space))
    ((eql dechar #\Newline )
        (setq dechar #\Newline))
    (t
        (setq dechar #\*))))

;encodes the file for testing (actual alphabet, same in PDF)
(defun singleDecode (dechar)
    (cond
    ((eql dechar #\a )
        (setq dechar #\d))  
    ((eql dechar #\b )
        (setq dechar #\e))
    ((eql dechar #\c )
        (setq dechar #\f))
    ((eql dechar #\d )
        (setq dechar #\p))
    ((eql dechar #\e )
        (setq dechar #\q))
    ((eql dechar #\f )
        (setq dechar #\a))
    ((eql dechar #\g )
        (setq dechar #\b))
    ((eql dechar #\h )
        (setq dechar #\k))
    ((eql dechar #\i )
        (setq dechar #\l))
    ((eql dechar #\j )
        (setq dechar #\c))
    ((eql dechar #\k )
        (setq dechar #\r))
    ((eql dechar #\l )
        (setq dechar #\s))
    ((eql dechar #\m )
        (setq dechar #\t))
    ((eql dechar #\n )
        (setq dechar #\g))
    ((eql dechar #\o )
        (setq dechar #\y))
    ((eql dechar #\p )
        (setq dechar #\z))
    ((eql dechar #\q )
        (setq dechar #\h))
    ((eql dechar #\r )
        (setq dechar #\i))
    ((eql dechar #\s )
        (setq dechar #\j))
    ((eql dechar #\t )
        (setq dechar #\m))
    ((eql dechar #\u )
        (setq dechar #\n))
    ((eql dechar #\v )
        (setq dechar #\o))
    ((eql dechar #\w )
        (setq dechar #\u))
    ((eql dechar #\x )
        (setq dechar #\v))
    ((eql dechar #\y )
        (setq dechar #\w))
    ((eql dechar #\z )
        (setq dechar #\x))
    ((eql dechar #\Space )
        (setq dechar #\Space))
    ((eql dechar #\Newline )
        (setq dechar #\Newline))
    (t
        (setq dechar #\*))))





;linear search
(defun spell-checker-0 (word)
  (setq foo-flag nil)
  (let ((in (open "dictionary2.txt" :if-does-not-exist nil)))
    (when in
      (loop for line = (read-line in nil)
        while line do 
            (if (string-equal word line)(setq foo-flag t)))
    (close in)))
    foo-flag)

;accessing word via hashmapping. See line 20.
(defun spell-checker-1 (word)
    (gethash word wordtable))


;; -----------------------------------------------------
;; DECODE FUNCTIONS
;;Brute force method.
(defun Gen-Decoder-A (paragraph)
    (setq originalalphabet '(#\a #\b #\c #\d #\e #\f #\g))
    (setq shuffledalphabet '(#\a #\b #\c #\d #\e #\f #\g))
    (setq shuffledalphabet(nshuffle shuffledalphabet))
    (setq singleword '())
    (setq wordcount 0)

    (loop while (< wordcount (list-size paragraph)) 
        do

        (setq singleword '())
        (setq lowerbound 0)
        (setq upperbound(list-size (get-nth-element paragraph wordcount)))
        (setq indexedword (nth wordcount paragraph))
        (loop for j from lowerbound to (- upperbound 1) collecting
            (progn               
                (setq indexedletter (nth j indexedword))
                (setq positionindex (position indexedletter shuffledalphabet))
                (setq subkey (nth positionindex originalalphabet))
                (setq singleword(cons subkey singleword)))


            )
        (setq singleword (reverse singleword))
        (setq tostring (list-to-string singleword))
        (setq booleanval (spell-checker-1 tostring))

        (if(eql booleanval nil)
                (progn
                    (setq shuffledalphabet (nshuffle shuffledalphabet))
                    (setq wordcount 0)
                )
                (setq wordcount (+ wordcount 1)))
        (print tostring)
        )

        (defun myfunc(paragraph)
            (line-decoder shuffledalphabet paragraph))

            ;)
        ;(print (myfunc paragraph))


        (myfunc paragraph))
;Brute Force Method with frequency analysis.
;You need long lines for this method. 
(defun Gen-Decoder-B-0 (paragraph)


    (setq bruteparagraph paragraph)
    (setq frequentcounter 0)
    (setq occurencynumbers '())
    (setq paragraph(flatten paragraph))
    ;(print document)
    (setq originalalphabet '(#\a #\b #\c #\d #\e #\f #\g))
    (setq shuffledalphabet '(#\a #\b #\c #\d #\e #\f #\g))
    (setq mostfrequentones '(#\e #\t #\a #\o #\i #\n))
    (setq encodedfrequentones '())
    (setq lettercounter 0)
    (setq shuffledalphabet(nshuffle shuffledalphabet))
    (setq singleword '())
    (setq wordcount 0)


    (loop while (< lettercounter (list-size originalalphabet))
            do
            (setq element(count-times paragraph (nth lettercounter originalalphabet)))
            (setq occurencynumbers(cons element occurencynumbers))
            (setq lettercounter (+ lettercounter 1))
    )
     (setq occurencynumbers(reverse occurencynumbers))
     (print occurencynumbers)

    (loop while (< frequentcounter 6)
            do

        (setq maxindex(position (reduce #'max occurencynumbers) occurencynumbers))
        (setq encodedfrequentones(cons (nth maxindex originalalphabet) encodedfrequentones))
        (setf (nth maxindex occurencynumbers) 0) ;golden shot
        (print occurencynumbers)
        (setq frequentcounter(+ frequentcounter 1))
            
    )
    (setq encodedfrequentones (reverse encodedfrequentones))
    (print encodedfrequentones)
    ;(print (max occurencynumbers))
    ;;;;;;;;;;;;;;;;;;; implement brute force here.
    (loop while (< wordcount (list-size bruteparagraph)) 
        do

        (setq singleword '())
        (setq lowerbound 0)
        (setq upperbound(list-size (get-nth-element bruteparagraph wordcount)))
        (setq indexedword (nth wordcount bruteparagraph))
        (loop for j from lowerbound to (- upperbound 1) collecting
            (progn               
                (setq indexedletter (nth j indexedword))
                (setq positionindex (position indexedletter shuffledalphabet))
                (setq subkey (nth positionindex originalalphabet))
                (setq singleword(cons subkey singleword)))


            )
        (setq frequentadder 0)
        (setq singleword (reverse singleword))
        (loop while (< frequentadder 6)
            do
                (setq frequentOne(nth frequentadder encodedfrequentones))
                (setq singleword(subst (nth frequentadder mostfrequentones) frequentOne singleword))
            
            (setq frequentadder(+ frequentadder 1))
        )
        (setq tostring (list-to-string singleword))
        (print tostring)
        (setq booleanval (spell-checker-1 tostring))

        (if(eql booleanval nil)
                (progn
                    (setq shuffledalphabet (nshuffle shuffledalphabet))
                    (setq wordcount 0)
                )
                (setq wordcount (+ wordcount 1)))))

(defun Gen-Decoder-B-1 (paragraph)
    ;you should implement this function
)

;function that returns decoded document.
(defun Code-Breaker (document decoder)
    (setq paragraphcounter 0)
    (setq decodedDocument '())

    (loop while (< paragraphcounter (list-size document))
            do
            (setq currentparagraph (funcall decoder (nth paragraphcounter document)))
            (print "Just decoded a paragraph.")
            ;(print currentparagraph)
            (setq decodedDocument(append decodedDocument(list currentparagraph)))
            ;(print currentparagraph)
            (setq currentparagraph '())
            (setq paragraphcounter(+ paragraphcounter 1)))
    


    (print decodedDocument)
    decodedDocument)

;; -----------------------------------------------------
;; Test code...

(defun test_on_test_data ()
  (print "....................................................")
  (set-hash-table); don't change this.
  (print "Testing ....")
  (print "....................................................")
  (let ((doc (read-as-list "document1.txt")))
    (print doc)
    (Code-Breaker doc 'Gen-Decoder-A)
  )
)

;; test code...
(test_on_test_data)