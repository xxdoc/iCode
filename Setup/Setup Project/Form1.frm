VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmMain 
   BackColor       =   &H00404040&
   BorderStyle     =   0  'None
   Caption         =   "iCode ��װ����"
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
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   420
      Top             =   1500
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin iCode_Setup.Button btnMain 
      Height          =   735
      Left            =   2730
      Top             =   1230
      Width           =   735
      _extentx        =   1296
      _extenty        =   1296
      font            =   "Form1.frx":0442
      fontbold        =   -1
      fontsize        =   10.5
      caption         =   "Hi"
      changebackcolor =   0
   End
   Begin iCode_Setup.MinimizeButton MinimizeButton 
      Height          =   255
      Left            =   5340
      Top             =   120
      Width           =   255
      _extentx        =   661
      _extenty        =   661
   End
   Begin iCode_Setup.CloseButton CloseButton 
      Height          =   255
      Left            =   5820
      Top             =   120
      Width           =   255
      _extentx        =   661
      _extenty        =   556
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "��װiCode����ζ����ͬ�����Э��"
      BeginProperty Font 
         Name            =   "΢���ź�"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00E0E0E0&
      Height          =   255
      Left            =   3180
      TabIndex        =   0
      Top             =   4260
      Width           =   2850
   End
   Begin VB.Image ccSp6 
      Height          =   195
      Left            =   300
      Picture         =   "Form1.frx":046A
      Top             =   3840
      Width           =   195
   End
   Begin VB.Image ccPath 
      Height          =   195
      Left            =   300
      Picture         =   "Form1.frx":06B6
      Top             =   3120
      Width           =   195
   End
   Begin VB.Image imgMain 
      Height          =   1155
      Left            =   2520
      Picture         =   "Form1.frx":0902
      Top             =   1020
      Width           =   1155
   End
   Begin VB.Image imgcc1 
      Height          =   195
      Left            =   5820
      Picture         =   "Form1.frx":4F0E
      Top             =   3840
      Visible         =   0   'False
      Width           =   195
   End
   Begin VB.Label lblSP6 
      BackStyle       =   0  'Transparent
      Caption         =   "��Ҫ������VB6 SP6��δ�ҵ���"
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
   Begin VB.Label lblPath 
      BackStyle       =   0  'Transparent
      Caption         =   "��װĿ¼��VB6 ��װĿ¼��δ��ʶ��"
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
      Height          =   675
      Left            =   660
      TabIndex        =   2
      Top             =   3105
      Width           =   5460
   End
   Begin VB.Label lblCaption 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "iCode ��װ"
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

Private Const iVersion As String = "1.21"

Private Path As String
Private bVB6 As Boolean, bSp6 As Boolean

Private bReset As Boolean

Private Sub Install()

    Dim p() As String
    p = Split(LoadResData(100, 6), ",")
    
    If Dir(Path & "\iCode", vbDirectory) = "" Then MkDir Path & "\iCode"
    
    Dim i As Long, s As String
    For i = 1 To CLng(p(0))
        s = Path & "\iCode\" & LoadResData(100 + i, 6)
        If Dir(s, vbDirectory) = "" Then
            MkDir s
        End If
    Next
    
    Dim Data() As Byte
    For i = CLng(p(0)) + 1 To CLng(p(1))
    
        s = Path & "\iCode\" & LoadResData(100 + i, 6)
        Data = LoadResData(100 + i, "CUSTOM")
        Open s For Binary As #1
        Put #1, , Data
        Close #1
        
        btnMain.Caption = Int((i * 2 - 1) / (CLng(p(1)) * 2) * 100) & "%"
        DoEvents
        If LCase(Right(s, 3)) = "dll" Then
            Shell "regsvr32 /s """ & s & """"
            DoEvents
        End If
        btnMain.Caption = Int((i * 2) / (CLng(p(1)) * 2) * 100) & "%"
        DoEvents
        
    Next
    
    Dim hKey As Long
    If RegCreateKey(HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\iCode", hKey) = 0 Then
        Reg_SetValue_SZ hKey, "DisplayName", "iCode For VB6"
        Reg_SetValue_SZ hKey, "DisplayIcon", Path & "\iCode\icon.ico"
        Reg_SetValue_SZ hKey, "Publisher", "liuzikai"
        Reg_SetValue_SZ hKey, "UninstallString", Path & "\iCode\uninstall.exe"
        Reg_SetValue_SZ hKey, "URLInfoAbout", "liuzikai@163.com"
        Reg_SetValue_SZ hKey, "DisplayVersion", iVersion
        RegSetValueEx hKey, "NoModify", 0&, REG_DWORD, 1, 4
        RegSetValueEx hKey, "NoRepair", 0&, REG_DWORD, 1, 4
        RegCloseKey hKey
    Else
        MsgBox "д��ע���ʧ�ܣ���Ҫж��ʱ���ֶ�����ж�����", vbExclamation, "iCode Setup"
    End If
    
    btnMain.Caption = "���"
    
End Sub

Private Sub SelectPath_VB6()
    CommonDialog1.Filter = "VB������(VB6.exe)|VB6.exe"
    CommonDialog1.FileName = Environ("ProgramFiles") & "\VB6.exe"
    CommonDialog1.ShowOpen
    Confirm_VB6 Left(CommonDialog1.FileName, InStrRev(CommonDialog1.FileName, "\"))
End Sub

Private Sub SelectPath_SP6()
    CommonDialog1.Filter = "SP6 ���(MSCOMCTL.OCX)|MSCOMCTL.OCX"
    CommonDialog1.FileName = Environ("WINDIR") & "\MSCOMCTL.OCX"
    CommonDialog1.ShowOpen
    If CommonDialog1.FileName <> "" Then Confirm_SP6
End Sub

Private Sub Confirm_VB6(ByVal s As String)
    If s <> "" Then
        Path = s
        lblPath.Caption = "��װĿ¼��VB6 ��װĿ¼" & vbCrLf & "��" & Path & "��"
        Set ccPath.Picture = imgcc1.Picture
        bVB6 = True
    End If
End Sub

Private Sub Confirm_SP6()
    lblSP6.Caption = "��Ҫ������VB6 SP6����ʶ��"
    Set ccSp6.Picture = imgcc1.Picture
    bSp6 = True
End Sub

Private Sub btnMain_Click()
    Select Case btnMain.Caption
    Case "���"
        Unload Me
    Case "�ֶ�" & vbCrLf & "ѡ��"
        If Not bVB6 Then
            SelectPath_VB6
        End If
        If Not bSp6 Then
            SelectPath_SP6
        End If
        If bVB6 And bSp6 Then
            btnMain.Caption = "��װ"
        End If
    Case "��װ"
        Install
    End Select
End Sub

Private Sub btnMain_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    bReset = False
End Sub

Private Sub CloseButton_Click()
    Unload Me
End Sub

Private Sub CloseButton_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    bReset = False
End Sub

Private Sub Form_Load()
    
    Confirm_VB6 Reg_Read_SZ(HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\VisualStudio\6.0\Setup\Microsoft Visual Basic\", "ProductDir")

    
    If Dir(Environ("WINDIR") & "\system32\MSCOMCTL.OCX") <> "" Or Dir(Environ("WINDIR") & "\sysWOW64\MSCOMCTL.OCX") <> "" Then
        Confirm_SP6
    End If
    
    If bVB6 And bSp6 Then
        btnMain.Caption = "��װ"
    Else
        btnMain.Caption = "�ֶ�" & vbCrLf & "ѡ��"
    End If
    
    
End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 1 Then
        ReleaseCapture
        Call SendMessage(Me.hWnd, WM_NCLBUTTONDOWN, HTCAPTION, ByVal 0&)
    End If
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Not bReset Then
        CloseButton.Reset
        MinimizeButton.Reset
        btnMain.Reset
        bReset = True
    End If
End Sub

Private Sub lblCaption_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call Form_MouseDown(Button, Shift, 0, 0)
End Sub

Private Sub lblPath_DblClick()
    SelectPath_VB6
End Sub

Private Sub lblSP6_DblClick()
    SelectPath_SP6
End Sub

Private Sub MinimizeButton_Click()
    Me.WindowState = vbMinimized
End Sub

Private Sub MinimizeButton_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    bReset = False
End Sub
