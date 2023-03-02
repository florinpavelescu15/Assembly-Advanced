global get_words
global compare_func
global sort

section .rodata
    delim db " .,", 0

section .text
extern strtok
extern qsort
extern strcmp
extern strlen

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0
    ;; void qsort(void *base, size_t nitems, size_t size, int (*compar)(const void*, const void*))
    ; pun argumentele functiei qsort pe stiva, in ordine inversa 
    push    compare_func         ; functia de comparare
    push    dword [ebp + 16]     ; dimensiunea tipului de date 
    push    dword [ebp + 12]     ; numarul de cuvinte
    push    dword [ebp + 8]      ; vectorul de cuvinte
    call    qsort                ; apelez qsort: qsort(words, number_of_words, size, compare_func)
    add     esp, 16              ; curat stiva
the_end_sort:
    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0
    mov     edi, [ebp + 12]      ; edi=words
    ; char *strtok(char *str, const char *delim)  
    ; pun argumentele functiei strtok pe stiva, in ordine inversa
    push    delim                ; delimitatorii
    push    dword [ebp + 8]      ; sirul de caractere care trebuie impartit 
    call    strtok               ; apelez strtok: eax=pch=strtok(str, delim)
    add     esp, 8               ; curat stiva
    xor     esi, esi             ; esi=i=0 (indicele din words)
while:
    cmp     eax, 0               ; daca pch=NULL
    je      the_end_get_words    ; sfarsitul impartirii in cuvinte
    mov     [edi + esi*4], eax   ; words[i]=pch
    inc     esi                  ; i++
    ; pun argumentele functiei strtok pe stiva, in ordine inversa
    push    delim                ; delimitatorii
    push    dword 0              ; NULL
    call    strtok               ; eax=pch=strtok(NULL, delim)     
    add     esp, 8               ; curat stiva 
    jmp     while                ; inapoi la while
the_end_get_words: 
    leave
    ret

;; int compare_func(const void *a, const void *b)
;  functia de comparare a doua cuvinte (siruri de caractere)
compare_func:
    enter 0, 0
    push    ebx                 ; retin valoarea lui ebx
    mov     eax, [ebp + 8]      ; eax=a
    push    dword [eax]         ; pun argumentul functiei strlen pe stiva
    call    strlen              ; apelez strlen: eax=strlen(a)
    add     esp, 4              ; curat stiva
    mov     ebx, eax            ; ebx=eax=strlen(a)
    mov     eax, [ebp + 12]     ; eax=b
    push    dword [eax]         ; pun argumentul functiei strlen pe stiva
    call    strlen              ; apelez strlen: eax=strlen(b)
    add     esp, 4              ; curat stiva
compare_len:
    cmp     ebx, eax            ; daca strlen(a)=strlen(b)
    je      equals_lens         ; compar lexicografic
    sub     ebx, eax            ; altfel, ebx=strlen(a)-strlen(b)
    mov     eax, ebx            ; return strlen(a)-strlen(b)
    jmp     the_end_compare     ; sfarsitul comparatiei
equals_lens:
    ; pun argumentele functiei strcmp pe stiva, in ordine inversa
    mov     eax, [ebp + 12]     ; eax=b
    push    dword [eax]         ; pun b pe stiva
    mov     eax, [ebp + 8]      ; eax=a
    push    dword [eax]         ; pun a pe stiva
    call    strcmp              ; apelez strcmp: eax=strcmp(a,b); practic, returnez strcmp(a,b)
    add     esp, 8              ; curat stiva
the_end_compare:                ; sfarsitul comparatiei
    pop     ebx                 ; restaurez ebx (conform conventiei)
    leave
    ret
