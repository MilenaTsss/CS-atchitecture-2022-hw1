	.file	"task3.c"
	.intel_syntax noprefix
	.text
	.section	.rodata
.LC0:
	.string	"%d"
.LC1:
	.string	"%d "
.LC5:
	.string	"%d\n"
	.text
	.globl	input
	.type	input, @function
input:
	push	rbp
	mov	rbp, rsp
	push	r14
	push	r13
	push	r12
	push	rbx
	mov	r13, rdi					# r13 = array
	mov	r12d, esi					# r12d = size
	mov	r14, rdx					# r14 = FILE* input_
	mov	ebx, 0						# i = 0
	jmp	.L2
.L3:
	mov	rdx, r13
	lea	rsi, .LC0[rip]
	mov	rdi, r14
	mov	eax, 0
	call	__isoc99_fscanf@PLT				# call fscanf rdi = input_, rsi = "%d", rdx = array + 4 * i
	add	ebx, 1						# i++
	add	r13, 4						# сдвигаем array на 4
.L2:
	cmp	ebx, r12d					# if i < size -> continue
	jl	.L3
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	rbp
	ret
	.size	input, .-input
	
	.globl	create_new_array
	.type	create_new_array, @function
create_new_array:					# здесь ничего не менялось
	push	rbp
	mov 	rbp, rsp
	push	rbx
	sub	rsp, 8
	mov	rbp, rsp				# rdi = array, rsi = new_array, edx = size
	mov 	eax, 0					# eax = i = 0
	mov 	ecx, 0					# ecx = j = 0
	jmp	.L5
.L7:
	movsx	r8, eax
	sal	r8, 2
	add	r8, rdi					# r8 = array + i * 4
	movsx	r9, ecx
	sal	r9, 2
	add	r9, rsi					# r9 = new_array + j * 4
	mov	r8d, DWORD PTR [r8]
	mov	DWORD PTR [r9], r8d
	add	eax, 1					# i++
	add	ecx, 2					# j += 2
.L5:
	lea	r8d, 1[rdx]				# r8d = size + 1
	mov	ebx, r8d				# ebx = size + 1
	shr	ebx, 31
	add	r8d, ebx
	sar	r8d					# r8d = (size + 1) / 2
	cmp	eax, r8d
	jge	.L6					# if (i >= (size + 1) / 2) -> cycle end
	cmp	ecx, edx				# if (j < size) -> cycle continue else cycle end
	jl	.L7
.L6:
	lea	eax, 1[rdx]				# eax = size + 1
	mov	r9d, eax				# r9d = size + 1
	shr	r9d, 31
	add	eax, r9d
	sar	eax					# eax = i = (size + 1) / 2
	mov	ecx, 1					# ecx = j = 1
	jmp	.L8
.L10:
	movsx   r8, eax
        sal     r8, 2
        add     r8, rdi				# r8 = array + i * 4
        movsx   r9, ecx
        sal     r9, 2
        add     r9, rsi				# r9 = new_array + j * 4
        mov     r8d, DWORD PTR [r8]
        mov     DWORD PTR [r9], r8d
        add     eax, 1                                # i++
        add     ecx, 2                                # j += 2
.L8:
	cmp	eax, edx
	jge	.L11					# if (i >= size) -> end cycle
	cmp	ecx, edx
	jl	.L10					# if (i < size && j < size) -> to cycle else -> end
.L11:
	add rsp, 8
	pop rbx
	pop rbp
	ret
	.size	create_new_array, .-create_new_array
	
	.globl	output
	.type	output, @function
output:
	push	rbp
	mov	rbp, rsp
	push	r14
	push	r13
	push	r12
	push	rbx
	mov	r13, rdi				# r13 = new_array
	mov	r12d, esi				# r12 = size
	mov	r14, rdx				# r14 = output_
	mov	ebx, 0					# i = 0
	jmp	.L13
.L14:
	mov     rdx, r13
	mov     edx, DWORD PTR [rdx]			# esi = array[i]
	lea	rsi, .LC1[rip]
	mov	rdi, r14
	mov	eax, 0
	call	fprintf@PLT				# call fprintf, rdi = FILE* output_, rsi = "%d ", edx = new_array[i]
	add	ebx, 1					# i++
	add	r13, 4					# сдвигаем array на 4
.L13:
	lea     eax, -1[r12]				# eax = size - 1
	cmp	ebx, eax
	jl	.L14					# if (i < size - 1) -> L14 else continue func and print last element
	mov	rdx, r13
	mov	edx, DWORD PTR [rdx]			# edx = array[size - 1]
	lea	rsi, .LC5[rip]				# rsi = "%d\n"
	mov	rdi, r14
	mov	eax, 0
	call	fprintf@PLT				# call fprintf, rdi = FILE* output_, rsi = "%d\n", edx = new_array[i]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	rbp
	ret
	.size	output, .-output
