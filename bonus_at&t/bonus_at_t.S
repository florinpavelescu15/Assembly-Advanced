/*
 * Don't forget to include "positions.h"
 */
#include "positions.h"

.section .text
.global add_vect

/* 
 * void add_vect(int *v1, int *v2, int n, int *v)
 *
 * add v1 and v2, that have both the length n, and store the result in v3.
 * also, substract from v3 the values provided in positions.S, as described
 * in the task
 */

add_vect:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx                            // retin valoarea lui ebx
	movl	8(%ebp), %eax                   // eax=v1
	movl	12(%ebp), %ebx                  // ebx=v2
	movl	20(%ebp), %edi                  // edi=v
	xorl	%ecx, %ecx                      // ecx=i=0
add_values:
	cmpl	16(%ebp), %ecx                  // daca i>=n
	jge 	first_subtraction               // sfarsitul adunarii elementelor
	movl	(%eax, %ecx, 4), %esi           // esi=v1[i]
	addl	(%ebx, %ecx, 4), %esi           // esi=v1[i]+v2[i]
	movl	%esi, (%edi, %ecx, 4)           // v[i]=v1[i]+v2[i]
	incl	%ecx                            // i++
	jmp 	add_values                      // inapoi la add_values (for)
first_subtraction:
	movl	16(%ebp), %eax	                // eax=n
	xorl	%edx, %edx                      // edx=0
	imull	$FIRST_POSITION, %eax           // eax=n*FIRST_POSITION
	movl	$10, %ecx                       
	idivl	%ecx                            // eax=n*FIRST_POSITION/10 (scalare)                  
	subl 	$FIRST_VALUE, (%edi, %eax, 4)   // v[n*FIRST_POSITION/10]-=FIRST_VALUE
second_subtraction:	
	movl	16(%ebp), %eax	                // eax=n
	xorl	%edx, %edx                      // edx=0
	imull	$SECOND_POSITION, %eax          // eax=n*SECOND_POSITION
	movl	$10, %ecx
	idivl	%ecx                            // eax=n*SECOND_POSITION/10 (scalare)
	subl	$SECOND_VALUE, (%edi, %eax, 4)  // v[n*SECOND_POSITION/10]-=SECOND_VALUE
third_subtraction:
	movl	16(%ebp), %eax	                // eax=n
	xorl	%edx, %edx                      // edx=0
	imull	$THIRD_POSITION, %eax           // eax=n*THIRD_POSITION
	movl	$10, %ecx
	idivl	%ecx                            // eax=n*THIRD_POSITION/10 (scalare)
	subl	$THIRD_VALUE, (%edi, %eax, 4)   // v[n*THIRD_POSITION/10]-=THIRD_VALUE
the_end:
	popl	%ebx                            // la final, restaurez ebx (conform conventiei)
	leave
	ret
