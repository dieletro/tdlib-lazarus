/// Demo project using the TDLib API with lazarus
/// by Ruan Diego Lacerda Menezes
/// Email: diegolacerdamenezes@gmail.com
/// Telegram: @diegolacerdamenezes
/// Group Suport: @Telegram

unit LazTeste;

{$mode OBJFPC}
{$H+}
interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, ChatControl, SynEdit, Dynlibs
  ,superobject, math;

type
  //Global Types Definitions
  MyPCharType = PAnsiChar;
  MyPVoid = IntPtr;

  //Definition of the Session
  TtgSession = record
    Name: String;
    ID: Integer;
    Client : MyPVoid;
  end;

var
  //Variable that receives the dll pointer
  tdjsonDll: TLibHandle = dynlibs.NilHandle;

const
  //DLL name associated with the test project
  {$IFDEF WINDOWS}
    {$IFDEF WIN32}                          //SharedSuffix = dll
       tdjsonDllName : String = 'tdjson.' + SharedSuffix;
    {$ENDIF}
    {$IFDEF WIN64}
       tdjsonDllName : String = 'tdjson-x64.' + SharedSuffix;
    {$ENDIF}
  {$ELSE}
    tdjsonDllName : String = 'libtdjson.so';
  {$ENDIF}

  //Setting the Receiver Timeout
  WAIT_TIMEOUT : double = 1.0; //1 seconds

var
  //should be set to 1, when updateAuthorizationState with authorizationStateClosed is received
  is_closed : integer  = 1;

  //Variable associated with function parameters
  FClient : MyPVoid;

  //Control Session...
  client_session : TtgSession;

  //Used to group contacts and groups
  ContactListTreeNode, GroupListTreeNode: TTreeNode;

  //Stores the logged user data
  CurrentChatStr: String = '';
  TLOGetMe, TLOMe  : ISuperObject;

type
  { TfrmLazteste }

  TfrmLazteste = class(TForm)
    btnClear: TButton;
    btnCreateClient: TButton;
    btnCreatePrivateChat: TButton;
    btnCusca: TButton;
    btnDestroyClient: TButton;
    btnExecute: TButton;
    btnInit: TButton;
    btnsearchChatMessages: TButton;
    btnSend: TButton;
    btnSend1: TButton;
    btnStart: TButton;
    btnStart1: TButton;
    btnStart2: TButton;
    btnStart3: TButton;
    btnStop: TButton;
    btnLogVerbosy: TButton;
    btnTestProxy: TButton;
    Button1: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button2: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    cbHttpOnly: TCheckBox;
    cbLoginBot: TCheckBox;
    cbType: TComboBox;
    cbUseDCTest: TCheckBox;
    chbEnable: TCheckBox;
    txtSearchBox: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    imgSearch: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblCurrentChat: TLabel;
    lblNomeDLL: TLabel;
    memChatMSG: TInjectChatControl;
    memReceiver: TMemo;
    PageControl1: TPageControl;
    shStatus: TShape;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ViewCtt: TTreeView;
    txtAPI_HASH: TEdit;
    txtAPI_ID: TEdit;
    txtChatIdToSend: TEdit;
    txtMSG: TEdit;
    txtMsgToSend: TEdit;
    txtNameToSearch: TEdit;
    memSend: TMemo;
    txtPassword: TEdit;
    txtPhoneNumber: TEdit;
    txtPort: TEdit;
    txtProxyID: TEdit;
    txtSecret: TEdit;
    txtServer: TEdit;
    txtToken: TEdit;
    txtUserName: TEdit;
    procedure btnClearClick(Sender: TObject);
    procedure btnCreateClientClick(Sender: TObject);
    procedure btnCreatePrivateChatClick(Sender: TObject);
    procedure btnCuscaClick(Sender: TObject);
    procedure btnDestroyClientClick(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure btnInitClick(Sender: TObject);
    procedure btnsearchChatMessagesClick(Sender: TObject);
    procedure btnSend1Click(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnStart1Click(Sender: TObject);
    procedure btnStart2Click(Sender: TObject);
    procedure btnStart3Click(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnLogVerbosyClick(Sender: TObject);
    procedure btnTestProxyClick(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure cbTypeChange(Sender: TObject);
    procedure txtSearchBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure imgSearchClick(Sender: TObject);
    procedure txtMSGKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ViewCttClick(Sender: TObject);
    procedure ViewCttDblClick(Sender: TObject);
  public
    procedure TDReceiver(Status: String);
    procedure TDSend(Status: String);
    procedure TDExecute(Status: String);
    procedure TDFatalErrorCallBack(Status: PAnsiChar);
    //Treatment of the necessary methods and functions
    function td_execute(JsonUTF8: String): String;
    function td_send(JsonUTF8: String): String;
    function td_receive: String;
    function DLLInitialize: Boolean;
    //# initialize TDLib log with desired parameters
    procedure on_fatal_error_callback(error_message: MyPCharType = '');
  end;

  type
    //Internal delegate void Callback(IntPtr ptr);
    TFatalErrorCallback = procedure (error_message: MyPcharType) of Object;

  //Defining DLL methods and functions
  function client_create: MyPVoid; stdcall; external 'tdjson-x64.dll' name 'td_json_client_create';
  procedure client_destroy(handle: MyPVoid); stdcall; external 'tdjson-x64.dll' name 'td_json_client_destroy';
  procedure client_send(handle: MyPVoid; data : MyPCharType); stdcall; external 'tdjson-x64.dll' name 'td_json_client_send';
  function client_receive(handle: MyPVoid; t: double ): MyPCharType; stdcall; external 'tdjson-x64.dll' name 'td_json_client_receive';
  function client_execute(handle: MyPVoid; data : MyPCharType): MyPCharType; stdcall; external 'tdjson-x64.dll' name 'td_json_client_execute';
  procedure set_log_verbosity_level(level: Int32); stdcall; external 'tdjson-x64.dll' name 'td_json_client_set_log_verbosity_level';
  procedure set_log_fatal_error_callback(callback : TFatalErrorCallback); stdcall; external 'tdjson-x64.dll' name 'td_json_client_set_log_fatal_error_callback';

type
  { TServiceThread }
  TServiceEvent = procedure(Status: String) of Object;

  TServiceThread = class(TThread)   //MyPCharType
  private
    Fis_closed: integer;
    FOnExecute: TServiceEvent;
    FOnFatalErrorCallback: TFatalErrorCallback;
    FFatalErrorCallback: MyPcharType;
    FOnSend: TServiceEvent;
    FOnReceiver: TServiceEvent;
    FReceiverText : string;
    FErrorMessage: AnsiString;
    procedure thReceiver;
    function thExecute(JsonUTF8: String): String;
    function thSend(JsonUTF8: String): String;
    procedure thSetLogFatalErrorCallback;
    procedure Setis_closed(AValue: integer);
  protected
    procedure Execute; override;
  public
    Constructor Create(CreateSuspended : boolean);
    property is_closed: integer read Fis_closed write Setis_closed;
    property OnFatalErrorCallback: TFatalErrorCallback read FOnFatalErrorCallback write FOnFatalErrorCallback;
    property OnReceiver: TServiceEvent read FOnReceiver write FOnReceiver;
    property OnSend: TServiceEvent read FOnSend write FOnSend;
    property OnExecute: TServiceEvent read FOnExecute write FOnExecute;
  end;

var
  frmLazteste: TfrmLazteste;
  ServiceThread: TServiceThread;

implementation

{$R *.lfm}

{ TServiceThread }

procedure TServiceThread.thReceiver;
var
  ReturnStr:  String;
  JsonAnsiStr: AnsiString;
  I, J, CTInt: Integer;

  XO, XOParam, TLOAuthState,
  TLOEvent, TLOUpdateMessage,
  TLOContent, TLOText, TLOChat,
  TLOUsers, TLOUser : ISuperObject;

  TLAContacts, TLAMessages: TSuperArray;

  ContactTreeNode, GroupTreeNode : TTreeNode;

begin

{$REGION 'IMPLEMENTATION'}
  ReturnStr := client_receive(FClient, WAIT_TIMEOUT);

  TLOEvent := SO(ReturnStr);

  if TLOEvent <> NIl then
  Begin

    {$REGION 'Authorization'}
    //# process authorization states
    if TLOEvent.S['@type'] = 'updateAuthorizationState' then
    Begin
      TLOAuthState := TLOEvent.O['authorization_state'];

      //# if client is closed, we need to destroy it and create new client
      if TLOAuthState.S['@type'] = 'authorizationStateClosed' then
        Exit;

      //# set TDLib parameters
      //# you MUST obtain your own api_id and api_hash at https://my.telegram.org
      //# and use them in the setTdlibParameters call
      if TLOAuthState.S['@type'] = 'authorizationStateWaitTdlibParameters' then
      Begin
        XO := nil;
        XO := SO;
        XO.S['@type'] := 'setTdlibParameters';
        XO.O['parameters'] := SO;
        XOParam := XO.O['parameters'];
          XOParam.B['use_test_dc'] := False;
          XOParam.S['database_directory'] := 'tdlib';
          XOParam.S['files_directory'] := 'myfiles';
          XOParam.B['use_file_database'] := True;
          XOParam.B['use_chat_info_database'] := True;
          XOParam.B['use_message_database'] := True;
          XOParam.B['use_secret_chats'] := true;

          JsonAnsiStr := '';
          JsonAnsiStr := frmLazteste.txtAPI_ID.Text;
          XOParam.I['api_id'] := StrToInt(JsonAnsiStr);

          JsonAnsiStr := '';
          JsonAnsiStr := frmLazteste.txtAPI_HASH.Text;
          XOParam.S['api_hash'] := JsonAnsiStr;

          if frmLazteste.cbLoginBot.Checked then
          Begin
            JsonAnsiStr := '';
            JsonAnsiStr := frmLazteste.txtToken.Text;
            XOParam.S['token'] := JsonAnsiStr;
          End;

          XOParam.S['system_language_code'] := 'pt';
          XOParam.S['device_model'] := 'TInjectTDLibTelegram';
          {$IFDEF WIN32}
            XOParam.S['system_version'] := 'WIN32';
          {$ENDIF}
          {$IFDEF WIN64}
            XOParam.S['system_version'] := 'WIN64';
          {$ENDIF}
          XOParam.S['application_version'] := '1.0';
          XOParam.B['enable_storage_optimizer'] := True;
          XOParam.B['ignore_file_names'] := False;

        //Send Request
        ReturnStr := thSend(XO.AsJSON);
      End;

      //# set an encryption key for database to let know TDLib how to open the database
      if TLOAuthState.S['@type'] = 'authorizationStateWaitEncryptionKey' then
      Begin
        XO := nil;
        XO := SO;
        XO.S['@type'] := 'checkDatabaseEncryptionKey';
        XO.S['encryption_key'] := '';

        //Send Request
        ReturnStr := thSend(XO.AsJSON);
      End;

      //# enter phone number to log in
      if TLOAuthState.S['@type'] = 'authorizationStateWaitPhoneNumber' then
      Begin
        //Clear Variable
        JsonAnsiStr:='';

        //Convert String to AnsiString Type
        JsonAnsiStr := frmLazteste.txtPhoneNumber.Text;

        XO := nil;
        XO := SO;
        XO.S['@type'] := 'setAuthenticationPhoneNumber';
        XO.S['phone_number'] := JsonAnsiStr;

        //Send Request
        ReturnStr := thSend(XO.AsJSON);
      End;

      //# wait for authorization code
      if TLOAuthState.S['@type'] = 'authorizationStateWaitCode' then
      Begin
        //Clear Variable
        JsonAnsiStr := '';

        ////Convert String to AnsiString Type
        JsonAnsiStr := InputBox('User Authorization', 'Enter the authorization code', '');

        if JsonAnsiStr <> '' then
        Begin
          XO := nil;
          XO := SO;
          XO.S['@type'] := 'checkAuthenticationCode';
          XO.S['code'] := JsonAnsiStr;

          //Send Request
          ReturnStr := thSend(XO.AsJSON);
        End;

      End;

      //# wait for first and last name for new users
      if TLOAuthState.S['@type'] = 'authorizationStateWaitRegistration' then
      Begin
        XO := nil;
        XO := SO;
        XO.S['@type'] := 'registerUser';
        XO.S['first_name'] := 'Ruan Diego';
        XO.S['last_name'] := 'Lacerda Menezes';

        //send request
        ReturnStr := thSend(XO.AsJSON);
      End;

      //# wait for password if present
      if TLOAuthState.S['@type'] = 'authorizationStateWaitPassword' then
      Begin
        //Clear Variable
        JsonAnsiStr := '';

        //Convert String to AnsiString Type
        JsonAnsiStr := InputBox('User Authentication', 'Enter the access code', '');

        XO := nil;
        XO := SO;
        XO.S['@type'] := 'checkAuthenticationPassword';
        XO.S['password'] := JsonAnsiStr;

        //Send Request
        ReturnStr := thSend(XO.AsJSON);
      End;

    End;
    {$ENDREGION 'Authorization'}

    {$REGION 'error'}
    if TLOEvent.S['@type'] = 'error' then
    Begin
      //if an error is found, stop the process
      if is_Closed = 0 then  //Restart Service
      Begin
         is_Closed := 1;
         is_Closed := 0;
      End;

      Showmessage('An error was found:'+ #10#13 +
                  'code : ' + TLOEvent.S['code'] + #10#13 +
                  'message : '+TLOEvent.S['message']);
    end;
    {$ENDREGION 'error'}

    {$REGION 'getMe'}
    if TLOAuthState <> Nil then
      if TLOAuthState.S['@type'] = 'authorizationStateReady' then
      Begin
        if TLOGetMe = Nil then
        Begin
          TLOGetMe := SO;
          TLOGetMe.S['@type'] := 'getMe';
          ReturnStr := thSend(TLOGetMe.AsAnsiString);
        End;
      End;


    if TLOEvent.S['@type'] = 'user' then  //updateUser
    Begin
      TLOMe := TLOEvent.Clone;
    End;
    {$ENDREGION 'getMe'}

    {$REGION 'getContacts FULL'}
    //  getContacts - Ok
    if TLOEvent.S['@type'] = 'updateUser' then  //updateUser
    Begin
      TLOUsers := Nil;
      TLOUsers := TLOEvent.O['user'];
      if TLOUsers.S['@type'] = 'user' then
      Begin
        with frmLazteste.ViewCtt.Items do
        begin
          if TLOUsers.S['first_name'] <> '' then
          begin
            { Add the root node }
            ContactTreeNode := AddChild(ContactListTreeNode,  TLOUsers.S['first_name']+' '+TLOUsers.S['last_name']);

            { Add child nodes }
            if TLOUsers.S['username'] <> '' then
              AddChild(ContactTreeNode,'UserName : '+TLOUsers.S['username']);
            if TLOUsers.S['phone_number'] <> '' then
              AddChild(ContactTreeNode,'Phone : '+TLOUsers.S['phone_number']);
            if TLOUsers.I['id'].ToString <> '' then
              AddChild(ContactTreeNode, 'ID : '+TLOUsers.I['id'].ToString);
          end
          else
            if TLOUsers.S['username'] <> '' then
            Begin
              { Add the root node }
              ContactTreeNode := AddChild(ContactListTreeNode, 'UserName : '+TLOUsers.S['username']);

              { Add child nodes }
              if TLOUsers.S['phone_number'] <> '' then
                AddChild(ContactTreeNode,'Phone : '+TLOUsers.S['phone_number']);
              if TLOUsers.I['id'].ToString <> '' then
                AddChild(ContactTreeNode, 'ID : '+TLOUsers.I['id'].ToString);
            End
            else
              if TLOUsers.I['id'].ToString <> '' then
              Begin
                { Add the root node }
                ContactTreeNode := AddChild(ContactListTreeNode, 'ID : '+TLOUsers.I['id'].ToString);

                { Add child nodes }
                if TLOUsers.S['phone_number'] <> '' then
                  AddChild(ContactTreeNode,'Phone : '+TLOUsers.S['phone_number']);
              End;

        end;
      End;
    End;
    {$ENDREGION 'getContacts'}

    {$REGION 'searchPublicChat'}
    //Return of searchPublicChat - OK....
    if TLOEvent.S['@type'] = 'chat' then
    Begin
      TLOChat := Nil;
      TLOChat := TLOEvent.Clone;
      with frmLazteste.ViewCtt.Items do
      begin
        if TLOChat.S['title'] <> '' then
        Begin
          { Add the root node in group type }
          GroupTreeNode := AddChild(GroupListTreeNode,  TLOChat.S['title']);

          { Add child nodes in root node}
          if TLOChat.I['id'].ToString <> '' then
          AddChild(GroupTreeNode,'ID : '+TLOChat.I['id'].ToString);
        End
        Else
          if TLOChat.I['id'].ToString <> '' then
          Begin
            { Add the root node }
            GroupTreeNode := AddChild(GroupListTreeNode, TLOChat.I['id'].ToString);
            { Add child nodes }
            AddChild(GroupTreeNode,'ID : '+TLOChat.I['id'].ToString);
          End;
      End;
    End;
    {$ENDREGION 'searchPublicChat'}

    {$REGION 'updateNewMessage'}
    //Handling New incoming messages
    if TLOEvent.S['@type'] = 'updateNewMessage' then
    Begin
      TLOUpdateMessage := TLOEvent.O['message'];
      TLOContent :=  TLOUpdateMessage.O['content'];

      //If it's a text message
      if TLOContent.S['@type'] = 'messageText' then
      Begin

        TLOText := TLOContent.O['text'];

        if CurrentChatStr = TLOUpdateMessage.I['chat_id'].ToString then
        Begin
          if TLOMe.I['id'].ToString = TLOUpdateMessage.I['sender_user_id'].ToString then
            frmLazteste.memChatMSG.Say(User2, TLOUpdateMessage.I['sender_user_id'].ToString, TLOText.S['text'])
          else
            frmLazteste.memChatMSG.Say(User1, TLOUpdateMessage.I['sender_user_id'].ToString, TLOText.S['text']);
        End;
      End;
    end;
    {$ENDREGION 'updateNewMessage'}

    {$REGION 'searchPublicChat'}
    //Return of searchPublicChat - OK....
    if TLOEvent.S['@type'] = 'chat' then
    Begin
      TLOChat := Nil;
      TLOChat := TLOEvent.Clone;
      with frmLazteste.ViewCtt.Items do
      begin
        if TLOChat.S['title'] <> '' then
        Begin
          { Add the root node in group type }
          GroupTreeNode := AddChild(GroupListTreeNode,  TLOChat.S['title']);

          { Add child nodes in root node}
          if TLOChat.I['id'].ToString <> '' then
          AddChild(GroupTreeNode,'ID : '+TLOChat.I['id'].ToString);
        End
        Else
          if TLOChat.I['id'].ToString <> '' then
          Begin
            { Add the root node }
            GroupTreeNode := AddChild(GroupListTreeNode, TLOChat.I['id'].ToString);
            { Add child nodes }
            AddChild(GroupTreeNode,'ID : '+TLOChat.I['id'].ToString);
          End;
      End;
    End;
    {$ENDREGION 'searchPublicChat'}

    {$REGION 'searchChatMessages'}
    //Handling New incoming messages  {"total_count":100,"@type":"messages","messages":
    if TLOEvent.S['@type'] = 'messages' then
    Begin
      TLAMessages := TLOEvent.A['messages'];
      for I := TLAMessages.Length -1 downto 0  do
      Begin
        TLOContent :=  TLAMessages[I].O['content'];

        //If it's a text message
        if TLOContent.S['@type'] = 'messageText' then
        Begin

          TLOText := TLOContent.O['text'];

          if CurrentChatStr = TLAMessages[I].I['chat_id'].ToString then
          Begin
            if TLOMe.I['id'].ToString = TLAMessages[I].I['sender_user_id'].ToString then
              frmLazteste.memChatMSG.Say(User2, TLAMessages[I].I['sender_user_id'].ToString, TLOText.S['text'])
            else
              frmLazteste.memChatMSG.Say(User1, TLAMessages[I].I['sender_user_id'].ToString, TLOText.S['text']);
          End;
        End;

      end;
    end;
    {$ENDREGION 'searchChatMessages'}

    //# handle an incoming update or an answer to a previously sent request
    if TLOEvent.AsJSON() <> '' then
    Begin
      ReturnStr := TLOEvent.AsJSon;
    End;

  End;
  //Else
  ////# destroy client when it is closed and isn't needed anymore
  //Client_destroy(FClient);

  {$ENDREGION 'IMPLEMENTATION'}

  if Assigned(FOnReceiver) then
  begin
    //if FReceiverText <> ReturnStr then
    //Begin
      FReceiverText := ReturnStr;
    //end;
    FOnReceiver(FReceiverText);
  end;
end;

function TServiceThread.thExecute(JsonUTF8: String): String;
var
  JSonAnsiStr: AnsiString;
begin
  JSonAnsiStr := JsonUTF8;
  Result := client_execute(0, MyPCharType(JSonAnsiStr));

  if Assigned(FOnExecute) then
  begin
    FOnExecute(Result);
  end;
end;

function TServiceThread.thSend(JsonUTF8: String): String;
var
  JsonAnsiStr: AnsiString;
begin
  JsonAnsiStr := JsonUTF8;
  client_send(FClient, MyPCharType(JsonAnsiStr));
  Result := JsonAnsiStr;

  if Assigned(FOnSend) then
  begin
    FOnSend(Result);
  end;
end;

procedure TServiceThread.thSetLogFatalErrorCallback;
begin
  set_log_fatal_error_callback(FOnFatalErrorCallback);
  if Assigned(FOnFatalErrorCallback) then
  begin
    FOnFatalErrorCallback(FFatalErrorCallback);
  end;
end;

procedure TServiceThread.Setis_closed(AValue: integer);
begin
  if Fis_closed = AValue then
     Exit;
  Fis_closed := AValue;
end;

procedure TServiceThread.Execute;
var
  NewReceiver : string;
begin
  //FReceiverText := 'TServiceThread Starting...';
  //Synchronize(@thReceiver);
  //FReceiverText := 'TServiceThread Running...';
  while (Fis_closed = 0) do
    begin
      //if NewReceiver <> FReceiverText then
      //Begin
      //  NewReceiver := FReceiverText;
        //Synchronize(@thReceiver);
      thReceiver;
      //end;
    end;
end;

constructor TServiceThread.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := True;
  Fis_closed := 1;
  inherited Create(CreateSuspended);
end;

{ TfrmLazteste }

function TfrmLazteste.DLLInitialize: Boolean;
begin
  //I initialize the Function Result to false
  Result := False;

  //Assigning the dll to the variable tdjsonDll
  tdjsonDll := SafeLoadLibrary(tdjsonDllName);

  //Checking if the variable was loaded with the DLL's Pointer
  if tdjsonDll = dynlibs.NilHandle then //DLL was not loaded successfully
  Begin
    raise Exception.CreateFmt('Cannot load Library "%s"'//+ sLineBreak
                             , [tdjsonDllName, GetLoadErrorStr]); //GetLoadErrorStr //GetLastError
    Exit;
  end;

  //Function return definition
  Result := tdjsonDll <> 0;
end;

procedure TfrmLazteste.on_fatal_error_callback(error_message: MyPCharType);
begin
  //  # initialize TDLib log with desired parameters
  memReceiver.Lines.Add(error_message^);
end;

procedure TfrmLazteste.Button9Click(Sender: TObject);
Var
  XO: ISuperObject;
begin
  XO := SO;
  XO.S['@type'] := 'getUser';
  XO.S['user_id_'] := txtChatIdToSend.Text;

  if Assigned(ServiceThread) then
    ServiceThread.thSend(XO.AsAnsiString)
  else
    memSend.Lines.Add(td_send(XO.AsAnsiString));

  XO := NIl;
end;

procedure TfrmLazteste.cbTypeChange(Sender: TObject);
begin
  //Samples Proxy Config
  case cbType.ItemIndex of
    0:
    Begin //proxyTypeHttp
      if txtServer.Text = '' then
        txtServer.Text := '119.93.235.205';

      if txtPort.Text = '' then
        txtPort.Text := '80';
    End;

    1:
    Begin //proxyTypeMtproto
      if txtServer.Text = '' then
        txtServer.Text := '65.52.166.119';

      if txtPort.Text = '' then
        txtPort.Text := '443';

      if txtSecret.Text = '' then
        txtSecret.Text := 'eef0c0e5aee000330514b3ed796d4012ff617a7572652e6d6963726f736f66742e636f6d';
    End;

    2:
    Begin //proxyTypeSocks5   98.190.102.62:4145
      if txtServer.Text = '' then
        txtServer.Text := '204.101.61.82';

      if txtPort.Text = '' then
        txtPort.Text := '4145';
    End;
  end;
end;

procedure TfrmLazteste.txtSearchBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i:integer;
begin
  if Key = VK_Return then
  Begin
    imgSearchClick(Sender);
  end;
end;

procedure TfrmLazteste.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if FClient <> 0 then
  Begin
    if  Assigned(ServiceThread) then
    Begin
      if ServiceThread.is_closed = 0 then
      begin
        is_closed := 1; //Now the Service is Closed
        ServiceThread.is_closed := 1; //Now the Service is Closed
      end;
    end
    Else
      if is_closed = 0 then
      begin
        is_closed := 1; //Now the Service is Closed
      end;

    client_session.Name := '';
    client_session.ID := 0;
    client_session.Client := 0;
    client_destroy(FClient);
    FClient := 0;

    TLOMe := Nil;
    TLOGetMe := Nil;
  End;

  if  Assigned(ServiceThread) then
      ServiceThread.Terminate;
end;

procedure TfrmLazteste.btnInitClick(Sender: TObject);
begin
  shStatus.Brush.Color := clYellow;
  if DLLInitialize then
    shStatus.Brush.Color := clGreen
  else
    shStatus.Brush.Color := clRed;
end;

procedure TfrmLazteste.btnsearchChatMessagesClick(Sender: TObject);
Var
  XO: ISuperObject;
begin
  if ViewCtt.Items.Item[ViewCtt.Selected.AbsoluteIndex].Text.Contains('ID') then
  Begin
    memChatMSG.Strings.Clear;
    XO := SO;
    XO.S['@type'] := 'searchChatMessages';
    XO.S['chat_id'] := StringReplace(ViewCtt.Items.Item[ViewCtt.Selected.AbsoluteIndex].Text,'ID : ','',[rfReplaceAll]);
    XO.S['query'] := '';
    XO.I['sender_user'] := 0;
    XO.I['from_message_id'] := 0;
    XO.I['limit'] := 30;
    XO.I['offset'] := 0;
    XO.O['filter'] := SO;
    XO.O['filter'].S['@type'] := 'searchMessagesFilterEmpty';

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));
    //memSend.Lines.Add(td_send(XO.AsAnsiString));
    XO := NIl;
  End
  Else
    Showmessage('Select a valid chat id!');
end;

procedure TfrmLazteste.btnSend1Click(Sender: TObject);
var
  XO: ISuperObject;
  JSonAnsiStr: AnsiString;
begin
  if is_closed = 1 then
    Showmessage('No active service to send!')
  Else
  begin
    //ChatID from the TInjectTelegram Group for you to use and test
    //-1001387521713
    XO := SO;
    XO.S['@type'] := 'sendMessage';
    XO.S['chat_id'] := txtChatIdToSend.Text;
    XO.O['input_message_content'] := SO;
    XO.O['input_message_content'].S['@type'] := 'inputMessageText';
    XO.O['input_message_content'].O['text'] := SO;
    XO.O['input_message_content'].O['text'].S['@type'] := 'formattedText';
    XO.O['input_message_content'].O['text'].S['text'] := txtMsgToSend.Text;

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      Begin
        JSonAnsiStr := XO.AsJSon;

        memSend.Lines.Add('SENDING : '+XO.AsJSon);
        memSend.Lines.Add('');

        td_send(JSonAnsiStr);
      end;

  end;

end;

procedure TfrmLazteste.btnSendClick(Sender: TObject);
var
  JSonAnsiStr : AnsiString;
  XO: ISuperObject;
begin
  if is_closed = 1 then
    Showmessage('No active service to send!')
  Else
  begin
    XO := SO;
    XO.S['@type'] := 'getAuthorizationState';
    XO.D['@extra'] := 1.01234;

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    //JSonAnsiStr := XO.AsJSon;
    //
    //memSend.Lines.Add('SENDING : '+XO.AsJSon);
    //memSend.Lines.Add('');
    //
    //td_send(JSonAnsiStr);
  end;
end;

procedure TfrmLazteste.btnStart1Click(Sender: TObject);
begin
  if FClient = 0 then
  Begin
    Showmessage('Create a client to start the service');
  end
  Else
  Begin
    is_Closed := 0;

    ServiceThread := TServiceThread.Create(False);
    //if Assigned(ServiceThread.FatalException) then
    //  raise ServiceThread.FatalException;

    ServiceThread.is_closed  := is_Closed;
    ServiceThread.OnReceiver := @TDReceiver;
    ServiceThread.OnSend     := @TDSend;
    ServiceThread.OnExecute  := @TDExecute;
    ServiceThread.OnFatalErrorCallback := @TDFatalErrorCallBack;
    ServiceThread.Resume;
    //memSend.Lines.Add('Service Started!!!');

  end;
end;

procedure TfrmLazteste.btnStart2Click(Sender: TObject);
begin
  is_closed := 1;
  ServiceThread.is_closed  := is_Closed;
  //ServiceThread.Terminate;
  //ServiceThread.Free;
end;

procedure TfrmLazteste.btnStart3Click(Sender: TObject);
begin
  is_closed := 0;
  ServiceThread.is_closed  := is_Closed;
  ServiceThread.Resume;
  //ServiceThread.Start;
end;

procedure TfrmLazteste.btnStartClick(Sender: TObject);

  procedure Receiver2;
  Begin
    while is_closed = 0 do
    Begin
       with frmLazteste do
         memReceiver.Lines.Add(td_receive);
    End;
  end;

begin

  if FClient = 0 then
  Begin
    Showmessage('Create a client to start the service');
  end
  Else
  Begin
    is_Closed := 0;

    //if TThread.CreateAnonymousThread(TProcedure(@Receiver)).Finished then
      with TThread.CreateAnonymousThread(TProcedure(@Receiver2)) do
        begin
          FreeOnTerminate := True;
          Start;
        end;
    //Else
    //  TThread.CreateAnonymousThread(TProcedure(@Receiver)).Terminate;


    memSend.Lines.Add('Service Started!!!');

  end;

end;

procedure TfrmLazteste.btnStopClick(Sender: TObject);
begin
  if is_closed = 1 then
    Showmessage('No active service to stop!')
  Else
  begin
    is_closed := 1;
    memSend.Lines.Add('Service Paused!!!');
  end;
end;

procedure TfrmLazteste.btnCuscaClick(Sender: TObject);
begin
  if FileExists(ExtractFilePath(Application.ExeName)+tdjsonDllName) then
    Showmessage('Dll '+ExtractFilePath(Application.ExeName)+tdjsonDllName+' Found')
  else
    Showmessage('Dll '+ExtractFilePath(Application.ExeName)+tdjsonDllName+' Not Found');
end;

procedure TfrmLazteste.btnDestroyClientClick(Sender: TObject);
begin
  if FClient <> 0 then
  Begin
    if is_Closed = 0 then
    begin
      Showmessage('Stop the service first');
      exit;
    end;

    client_session.Name := '';
    client_session.ID := 0;
    client_session.Client := 0;
    client_destroy(FClient);
    FClient := 0;

    with memSend.Lines do
    Begin
      Add('Name : '+client_session.Name);
      Add('ID : '+client_session.ID.ToString);
      Add('Client : '+client_session.Client.ToString);
      Add('*******Section Finished********');
    end;
  End
  Else
    Showmessage('No Client Created to Destroy!');
end;

procedure TfrmLazteste.btnExecuteClick(Sender: TObject);
var
  JSOnAnsiStr: AnsiString;
  XO, A: ISuperObject;
begin
  A := TSuperObject.Create(stArray);
  A.S['@extra'] := '5';
  A.D['@extra'] := 7.0;

  XO := TSuperObject.Create(stObject);
  XO.S['@type'] := 'getTextEntities';
  XO.S['text']  := '@telegram /test_command https://telegram.org telegram.me';
  XO['@extra'] := A;

  if Assigned(ServiceThread) then
    ServiceThread.thExecute(XO.AsAnsiString)
  else
    Begin
      memReceiver.Lines.Add('RECEIVING : '+td_execute(XO.AsAnsiString));
      memReceiver.Lines.Add('');
    end;

end;

procedure TfrmLazteste.btnCreateClientClick(Sender: TObject);
begin

  if FClient = 0 then
  Begin
    FClient := client_create;

    with client_session do
    Begin
      Client := FClient;
      ID := MyPVoid(FClient);
      Name := 'Section Desktop TDLib TInjectTelegram';
    End;

    with memSend.Lines do
    Begin
      Add('Name : '+client_session.Name);
      Add('ID : '+client_session.ID.ToString);
      Add('*******Section Initialized********');
    end;

  End
  Else
    Showmessage('There is already a Created Customer!');

end;

procedure TfrmLazteste.btnCreatePrivateChatClick(Sender: TObject);
var
  XO: ISuperObject;
begin

  if is_closed = 1  then
    Showmessage('No active service to send!')
  Else
  begin
    XO := SO;
    XO.S['@type'] := 'createPrivateChat';
    XO.S['user_id'] := txtChatIdToSend.text;
    XO.B['force'] := True;

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      Begin
        memReceiver.Lines.Add('RECEIVING : '+td_send(XO.AsAnsiString));
        memReceiver.Lines.Add('');
      end;

    XO := Nil;
  end;
end;

procedure TfrmLazteste.btnClearClick(Sender: TObject);
begin
  //*ClearProxyConfig
  txtUserName.Text := '';
  txtPassword.Text := '';
  txtServer.Text := '';
  txtSecret.Text := '';
  txtPort.Text := '';
end;

procedure TfrmLazteste.btnLogVerbosyClick(Sender: TObject);
var
  JSonAnsiStr: AnsiString;
  XO: ISuperObject;
begin
  //# setting TDLib log verbosity level to 1 (errors)
  XO := SO;
  XO.S['@type'] := 'setLogVerbosityLevel';
  XO.I['new_verbosity_level'] := 1;
  XO.D['@extra'] := 1.01234;

  if Assigned(ServiceThread) then
    ServiceThread.thExecute(XO.AsAnsiString)
  else
    Begin
      memReceiver.Lines.Add('RECEIVING : '+td_execute(XO.AsAnsiString));
    end;

end;

procedure TfrmLazteste.btnTestProxyClick(Sender: TObject);
var
  XO: ISuperObject;
begin

  if is_closed = 1  then
    Showmessage('No active service to send!')
  Else
  begin

    XO := SO;
    XO.S['@type'] := 'testProxy';
    XO.S['server'] := txtServer.Text;
    XO.I['port'] := StrToInt(txtPort.Text);
    XO.I['dc_id'] := 0;
    XO.D['timeout'] := 10.0;
    XO.O['type'] := SO;
    XO.O['type'].S['@type'] := cbType.Text;

    if cbType.Text = 'proxyTypeMtproto' then
    Begin
      if txtSecret.Text <> '' then
        XO.O['type'].S['secret'] := txtSecret.Text
      else
        Begin
          Showmessage('Enter the value of MTProto secret!');
          Exit;
        End;
    End
    Else
      Begin
        XO.O['type'].S['username'] := txtUserName.Text;
        XO.O['type'].S['password'] := txtPassword.Text;

        if cbType.Text = 'proxyTypeHttp' then
          XO.O['type'].B['http_only'] := cbHttpOnly.Checked;
      End;

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := Nil;

  end;
end;

procedure TfrmLazteste.Button11Click(Sender: TObject);
var
  XO: ISuperObject;
begin
  if is_closed = 1 then
    Showmessage('No active service to get!')
  Else
  begin
    XO := SO;
    XO.S['@type'] := 'getChats';
    //XO.O['chat_list'] := SO; //chatListArchive, and chatListMain
    //XO.O['chat_list'].S['@type'] := 'chatListMain';
    XO.I['offset_order'] := 9223372036854775807;//(Power(2, 63) - 1).ToString; //This is a big number
    XO.I['offset_chat_id'] := 0;
    XO.I['limit'] := 100; //Get 100 first messages

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := Nil;
  end;
end;

procedure TfrmLazteste.Button12Click(Sender: TObject);
var
  XO: ISuperObject;
begin

  if is_closed = 1  then
    Showmessage('No active service to send!')
  Else
  begin

    XO := SO;
    XO.S['@type'] := 'getMe';

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := Nil;
  end;
end;

procedure TfrmLazteste.Button13Click(Sender: TObject);
var
  XO: ISuperObject;
begin

  if is_closed = 1  then
    Showmessage('No active service to send!')
  Else
  begin

    XO := SO;
    XO.S['@type'] := 'addProxy';
    XO.S['server'] := txtServer.Text;
    XO.I['port'] := StrToInt(txtPort.Text);
    XO.B['enable'] := chbEnable.Checked;
    XO.O['type'] := SO;
    XO.O['type'].S['@type'] := cbType.Text;

    if cbType.Text = 'proxyTypeMtproto' then
    Begin
      if txtSecret.Text <> '' then
        XO.O['type'].S['secret'] := txtSecret.Text
      else
        Begin
          Showmessage('Enter the value of MTProto secret!');
          Exit;
        End;
    End
    Else
      Begin
        XO.O['type'].S['username'] := txtUserName.Text;
        XO.O['type'].S['password'] := txtPassword.Text;

        if cbType.Text = 'proxyTypeHttp' then
          XO.O['type'].B['http_only'] := cbHttpOnly.Checked;
      End;

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := Nil;
  end;

end;

procedure TfrmLazteste.Button14Click(Sender: TObject);
var
  XO: ISuperObject;
begin

  if is_closed = 1  then
    Showmessage('No active service to send!')
  Else
  begin
    XO := SO;
    XO.S['@type'] := 'getProxies';

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := Nil;
  end;
end;

procedure TfrmLazteste.Button15Click(Sender: TObject);
var
  XO: ISuperObject;
begin

  if is_closed = 1  then
    Showmessage('No active service to send!')
  Else
  begin

    XO := SO;
    XO.S['@type'] := 'getProxyLink';
    XO.I['proxy_id'] := StrToInt(txtProxyID.Text);

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := Nil;
  end;
end;

procedure TfrmLazteste.Button16Click(Sender: TObject);
var
  XO: ISuperObject;
begin

  if is_closed = 1  then
    Showmessage('No active service to send!')
  Else
  begin

    XO := SO;
    XO.S['@type'] := 'pingProxy';
    XO.I['proxy_id'] := StrToInt(txtProxyID.Text);

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := Nil;
  end;
end;

procedure TfrmLazteste.Button17Click(Sender: TObject);
var
  XO: ISuperObject;
begin

  if is_closed = 1  then
    Showmessage('No active service to send!')
  Else
  begin

    XO := SO;
    XO.S['@type'] := 'removeProxy';
    XO.I['proxy_id'] := StrToInt(txtProxyID.Text);

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := Nil;
  end;

end;

procedure TfrmLazteste.Button18Click(Sender: TObject);
var
  XO: ISuperObject;
begin

  if is_closed = 1  then
    Showmessage('No active service to send!')
  Else
  begin
    XO := SO;
    XO.S['@type'] := 'disableProxy';

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := Nil;
  end;
end;

procedure TfrmLazteste.Button19Click(Sender: TObject);
var
  XO: ISuperObject;
begin

  if is_closed = 1  then
    Showmessage('No active service to send!')
  Else
  begin

    XO := SO;
    XO.S['@type'] := 'enableProxy';
    if txtProxyID.Text <> '' then
       XO.I['proxy_id'] := StrToInt(txtProxyID.Text);

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := Nil;
  end;
end;

procedure TfrmLazteste.Button1Click(Sender: TObject);
var
  XO: ISuperObject;
begin

  if is_closed = 1  then
    Showmessage('No active service to send!')
  Else
  begin

    XO := SO;
    XO.S['@type'] := 'getChat';
    XO.S['chat_id'] := txtChatIdToSend.text;

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := Nil;
  end;

end;

procedure TfrmLazteste.Button20Click(Sender: TObject);
var
  XO: ISuperObject;
begin

  if is_closed = 1  then
    Showmessage('No active service to send!')
  Else
  begin

    XO := SO;
    XO.S['@type'] := 'editProxy';
    XO.I['proxy_id'] := StrToInt(txtProxyID.Text);
    XO.S['server'] := txtServer.Text;
    XO.I['port'] := StrToInt(txtPort.Text);
    XO.B['enable'] := chbEnable.Checked;
    XO.O['type'] := SO;
    XO.O['type'].S['@type'] := cbType.Text;

    if cbType.Text = 'proxyTypeMtproto' then
    Begin
      XO.O['type'].S['secret'] := txtSecret.Text;
    End
    Else
      Begin
        XO.O['type'].S['username'] := txtUserName.Text;
        XO.O['type'].S['password'] := txtPassword.Text;

        if cbType.Text = 'proxyTypeHttp' then
          XO.O['type'].B['http_only'] := cbHttpOnly.Checked;
      End;

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := Nil;
  end;

end;

procedure TfrmLazteste.Button21Click(Sender: TObject);
var
  XO: ISuperObject;
begin
  if ViewCtt.Items.Item[ViewCtt.Selected.AbsoluteIndex].Text.Contains('ID') then
  Begin
    if is_closed = 1  then
      Showmessage('No active service to send!')
    Else
    begin
      XO := SO;
      XO.S['@type'] := 'createPrivateChat';
      XO.S['user_id'] := StringReplace(ViewCtt.Items.Item[ViewCtt.Selected.AbsoluteIndex].Text,'ID : ','',[rfReplaceAll]);
      XO.B['force'] := True;

      if Assigned(ServiceThread) then
        ServiceThread.thSend(XO.AsAnsiString)
      else
        memSend.Lines.Add(td_send(XO.AsAnsiString));

      XO := Nil;
    end;
  End
  Else
    Showmessage('Select a valid chat id!');
end;

procedure TfrmLazteste.Button22Click(Sender: TObject);
var
  XO: ISuperObject;
begin
  //getSupergroup (std::int32_t supergroup_id_)
  //getBasicGroup (std::int32_t basic_group_id_)
  //PublicChatType = publicChatTypeHasUsername, and publicChatTypeIsLocationBased.
  //getCreatedPublicChats (object_ptr< PublicChatType > &&type_)
  //getGroupsInCommon (std::int32_t user_id_, std::int64_t offset_chat_id_, std::int32_t limit_)
  //searchPublicChats (std::string const &query_)
  if is_closed = 1 then
    Showmessage('No active service to get!')
  Else
  begin
    XO := SO;
    XO.S['@type'] := 'getInactiveSupergroupChats';

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := Nil;
  end;

end;

procedure TfrmLazteste.Button2Click(Sender: TObject);
var
  XO: ISuperObject;
begin
  if is_closed = 1  then
    Showmessage('No active service to send!')
  Else
  begin

    XO := SO;
    XO.S['@type'] := 'searchPublicChat';
    XO.S['username'] := txtNameToSearch.text;

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := Nil;
  end;
end;

procedure TfrmLazteste.Button5Click(Sender: TObject);
var
  XO: ISuperObject;
begin
  if is_closed = 1  then
    Showmessage('No active service to send!')
  Else
  begin
    XO := SO;
    XO.S['@type'] := 'openChat';
    XO.S['user_id'] := txtChatIdToSend.text;

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := NIl;
  end;
end;

procedure TfrmLazteste.Button6Click(Sender: TObject);
var
  XO: ISuperObject;
begin

  if is_closed = 1  then
    Showmessage('No active service to get!')
  Else
  begin
    XO := SO;
    XO.S['@type'] := 'getContacts';

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := NIl;
  end;
end;

procedure TfrmLazteste.Button7Click(Sender: TObject);
Var
  XO: ISuperObject;
begin
  XO := SO;
  XO.S['@type'] := 'searchChatsOnServer';
  XO.S['&query'] := txtNameToSearch.Text;
  XO.I['limit'] := 200;

  if Assigned(ServiceThread) then
    ServiceThread.thSend(XO.AsAnsiString)
  else
    memSend.Lines.Add(td_send(XO.AsAnsiString));

  XO := NIl;
end;

procedure TfrmLazteste.Button8Click(Sender: TObject);
Var
  XO: ISuperObject;
begin
  //#Beta version in test...
  if ViewCtt.Items.Item[ViewCtt.Selected.AbsoluteIndex].Text.Contains('ID') then
  Begin
    XO := SO;
    XO.S['@type'] := 'createCall';
    XO.I['user_id'] := StrToInt64(StringReplace(ViewCtt.Items.Item[ViewCtt.Selected.AbsoluteIndex].Text,'ID : ','',[rfReplaceAll]));
    XO.O['protocol'] := SO;
    XO.O['protocol'].B['udp_p2p'] := True;
    XO.O['protocol'].B['udp_reflector'] := True;
    XO.O['protocol'].I['min_layer'] := 65;
    XO.O['protocol'].I['max_layer'] := 65;

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := NIl;
  End
  Else
    Showmessage('Select a valid chat id!');
end;

procedure TfrmLazteste.FormCreate(Sender: TObject);
begin
  shStatus.Brush.Color := clYellow;
  if DLLInitialize then
    shStatus.Brush.Color := clGreen
  else
    shStatus.Brush.Color := clRed;

  lblNomeDLL.Caption := tdjsonDllName;

  with ViewCtt.Items do
  begin
    if GroupListTreeNode = Nil then
      GroupListTreeNode := Add(nil,  'Group List');

    if ContactListTreeNode = Nil then
      ContactListTreeNode := Add(nil,  'Contacts List');
  end;

end;

procedure TfrmLazteste.imgSearchClick(Sender: TObject);
var
  i:integer;
begin
  {Browsing the Items}
  for i:=0 to ViewCtt.Items.Count-1 do
    if (ViewCtt.Items.Item[i].Text.Contains(txtSearchBox.Text)) then
    begin
       // Expanding the desired Node. The False parameter does not
       // enable recursion (it will not expand whoever is
       // within the Node located) and True enables recursion,
       // that way it expands what you've located and all the others
       // internal nodes to it (obviously only those with children)}}
      ViewCtt.Items.Item[i].Expand(False);
    end;
end;

procedure TfrmLazteste.txtMSGKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  XO: ISuperObject;
begin
  if Key = VK_RETURN then
    if ViewCtt.Items.Item[ViewCtt.Selected.AbsoluteIndex].Text.Contains('ID') then
    Begin
      if is_closed = 1 then
        Showmessage('No active service to send!')
      Else
      begin
        XO := SO;
        XO.S['@type'] := 'sendMessage';
        XO.S['chat_id'] := StringReplace(ViewCtt.Items.Item[ViewCtt.Selected.AbsoluteIndex].Text,'ID : ','',[rfReplaceAll]);;
        XO.O['input_message_content'] := SO;
        XO.O['input_message_content'].S['@type'] := 'inputMessageText';
        XO.O['input_message_content'].O['text'] := SO;
        XO.O['input_message_content'].O['text'].S['@type'] := 'formattedText';
        XO.O['input_message_content'].O['text'].S['text'] := txtMsg.Text;

        if Assigned(ServiceThread) then
          ServiceThread.thSend(XO.AsAnsiString)
        else
          memSend.Lines.Add(td_send(XO.AsAnsiString));

        XO := Nil;
        txtMsg.Text := '';
      end;

      Key := Ord(#0);
    End
    Else
      Showmessage('Select a valid id!');
end;

procedure TfrmLazteste.ViewCttClick(Sender: TObject);
Var
  XO: ISuperObject;
begin
  if ViewCtt.Items.Item[ViewCtt.Selected.AbsoluteIndex].Text.Contains('ID : ') then
  Begin
    memChatMSG.Strings.Clear;
    XO := SO;
    XO.S['@type'] := 'searchChatMessages';
    CurrentChatStr := StringReplace(ViewCtt.Items.Item[ViewCtt.Selected.AbsoluteIndex].Text,'ID : ','',[rfReplaceAll]);
    lblCurrentChat.Caption :=  'Current Chat : '+CurrentChatStr;
    XO.S['chat_id'] := CurrentChatStr;
    XO.S['query'] := '';
    XO.I['sender_user'] := 0;
    XO.I['from_message_id'] := 0;
    XO.I['limit'] := 30;
    XO.I['offset'] := 0;
    XO.O['filter'] := SO;
    XO.O['filter'].S['@type'] := 'searchMessagesFilterEmpty';

    if Assigned(ServiceThread) then
      ServiceThread.thSend(XO.AsAnsiString)
    else
      memSend.Lines.Add(td_send(XO.AsAnsiString));

    XO := NIl;
  End;

end;

procedure TfrmLazteste.ViewCttDblClick(Sender: TObject);
begin
  if ViewCtt.Items.Item[ViewCtt.Selected.AbsoluteIndex].Text.Contains('ID') then
  Begin
    PageControl1.TabIndex := 0;
    txtChatIdToSend.Text := StringReplace(ViewCtt.Items.Item[ViewCtt.Selected.AbsoluteIndex].Text,'ID : ','',[rfReplaceAll]);
  End;

  if (ViewCtt.Items.Item[ViewCtt.Selected.AbsoluteIndex].Text.Contains('UserName')) and
  (Length(ViewCtt.Items.Item[ViewCtt.Selected.AbsoluteIndex].Text) > 10) then
  Begin
    PageControl1.TabIndex := 0;
    txtNameToSearch.Text := StringReplace(ViewCtt.Items.Item[ViewCtt.Selected.AbsoluteIndex].Text,'UserName : ','',[rfReplaceAll]);
  End;
end;

procedure TfrmLazteste.TDReceiver(Status: String);
begin
  if (Status <> '') and (Status <> '""') then
    memReceiver.Lines.Add(Status);
end;

procedure TfrmLazteste.TDSend(Status: String);
begin
  if (Status <> '') and (Status <> '""') then
    memSend.Lines.Add(Status);
end;

procedure TfrmLazteste.TDExecute(Status: String);
begin
  if (Status <> '') and (Status <> '""') then
    memReceiver.Lines.Add(Status);
end;

procedure TfrmLazteste.TDFatalErrorCallBack(Status: PAnsiChar);
begin
  if (Status <> '') and (Status <> '""') then
    memReceiver.Lines.Add(Status^);
end;

function TfrmLazteste.td_execute(JsonUTF8: String): String;
var
  JSonAnsiStr: AnsiString;
begin
  JSonAnsiStr := JsonUTF8;
  Result := client_execute(0, MyPCharType(JSonAnsiStr));
end;

function TfrmLazteste.td_send(JsonUTF8: String): String;
var
  JsonAnsiStr: AnsiString;
begin
  JsonAnsiStr := JsonUTF8;
  client_send(FClient, MyPCharType(JsonAnsiStr));
  Result := JsonAnsiStr;
end;

function TfrmLazteste.td_receive: String;
var
  ReturnStr:  String;
  JsonAnsiStr: AnsiString;
  I, J, CTInt: Integer;

  XO, XOParam, TLOAuthState,
  TLOEvent, TLOUpdateMessage,
  TLOContent, TLOText, TLOChat,
  TLOUsers, TLOUser : ISuperObject;

  TLAContacts, TLAMessages: TSuperArray;

  ContactTreeNode, GroupTreeNode : TTreeNode;

begin

{$REGION 'IMPLEMENTATION'}
  ReturnStr := client_receive(FClient, WAIT_TIMEOUT);

  TLOEvent := SO(ReturnStr);

  if TLOEvent <> NIl then
  Begin

    {$REGION 'Authorization'}
    //# process authorization states
    if TLOEvent.S['@type'] = 'updateAuthorizationState' then
    Begin
      TLOAuthState := TLOEvent.O['authorization_state'];

      //# if client is closed, we need to destroy it and create new client
      if TLOAuthState.S['@type'] = 'authorizationStateClosed' then
        Exit;

      //# set TDLib parameters
      //# you MUST obtain your own api_id and api_hash at https://my.telegram.org
      //# and use them in the setTdlibParameters call
      if TLOAuthState.S['@type'] = 'authorizationStateWaitTdlibParameters' then
      Begin
        XO := nil;
        XO := SO;
        XO.S['@type'] := 'setTdlibParameters';
        XO.O['parameters'] := SO;
        XOParam := XO.O['parameters'];
          XOParam.B['use_test_dc'] := False;
          XOParam.S['database_directory'] := 'tdlib';
          XOParam.S['files_directory'] := 'myfiles';
          XOParam.B['use_file_database'] := True;
          XOParam.B['use_chat_info_database'] := True;
          XOParam.B['use_message_database'] := True;
          XOParam.B['use_secret_chats'] := true;

          JsonAnsiStr := '';
          JsonAnsiStr := txtAPI_ID.Text;
          XOParam.I['api_id'] := StrToInt(JsonAnsiStr);

          JsonAnsiStr := '';
          JsonAnsiStr := txtAPI_HASH.Text;
          XOParam.S['api_hash'] := JsonAnsiStr;

          if cbLoginBot.Checked then
          Begin
            JsonAnsiStr := '';
            JsonAnsiStr := txtToken.Text;
            XOParam.S['token'] := JsonAnsiStr;
          End;

          XOParam.S['system_language_code'] := 'pt';
          XOParam.S['device_model'] := 'TInjectTDLibTelegram';
          {$IFDEF WIN32}
            XOParam.S['system_version'] := 'WIN32';
          {$ENDIF}
          {$IFDEF WIN64}
            XOParam.S['system_version'] := 'WIN64';
          {$ENDIF}
          XOParam.S['application_version'] := '1.0';
          XOParam.B['enable_storage_optimizer'] := True;
          XOParam.B['ignore_file_names'] := False;

        //Send Request
        ReturnStr := td_send(XO.AsJSON);
      End;

      //# set an encryption key for database to let know TDLib how to open the database
      if TLOAuthState.S['@type'] = 'authorizationStateWaitEncryptionKey' then
      Begin
        XO := nil;
        XO := SO;
        XO.S['@type'] := 'checkDatabaseEncryptionKey';
        XO.S['encryption_key'] := '';

        //Send Request
        ReturnStr := td_send(XO.AsJSON);
      End;

      //# enter phone number to log in
      if TLOAuthState.S['@type'] = 'authorizationStateWaitPhoneNumber' then
      Begin
        //Clear Variable
        JsonAnsiStr:='';

        //Convert String to AnsiString Type
        JsonAnsiStr := txtPhoneNumber.Text;

        XO := nil;
        XO := SO;
        XO.S['@type'] := 'setAuthenticationPhoneNumber';
        XO.S['phone_number'] := JsonAnsiStr;

        //Send Request
        ReturnStr := td_send(XO.AsJSON);
      End;

      //# wait for authorization code
      if TLOAuthState.S['@type'] = 'authorizationStateWaitCode' then
      Begin
        //Clear Variable
        JsonAnsiStr := '';

        ////Convert String to AnsiString Type
        JsonAnsiStr := InputBox('User Authorization', 'Enter the authorization code', '');

        if JsonAnsiStr <> '' then
        Begin
          XO := nil;
          XO := SO;
          XO.S['@type'] := 'checkAuthenticationCode';
          XO.S['code'] := JsonAnsiStr;

          //Send Request
          ReturnStr := td_send(XO.AsJSON);
        End;

      End;

      //# wait for first and last name for new users
      if TLOAuthState.S['@type'] = 'authorizationStateWaitRegistration' then
      Begin
        XO := nil;
        XO := SO;
        XO.S['@type'] := 'registerUser';
        XO.S['first_name'] := 'Ruan Diego';
        XO.S['last_name'] := 'Lacerda Menezes';

        //send request
        ReturnStr := td_send(XO.AsJSON);
      End;

      //# wait for password if present
      if TLOAuthState.S['@type'] = 'authorizationStateWaitPassword' then
      Begin
        //Clear Variable
        JsonAnsiStr := '';

        //Convert String to AnsiString Type
        JsonAnsiStr := InputBox('User Authentication', 'Enter the access code', '');

        XO := nil;
        XO := SO;
        XO.S['@type'] := 'checkAuthenticationPassword';
        XO.S['password'] := JsonAnsiStr;

        //Send Request
        ReturnStr := td_send(XO.AsJSON);
      End;

    End;
    {$ENDREGION 'Authorization'}

    {$REGION 'error'}
    if TLOEvent.S['@type'] = 'error' then
    Begin
      //if an error is found, stop the process
      if is_Closed = 0 then  //Restart Service
      Begin
         is_Closed := 1;
         is_Closed := 0;
      End;

      Showmessage('An error was found:'+ #10#13 +
                  'code : ' + TLOEvent.S['code'] + #10#13 +
                  'message : '+TLOEvent.S['message']);
    end;
    {$ENDREGION 'error'}

    {$REGION 'getMe'}
    if TLOAuthState <> Nil then
      if TLOAuthState.S['@type'] = 'authorizationStateReady' then
      Begin
        if TLOGetMe = Nil then
        Begin
          TLOGetMe := SO;
          TLOGetMe.S['@type'] := 'getMe';
          memSend.Lines.Add(td_send(TLOGetMe.AsAnsiString));
          memReceiver.Lines.Add(TLOGetMe.AsAnsiString);
        End;
      End;


    if TLOEvent.S['@type'] = 'user' then  //updateUser
    Begin
      TLOMe := TLOEvent.Clone;
    End;
    {$ENDREGION 'getMe'}

    {$REGION 'getContacts FULL'}
    //  getContacts - Ok
    if TLOEvent.S['@type'] = 'updateUser' then  //updateUser
    Begin
      TLOUsers := Nil;
      TLOUsers := TLOEvent.O['user'];
      if TLOUsers.S['@type'] = 'user' then
      Begin
        with ViewCtt.Items do
        begin
          if TLOUsers.S['first_name'] <> '' then
          begin
            { Add the root node }
            ContactTreeNode := AddChild(ContactListTreeNode,  TLOUsers.S['first_name']+' '+TLOUsers.S['last_name']);

            { Add child nodes }
            if TLOUsers.S['username'] <> '' then
              AddChild(ContactTreeNode,'UserName : '+TLOUsers.S['username']);
            if TLOUsers.S['phone_number'] <> '' then
              AddChild(ContactTreeNode,'Phone : '+TLOUsers.S['phone_number']);
            if TLOUsers.I['id'].ToString <> '' then
              AddChild(ContactTreeNode, 'ID : '+TLOUsers.I['id'].ToString);
          end
          else
            if TLOUsers.S['username'] <> '' then
            Begin
              { Add the root node }
              ContactTreeNode := AddChild(ContactListTreeNode, 'UserName : '+TLOUsers.S['username']);

              { Add child nodes }
              if TLOUsers.S['phone_number'] <> '' then
                AddChild(ContactTreeNode,'Phone : '+TLOUsers.S['phone_number']);
              if TLOUsers.I['id'].ToString <> '' then
                AddChild(ContactTreeNode, 'ID : '+TLOUsers.I['id'].ToString);
            End
            else
              if TLOUsers.I['id'].ToString <> '' then
              Begin
                { Add the root node }
                ContactTreeNode := AddChild(ContactListTreeNode, 'ID : '+TLOUsers.I['id'].ToString);

                { Add child nodes }
                if TLOUsers.S['phone_number'] <> '' then
                  AddChild(ContactTreeNode,'Phone : '+TLOUsers.S['phone_number']);
              End;

        end;
      End;
    End;
    {$ENDREGION 'getContacts'}

    {$REGION 'searchPublicChat'}
    //Return of searchPublicChat - OK....
    if TLOEvent.S['@type'] = 'chat' then
    Begin
      TLOChat := Nil;
      TLOChat := TLOEvent.Clone;
      with ViewCtt.Items do
      begin
        if TLOChat.S['title'] <> '' then
        Begin
          { Add the root node in group type }
          GroupTreeNode := AddChild(GroupListTreeNode,  TLOChat.S['title']);

          { Add child nodes in root node}
          if TLOChat.I['id'].ToString <> '' then
          AddChild(GroupTreeNode,'ID : '+TLOChat.I['id'].ToString);
        End
        Else
          if TLOChat.I['id'].ToString <> '' then
          Begin
            { Add the root node }
            GroupTreeNode := AddChild(GroupListTreeNode, TLOChat.I['id'].ToString);
            { Add child nodes }
            AddChild(GroupTreeNode,'ID : '+TLOChat.I['id'].ToString);
          End;
      End;
    End;
    {$ENDREGION 'searchPublicChat'}

    {$REGION 'updateNewMessage'}
    //Handling New incoming messages
    if TLOEvent.S['@type'] = 'updateNewMessage' then
    Begin
      TLOUpdateMessage := TLOEvent.O['message'];
      TLOContent :=  TLOUpdateMessage.O['content'];

      //If it's a text message
      if TLOContent.S['@type'] = 'messageText' then
      Begin

        TLOText := TLOContent.O['text'];

        if CurrentChatStr = TLOUpdateMessage.I['chat_id'].ToString then
        Begin
          if TLOMe.I['id'].ToString = TLOUpdateMessage.I['sender_user_id'].ToString then
            memChatMSG.Say(User2, TLOUpdateMessage.I['sender_user_id'].ToString, TLOText.S['text'])
          else
            memChatMSG.Say(User1, TLOUpdateMessage.I['sender_user_id'].ToString, TLOText.S['text']);
        End;
      End;
    end;
    {$ENDREGION 'updateNewMessage'}

    //# handle an incoming update or an answer to a previously sent request
    if TLOEvent.AsJSON() <> '' then
    Begin
      Result := 'RECEIVING : '+ TLOEvent.AsString;//ReturnStr;
    End;

  End
  Else
  //# destroy client when it is closed and isn't needed anymore
  Client_destroy(FClient);

  {$ENDREGION 'IMPLEMENTATION'}
end;

end.


