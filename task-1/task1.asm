section .text
	global sort

; struct node {
;     	int val;
;    	struct node* bubble;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
    enter 0, 0
    ;; folosesc vectorul node* addr[n]
    ;; in el retin adresele nodurilor date ca parametru
    ;; voi lucra cu adresele nodurilor, nu cu nodurile in sine
    ;; practic, voi sorta adresele (folosind bubble sort)
    push    ebx                         ; retin valoarea lui ebx
    mov     ebx, [ebp + 8]              ; ebx=n 
    imul    ebx, 4                      ; ebx=n*sizeof(node*)=4*n
    sub     esp, ebx                    ; fac loc pe stiva pentru addr[n]
    mov     esi, ebp                    ; esi=ebp
    sub     esi, ebx                    ; esi=ebp-4*n=addr
    xor     ecx, ecx                    ; ecx=i=0
copy_addresses:
    cmp     ecx, [ebp + 8]              ; daca i>=n 
    jge     bubble                      ; sfarsitul copierii adreselor in addr      
    mov     eax, [ebp + 12]             ; eax=node
    lea     edx, [eax + ecx*8]          ; edx=&node[i]
    mov     [esi + ecx*4], edx          ; addr[i]=&node[i]
    inc     ecx                         ; i++
    jmp     copy_addresses              ; inapoi la copy_addresses (for)
bubble:
    dec     dword [ebp + 8]             ; n--; la bubble sort merg pana la n-1
do:
    mov     edi, 1                      ; ok=1
    xor     ecx, ecx                    ; ecx=i=0
for1:
    cmp     ecx, [ebp + 8]              ; daca i>=n-1
    jge     while
compare_vals:
    mov     eax, [esi + ecx*4]          ; eax=addr[i]
    mov     edx, [eax]                  ; edx=addr[i]->val  
    inc     ecx                         ; ecx=i+1
    mov     eax, [esi + ecx*4]          ; eax=addr[i+1]
    dec     ecx                         ; ecx=i
    mov     eax, [eax]                  ; eax=addr[i+1]->val
    cmp     edx, eax                    ; daca addr[i]->val<=addr[i+1]->val
    jle     next                        ; nu schimb nimic, altfel interschimb addr[i] si addr[i+1]
swap:
    mov     eax, [esi + ecx*4]          ; eax=addr[i]
    inc     ecx                         ; ecx=i+1
    mov     edx, [esi + ecx*4]          ; edx=addr[i+1]
    dec     ecx                         ; ecx=i
    mov     [esi + ecx*4], edx          ; addr[i]=addr[i+1]
    inc     ecx                         ; ecx=i+1
    mov     [esi + ecx*4], eax          ; addr[i+1]=eax=addr[i]
    dec     ecx                         ; ecx=i
    xor     edi, edi                    ; ok=0
next:
    inc     ecx                         ; i++
    jmp     for1                        ; inapoi la for1
while:
    cmp     edi, 0                      ; daca ok=0 
    je      do                          ; inapoi la do (do while)
link_nodes:
    xor     ecx, ecx                    ; i=0
for2:
    cmp     ecx, [ebp + 8]              ; daca i>=n-1
    jge     the_end                     ; sfarsit
    mov     eax, [esi + ecx*4]          ; eax=addr[i]
    inc     ecx                         ; ecx=i+1
    mov     edx, [esi + ecx*4]          ; edx=addr[i+1]
    mov     [eax + 4], edx              ; addr[i]->next=addr[i+1]
    jmp     for2                        ; inapoi la for2
the_end:
    mov     eax, [esi + 0]              ; return addr[0] 
    add     esp, ebx                    ; sterg vectorul addr de pe stiva
    pop     ebx                         ; restaurez ebx (conform conventiei)
    leave
    ret
