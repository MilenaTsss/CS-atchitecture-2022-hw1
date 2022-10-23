	.file	"task_2.c"
	.intel_syntax noprefix
	.text
	.section	.rodata
.input:
	.string	"%d"
output1:
        .string "%d "
output2:
        .string "%d\n"

	.text
	.type	input, @function
input:
	push	rbp
	mov	rbp, rsp
	push	r13					# сохраняем r13, r12, rbx
	push	r12
	push	rbx
	sub	rsp, 8					# выравниваем стек
	mov	r13, rdi				# r13 = array
	mov	r12d, esi				# r12d = size
	mov	ebx, 0					# ebx = i = 0
	jmp	.L2
.L3:
        mov     rsi, r13
	lea	rdi, .input[rip]
	mov	eax, 0
	call	__isoc99_scanf@PLT			# call scanf with rdi = "%d", rsi = array + 4 * i
	add	ebx, 1					# i++
	add	r13, 4					# сдвигаем array на 4
.L2:
	cmp	ebx, r12d				# if i < size -> continue
	jl	.L3
	add	rsp, 8
	pop	rbx
	pop	r12
	pop	r13
	pop	rbp
	ret
	.size	input, .-input

	.type	create_new_array, @function
create_new_array:
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
        add     r8, rdi                                 # r8 = array + i * 4
        movsx   r9, ecx
        sal     r9, 2
        add     r9, rsi                                 # r9 = new_array + j * 4
        mov     r8d, DWORD PTR [r8]
        mov     DWORD PTR [r9], r8d
        add     eax, 1                                  # i++
        add     ecx, 2                                  # j += 2
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

	.type	output, @function
output:
	push	rbp
	mov	rbp, rsp
	push	r13					# сохраняем r13, r12, rbx
	push	r12
	push	rbx
	sub	rsp, 8					# выравниваем стек по 16
	mov	r13, rdi				# r13 = array
	mov	r12d, esi				# r12d = size
	mov	ebx, 0					# ebx = i = 0
	jmp	.L13
.L14:
	mov     rsi, r13
        mov     esi, DWORD PTR [rsi]			# esi = array[i]
        lea     rdi, output1[rip]
        mov     eax, 0
	call	printf@PLT				# call printf with rdi = "%d ", esi = array[i]
	add	ebx, 1					# i++
	add	r13, 4					# сдвигаем array на следующий элемент
.L13:
	lea     eax, -1[r12]				# eax = size - 1
	cmp	ebx, eax
	jl	.L14					# if (i < size - 1) -> L14 else continue func and print last element
	mov	rsi, r13
	mov	esi, DWORD PTR [rsi]			# esi = array[size - 1]
	lea	rdi, output2[rip]
	mov	eax, 0
	call	printf@PLT				# call printf with rdi = "%d\n", esi = array[size - 1]
	add	rsp, 8
	pop	rbx
	pop	r12
	pop	r13
	pop	rbp
	ret
	.size	output, .-output

	.globl  main
	.type	main, @function
main:
	push	rbp
	mov	rbp, rsp
	push    r13
        push    r12
        push    rbx
        sub     rsp, 24
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -40[rbp], rax
	xor	eax, eax

	lea	rax, -44[rbp]
	mov	rsi, rax				# rax = n - хранится на стеке по адресу rbp - 44
	lea	rdi, .input[rip]			# rdi = "%d"
	mov	eax, 0
	call	__isoc99_scanf@PLT			# call scanf with rdi = "%d", rsi = n

	mov	r13d, DWORD PTR -44[rbp]		# r13d  = size
	movsx   rax, r13d				
	sal	rax, 2
	mov	rdi, rax				# rdi = size * 4
	call	malloc@PLT				# call malloc with rdi = size * 4
	mov	r12, rax				# r12 = array = result of malloc
	movsx	rax, r13d
	sal	rax, 2
	mov	rdi, rax
	call	malloc@PLT				# call malloc with rdi = size * 4
	mov	rbx, rax				# rbx = array = result of malloc

	mov	esi, r13d
	mov	rdi, r12
	call	input					# call input with rdi = array, esi = size

	mov	edx, r13d
	mov	rsi, rbx
	mov	rdi, r12
	call	create_new_array			# call input with rdi = array, rsi = new_array, edx = size

	mov	esi, r13d
	mov	rdi, rbx
	call	output					# call output with rdi = new_array, esi = size

	mov	rdi, r12
	call	free@PLT				# free array

	mov	rdi, rbx
	call	free@PLT				# free new_array

	mov	eax, 0
	mov	rcx, QWORD PTR -40[rbp]
	xor	rcx, QWORD PTR fs:40
	je	.L17
	call	__stack_chk_fail@PLT
.L17:
	add	rsp, 24
	pop	rbx
	pop	r12
	pop	r13
	pop	rbp
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
