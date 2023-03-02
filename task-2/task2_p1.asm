section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:
	;; folosesc formula a*b=(a,b)*[a,b]
	;; folosesc echivalenta mov eax, ebx <-> push ebx
	;;                                       pop eax
	;; calculez cmmdc cu algoritmul lui Euclid
	push	ebp
	push	esp
	pop 	ebp
	push	ebx                  ; retin valoarea lui ebx
	push	dword [ebp + 8]
	pop 	eax                  ; eax=a
	push	dword [ebp + 12]
	pop 	ebx                  ; ebx=b
	imul	eax, ebx             ; eax=a*b
	push	eax
	pop 	ecx                  ; ecx=eax=a*b
	push	dword [ebp + 8]
	pop 	eax                  ; eax=a
find_gcd:                 
	cmp 	eax, ebx             ; daca a=b
	je  	gcd_found            ; sfarsit cmmdc
	cmp 	eax, ebx             ; daca a<=b
	jle 	else
	sub 	eax, ebx             ; altfel a=a-b
	jmp 	find_gcd             ; inapoi la find_gcd (while)
else:
	sub 	ebx, eax             ; b=b-a
	jmp 	find_gcd             ; inapoi la find_gcd (while)
gcd_found:
	push	eax
	pop 	esi                  ; esi=eax=cmmdc
	push	ecx
	pop 	eax                  ; eax=ecx=a*b
	xor 	edx, edx             ; edx=0, golesc edx pentru impartire
	idiv	esi                  ; eax=eax/cmmdc=cmmmc, return cmmmc   
the_end:
	pop 	ebx                  ; restaurez ebx (conform conventiei)
	push	ebp
	pop 	esp
	pop 	ebp
	ret
