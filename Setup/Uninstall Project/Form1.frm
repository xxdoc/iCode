VERSION 5.00
Begin VB.Form frmMain 
   BackColor       =   &H00404040&
   BorderStyle     =   0  'None
   Caption         =   "iCode ж�س���"
   ClientHeight    =   4680
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   6225
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "iCode"
   ScaleHeight     =   312
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   415
   StartUpPosition =   3  '����ȱʡ
   Begin iCode_Uninstall.Button btnMain 
      Height          =   735
      Left            =   2730
      Top             =   1230
      Width           =   735
      _ExtentX        =   1296
      _ExtentY        =   1296
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "΢���ź�"
         Size            =   10.5
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontSize        =   10.5
      Caption         =   "ж��"
      ChangeBackColor =   0   'False
   End
   Begin iCode_Uninstall.MinimizeButton MinimizeButton 
      Height          =   255
      Left            =   5340
      Top             =   120
      Width           =   255
      _ExtentX        =   661
      _ExtentY        =   661
   End
   Begin iCode_Uninstall.CloseButton CloseButton 
      Height          =   255
      Left            =   5820
      Top             =   120
      Width           =   255
      _ExtentX        =   661
      _ExtentY        =   556
   End
   Begin VB.Image imgcc 
      Height          =   195
      Index           =   1
      Left            =   4920
      Picture         =   "Form1.frx":0442
      Top             =   2280
      Visible         =   0   'False
      Width           =   195
   End
   Begin VB.Image imgcc 
      Height          =   195
      Index           =   0
      Left            =   4560
      Picture         =   "Form1.frx":068E
      Top             =   2280
      Visible         =   0   'False
      Width           =   195
   End
   Begin VB.Label lblDeleteSetting 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "ɾ�������ļ�"
      BeginProperty Font 
         Name            =   "΢���ź�"
         Size            =   9
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00E0E0E0&
      Height          =   255
      Left            =   660
      TabIndex        =   0
      Top             =   2640
      Width           =   1080
   End
   Begin VB.Image ccDeleteSetting 
      Height          =   195
      Left            =   300
      Picture         =   "Form1.frx":08DA
      Tag             =   "0"
      Top             =   2655
      Width           =   195
   End
   Begin VB.Image ccSp6 
      Height          =   195
      Left            =   300
      Picture         =   "Form1.frx":0B26
      Top             =   3840
      Width           =   195
   End
   Begin VB.Image ccPath 
      Height          =   195
      Left            =   300
      Picture         =   "Form1.frx":0D72
      Top             =   3360
      Width           =   195
   End
   Begin VB.Image imgMain 
      Height          =   1155
      Left            =   2520
      Picture         =   "Form1.frx":0FBE
      Top             =   1020
      Width           =   1155
   End
   Begin VB.Label lblContact 
      BackStyle       =   0  'Transparent
      Caption         =   "��ӭ������ϵ��liuzikai@163.com   ��)"
      BeginProperty Font 
         Name            =   "΢���ź�"
         Size            =   9
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00E0E0E0&
      Height          =   255
      Left            =   660
      TabIndex        =   1
      Top             =   3810
      Width           =   4875
   End
   Begin VB.Label lblThanks 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "��л����ʹ��!"
      BeginProperty Font 
         Name            =   "΢���ź�"
         Size            =   9
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00E0E0E0&
      Height          =   255
      Left            =   660
      TabIndex        =   2
      Top             =   3345
      Width           =   1140
   End
   Begin VB.Label lblCaption 
      BackStyle       =   0  'Transparent
      Caption         =   "iCode ж��"
      BeginProperty Font 
         Name            =   "΢���ź�"
         Size            =   9
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00E0E0E0&
      Height          =   255
      Left            =   180
      TabIndex        =   3
      Top             =   120
      Width           =   4875
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'Private oShadow As New aShadow

Private Declare Function DeleteFile Lib "kernel32" Alias "DeleteFileA" (ByVal lpFileName As String) As Long

Private bReset As Boolean

Private Sub Uninstall()

    Dim p() As String
    p = Split(LoadResData(100, 6), ",")
    
    
    Dim i As Long, k As Long, f As String, s As String
    
    s = "@echo off" & vbCrLf & _
        "sleep 1000" & vbCrLf
    
    If ccDeleteSetting.Tag = "1" Then
        f = Environ("AppData") & "\iCode\Settings.ini"
        If Dir(f) <> "" Then
            If DeleteFile(f) = False Then
                s = s & "del """ & f & """" & vbCrLf
            End If
        End If
    End If
    
    For i = CLng(p(1)) To CLng(p(0)) + 1 Step -1
        
        f = App.Path & "\" & LoadResData(100 + i, 6)
        If Dir(f) <> "" Then
            If LCase(Right(f, 3)) = "dll" Then
                Shell "regsvr32 /u /s """ & f & """"
            End If
            DoEvents
            If DeleteFile(f) = False Then
                s = s & "del """ & f & """" & vbCrLf
            End If
        End If
        
        k = k + 1
        btnMain.Caption = Int(k / CLng(p(1)) * 100) & "%"
        DoEvents
        
    Next
    
    For i = CLng(p(0)) To 1 Step -1
        
        f = App.Path & "\" & LoadResData(100 + i, 6)
        If Dir(f, vbDirectory) <> "" Then
            RmDir f
        End If
        
        k = k + 1
        btnMain.Caption = Int(k / CLng(p(1)) * 100) & "%"
        DoEvents
    Next
    
    RegDeleteKey HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\iCode"

    s = s & "sleep 500" & vbCrLf & _
            "rd """ & App.Path & """" & vbCrLf & _
            "del """ & Environ("Temp") & "\iCode_DeleteFile.bat"
    
    Open Environ("Temp") & "\iCode_DeleteFile.bat" For Output As #1
    Print #1, s
    Close #1
    
    DoEvents
    
    btnMain.Caption = "���"
    
End Sub

'Private Sub LoadShadow()
'    With oShadow
'        If .Shadow(Me) Then
'            .Depth = 6 '��Ӱ���
'            .Color = RGB(0, 0, 0) '��Ӱ��ɫ
'            .Transparency = 36 '��Ӱɫ��
'        End If
'    End With
'End Sub

Private Sub btnMain_Click()
    Select Case btnMain.Caption
    Case "ж��"
        Uninstall
    Case "���"
        Unload Me
    End Select
End Sub

Private Sub ccDeleteSetting_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    ccDeleteSetting.Tag = 1 - ccDeleteSetting.Tag
    Set ccDeleteSetting.Picture = imgcc(ccDeleteSetting.Tag).Picture
End Sub

Private Sub CloseButton_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    
    If Right(App.Path, 5) <> "iCode" Then
        MsgBox "��⵽��ǰĿ¼����Ĭ�ϰ�װĿ¼��ж�س��򽫰����ļ���ɾ���ļ�����ע�⣡", vbCritical, "����"
    End If
    
    'LoadShadow
    
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Not bReset Then
        CloseButton.Reset
        MinimizeButton.Reset
        btnMain.Reset
        bReset = True
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    If btnMain.Caption = "���" Then Shell "cmd /c """ & Environ("Temp") & "\iCode_DeleteFile.bat""", vbHide
    'Set oShadow = Nothing
End Sub

Private Sub lblCaption_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call Form_MouseDown(Button, Shift, 0, 0)
End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 1 Then
        ReleaseCapture
        Call SendMessage(Me.hWnd, WM_NCLBUTTONDOWN, HTCAPTION, ByVal 0&)
    End If
End Sub

Private Sub btnMain_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    bReset = False
End Sub

Private Sub CloseButton_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    bReset = False
End Sub

Private Sub MinimizeButton_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    bReset = False
End Sub

Private Sub MinimizeButton_Click()
    Me.WindowState = vbMinimized
End Sub
