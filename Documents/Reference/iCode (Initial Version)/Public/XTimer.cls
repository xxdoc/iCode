VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "XTimer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'===============================================
' ע�⣡�������������ʱ��Ҫ������������ť��
'   ������� XTimerSupport ģ��(XTimerS.bas)
'   �����Ľ��͡�
'===============================================

' XTimer ���Ե�˽�д洢�壺
Private mlngTimerID As Long
Private mlngInterval As Long
Private mblnEnabled As Boolean

' XTimer��Ψһ�¼��� Tick��XTimer �� Tick �¼�
'   û���κβ���(�ų��������Լ���
'   �¼���������)���������ܳ�Ϊ��ϣ��
'   �ṩ��û���ṩ������ԭ��
Event Tick()

' TimerID property �� EndTimer ������Ҫ��
' ----------------   ��Ŀ�����ڻ�ļ�ʱ��
'   ��֧��ģ�������п��ٶ�λ��ʱ����
'
' ���ڿͻ���˵��ʹ���������û�����壬
'   ������������Ϊ Friend ���� Public��
'
Friend Property Get TimerID() As Long
    TimerID = mlngTimerID
End Property

' Enabled ���Դ򿪺͹رռ�ʱ������ͨ��
' -----------  ȥ��ϵͳ�ļ�ʱ����ʵ�֣�
'   ��Ϊû�а취��ͣϵͳ��ʱ����
'   ������Ǵ��ڣ����������С�
'
Public Property Get Enabled() As Boolean
    Enabled = mblnEnabled
End Property
'
Public Property Let Enabled(ByVal NewValue As Boolean)
    ' ��������Ե�״̬û�н��и��ģ�
    '   ���˳�����������˵��Ѿ�
    '   ��һ��ϵͳ��ʱ����������ʱ��
    '   �����ڶ���ϵͳ��ʱ�����ȵȡ�
    If NewValue = mblnEnabled Then Exit Property
    '
    ' �����µ��������á�
    mblnEnabled = NewValue
    '
    ' ������Ϊ�㣬���ʱ���Ѿ�
    '   ֹͣ����Ҫ��������
    If mlngInterval = 0 Then Exit Property
    '
    ' �򿪺͹رռ�ʱ����
    If mblnEnabled Then
        Debug.Assert mlngTimerID = 0
        mlngTimerID = BeginTimer(Me, mlngInterval)
    Else
        ' ���еĴ����Ǳ���ģ���Ϊ
        '   XTimer ����ͨ����������
        '   �ر�ϵͳ��ʱ����Enabled = False��
        '   ���� Interval = 0��
        If mlngTimerID <> 0 Then
            Call EndTimer(Me)
            mlngTimerID = 0
        End If
    End If
End Property

' Interval ������Ҫ���ܶ������������
' -----------------   ��ʱ���ļ������� XTimer
'   �� enabled�����Ҽ�������㵽��������˸���
'   ��ôϵͳ��ʱ�����뱻������
'   ͬ���أ�������������Ϊ�㣬
'   ϵͳ��ʱ�����뱻ֹͣ��
'
' ���ۼ���Ƿ���Ĵ������ù���
'   ��ֹͣһ��ϵͳ��ʱ������������һ��ϵͳ��ʱ����
'   ������Ϊ�޷�����һ��ϵͳ��ʱ���ļ����
'
Public Property Get Interval() As Long
    Interval = mlngInterval
End Property
'
Public Property Let Interval(ByVal NewInterval As Long)
    ' ����µļ��ֵ��ɵ�һ�£�
    '   û�б�Ҫ���κι�����
    If NewInterval = mlngInterval Then Exit Property
    '
    ' �����µ�ֵ��
    mlngInterval = NewInterval
    '
    ' ��� XTimer �ǻ�ģ�mlngTimerID Ϊ���㡣
    '   ����������£��ɵ�ϵͳ��ʱ���������µ�
    '   ����֮ǰ��ֹ��
    If mlngTimerID <> 0 Then
        Call EndTimer(Me)
        mlngTimerID = 0
    End If
    '
    ' ����µļ��Ϊ�㣬��ô XTimer
    '   ��Ϊ�ǻ�ģ����ܵ�ǰ��
    '   Enabled ����Ϊ��ֵ������µļ��
    '   ��Ϊ�㣬���� Enabled ����Ϊ True��
    '   ��ôһ���µ�ϵͳ��ʱ��������������
    '   ���� ID ���洢�� mlngTimerID �С�
    If (NewInterval <> 0) And mblnEnabled Then
        mlngTimerID = BeginTimer(Me, NewInterval)
    End If
End Property

' RaiseTick ����֧�ֵ�ģ�������ã���
' ----------------   ϵͳ��ʱ���¼�Ϊ
'   ��� XTimer �����ϵͳ��ʱ��������ʱ�
'
' ʵ�ֵ�ϸ�ڣ��������ڴ��������
'   ����Ϊ Friend ���� Public����Ϊ��
'   ��Ҫ�ÿͻ������� RaiseTick��Ȼ����
'   RaiseTick ����������Ϊ Public��
'   ��Ϊ XTimer �� Tick �¼�Ȼ������ʱ
'   ���ܱ��ͷš��������һ�����з����ڶ�ջ��ʱ��
'   �����ܱ���ֹ�������ڶ�ջ�е�����
'   Friend �������Ա���ֹ������˶���
'   �� Friend ��������֮ǰ��ֹ (���
'   �ͻ��� XTimer �� Tick �¼���ִ�д���
'   ���룬����������ܻᷢ��)������ǲ���һ�� GPF ��
'   (ע������߶ȵĲ�Ѱ���龰ȡ�����ⲿ���¼���
'   ����һ���ʹ�� Friend �����в��ᷢ����)
'
Public Sub RaiseTick()
    RaiseEvent Tick
End Sub

Private Sub Class_Terminate()
    ' ���ͻ��ͷ��������һ���� XTimer ���������ʱ
    '   �����뿪 -- ��������
    '   XTimer �� Enabled ����Ϊ False ��ʱ�
    '   �������� Interval ����Ϊ True!
    '
    ' ������Ϊ�� XTimer ��ϵͳ��ʱ��
    '   ��������ʱ��XTimerSupport ģ��
    '   Ϊ�˲������� Tick �¼���
    '   ���ò�ʹ��һ���� XTimer �����á�
    '   ��ô�ͻ����ͷ� XTimer ����ǰ
    '   �������ǣ�������ϵͳ��ʱ��!
    '
    ' ��Щ������ϵͳ��ʱ��ֱ��
    '   XTimers �����ر�ʱ���ܱ��ָ�
    '   -- �Ǿ���˵�����ͻ�ʹ�õ�
    '   DLL �ر�ʱ���� DLL ������
    '   ж��ֱ������ XTimer �����ͷš�
    '   ��Ϊ�Թ��ж�������� (������
    '   ����£����Ǳ� XTimerSupport ������)
    '   ����ֹ DLL ��ж�ء�
    '
    ' ��ôΪʲôҪ�鷳�������ֹ�¼��е�ϵͳ
    '   ��ʱ���أ���Ϊ��
    '   DLL ���رպ����е�
    '   XTimer ��������ý������
    '   -- ���� XTimer �����������ֹ
    '   �¼���ϵͳ��ʱ���ڴ�ʱ�����ƻ���
    On Error Resume Next
    If mlngTimerID <> 0 Then KillTimer 0, mlngTimerID
    '
    ' ���й����� XTimer ��Ҫ�������
    '   ����Ҫ�ͷŹرյ� DLL �����ȼ�
    'If mlngTimerID <> 0 Then Call EndTimer(Me)
End Sub

Public Sub Start()
    Me.Enabled = True
End Sub

Public Sub Pause()
    Me.Enabled = False
End Sub