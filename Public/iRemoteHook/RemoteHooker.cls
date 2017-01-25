VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "iRemoteHook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'ģ������iRemoteHook
'���ߣ�liuzikai [liuzikai@163.com]
'���ڣ�2015��7��17��
'�汾��V1.0
'˵����ִ��Զ��Hook
'       1.ע����Ҫ���ص���Ϣ��       .RegisterMessage(��Ϣ)
'       2.ע��Hook��                .Inject(�߳�ID)
'       3.��ע��Hook��              .UnInject
'       4.������Ϣ��MiniWindow��    .MsgWindow
'       5.���ص���Ϣʱ������         Event GetCallWndMessage��������Ϊ��Ϣ���ݣ�Result���÷���ֵ��

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)

Private Type CWPSTRUCT
        lParam As Long
        wParam As Long
        Message As Long
        hWnd As Long
End Type

Private Type COPYDATASTRUCT
        dwData As Long
        cbData As Long
        lpData As Long
End Type

Private Const WM_COPYDATA = &H4A

#If 1 Then

    Private Declare Function DLL_CALLWNDHOOK_RegisterMessage Lib "Public\iRemoteHook\iDLL_CALLWNDHOOK\Debug\iDll.dll" Alias "RegisterMessage" (ByVal Msg As Long, ByVal hReciver As Long) As Long
    Private Declare Function DLL_CALLWNDHOOK_SetHook Lib "Public\iRemoteHook\iDLL_CALLWNDHOOK\Debug\iDll.dll" Alias "SetHook" (ByVal TID As Long) As Long
    Private Declare Sub DLL_CALLWNDHOOK_UnHook Lib "Public\iRemoteHook\iDLL_CALLWNDHOOK\Debug\iDll.dll" Alias "UnHook" ()
    
    Private Declare Function DLL_GETMESSAGE_RegisterMessage Lib "Public\iRemoteHook\iDLL_GETMESSAGE\Debug\iDll.dll" Alias "RegisterMessage" (ByVal Msg As Long, ByVal hReciver As Long) As Long
    Private Declare Function DLL_GETMESSAGE_SetHook Lib "Public\iRemoteHook\iDLL_GETMESSAGE\Debug\iDll.dll" Alias "SetHook" (ByVal TID As Long) As Long
    Private Declare Sub DLL_GETMESSAGE_UnHook Lib "Public\iRemoteHook\iDLL_GETMESSAGE\Debug\iDll.dll" Alias "UnHook" ()

#Else

    Private Declare Function DLL_CALLWNDHOOK_RegisterMessage Lib "..\Public\iRemoteHook\iDLL_CALLWNDHOOK\Debug\iDll.dll" Alias "RegisterMessage" (ByVal Msg As Long, ByVal hReciver As Long) As Long
    Private Declare Function DLL_CALLWNDHOOK_SetHook Lib "..\Public\iRemoteHook\iDLL_CALLWNDHOOK\Debug\iDll.dll" Alias "SetHook" (ByVal TID As Long) As Long
    Private Declare Sub DLL_CALLWNDHOOK_UnHook Lib "..\Public\iRemoteHook\iDLL_CALLWNDHOOK\Debug\iDll.dll" Alias "UnHook" ()
    
    Private Declare Function DLL_GETMESSAGE_RegisterMessage Lib "..\Public\iRemoteHook\iDLL_GETMESSAGE\Debug\iDll.dll" Alias "RegisterMessage" (ByVal Msg As Long, ByVal hReciver As Long) As Long
    Private Declare Function DLL_GETMESSAGE_SetHook Lib "..\Public\iRemoteHook\iDLL_GETMESSAGE\Debug\iDll.dll" Alias "SetHook" (ByVal TID As Long) As Long
    Private Declare Sub DLL_GETMESSAGE_UnHook Lib "..\Public\iRemoteHook\iDLL_GETMESSAGE\Debug\iDll.dll" Alias "UnHook" ()

#End If

Private Declare Function GetWindowThreadProcessId Lib "user32" (ByVal hWnd As Long, lpdwProcessId As Long) As Long

Dim WithEvents MiniWindow As iMiniWindow
Attribute MiniWindow.VB_VarHelpID = -1

Event GetCallWndMessage(ByRef Result As Long, ByVal hWnd As Long, ByVal Message As Long, ByVal wParam As Long, ByVal lParam As Long)

Public Enum iRemoteHook_Mode
    SubClass = 1
    CALLWNDPROCHOOK = 2
    GETMESSAGEHOOK = 3
End Enum

Dim m_Mode As iRemoteHook_Mode

Public Function GetThreadIDByhWnd(ByVal hWnd As Long) As Long
    GetThreadIDByhWnd = GetWindowThreadProcessId(hWnd, 0&)
End Function

Public Sub SetMode(ByVal Mode As iRemoteHook_Mode)
    m_Mode = Mode
End Sub

'Ϊ�˱�֤����Ч�ʣ�Dll����������Ϣ��������ֻ��ָ������Ϣ�ᱻ���͹���������������������10����Ϣ��Ҳ��Ϊ�˱�֤����Ч�ʣ���
'����ͬһ����Ϣ������ע�������վ����ͬһ����Ϣ����Ϊ5������Dll�������δ�����Ϣ

'ʹ��RegisterMessageע��������Ϣ
Public Function RegisterMessage(ByVal Msg As Long)
    If m_Mode = SubClass Then
    
    ElseIf m_Mode = CALLWNDPROCHOOK Then
        RegisterMessage = DLL_CALLWNDHOOK_RegisterMessage(Msg, MiniWindow.hWnd)
    ElseIf m_Mode = GETMESSAGEHOOK Then
        RegisterMessage = DLL_GETMESSAGE_RegisterMessage(Msg, MiniWindow.hWnd)
    Else
        DBPrint "iReomoteHook: Have not set Mode yet!"
    End If
End Function

'ע��Hook��ָ���߳�
Public Function Inject(ByVal ThreadID As Long) As Long
    If m_Mode = SubClass Then
    
    ElseIf m_Mode = CALLWNDPROCHOOK Then
        Inject = DLL_CALLWNDHOOK_SetHook(ThreadID)
    ElseIf m_Mode = GETMESSAGEHOOK Then
        Inject = DLL_GETMESSAGE_SetHook(ThreadID)
    Else
        DBPrint "iReomoteHook: Have not set Mode yet!"
    End If
End Function

'��ע��Hook
Public Sub UnInject()
    If m_Mode = SubClass Then
    
    ElseIf m_Mode = CALLWNDPROCHOOK Then
        DLL_CALLWNDHOOK_UnHook
    ElseIf m_Mode = GETMESSAGEHOOK Then
        DLL_GETMESSAGE_UnHook
    End If
    
    MiniWindow.Terminate
    Set MiniWindow = Nothing
End Sub

Friend Property Get MsgWindow() As iMiniWindow
    Set MsgWindow = MiniWindow
End Property

Private Sub Class_Initialize()
    Set MiniWindow = New iMiniWindow
    MiniWindow.Initialize
End Sub

Private Sub Class_Terminate()
    If Not (MiniWindow Is Nothing) Then
        UnInject
    End If
End Sub

'Dll���÷���WM_COPYDATA��Ϣ�ķ�ʽ�ش�

Private Sub MiniWindow_GetWindowMessage(Result As Long, ByVal cHwnd As Long, ByVal Message As Long, ByVal wParam As Long, ByVal lParam As Long)
    If Message = WM_COPYDATA Then
        
        Dim cds As COPYDATASTRUCT
        CopyMemory cds, ByVal lParam, Len(cds)

        Dim cwp As CWPSTRUCT
        CopyMemory cwp, ByVal cds.lpData, Len(cwp)
        
        RaiseEvent GetCallWndMessage(Result, cwp.hWnd, cwp.Message, cwp.wParam, cwp.lParam)
        
    Else
        If Not (MiniWindow Is Nothing) Then Result = MiniWindow.CallDefaultWindowProc(cHwnd, Message, wParam, lParam)
    End If
End Sub
