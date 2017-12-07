VERSION 5.00
Begin VB.UserControl CloseButton 
   BackColor       =   &H00404040&
   CanGetFocus     =   0   'False
   ClientHeight    =   480
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   510
   ScaleHeight     =   32
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   34
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      BorderWidth     =   3
      X1              =   12
      X2              =   20
      Y1              =   12
      Y2              =   20
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000010&
      BorderWidth     =   3
      X1              =   12
      X2              =   20
      Y1              =   20
      Y2              =   12
   End
End
Attribute VB_Name = "CloseButton"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Event Click()
Event MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
Event MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Event MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

Private Const UI_R As Long = 4

Private Const Color_Line_Normal = &H80000010
Private Const Color_Line_Selected = &H80000015

Private Const Color_Button_Normal = &H80000015
Private Const Color_Button_Selected = &H80000010
Private Const Color_Button_Clicked = &H6C6C6C

Private bMouseIn As Boolean

Public Sub Reset()
    If bMouseIn Then
        Line1.BorderColor = Color_Line_Normal
        Line2.BorderColor = Color_Line_Normal
        bMouseIn = False
    End If
End Sub

Private Sub UserControl_Click()
    RaiseEvent Click
End Sub

Public Property Get Enabled() As Boolean
Attribute Enabled.VB_Description = "����/����һ��ֵ������һ�������Ƿ���Ӧ�û������¼���"
    Enabled = UserControl.Enabled
End Property

Public Property Let Enabled(ByVal New_Enabled As Boolean)
    UserControl.Enabled() = New_Enabled
    PropertyChanged "Enabled"
End Property

Private Sub UserControl_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    RaiseEvent MouseDown(Button, Shift, X, Y)
End Sub

Private Sub UserControl_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    RaiseEvent MouseMove(Button, Shift, X, Y)
    If Not bMouseIn Then
        Line1.BorderColor = Color_Line_Selected
        Line2.BorderColor = Color_Line_Selected
        bMouseIn = True
    End If
End Sub

Private Sub UserControl_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    RaiseEvent MouseUp(Button, Shift, X, Y)
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    UserControl.Enabled = PropBag.ReadProperty("Enabled", True)
End Sub

Private Sub UserControl_Resize()
    Line1.X1 = UserControl.ScaleWidth / 2 - UI_R
    Line1.Y1 = UserControl.ScaleHeight / 2 - UI_R
    Line1.X2 = UserControl.ScaleWidth / 2 + UI_R
    Line1.Y2 = UserControl.ScaleHeight / 2 + UI_R
    
    Line2.X1 = UserControl.ScaleWidth / 2 - UI_R
    Line2.Y1 = UserControl.ScaleHeight / 2 + UI_R
    Line2.X2 = UserControl.ScaleWidth / 2 + UI_R
    Line2.Y2 = UserControl.ScaleHeight / 2 - UI_R
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    Call PropBag.WriteProperty("Enabled", UserControl.Enabled, True)
End Sub

