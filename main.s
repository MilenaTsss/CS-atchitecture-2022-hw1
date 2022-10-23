	.intel_syntax noprefix
	.section	.rodata
.LC0:
	.string	"%d"
.LC2:
	.string	"Please give input and output file"
.LC3:
	.string	"r"
.LC4:
	.string	"w"
.LC6:
	.string	"stdin"
.LC7:
	.string	"stdout"
	
	.text
	.globl	main
	.type	main, @function
main:
	push	rbp
	mov	rbp, rsp
	push	r15
	push	r14
	push	r13
	push	r12
	push	rbx
	sub	rsp, 40
	mov	DWORD PTR -68[rbp], edi		# DWORD PTR -68[rbp] = argc 
	mov	QWORD PTR -80[rbp], rsi		# DWORD PTR -64[rbp] = argv
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -56[rbp], rax		# ret
	xor	eax, eax
	cmp	DWORD PTR -68[rbp], 3
	je	.L16					# if argc == 3 -> continue
	lea	rdi, .LC2[rip]
	mov	eax, 0
	call	printf@PLT				# printf help message
	mov	eax, 0
	jmp	.L24					# go to end
.L16:
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	lea	rsi, .LC6[rip]
	mov	rdi, rax
	call	strcmp@PLT				# strcmp argv[1] && "stdin"
	test	eax, eax
	jne	.L18					# if argv[1] == "stdin" -> r12 = stdin, else r12 = fopen
	mov	r12, QWORD PTR stdin[rip]
	jmp	.L19
.L18:
	mov	rax, QWORD PTR -80[rbp]		
	add	rax, 8
	mov	rax, QWORD PTR [rax]			# rax = argv[1]
	lea	rsi, .LC3[rip]
	mov	rdi, rax
	call	fopen@PLT				# fopen rdi = argv[1], rsi = "r"
	mov	r12, rax				# r12 = File * input_
.L19:
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	lea	rsi, .LC7[rip]
	mov	rdi, rax
	call	strcmp@PLT				# strcmp argv[2] && "stdout"	
	test	eax, eax
	jne	.L20
	mov	r15, QWORD PTR stdout[rip]		# if (argv[2] == "stdout") -> r15 = stdout, else r15 = fopen
	jmp	.L21
.L20:
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]			# rax = argv[2]
	lea	rsi, .LC4[rip]
	mov	rdi, rax
	call	fopen@PLT				# fopen rdi = argv[2], rsi = "w"
	mov	r15, rax				# r15 = file* output_
.L21:
	lea	rax, -60[rbp]				# rax = &size
	mov	rdx, rax
	lea	rsi, .LC0[rip]
	mov	rdi, r12
	mov	eax, 0
	call	__isoc99_fscanf@PLT			# fscanf rdi = input_, rsi = "%d", rdx = size
	
	mov	ebx, DWORD PTR -60[rbp]
	movsx	rax, ebx
	sal	rax, 2					# rax = size * 4
	mov	rdi, rax
	call	malloc@PLT				# malloc rdi = size * 4
	mov	r14, rax				# r13 = array
	
	movsx	rax, ebx				# rbx = size * 4
	sal	rax, 2
	mov	rdi, rax
	call	malloc@PLT				# malloc rdi = size * 4
	mov	r13, rax				# r13 = new_array
	
	mov	rdx, r12
	mov	esi, ebx
	mov	rdi, r14
	call	input					# rdi = array, esi = size, rbx = input_
	
	mov	edx, ebx
	mov	rsi, r13
	mov	rdi, r14
	call	create_new_array			# rdi = array, rsi = new_array, ebx = size
	
	mov	rdx, r15
	mov	esi, ebx
	mov	rdi, r13
	call	output					# rdi = new_array, rsi = size, rdx = r15 = output_
	
	mov	rdi, r14
	call	free@PLT				# free rdi = array
	
	mov	rdi, r13
	call	free@PLT				# free rdi = new_array
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	lea	rsi, .LC4[rip]
	mov	rdi, rax
	call	strcmp@PLT
	test	eax, eax
	je	.L22					# if argv[1] != "stdin" -> close
	mov	rdi, r12
	call	fclose@PLT
.L22:
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	lea	rsi, .LC6[rip]
	mov	rdi, rax
	call	strcmp@PLT
	test	eax, eax
	je	.L23					# if argv[2] != "stdout" -> close
	mov	rdi, r15
	call	fclose@PLT
.L23:
	mov	eax, 0
.L24:
	mov	rcx, QWORD PTR -56[rbp]
	xor	rcx, QWORD PTR fs:40
	je	.L25
	call	__stack_chk_fail@PLT
.L25:
	add	rsp, 40
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
