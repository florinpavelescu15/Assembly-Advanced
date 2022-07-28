section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
        ;; folosesc echivalenta mov eax, ebx <-> push ebx
	;;                                       pop eax
        ;; problema parantezelor se rezolva, in general, folosind o stiva
        ;; pentru simplitate, in loc de stiva, voi folosi un intreg stack
        ;; tin cont de urmatoarele echivalente: stack.push() <-> stack++
        ;;                                      stack.pop() <-> stack--
        ;;                                      stack.isEmpty() <-> stack==0
	push    ebp
        push    esp
        pop     ebp
        push    ebx                    ; retin valoarea lui ebx
        xor     esi, esi               ; esi=stack=0 (stiva goala)
        push    dword 1
        pop     ebx                    ; ebx=is_balanced=1
        xor     ecx, ecx               ; ecx=i=0 
through_str:
        cmp     ecx, dword [ebp + 8]   ; daca i>=n
        jge     return                 ; returneaza rezultatul
        cmp     ebx, 1                 ; altfel, daca is_balanced=0
        jne     return                 ; returneaza rezultatul
        push    dword [ebp + 12] 
        pop     eax                    ; eax=str
        push    eax                    ; salvez eax pe stiva
        push    dword [eax + ecx]      
        pop     eax                    ; eax=str[i] 
        cmp     al, 40                 ; daca str[i]='('
        jne     closed_bracket         
open_bracket:                   
        inc     esi                    ; adaug paranteza pe "stiva" stack
        jmp     next1
closed_bracket:           
        cmp     esi, 0                 ; daca "stiva" stack e vida
        jne     next2     
        xor     ebx, ebx               ; is_balanced=0
        jmp     next1                   
next2:                                 ; daca "stiva" stack nu e vida
        dec     esi                    ; fac pop()
next1:
        inc     ecx                    ; i++
        pop     eax                    ; scot eax de pe stiva: eax=str
        jmp     through_str            ; inapoi la through_str (while)
return:
        cmp     ebx, 1               
        jne     not_balanced          
        cmp     esi, 0                
        jne     not_balanced
balanced:                              ; daca is_balanced=1 si "stiva" stack e vida 
        push    dword 1
        pop     eax                    ; return 1
        jmp     the_end
not_balanced:                          ; altfel, return 0
        xor     eax, eax
the_end:
        pop     ebx                    ; restaurez ebx (conform conventiei)
	push 	ebp
	pop 	esp
	pop     ebp
        ret
