	.file	"task.c"		# название программы
	.intel_syntax noprefix
	.text
	.section	.rodata
.LC0:
	.string	"%d"			# форматная строка для ввода
	.text
	.globl	input			# объявление функции input
	.type	input, @function
input:
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32 # пролог
	mov	QWORD PTR -24[rbp], rdi	 # array = rdi
	mov	DWORD PTR -28[rbp], esi	 # size = esi
	mov	DWORD PTR -4[rbp], 0	 # i = 0
	jmp	.L2			# переход в проверку условия цикла
.L3:
	mov	eax, DWORD PTR -4[rbp]	# eax = i
	cdqe
	lea	rdx, 0[0+rax*4]		# rdx = i * 4
	mov	rax, QWORD PTR -24[rbp]	# rax = array
	add	rax, rdx		# rax = array + i * 4
	mov	rsi, rax		# rsi = rax, чтобы освободить rax
	lea	rdi, .LC0[rip]		# rdi = "%d"
	mov	eax, 0			# зануляем eax
	call	__isoc99_scanf@PLT	# вызываем функцию scanf с аргументами rdi, rsi
	add	DWORD PTR -4[rbp], 1	# i++
.L2:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -28[rbp]	# i < size
	jl	.L3 # если i < size то идем в L3 делать ввод
	nop
	nop
	leave	# эпилог
	ret
	.size	input, .-input
	.globl	create_new_array	# объявление функции
	.type	create_new_array, @function
create_new_array:
	endbr64
	push	rbp
	mov	rbp, rsp		# пролог
	mov	QWORD PTR -24[rbp], rdi	# array = rdi
	mov	QWORD PTR -32[rbp], rsi	# new_array = rsi
	mov	DWORD PTR -36[rbp], edx	# size = edx
	mov	DWORD PTR -16[rbp], 0	# i = 0
	mov	DWORD PTR -12[rbp], 0	# j = 0
	jmp	.L5
.L7:					# условия цикла выполнены
	mov	eax, DWORD PTR -16[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]		# rdx = i * 4
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx		# rax = array + i * 4
	mov	edx, DWORD PTR -12[rbp]	# edx = j
	movsx	rdx, edx		
	lea	rcx, 0[0+rdx*4]		# rcx = j * 4
	mov	rdx, QWORD PTR -32[rbp]
	add	rdx, rcx		# rdx = new_array + j * 4
	mov	eax, DWORD PTR [rax]	# eax = array[i]
	mov	DWORD PTR [rdx], eax	# new_array[j] = array[i]
	add	DWORD PTR -16[rbp], 1	# i++
	add	DWORD PTR -12[rbp], 2	# j += 2 + переход в проверку условий L5
.L5:
	mov	eax, DWORD PTR -36[rbp]
	add	eax, 1			# eax = size + 1
	mov	edx, eax		# edx = size + 1
	shr	edx, 31			
	add	eax, edx		
	sar	eax			# eax = (size + 1) / 2
	cmp	DWORD PTR -16[rbp], eax
	jge	.L6			# if i >= (size + 1) / 2 -> L6 - переход в выход из цикла
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -36[rbp]
	jl	.L7			# if i < (size + 1) / 2 && j < size -> L7 else -> L6 - выход из цикла
.L6:
	mov	eax, DWORD PTR -36[rbp]
	add	eax, 1
	mov	edx, eax
	shr	edx, 31
	add	eax, edx
	sar	eax			# eax = (size + 1) / 2
	mov	DWORD PTR -8[rbp], eax	# i = (size + 1) / 2
	mov	DWORD PTR -4[rbp], 1	# j = 1
	jmp	.L8
.L10:					# следующий цикл
	mov	eax, DWORD PTR -8[rbp]	# eax = i
	cdqe
	lea	rdx, 0[0+rax*4]		# edx = i * 4
	mov	rax, QWORD PTR -24[rbp]	# rax = array
	add	rax, rdx		# rax = array + i * 4
	mov	edx, DWORD PTR -4[rbp]	# edx = j
	movsx	rdx, edx
	lea	rcx, 0[0+rdx*4]		# rcx = j * 4
	mov	rdx, QWORD PTR -32[rbp]
	add	rdx, rcx		# rdx new_array + j * 4
	mov	eax, DWORD PTR [rax]	# eax = array[i]
	mov	DWORD PTR [rdx], eax	# new_array[j] = array[i]
	add	DWORD PTR -8[rbp], 1	# i++
	add	DWORD PTR -4[rbp], 2	# j += 2
.L8:					# проверка условия цикла
	mov	eax, DWORD PTR -8[rbp]
	cmp	eax, DWORD PTR -36[rbp]
	jge	.L11			# if i >= size -> L11 - выход из цикла
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -36[rbp]
	jl	.L10			# if i < size && j < size -> L10 - переход в цикл else L11 - выход из цикла
.L11:
	nop
	pop	rbp			# эпилог
	ret
	.size	create_new_array, .-create_new_array
	.section	.rodata
.LC1:
        .string "%d "			# форматная строка вывода
.LC2:
        .string "%d\n"			# форматная строка вывода
        .text
	.globl	output			# объявление функции вывода
	.type	output, @function
output:
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32			# пролог
	mov	QWORD PTR -24[rbp], rdi	# array = rdi
	mov	DWORD PTR -28[rbp], esi # size = esi
	mov	DWORD PTR -4[rbp], 0	# i = 0
	jmp	.L13			# переход к проверке условия цикла
.L14:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]		# rdx = i * 4
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx		# rax = array + i * 4
	mov	eax, DWORD PTR [rax]	# eax = array[i]
	mov	esi, eax		# esi = array[i]
	lea	rdi, .LC1[rip]		# rdi = "%d "
	mov	eax, 0			
	call	printf@PLT		# вызываем функцию printf для rdi, esi
	add	DWORD PTR -4[rbp], 1	# i++
.L13:
	mov	eax, DWORD PTR -28[rbp]	
	sub	eax, 1			# eax = size - 1
	cmp	DWORD PTR -4[rbp], eax
	jl	.L14			# if (i < size - 1) -> в цикл else продолжить после цикла
	mov	eax, DWORD PTR -28[rbp] # eax = size
	cdqe
	sal	rax, 2
	lea	rdx, -4[rax]		# rdx = (size - 1) * 4
	mov	rax, QWORD PTR -24[rbp]	# rax = array
	add	rax, rdx		# rax = array + (size - 1) * 4
	mov	eax, DWORD PTR [rax]	# eax = array[size - 1]
	mov	esi, eax		# esi = array[size - 1]
	lea	rdi, .LC2[rip]		
	mov	eax, 0
	call	printf@PLT		# вызов функции printf для rdi, esi
	nop
	leave				# эпилог
	ret
	.size	output, .-output
	.globl	main
	.type	main, @function
main:
	endbr64				# пролог
	push	rbp
	mov	rbp, rsp
	push	r15
	push	r14
	push	r13
	push	r12
	push	rbx
	sub	rsp, 88
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -56[rbp], rax	
	xor	eax, eax
	mov	rax, rsp
	mov	rbx, rax
	lea	rax, -92[rbp]
	mov	rsi, rax		# rsi = &size
	lea	rdi, .LC0[rip]		# rdi = "%d"
	mov	eax, 0
	call	__isoc99_scanf@PLT	# call scanf with rdi = "%d", esi = &size
	mov	eax, DWORD PTR -92[rbp]
	movsx	rdx, eax
	sub	rdx, 1
	mov	QWORD PTR -88[rbp], rdx	# размер array, дальше идет создание этого массива
	movsx	rdx, eax
	mov	QWORD PTR -112[rbp], rdx
	mov	QWORD PTR -104[rbp], 0
	movsx	rdx, eax
	mov	QWORD PTR -128[rbp], rdx
	mov	QWORD PTR -120[rbp], 0
	cdqe
	lea	rdx, 0[0+rax*4]
	mov	eax, 16
	sub	rax, 1
	add	rax, rdx
	mov	edi, 16
	mov	edx, 0
	div	rdi
	imul	rax, rax, 16
	mov	rdx, rax
	and	rdx, -4096
	mov	rcx, rsp
	sub	rcx, rdx
	mov	rdx, rcx
.L16:
	cmp	rsp, rdx
	je	.L17
	sub	rsp, 4096
	or	QWORD PTR 4088[rsp], 0
	jmp	.L16
.L17:
	mov	rdx, rax
	and	edx, 4095
	sub	rsp, rdx
	mov	rdx, rax
	and	edx, 4095
	test	rdx, rdx
	je	.L18
	and	eax, 4095
	sub	rax, 8
	add	rax, rsp
	or	QWORD PTR [rax], 0
.L18:
	mov	rax, rsp
	add	rax, 3
	shr	rax, 2
	sal	rax, 2
	mov	QWORD PTR -80[rbp], rax		# array[size]
	mov	eax, DWORD PTR -92[rbp]
	movsx	rdx, eax
	sub	rdx, 1
	mov	QWORD PTR -72[rbp], rdx		# размер new_array, дальше создание массива
	movsx	rdx, eax
	mov	r14, rdx
	mov	r15d, 0
	movsx	rdx, eax
	mov	r12, rdx
	mov	r13d, 0
	cdqe
	lea	rdx, 0[0+rax*4]
	mov	eax, 16
	sub	rax, 1
	add	rax, rdx
	mov	ecx, 16
	mov	edx, 0
	div	rcx
	imul	rax, rax, 16
	mov	rdx, rax
	and	rdx, -4096
	mov	rsi, rsp
	sub	rsi, rdx
	mov	rdx, rsi
.L19:
	cmp	rsp, rdx
	je	.L20
	sub	rsp, 4096
	or	QWORD PTR 4088[rsp], 0
	jmp	.L19
.L20:
	mov	rdx, rax
	and	edx, 4095
	sub	rsp, rdx
	mov	rdx, rax
	and	edx, 4095
	test	rdx, rdx
	je	.L21
	and	eax, 4095
	sub	rax, 8
	add	rax, rsp
	or	QWORD PTR [rax], 0
.L21:
	mov	rax, rsp
	add	rax, 3
	shr	rax, 2
	sal	rax, 2
	mov	QWORD PTR -64[rbp], rax	# new_array[size]
	mov	edx, DWORD PTR -92[rbp]	# edx = size
	mov	rax, QWORD PTR -80[rbp] # rax = array
	mov	esi, edx		# esi = size
	mov	rdi, rax		# rdi = array
	call	input			# call input with rdi = array, rsi = size
	mov	edx, DWORD PTR -92[rbp]	# edx = size
	mov	rcx, QWORD PTR -64[rbp]	# rcx = new_array
	mov	rax, QWORD PTR -80[rbp]	# rax = array
	mov	rsi, rcx		# rsi = new_array
	mov	rdi, rax		# rdi = array
	call	create_new_array	# call create_new_array with rdi = array, rsi = new_array, edx = size
	mov	edx, DWORD PTR -92[rbp]	# edx = size
	mov	rax, QWORD PTR -64[rbp]	# rax = new_array
	mov	esi, edx		# esi = size
	mov	rdi, rax		# rdi = new_array
	call	output			# call output with rdi = new_array, rsi = size
	mov	eax, 0
	mov	rsp, rbx
	mov	rbx, QWORD PTR -56[rbp]
	xor	rbx, QWORD PTR fs:40
	je	.L23
	call	__stack_chk_fail@PLT
.L23:
	lea	rsp, -40[rbp]		# эпилог
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
