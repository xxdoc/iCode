VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsWindowsHandler"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Declare Function MoveWindow Lib "user32" (ByVal hWnd As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal bRepaint As Long) As Long
Private Declare Function GetClientRect Lib "user32" (ByVal hWnd As Long, lpRect As RECT) As Long
Private Type RECT
        Left As Long
        Top As Long
        Right As Long
        Bottom As Long
End Type

Private WithEvents t As TasksCollection
Attribute t.VB_VarHelpID = -1

Private Const iSection = "iCode_Windows"

Private Const WS_EX_ACCEPTFILES = &H10&
Private Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long) As Long
Private Const GWL_EXSTYLE = (-20)
Private Const GWL_STYLE = (-16)

Private clsLinker As clsLinker
Private TargetEXEFileName As String

Private WithEvents FileControlEvents As FileControlEvents
Attribute FileControlEvents.VB_VarHelpID = -1

Private EnhanceWindow As Boolean

Public Property Get Mode() As Boolean
    Mode = EnhanceWindow
End Property

Public Property Let Mode(ByVal Value As Boolean)
    EnhanceWindow = Value
    t.Clear
    Load_Basic_Tasks
End Property

Private Sub Load_Basic_Tasks()

    t.Add hVBIDE, "#32770", "���ɹ���", 263, 136, 630, 467, True
    
    If EnhanceWindow Then
    
        t.Add hVBIDE, "#32770", "�ļ�����Ϊ", 263, 136, 630, 467, True
        t.Add hVBIDE, "#32770", "��������Ϊ", 263, 136, 630, 467, True
        t.Add hVBIDE, "#32770", "����������Ϊ", 263, 136, 630, 467, True
        
        t.Add hVBIDE, "#32770", "�򿪹���", 258, 123, 652, 523, True
        
        t.Add hVBIDE, "#32770", "�����ļ�", 263, 123, 630, 494, True
        
        'ע����������ĸ����ڲ�����VB�����ڣ����ǲ���/���ô���
        t.Add , "#32770", "��������", 263, 136, 630, 467, True
        t.Add , "#32770", "���� ActiveX �ؼ�", 263, 136, 630, 467, True
    
    End If
    
End Sub

Public Sub Msg_Windows(ByVal hWnd As Long)
    t.Find hWnd
End Sub


Public Sub Initialize(ByVal IDEIns As VBE, ByVal DBForm As Object, ByVal WindowRedesign As Boolean)
    
    EnhanceWindow = WindowRedesign
    
    Set VBIns = IDEIns
    Let hVBIDE = VBIns.MainWindow.hWnd
    
    Set DebugForm = DBForm
        
    Set t = New TasksCollection
    
    Load_Basic_Tasks
    
    Set clsLinker = New clsLinker
    
    Set FileControlEvents = VBIns.Events.FileControlEvents(Nothing)
        
End Sub

Private Sub Class_Terminate()
    Set t = Nothing
    Set clsLinker = Nothing
    Set FileControlEvents = Nothing
End Sub


'���ര�ڲ�����WM_CLOSE��Ϣ
Public Sub Msg_WM_DESTROY_If_32770(ByVal hWnd As Long)
    '����ʵ�ʲ���û��ִ��CleanUp�����ı�Ҫ
    Select Case iGetCaption(hWnd)
    Case "���ɹ���"
        't.CleanUp hWnd
        clsLinker.Msg_CompileWindowDestory
    Case "�ļ�����Ϊ", "��������Ϊ", "����������Ϊ", "�򿪹���", "�����ļ�", "��������", "���� ActiveX �ؼ�"
        't.CleanUp hWnd
    End Select
End Sub


Private Sub FileControlEvents_AfterWriteFile(ByVal VBProject As VBIDE.VBProject, ByVal FileType As VBIDE.vbext_FileType, ByVal FileName As String, ByVal Result As Integer)
    If FileType = vbext_ft_Exe And FileName = TargetEXEFileName Then
        Shell LinkerPath & "iCodeLinker.exe " & FileName & "#" & LinkerData.pIcon & "#" & LinkerData.pManifest
        TargetEXEFileName = ""
        
        VBProject.WriteProperty iSection, "LastBuildFile", FileName
    End If
End Sub

Private Sub FileControlEvents_DoGetNewFileName(ByVal VBProject As VBIDE.VBProject, ByVal FileType As VBIDE.vbext_FileType, NewName As String, ByVal OldName As String, CancelDefault As Boolean)
    
    Set clsLinker.CurProject = VBProject
    
    On Error Resume Next '����û�м�¼��ʱReadProperty��������
    
    Dim LastBuildFile As String
    LastBuildFile = VBProject.ReadProperty(iSection, "LastBuildFile")
    If LastBuildFile = "" Then Exit Sub
    
    If FileType = vbext_ft_Exe Then
        NewName = LastBuildFile
        VBProject.WriteProperty iSection, "LastComponentFile", OldName '�����ʱĿ¼
    Else
        If OldName = LastBuildFile Then '�������Զ��л��л�ʱ�ָ��ļ�Ŀ¼
            Dim LastComponentFile As String
            LastComponentFile = VBProject.ReadProperty(iSection, "LastComponentFile")
            If LastComponentFile <> "" Then NewName = LastComponentFile
        End If
    End If
    
End Sub

Private Sub FileControlEvents_RequestWriteFile(ByVal VBProject As VBIDE.VBProject, ByVal FileName As String, Cancel As Boolean)
    If LCase(Right(FileName, 3)) = "exe" Then
        'clsLinker.Msg_StartCompile
        TargetEXEFileName = FileName
    End If
End Sub

Private Sub T_Find(Task As Task, ByVal hWnd As Long)
    
    Select Case Task.sClass
    
    Case "#32770"
    
        Select Case Task.sName
        
        Case ""
            If Task.Tag = "BuildWindow" Then t.Add hWnd, "Button", "ѡ��(&O)...", 450, 380, 77, 23
            If Task.Tag = "AddFileWindow" Then t.Add hWnd, "Button", "����Ϊ����ĵ�", 8, 440, 108, 15
        
        Case "���ɹ���"
            
            If EnhanceWindow Then
            
                t.Add hWnd, "#32770", "", 0, 0, 614, 439, , "BuildWindow"
            
                t.Add hWnd, "Static", "������(&I):", 11, 10, 72, 14
                t.Add hWnd, "ComboBox", "*Any*", 86, 5, 420, 24, , "WS_EX_ACCEPTFILES"
                t.Add hWnd, "ToolbarWindow32", "", 513, 5, 132, 26
                t.Add hWnd, "Static", "�ļ���(&N):", 8, 386, 66, 14
                t.Add hWnd, "Edit", "*Any*", 89, 383, 350, 20
                t.Add hWnd, "Button", "ȷ��", 541, 380, 75, 23
                t.Add hWnd, "Button", "ȡ��", 541, 408, 75, 23
                t.Add hWnd, "Button", "����(&H)", 6, 408, 70, 23
                t.Add hWnd, "SHELLDLL_DefView", "", 6, 36, 610, 337
                
                If Not VBIns.ActiveVBProject Is Nothing Then
                    If VBIns.ActiveVBProject.Type = vbext_pt_StandardExe Then
                        If clsLinker.Msg_CompileWindowShow(hWnd) Then
                            MoveWindow clsLinker.hContainer, 407, 408, 120, 23, True
                        End If
                    End If
                End If
            
            Else
                
                If Not VBIns.ActiveVBProject Is Nothing Then
                    If VBIns.ActiveVBProject.Type = vbext_pt_StandardExe Then
                        If clsLinker.Msg_CompileWindowShow(hWnd) Then
                            
                            Dim r As RECT
                            GetClientRect hWnd, r
                            
                            MoveWindow clsLinker.hContainer, 10, r.Bottom - r.Top - 33, 120, 23, True
                        End If
                    End If
                End If
                
            End If
            
        Case "�����ļ�"

            t.Add hWnd, "#32770", "", 0, 0, 614, 466, , "AddFileWindow"

            t.Add hWnd, "Static", "���ҷ�Χ(&I):", 11, 10, 72, 14

            t.Add hWnd, "ComboBox", "*Any*", 86, 5, 420, 24, , "WS_EX_ACCEPTFILES"
            t.Add hWnd, "ComboBox", "*Any*", 89, 411, 350, 20

            t.Add hWnd, "ToolbarWindow32", "", 513, 5, 100, 26

            t.Add hWnd, "Static", "�ļ���(&N):", 8, 386, 66, 14
            t.Add hWnd, "Edit", "", 89, 383, 437, 20

            t.Add hWnd, "Static", "�ļ�����(&T):", 8, 414, 80, 14


            t.Add hWnd, "Button", "��(&O)", 541, 380, 75, 23
            t.Add hWnd, "Button", "ȡ��", 541, 408, 75, 23
            t.Add hWnd, "Button", "����(&H)", 451, 408, 75, 23

            t.Add hWnd, "SHELLDLL_DefView", "", 6, 36, 610, 337
        
            
            
        Case "�ļ�����Ϊ", "��������Ϊ", "����������Ϊ"
            
            t.Add hWnd, "Static", "������(&I):", 11, 10, 72, 14
    
            t.Add hWnd, "ComboBox", "*Any*", 86, 5, 420, 24, , "WS_EX_ACCEPTFILES"
            t.Add hWnd, "ComboBox", "*Any*", 89, 411, 350, 20
            
            t.Add hWnd, "ToolbarWindow32", "", 513, 5, 100, 26
            
            t.Add hWnd, "Static", "�ļ���(&N):", 8, 386, 66, 14
            t.Add hWnd, "Edit", "*Any*", 99 - 10, 409 - 26, 437, 20
            
            t.Add hWnd, "Static", "��������(&T):", 8, 414, 80, 14
            
            t.Add hWnd, "Button", "����(&S)", 541, 380, 75, 23
            t.Add hWnd, "Button", "ȡ��", 541, 408, 75, 23
            t.Add , "Button", "����(&H)", 451, 408, 75, 23
            
            t.Add hWnd, "SHELLDLL_DefView", "", 6, 36, 610, 337
        
        Case "�򿪹���"
        
            t.Add hWnd, "Static", "���ҷ�Χ(&I):", 21, 36, 72, 14
    
            t.Add hWnd, "ComboBox", "*Any*", 96, 31, 420, 24, , "WS_EX_ACCEPTFILES"
            
            t.Add hWnd, "ToolbarWindow32", "", 523, 31, 100, 26
            
            t.Add hWnd, "Static", "�ļ���(&N):", 18, 412, 66, 14
            t.Add hWnd, "Edit", "", 99, 409, 437, 20
            
            t.Add hWnd, "Static", "�ļ�����(&T):", 18, 440, 80, 14
            t.Add hWnd, "ComboBox", "*Any*", 99, 437, 350, 20
            
            t.Add hWnd, "Button", "��(&O)", 551, 406, 75, 23
            t.Add hWnd, "Button", "ȡ��", 551, 434, 75, 23
            t.Add hWnd, "Button", "����(&H)", 461, 434, 75, 23
            
            t.Add hWnd, "SHELLDLL_DefView", "", 16, 62, 610, 337
            
            t.Add hWnd, "SysListView32", "", 16, 32, 610, 367
            
            t.Add hWnd, "SysTabControl32", "", 6, 6, 634, 469
        
        
        Case "��������", "���� ActiveX �ؼ�"
            
            t.Add hWnd, "Static", "���ҷ�Χ(&I):", 11, 10, 72, 14
    
            t.Add hWnd, "ComboBox", "*Any*", 86, 5, 420, 24, , "WS_EX_ACCEPTFILES"
            
            t.Add hWnd, "ToolbarWindow32", "", 513, 5, 100, 26
            
            t.Add hWnd, "Static", "�ļ���(&N):", 8, 386, 66, 14
            t.Add hWnd, "Edit", "", 99 - 10, 409 - 26, 437, 20
            
            t.Add hWnd, "Static", "�ļ�����(&T):", 8, 414, 80, 14
            t.Add hWnd, "ComboBox", "*Any*", 89, 411, 350, 20
            
            t.Add hWnd, "Button", "��(&O)", 541, 380, 75, 23
            t.Add hWnd, "Button", "ȡ��", 541, 408, 75, 23
            t.Add hWnd, "Button", "����(&H)", 451, 408, 75, 23
            
            t.Add hWnd, "SHELLDLL_DefView", "", 6, 36, 610, 337
        
        End Select
    
    Case "ComboBox"
        
        Dim lngStyle As Long
        lngStyle = GetWindowLong(hWnd, GWL_STYLE)
        
        If Task.Tag = "WS_EX_ACCEPTFILES" Then
            If (lngStyle And WS_EX_ACCEPTFILES) = False Then Exit Sub
        Else
            If (lngStyle And WS_EX_ACCEPTFILES) Then Exit Sub
        End If
    
    End Select
    
    If EnhanceWindow Then
        MoveWindow hWnd, Task.x, Task.y, Task.Width, Task.Height, False
    End If
    
End Sub