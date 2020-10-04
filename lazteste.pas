unit LazTeste;

{$mode objfpc}
{$H+}
interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SynEdit, Dynlibs
  ,superobject;

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

type
  { TfrmLazteste }

  TfrmLazteste = class(TForm)
    btnCreateClient: TButton;
    btnCusca: TButton;
    btnDestroyClient: TButton;
    btnExecute: TButton;
    btnInit: TButton;
    btnSend: TButton;
    btnTestThread: TButton;
    btnStart: TButton;
    btnStop: TButton;
    btnLogVerbosy: TButton;
    Button9: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblNomeDLL: TLabel;
    memReceiver: TMemo;
    shStatus: TShape;
    txtAPI_ID: TEdit;
    txtAPI_HASH: TEdit;
    txtPhoneNumber: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    memSend: TMemo;
    procedure btnCreateClientClick(Sender: TObject);
    procedure btnCuscaClick(Sender: TObject);
    procedure btnDestroyClientClick(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure btnInitClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnLogVerbosyClick(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  public
    //Treatment of the necessary methods and functions
    function td_execute(JsonUTF8: String): String;
    function td_send(JsonUTF8: String): String;
    function td_receive: String;
    function DLLInitialize: Boolean;
    //# initialize TDLib log with desired parameters
    procedure on_fatal_error_callback(error_message: MyPCharType = '');
  end;

  //  fatal_error_callback_type = CFUNCTYPE(None, c_char_p)
  //
  //  td_set_log_fatal_error_callback = tdjson.td_set_log_fatal_error_callback
  //  td_set_log_fatal_error_callback.restype = None
  //  td_set_log_fatal_error_callback.argtypes = [fatal_error_callback_type]
  //
  //
  //  # initialize TDLib log with desired parameters
  //  def on_fatal_error_callback(error_message):
  //      print('TDLib fatal error: ', error_message)
  //
  //c_on_fatal_error_callback = fatal_error_callback_type(on_fatal_error_callback)
  //td_set_log_fatal_error_callback(c_on_fatal_error_callback)

  type
    //Internal delegate void Callback(IntPtr ptr);
    fatal_error_callback_type = procedure (error_message: MyPCharType);

  //type
    //c_on_fatal_error_callback = on_fatal_error_callback;
    //td_set_log_fatal_error_callback(c_on_fatal_error_callback)



  //Defining DLL methods and functions
  function client_create: MyPVoid; stdcall; external 'tdjson-x64.dll' name 'td_json_client_create';
  procedure client_destroy(handle: MyPVoid); stdcall; external 'tdjson-x64.dll' name 'td_json_client_destroy';
  procedure client_send(handle: MyPVoid; data : MyPCharType); stdcall; external 'tdjson-x64.dll' name 'td_json_client_send';
  function client_receive(handle: MyPVoid; t: double ): MyPCharType; stdcall; external 'tdjson-x64.dll' name 'td_json_client_receive';
  function client_execute(handle: MyPVoid; data : MyPCharType): MyPCharType; stdcall; external 'tdjson-x64.dll' name 'td_json_client_execute';
  procedure set_log_verbosity_level(level: Int32); stdcall; external 'tdjson-x64.dll' name 'td_json_client_set_log_verbosity_level';
  procedure set_log_fatal_error_callback(callback : fatal_error_callback_type); stdcall; external 'tdjson-x64.dll' name 'td_json_client_set_log_fatal_error_callback';



var
  frmLazteste: TfrmLazteste;

implementation

{$R *.lfm}

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
  //  def on_fatal_error_callback(error_message):
  //      print('TDLib fatal error: ', error_message)
  memReceiver.Lines.Add(error_message^);
end;

procedure TfrmLazteste.Button9Click(Sender: TObject);
begin
  FreeLibrary(tdjsonDll);
  tdjsonDll := 0;

  shStatus.Brush.Color := clYellow;
  if tdjsonDll <> 0 then
    shStatus.Brush.Color := clGreen
  else
    shStatus.Brush.Color := clRed;
end;

procedure TfrmLazteste.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if (Pointer(FClient) <> Nil) or (IntPtr(FClient) <> 0) then
   Begin
     client_destroy(FClient);
   End;
end;

procedure TfrmLazteste.btnInitClick(Sender: TObject);
begin
  shStatus.Brush.Color := clYellow;
  if DLLInitialize then
    shStatus.Brush.Color := clGreen
  else
    shStatus.Brush.Color := clRed;
end;

procedure TfrmLazteste.btnSendClick(Sender: TObject);
var
  JSonAnsiStr : AnsiString;
  X: ISuperObject;
begin
  if is_closed = 1 then
    Showmessage('No active service to send!')
  Else
  begin
    X := SO;
    X.S['@type'] := 'getAuthorizationState';
    X.D['@extra'] := 1.01234;

    JSonAnsiStr := X.AsJSon;

    memSend.Lines.Add('SENDING : '+X.AsJSon);
    memSend.Lines.Add('');

    td_send(JSonAnsiStr);
  end;
end;

procedure TfrmLazteste.btnStartClick(Sender: TObject);

  procedure Receiver;
  Begin
    while is_closed = 0 do
    Begin
       with frmLazteste do
         memReceiver.Lines.Add(td_receive);
    End;
  end;

begin

  if (Pointer(FClient) = Nil) or (IntPtr(FClient) = 0) then
  Begin
    Showmessage('Create a client to start the service');
  end
  Else
  Begin
    is_Closed := 0;

    if TThread.CreateAnonymousThread(TProcedure(@Receiver)).Finished then
      with TThread.CreateAnonymousThread(TProcedure(@Receiver)) do
        begin
          FreeOnTerminate := True;
          Start;
        end
    Else
      TThread.CreateAnonymousThread(TProcedure(@Receiver)).Terminate;


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
  if (Pointer(FClient) <> Nil) or (IntPtr(FClient) <> 0) then
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

    with memSend.Lines do
    Begin
      Add('Name : '+client_session.Name);
      Add('ID : '+client_session.ID.ToString);
      Add('*******Section Finished********');
    end;
  End
  Else
    Showmessage('No Client Created to Destroy!');
end;

procedure TfrmLazteste.btnExecuteClick(Sender: TObject);
var
  JSOnAnsiStr: AnsiString;
  X, A: ISuperObject;
begin
  A := TSuperObject.Create(stArray);
  A.S['@extra'] := '5';
  A.D['@extra'] := 7.0;

  X := TSuperObject.Create(stObject);
  X.S['@type'] := 'getTextEntities';
  X.S['text']  := '@telegram /test_command https://telegram.org telegram.me';
  X['@extra'] := A;

  JSOnAnsiStr := X.AsJson;

  memSend.Lines.Add('SENDING... '+JSOnAnsiStr);
  memSend.Lines.Add('');

  memReceiver.Lines.Add('RECEIVING... '+td_execute(JSOnAnsiStr));
  memReceiver.Lines.Add('');

end;

procedure TfrmLazteste.btnCreateClientClick(Sender: TObject);
begin

  if (Pointer(FClient) = Nil) or (IntPtr(FClient) = 0) then
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

procedure TfrmLazteste.btnLogVerbosyClick(Sender: TObject);
var
  JSonAnsiStr: AnsiString;
  X: ISuperObject;
begin
  //set_log_fatal_error_callback(on_fatal_error_callback);

  //# setting TDLib log verbosity level to 1 (errors)
  X := SO;
  X.S['@type'] := 'setLogVerbosityLevel';
  X.I['new_verbosity_level'] := 1;
  X.D['@extra'] := 1.01234;

  //Convert String to AnsiString Type
  JSonAnsiStr := X.AsJSon;

  memSend.Lines.Add('SENDING : '+X.AsJSon);
  memSend.Lines.Add('');

  memReceiver.Lines.Add('RECEIVING : '+td_execute(JSonAnsiStr));
  memReceiver.Lines.Add('');

end;

procedure TfrmLazteste.FormCreate(Sender: TObject);
begin
  shStatus.Brush.Color := clYellow;
  if DLLInitialize then
    shStatus.Brush.Color := clGreen
  else
    shStatus.Brush.Color := clRed;

  lblNomeDLL.Caption := tdjsonDllName;
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
  ReturnStr, SDebug:  String;
  X, XParam, TLAuthState, TLEvent: ISuperObject;
  JsonAnsiStr: AnsiString;
begin
{$REGION 'IMPLEMENTATION'}
  ReturnStr := client_receive(FClient, WAIT_TIMEOUT);

  TLEvent := SO(ReturnStr);

  if TLEvent <> NIl then
  Begin
    {$IFDEF DEBUG}
      SDebug := TLEvent.AsJSON;
    {$ENDIF}

    //# process authorization states
    if TLEvent.S['@type'] = 'updateAuthorizationState' then
    Begin
      TLAuthState := TLEvent.O['authorization_state'];

      //# if client is closed, we need to destroy it and create new client
      if TLAuthState.S['@type'] = 'authorizationStateClosed' then
        Exit;

      //# set TDLib parameters
      //# you MUST obtain your own api_id and api_hash at https://my.telegram.org
      //# and use them in the setTdlibParameters call
      if TLAuthState.S['@type'] = 'authorizationStateWaitTdlibParameters' then
      Begin
        X := nil;
        X := SO;
        X.S['@type'] := 'setTdlibParameters';
        X.O['parameters'] := SO;
        XParam := X.O['parameters'];
          XParam.B['use_test_dc'] := False;
          XParam.S['database_directory'] := 'tdlib';
          XParam.S['files_directory'] := 'myfiles';
          XParam.B['use_file_database'] := True;
          XParam.B['use_chat_info_database'] := True;
          XParam.B['use_message_database'] := True;
          XParam.B['use_secret_chats'] := true;

          JsonAnsiStr := '';
          JsonAnsiStr := txtAPI_ID.Text;
          XParam.I['api_id'] := StrToInt(JsonAnsiStr);

          JsonAnsiStr := '';
          JsonAnsiStr := txtAPI_HASH.Text;
          XParam.S['api_hash'] := JsonAnsiStr;

          XParam.S['system_language_code'] := 'pt';
          XParam.S['device_model'] := 'TInjectTDLibTelegram';
          {$IFDEF WIN32}
            XParam.S['system_version'] := 'WIN32';
          {$ENDIF}
          {$IFDEF WIN64}
            XParam.S['system_version'] := 'WIN64';
          {$ENDIF}
          XParam.S['application_version'] := '1.0';
          XParam.B['enable_storage_optimizer'] := True;
          XParam.B['ignore_file_names'] := False;

        //Send Request
        ReturnStr := td_send(X.AsJSON);
      End;

      //# set an encryption key for database to let know TDLib how to open the database
      if TLAuthState.S['@type'] = 'authorizationStateWaitEncryptionKey' then
      Begin
        X := nil;
        X := SO;
        X.S['@type'] := 'checkDatabaseEncryptionKey';
        X.S['encryption_key'] := '';

        //Send Request
        ReturnStr := td_send(X.AsJSON);
      End;

      //# enter phone number to log in
      if TLAuthState.S['@type'] = 'authorizationStateWaitPhoneNumber' then
      Begin
        //Clear Variable
        JsonAnsiStr:='';

        //Convert String to AnsiString Type
        JsonAnsiStr := txtPhoneNumber.Text;

        X := nil;
        X := SO;
        X.S['@type'] := 'setAuthenticationPhoneNumber';
        X.S['phone_number'] := JsonAnsiStr;

        //Send Request
        ReturnStr := td_send(X.AsJSON);
      End;

      //# wait for authorization code
      if TLAuthState.S['@type'] = 'authorizationStateWaitCode' then
      Begin
        //Clear Variable
        JsonAnsiStr:='';

        //Convert String to AnsiString Type
        JsonAnsiStr := InputBox('User Authorization', 'Enter the authorization code', '');

        X := nil;
        X := SO;
        X.S['@type'] := 'checkAuthenticationCode';
        X.S['code'] := JsonAnsiStr;

        //Send Request
        ReturnStr := td_send(X.AsJSON);
      End;

      //# wait for first and last name for new users
      if TLAuthState.S['@type'] = 'authorizationStateWaitRegistration' then
      Begin
        X := nil;
        X := SO;
        X.S['@type'] := 'registerUser';
        X.S['first_name'] := 'Ruan Diego';
        X.S['last_name'] := 'Lacerda Menezes';

        //send request
        ReturnStr := td_send(X.AsJSON);
      End;

      //# wait for password if present
      if TLAuthState.S['@type'] = 'authorizationStateWaitPassword' then
      Begin
        //Clear Variable
        JsonAnsiStr := '';

        //Convert String to AnsiString Type
        JsonAnsiStr := InputBox('Autenticação de Usuário', 'Informe o código de acesso', '');

        X := nil;
        X := SO;
        X.S['@type'] := 'checkAuthenticationPassword';
        X.S['password'] := JsonAnsiStr;

        //Send Request
        ReturnStr := td_send(X.AsJSON);
      End;

    End;

    if TLEvent.S['@type'] = 'error' then
    Begin
      //if an error is found, stop the process
      if is_Closed = 0 then
         is_Closed := 1
      else
          is_Closed := 0;

      Showmessage('An error was found:'+ #10#13 +
                  'code : ' + TLEvent.S['code'] + #10#13 +
                  'message : '+TLEvent.S['message']);
    end;

    //# handle an incoming update or an answer to a previously sent request
    if TLEvent.AsJSON() <> '' then
    Begin
      Result := 'RECEIVING : '+ TLEvent.AsString;//ReturnStr;
    End;

  End
  Else
  //# destroy client when it is closed and isn't needed anymore
  Client_destroy(FClient);

  {$ENDREGION 'IMPLEMENTATION'}
end;

end.


