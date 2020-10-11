unit ChatControl;

{$ifdef fpc}
  {$H+}
  {.$mode objfpc}
  {$mode delphi}
{$endif}

interface

uses
  {$ifdef fpc}
    LResources,
    Windows, Messages, SysUtils, Classes,
    Controls, Graphics, ComCtrls, StdCtrls, LCLType
  {$else}
    WinApi.Windows, WinApi.Messages, System.SysUtils, System.Classes,
    Vcl.Controls, Vcl.Graphics, Vcl.StdCtrls
  {$endif};
type
  TUser = (User1 = 0, User2 = 1);

  TInjectChatControl = class(TCustomControl)
  private
    FColor1, FColor2: TColor;
    FStrings: TStringList;
    FTitle: TLabel;  //Add for Test use Title of message(Beta)
    FScrollPos: integer;
    FOldScrollPos: integer;
    FBottomPos: integer;
    FBoxTops: array of integer;
    FInvalidateCache: boolean;
    procedure StringsChanged(Sender: TObject);
    procedure SetColor1(Color1: TColor);
    procedure SetColor2(Color2: TColor);
    procedure SetStringList(Strings: TStringList);
    procedure ScrollPosUpdated;
    procedure InvalidateCache;
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Say(const User: TUser; const Title, S: String): Integer;
    procedure ScrollToBottom;
    {$ifdef fpc}
    property Canvas;
    {$endif}
  published
    property Align;
    property Anchors;
    {$ifndef fpc}
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property Ctl3D;
    property ImeMode;
    property ImeName;
    property ParentCtl3D;
    property Touch;
    property StyleElements;
    property StyleName;
    {$endif}
    property BiDiMode;
    property Color;
    property Color1: TColor read FColor1 write SetColor1 default clSkyBlue;
    property Color2: TColor read FColor2 write SetColor2 default clMoneyGreen;
    property Constraints;
    property Strings: TStringList read FStrings write SetStringList;
    {$ifdef fpc}
    property ControlStyle;
    {$endif}
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    {$ifndef fpc}
    property OnGesture;
    property OnMouseActivate;
    {$endif}
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

procedure Register;

implementation

uses Math;

procedure Register;
begin
  {$ifdef fpc}
    {$I TInjectChatControl.lrs}
  {$endif}
  RegisterComponents('InjectTelegram', [TInjectChatControl]);
end;

{ TInjectChatControl }

procedure TInjectChatControl.Click;
begin
  inherited;
  if CanFocus and TabStop then
    SetFocus;
end;

constructor TInjectChatControl.Create(AOwner: TComponent);
begin
  inherited;

  {$ifdef fpc}
    ControlStyle := [csOpaque];
  {$endif}

  DoubleBuffered := true;

  FScrollPos := 0;
  FBoxTops := nil;
  InvalidateCache;

  FStrings := TStringList.Create;
  FTitle := TLabel.Create(Nil);
  FStrings.OnChange := StringsChanged;
  FColor1 := clWhite;
  FColor2 := $00FDF6E0;
  Color := $00E3C578;
  {$ifdef fpc}
   Width := 400;
   Height:= 200;


   Canvas.Brush.Color := Color;
  {$endif}
  Font.Size := 10;

  FOldScrollPos := MaxInt;
end;

procedure TInjectChatControl.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style or WS_VSCROLL;
end;

destructor TInjectChatControl.Destroy;
begin
  FStrings.Free;
  inherited;
end;

function TInjectChatControl.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  dec(FScrollPos, WheelDelta);
  ScrollPosUpdated;
end;

procedure TInjectChatControl.InvalidateCache;
begin
  FInvalidateCache := true;
end;

procedure TInjectChatControl.Paint;
const
  Aligns: array[TUser] of integer = (DT_RIGHT, DT_LEFT);
var
  Colors: array[TUser] of TColor;
var
  User: TUser;
  i, y, MaxWidth, RectWidth: integer;
  r, r2: TRect;
  SI: {$ifdef fpc}SCROLLINFO{$else}TScrollInfo{$endif};
begin

  inherited;

  Colors[User1] := FColor1;
  Colors[User2] := FColor2;

  y := 10 - FScrollPos;
  MaxWidth := ClientWidth div 2;

  Canvas.Font.Assign(Font);

  if FInvalidateCache then
    SetLength(FBoxTops, FStrings.Count);

  for i := 0 to FStrings.Count - 1 do
  begin

    if FInvalidateCache then
      FBoxTops[i] := y + FScrollPos
    else
    begin
      if (i < (FStrings.Count - 1)) and (FBoxTops[i + 1] - FScrollPos < 0) then
        Continue;
      if FBoxTops[i] - FScrollPos > ClientHeight then
        Break;
      y := FBoxTops[i] - FScrollPos;
    end;

    User := TUser(FStrings.Objects[i]);

    Canvas.Brush.Color := Colors[User];
    Canvas.Pen.Width := 0;
    Canvas.Pen.Color := Colors[User];

    FTiTle.Font.Style := [fsBold];
    FTiTle.Font.Size := Font.Size;

    r := Rect(10, y, MaxWidth, 16);
    DrawText(Canvas.Handle,
      PChar(FTiTle.Caption+#10#13+FStrings[i]),
      Length(FTiTle.Caption+#10#13+FStrings[i]),
      r,
      Aligns[User] or DT_WORDBREAK or DT_CALCRECT);

    if User = User2 then
    begin
      RectWidth := r.Right - r.Left;
      r.Right := ClientWidth - 10;
      r.Left := r.Right - RectWidth;
    end;

    r2 := Rect(r.Left - 4, r.Top - 4, r.Right + 4, r.Bottom + 4);
    Canvas.RoundRect(r2, 5, 5);

    DrawText(Canvas.Handle,
      PChar(FTiTle.Caption+#10#13+FStrings[i]),
      Length(FTiTle.Caption+#10#13+FStrings[i]),
      r,
      Aligns[User] or DT_WORDBREAK);

    if FInvalidateCache then
    begin
      y := r.Bottom + 10;
      FBottomPos := y + FScrollPos;
    end;

  end;

  SI.cbSize := sizeof(SI);
  SI.fMask := SIF_ALL;
  SI.nMin := 0;
  SI.nMax := FBottomPos;
  SI.nPage := ClientHeight;
  SI.nPos := FScrollPos;
  SI.nTrackPos := SI.nPos;

  SetScrollInfo(Handle, SB_VERT, SI, true);

  if FInvalidateCache then
    ScrollToBottom;

  FInvalidateCache := false;

end;

procedure TInjectChatControl.Resize;
begin
  inherited;
  InvalidateCache;
  Invalidate;
end;

function TInjectChatControl.Say(const User: TUser; const Title, S: String): Integer;
begin
  FTitle.Caption := Title;
  ControlStyle := [csOpaque];
  result := FStrings.AddObject(S, TObject(User));
end;

procedure TInjectChatControl.ScrollToBottom;
begin
  Perform(WM_VSCROLL, SB_BOTTOM, 0);
end;

procedure TInjectChatControl.SetColor1(Color1: TColor);
begin
  if FColor1 <> Color1 then
  begin
    FColor1 := Color1;
    Invalidate;
  end;
end;

procedure TInjectChatControl.SetColor2(Color2: TColor);
begin
  if FColor2 <> Color2 then
  begin
    FColor2 := Color2;
    Invalidate;
  end;
end;

procedure TInjectChatControl.SetStringList(Strings: TStringList);
begin
  FStrings.Assign(Strings);
  InvalidateCache;
  Invalidate;
end;

procedure TInjectChatControl.StringsChanged(Sender: TObject);
begin
  InvalidateCache;
  Invalidate;
end;

procedure TInjectChatControl.WndProc(var Message: TMessage);
var
  SI: {$ifdef fpc}SCROLLINFO{$else}TScrollInfo{$endif};
begin
  inherited;
  case Message.Msg of
    WM_GETDLGCODE:
      Message.Result := Message.Result or DLGC_WANTARROWS;
    WM_KEYDOWN:
      case Message.wParam of
        VK_UP:
          Perform(WM_VSCROLL, SB_LINEUP, 0);
        VK_DOWN:
          Perform(WM_VSCROLL, SB_LINEDOWN, 0);
        VK_PRIOR:
          Perform(WM_VSCROLL, SB_PAGEUP, 0);
        VK_NEXT:
          Perform(WM_VSCROLL, SB_PAGEDOWN, 0);
        VK_HOME:
          Perform(WM_VSCROLL, SB_TOP, 0);
        VK_END:
          Perform(WM_VSCROLL, SB_BOTTOM, 0);
      end;
    WM_VSCROLL:
      begin
        case Message.WParamLo of
          SB_TOP:
            begin
              FScrollPos := 0;
              ScrollPosUpdated;
            end;
          SB_BOTTOM:
            begin
              FScrollPos := FBottomPos - ClientHeight;
              ScrollPosUpdated;
            end;
          SB_LINEUP:
            begin
              dec(FScrollPos);
              ScrollPosUpdated;
            end;
          SB_LINEDOWN:
            begin
              inc(FScrollPos);
              ScrollPosUpdated;
            end;
          SB_PAGEUP:
            begin
              dec(FScrollPos, ClientHeight);
              ScrollPosUpdated;
            end;
          SB_PAGEDOWN:
            begin
              inc(FScrollPos, ClientHeight);
              ScrollPosUpdated;
            end;
          SB_THUMBTRACK:
            begin
              ZeroMemory(@SI, sizeof(SI));
              SI.cbSize := sizeof(SI);
              SI.fMask := SIF_TRACKPOS;
              if GetScrollInfo(Handle, SB_VERT, SI) then
              begin
                FScrollPos := SI.nTrackPos;
                ScrollPosUpdated;
              end;
            end;
        end;
        Message.Result := 0;
      end;
  end;
end;

procedure TInjectChatControl.ScrollPosUpdated;
begin
  FScrollPos := EnsureRange(FScrollPos, 0, FBottomPos - ClientHeight);
  if FOldScrollPos <> FScrollPos then
    Invalidate;
  FOldScrollPos := FScrollPos;
end;

end.
