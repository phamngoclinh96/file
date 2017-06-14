.386 
.model flat,stdcall 
option casemap:none 
include C:\masm32\include\windows.inc 
include C:\masm32\include\user32.inc 
include C:\masm32\include\kernel32.inc 
include C:\masm32\include\gdi32.inc 
includelib C:\masm32\lib\user32.lib 
includelib C:\masm32\lib\kernel32.lib 
includelib C:\masm32\lib\gdi32.lib
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD 
IDB_MAIN   equ 1

.data 
ClassName db "SimpleWin32ASMBitmapClass",0 
AppName  db "Win32ASM Simple Bitmap Example",0

.data? 
hInstance HINSTANCE ? 
CommandLine LPSTR ? 
hBitmap dd ?
pen HPEN ?
wc WNDCLASSEX <?>
msg MSG <?>
hwnd HWND ?
ps PAINTSTRUCT <?> 
hdc HDC ?
hMemDC HDC ?
rect RECT <?>
x1 dw ?
y1 dw ?
x2 dw ?
y2 dw ?
.code 
start: 
 ;invoke GetModuleHandle, NULL 
 push NULL
 call GetModuleHandle
 mov    hInstance,eax 
 ;invoke GetCommandLine 
 call GetCommandLine
 mov    CommandLine,eax 
 ;invoke WinMain, hInstance,NULL,CommandLine, SW_SHOWDEFAULT 
 push SW_SHOWDEFAULT
 push CommandLine
 push NULL
 push hInstance
 call WinMain
 ;invoke ExitProcess,eax
 push eax
 call ExitProcess

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD 
 
 mov   wc.cbSize,SIZEOF WNDCLASSEX 
 mov   wc.style, CS_HREDRAW or CS_VREDRAW 
 mov   wc.lpfnWndProc, OFFSET WndProc 
 mov   wc.cbClsExtra,NULL 
 mov   wc.cbWndExtra,NULL 
 push  hInstance 
 pop   wc.hInstance 
 mov   wc.hbrBackground,COLOR_WINDOW+1 
 mov   wc.lpszMenuName,NULL 
 mov   wc.lpszClassName,OFFSET ClassName 
 ;invoke LoadIcon,NULL,IDI_APPLICATION 
 push IDI_APPLICATION
 push NULL
 call LoadIcon
 mov   wc.hIcon,eax 
 mov   wc.hIconSm,eax 
 ;invoke LoadCursor,NULL,IDC_ARROW 
 push IDC_ARROW
 push NULL
 call LoadCursor
 mov   wc.hCursor,eax 
 ;invoke RegisterClassEx, addr wc 
 push offset wc
 call RegisterClassEx
 ;INVOKE CreateWindowEx,NULL,ADDR ClassName,ADDR AppName,\ 
 ;          WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\ 
 ;          CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,\ 
 ;          hInst,NULL 
 push NULL
 push hInst
 push NULL
 push NULL
 push CW_USEDEFAULT
 push CW_USEDEFAULT
 push CW_USEDEFAULT
 push CW_USEDEFAULT
 push WS_OVERLAPPEDWINDOW
 push offset AppName
 push offset ClassName
 push NULL
 call CreateWindowEx
 mov   hwnd,eax 
 ;invoke ShowWindow, hwnd,SW_SHOWNORMAL 
 push SW_SHOWNORMAL
 push hwnd
 call ShowWindow
 ;invoke UpdateWindow, hwnd 
 push hwnd
 call UpdateWindow
 ;.while TRUE 
loop_message: 
  ;invoke GetMessage, ADDR msg,NULL,0,0 
  push 0
  push 0
  push NULL
  push offset msg
  call GetMessage
  ;.break .if (!eax)
  or eax,eax
  ;cmp eax,0
  je exit_loop
  ;invoke TranslateMessage, ADDR msg 
  push offset msg
  call TranslateMessage
  ;invoke DispatchMessage, ADDR msg 
  push offset msg
  call DispatchMessage
  jmp loop_message
 ;.endw 
 exit_loop:
 mov     eax,msg.wParam 
 ret 
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 
  
   .if uMsg==WM_CREATE 
      invoke LoadBitmap,hInstance,IDB_MAIN 
      mov hBitmap,eax 
   .elseif uMsg==WM_PAINT 
      invoke BeginPaint,hWnd,addr ps 
      mov    hdc,eax 
      invoke CreateCompatibleDC,hdc 
      mov    hMemDC,eax 
      invoke SelectObject,hMemDC,hBitmap 
      invoke GetClientRect,hWnd,addr rect 
      invoke BitBlt,hdc,0,0,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
      invoke DeleteDC,hMemDC 
	  invoke MoveToEx,ps.hdc,x2,y2,NULL
	  invoke SelectObject ,ps.hdc,pen
	  invoke LineTo,ps.hdc,x1,y1
	  mov bx,x1
	  mov x2,bx
	  mov bx,y1
	  mov y2,bx
      invoke EndPaint,hWnd,addr ps 
	.elseif uMsg == WM_MOUSEMOVE
		.if wParam==MK_LBUTTON
			mov eax,lParam
			mov x1,ax
			shr eax,16
			mov y1,ax
			invoke Chord , hdc,x1,y1,x2,y2,x1,y1,x2,y2
			invoke InvalidateRect,hWnd,NULL,FALSE
		.endif
 .elseif uMsg==WM_DESTROY 
  invoke DeleteObject,hBitmap 
  invoke PostQuitMessage,NULL 
 .ELSE 
  invoke DefWindowProc,hWnd,uMsg,wParam,lParam 
  ret 
 .ENDIF 
 xor eax,eax 
 ret 
WndProc endp 
end start