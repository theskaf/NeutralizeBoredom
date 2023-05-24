unit TabbedTemplate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.TabControl,
  FMX.StdCtrls, FMX.Gestures, FMX.Controls.Presentation, FMX.Edit, FMX.EditBox,
  FMX.NumberBox, FMX.ListBox, FMX.Colors,
  Androidapi.Helpers,
  Androidapi.JNI.Net,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.App,
  IdHTTP,
  System.JSON, // JSON.net;
  System.Net.HttpClient,
  System.Net.HttpClient.Android,
  System.NetEncoding,
  System.Generics.Collections, FMX.Layouts, FMX.Memo.Types, FMX.ScrollBox,
  System.Notification,
  FMX.Styles.Objects,
  FMX.Objects,
  FMX.Memo;

type
  TTabbedForm = class(TForm)
    HeaderToolBar: TToolBar;
    ToolBarLabel: TLabel;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    GestureManager1: TGestureManager;
    Panel2: TPanel;
    grpbSelLang: TGroupBox;
    rbEnglish: TRadioButton;
    rbGreek: TRadioButton;
    grpbChoices: TGroupBox;
    Panel2a: TPanel;
    lblParticipants: TLabel;
    Panel2b: TPanel;
    lblAccessibility: TLabel;
    cbAccessibility: TComboBox;
    Panel2c: TPanel;
    Panel3: TPanel;
    Button1: TButton;
    lblType: TLabel;
    cbType: TComboBox;
    cbParticipants: TComboBox;
    edtResponse: TEdit;
    Label1: TLabel;
    lblCost: TLabel;
    edtLabel: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblParts: TLabel;
    lblCCssblt: TLabel;
    lblTp: TLabel;
    Layout1: TLayout;
    Button3: TButton;
    Button2: TButton;
    Memo1: TMemo;
    ImageControl1: TImageControl;
    StyleBook1: TStyleBook;
    NotificationCenter1: TNotificationCenter;
    procedure FormCreate(Sender: TObject);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure rbGreekChange(Sender: TObject);
    procedure rbEnglishChange(Sender: TObject);
    procedure cbAccessibilityClick(Sender: TObject);
    procedure cbParticipantsClick(Sender: TObject);
    procedure cbTypeClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure edtLabelClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure edtResponseClick(Sender: TObject);
    procedure Memo1ApplyStyleLookup(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure ImageControl1Click(Sender: TObject);

  private
    strErrorMsgEng, strErrorMsgGr: string;

    Activity: string;
    ActivityType: string;
    Participants: Integer;
    //Price: Double;
    //Accessibility: Double;
    Error: string;
    Link: string;

    AniIndicator: TAniIndicator;
    Timer: TTimer;

    const
      TranslationUrl = 'https://translate.googleapis.com/translate_a/single';

    procedure TranWhenRBClicked;
    function CheatTranslateStuffToSpecificLang(strTwoLetterLang, strInput: string): string;
    procedure BlueDaBaDeeDaBaDiTimer(Sender: TObject);
    procedure AlterMemoAndImage;
    //procedure TransationNotifyComplete;
  public

  end;

var
  TabbedForm: TTabbedForm;

implementation

{$R *.fmx}


procedure TTabbedForm.Button1Click(Sender: TObject);
var
  IdHTTP: TIdHTTP;
  Response: string;
  JsonObject: TJSONObject;
  strFullGet: string;
  //r: TRectangle;
  varPrice, varAccessibility: Variant;
begin
  edtResponse.Text := EmptyStr;
  lblCost.Text := EmptyStr;
  lblParts.Text := EmptyStr;
  lblCCssblt.Text := EmptyStr;
  lblTp.Text := EmptyStr;
  edtLabel.Text := EmptyStr;

  //r := (Button1.FindStyleResource('background') as TRectangle);
  //if Assigned(r) then
  //begin
  //  r.Fill.Color := System.UITypes.TAlphaColorRec.Blue; // claBlue;
  //end;
  //TODO - Not working:
  //Button1.TintColor := System.UITypes.TAlphaColorRec.Blue;

  IdHTTP := TIdHTTP.Create(nil);
  try
    strFullGet := 'http://www.boredapi.com/api/activity/?';  //?

    if cbType.ItemIndex > 0 then
    begin
      case cbType.ItemIndex of
        1: strFullGet := strFullGet + '&type=education';
        2: strFullGet := strFullGet + '&type=recreational';
        3: strFullGet := strFullGet + '&type=social';
        4: strFullGet := strFullGet + '&type=diy';
        5: strFullGet := strFullGet + '&type=charity';
        6: strFullGet := strFullGet + '&type=cooking';
        7: strFullGet := strFullGet + '&type=relaxation';
        8: strFullGet := strFullGet + '&type=music';
        9: strFullGet := strFullGet + '&type=busywork';
      end;

    end;
    if cbParticipants.ItemIndex > 0 then
    begin
      case cbParticipants.ItemIndex of
       1..5: strFullGet := strFullGet + '&participants=' + IntToStr(cbParticipants.ItemIndex);
       6: strFullGet := strFullGet + '&participants=8';
      end;
    end;
    if cbAccessibility.ItemIndex > 0 then
    begin
      case cbAccessibility.ItemIndex of
        1: strFullGet := strFullGet + '&minaccessibility=0&maxaccessibility=0.1';
        2: strFullGet := strFullGet + '&minaccessibility=0.1&maxaccessibility=0.2';
        3: strFullGet := strFullGet + '&minaccessibility=0.2&maxaccessibility=0.3';
        4: strFullGet := strFullGet + '&minaccessibility=0.3&maxaccessibility=0.4';
        5: strFullGet := strFullGet + '&minaccessibility=0.4&maxaccessibility=0.5';
        6: strFullGet := strFullGet + '&minaccessibility=0.5&maxaccessibility=0.6';
        7: strFullGet := strFullGet + '&minaccessibility=0.6&maxaccessibility=0.7';
        8: strFullGet := strFullGet + '&minaccessibility=0.7&maxaccessibility=0.8';
        9: strFullGet := strFullGet + '&minaccessibility=0.8&maxaccessibility=0.9';
        10: strFullGet := strFullGet + '&minaccessibility=0.9&maxaccessibility=1.0';
        11: strFullGet := strFullGet + '&accessibility=1.0';
      end;
    end;

    Response := IdHTTP.Get(strFullGet);  // Response := IdHTTP.Get('http://www.boredapi.com/api/activity/'); --- Use the 'Response' variable to handle the response data as needed
    JsonObject := TJSONObject.ParseJSONValue(Response) as TJSONObject;
    try
      if JsonObject.TryGetValue('error', Error) then  // Check if the response contains an error field
      begin
        if ((rbEnglish.IsChecked) or (not rbGreek.IsChecked)) then
          edtResponse.Text := Error
        else
          edtResponse.Text := 'Δεν βρέθηκε δραστηριότητα με τις καθορισμένες παραμέτρους - επιλογές.';

        Activity := EmptyStr;
        //Price := -1.0;
        Link := EmptyStr;

        Exit;   //If so, you know what to do
      end;


      try
        // Extract the desired information from the JSON object :
        Activity := JsonObject.GetValue('activity').Value;
        //Price := JsonObject.GetValue('price').Value.ToDouble;
        varPrice := JsonObject.GetValue('price').Value;
        Link := JsonObject.GetValue('link').Value;
        ActivityType := JsonObject.GetValue('type').Value;
        Participants := JsonObject.GetValue('participants').Value.ToInteger;
        //Accessibility := JsonObject.GetValue('accessibility').Value.ToDouble;
        varAccessibility := JsonObject.GetValue('accessibility').Value;
      except
        on e: Exception do
        begin
          ShowMessage('Accessibility ' + VarToStr(varAccessibility) + ' Participants ' + Participants.ToString + ' Price ' + VarToStr(varPrice) + ' Activity ' + Activity + ' ActivityType ' + ActivityType + ' Link ' + Link + '  -  Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message);
          //ShowMessage('Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message);
        end;
      end;

      if VarIsNull(varPrice) then
        varPrice := '0'
      else
        varPrice := VarToStr(varPrice);

      if VarIsNull(varAccessibility) then
        varAccessibility := '0'
      else
        varAccessibility := VarToStr(varAccessibility);

      lblCost.Text := varPrice; //Price.ToString + ' %';
      edtLabel.Text := Trim(Link);
      //Accessibility := 100 * Accessibility;


      if ((rbEnglish.IsChecked) or (not rbGreek.IsChecked)) then
      begin
        edtResponse.Text := Activity;
        lblTp.Text := ActivityType;
      end
      else
      begin
        edtResponse.Text := CheatTranslateStuffToSpecificLang('el', Activity);

        //strLengthTemp := CheatTranslateStuffToSpecificLang('el', Activity);      //
        //sIngleLengthTemp := edtResponse.TextSettings.Font.Size;                  //
        //intLengthTemp := Round(sIngleLengthTemp);                                //

        //if Length(strLengthTemp) > 35 then                                       //
        //begin                                                                    //
        //  intLengthTemp := intLengthTemp - 1;                                    //
        //  sIngleLengthTemp := intLengthTemp;                                     //

        //  edtResponse.TextSettings.Font.Size := sIngleLengthTemp;                //
        //end                                                                      //
        //else                                                                     //
        //begin                                                                    //
        //  edtResponse.TextSettings.Font.Size := sIngleLengthTemp;                //
        //end;                                                                     //
        //edtResponse.Text := strLengthTemp;                                       //

        lblTp.Text := CheatTranslateStuffToSpecificLang('el', ActivityType);
      end;

      //r := (Button1.FindStyleResource('background') as TRectangle);
      //if Assigned(r) then
      //begin
      //  r.Fill.Color := System.UITypes.TAlphaColorRec.Teal;
      //end;
      //TODO - Not working:
      //Button1.TintColor := System.UITypes.TAlphaColorRec.Teal;


      lblParts.Text := IntToStr(Participants);
      lblCCssblt.Text := varAccessibility; //Accessibility.ToString + ' %';
    finally
      JsonObject.Free;
    end;
  finally
    IdHTTP.Free;
  end;
end;



procedure TTabbedForm.Button2Click(Sender: TObject);
begin
  TabControl1.ActiveTab := TabControl1.Tabs[1];
end;

procedure TTabbedForm.Button3Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TTabbedForm.cbAccessibilityClick(Sender: TObject);
begin
  try
    cbAccessibility.Items.Clear;

    if ((rbEnglish.IsChecked) or (not rbGreek.IsChecked)) then
    begin
      cbAccessibility.Items.Add('Any');
      cbAccessibility.Items.Add('Extremely easy');
      cbAccessibility.Items.Add('Very easy');
      cbAccessibility.Items.Add('Easy');
      cbAccessibility.Items.Add('Moderately easy');
      cbAccessibility.Items.Add('Somewhat easy');
      cbAccessibility.Items.Add('Moderate');
      cbAccessibility.Items.Add('Moderately hard');
      cbAccessibility.Items.Add('Hard');
      cbAccessibility.Items.Add('Very hard');
      cbAccessibility.Items.Add('Extremely hard');
      cbAccessibility.Items.Add('Extremely difficult');
    end
    else
    begin
      cbAccessibility.Items.Add('Αδιάφορη');
      cbAccessibility.Items.Add('Εξαιρετικά εύκολη');
      cbAccessibility.Items.Add('Πολύ εύκολη');
      cbAccessibility.Items.Add('Εύκολη');
      cbAccessibility.Items.Add('Μέτρια εύκολη');
      cbAccessibility.Items.Add('Κάπως εύκολη');
      cbAccessibility.Items.Add('Μέτρια');
      cbAccessibility.Items.Add('Μέτρια σκληρή');
      cbAccessibility.Items.Add('Σκληρή');
      cbAccessibility.Items.Add('Πολύ δύσκολη');
      cbAccessibility.Items.Add('Εξαιρετικά δύσκολη');
      cbAccessibility.Items.Add('Απίστευτα δύσκολη');
    end;
    //cbAccessibility.ItemIndex := 0;
    edtResponse.Text := EmptyStr;
    lblCost.Text := EmptyStr;
    lblParts.Text := EmptyStr;
    lblCCssblt.Text := EmptyStr;
    lblTp.Text := EmptyStr;
    edtLabel.Text := EmptyStr;
  except
    on e: Exception do
    begin
      if ((rbEnglish.IsChecked) or (not rbGreek.IsChecked)) then
        ShowMessage(strErrorMsgEng + 'Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message)
      else
        ShowMessage(strErrorMsgGr + 'Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message);
    end;
  end;
end;



procedure TTabbedForm.cbParticipantsClick(Sender: TObject);
begin
  try
    cbParticipants.Items.Clear;

    if ((rbEnglish.IsChecked) or (not rbGreek.IsChecked)) then
    begin
      cbParticipants.Items.Add('Any');
    end
    else
    begin
      cbParticipants.Items.Add('Αδιάφορo');
    end;
    cbParticipants.Items.Add('1');
    cbParticipants.Items.Add('2');
    cbParticipants.Items.Add('3');
    cbParticipants.Items.Add('4');
    cbParticipants.Items.Add('5');
    cbParticipants.Items.Add('8');

    edtResponse.Text := EmptyStr;
    lblCost.Text := EmptyStr;
    lblParts.Text := EmptyStr;
    lblCCssblt.Text := EmptyStr;
    lblTp.Text := EmptyStr;
    edtLabel.Text := EmptyStr;
  except
    on e: Exception do
    begin
      if ((rbEnglish.IsChecked) or (not rbGreek.IsChecked)) then
        ShowMessage(strErrorMsgEng + 'Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message)
      else
        ShowMessage(strErrorMsgGr + 'Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message);
    end;
  end;
end;



procedure TTabbedForm.cbTypeClick(Sender: TObject);
begin
  try
    cbType.Items.Clear;

    if ((rbEnglish.IsChecked) or (not rbGreek.IsChecked)) then
    begin
      cbType.Items.Add('Any');
      cbType.Items.Add('Education');
      cbType.Items.Add('Recreational');
      cbType.Items.Add('Social');
      cbType.Items.Add('DIY');
      cbType.Items.Add('Charity');
      cbType.Items.Add('Cooking');
      cbType.Items.Add('Relaxation');
      cbType.Items.Add('Music');
      cbType.Items.Add('Busywork');
    end
    else
    begin
      cbType.Items.Add('Αδιάφορo');
      cbType.Items.Add('Εκπαίδευση');
      cbType.Items.Add('Ψυχαγωγία');
      cbType.Items.Add('Κοινωνικό');
      cbType.Items.Add('Κάντο Μόνος σου');
      cbType.Items.Add('Φιλανθρωπία');
      cbType.Items.Add('Μαγείρεμα');
      cbType.Items.Add('Χαλάρωση');
      cbType.Items.Add('Μουσική');
      cbType.Items.Add('Πολυάσχολο');
    end;
    edtResponse.Text := EmptyStr;
    lblCost.Text := EmptyStr;
    lblParts.Text := EmptyStr;
    lblCCssblt.Text := EmptyStr;
    lblTp.Text := EmptyStr;
    edtLabel.Text := EmptyStr;
  except
    on e: Exception do
    begin
      if ((rbEnglish.IsChecked) or (not rbGreek.IsChecked)) then
        ShowMessage(strErrorMsgEng + 'Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message)
      else
        ShowMessage(strErrorMsgGr + 'Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message);
    end;
  end;
end;



procedure TTabbedForm.FormCreate(Sender: TObject);
begin
  { This defines the default active tab at runtime }
  TabControl1.ActiveTab := TabItem1;
  rbEnglish.IsChecked := True;
  strErrorMsgEng := 'Something went wrong. ';
  strErrorMsgGr := 'Κάτι πήγε στραβά. ';

  Activity := EmptyStr;
  ActivityType := EmptyStr;
  Participants := 0;
  //Price := -1.0;
  //Accessibility := -1.0;
  Error := EmptyStr;
  Link := EmptyStr;

  Timer := TTimer.Create(Self);
  Timer.Interval := 5000;
  Timer.OnTimer := BlueDaBaDeeDaBaDiTimer; //TimerTimer;
end;

procedure TTabbedForm.FormDestroy(Sender: TObject);
begin
  Timer.Free;
end;

procedure TTabbedForm.FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
{$IFDEF ANDROID}
  case EventInfo.GestureID of
    sgiLeft:
    begin
      if TabControl1.ActiveTab <> TabControl1.Tabs[TabControl1.TabCount-1] then
        TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex+1];
      Handled := True;
    end;

    sgiRight:
    begin
      if TabControl1.ActiveTab <> TabControl1.Tabs[0] then
        TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex-1];
      Handled := True;
    end;
  end;
{$ENDIF}
end;

procedure TTabbedForm.BlueDaBaDeeDaBaDiTimer(Sender: TObject); // Perform actions after the specified interval
begin
  ImageControl1.Visible := True;  //Layout2.Visible := True;
  Memo1.Visible := False;
  Timer.Enabled := False;
end;

procedure TTabbedForm.FormShow(Sender: TObject);    // Perform actions like showing/hiding images
begin
  Timer.Enabled := True;
  ImageControl1.Visible := False;
  Memo1.Visible := True;
end;

procedure TTabbedForm.Memo1ApplyStyleLookup(Sender: TObject);
var
  Obj: TFmxObject;
begin
  Obj := Memo1.FindStyleResource('background');

  if Assigned(Obj) and ( Obj is TActiveStyleObject ) then
    TActiveStyleObject(Obj).Source := nil;
end;



procedure TTabbedForm.ImageControl1Click(Sender: TObject);
begin
  AlterMemoAndImage;
end;

procedure TTabbedForm.Memo1Click(Sender: TObject);
begin
  AlterMemoAndImage;
end;

procedure TTabbedForm.AlterMemoAndImage;
begin
  if ((ImageControl1.Visible = True) or (Memo1.Visible = False)) then
  begin
    ImageControl1.Visible := False;
    Memo1.Visible := True;
  end
  else
  if ((ImageControl1.Visible = False) or (Memo1.Visible = True)) then
  begin
    ImageControl1.Visible := True;
    Memo1.Visible := False;
  end;
end;



procedure TTabbedForm.edtLabelClick(Sender: TObject);
var
  Intent: JIntent;
  Uri: Jnet_Uri;
  RequestCode: Integer;
begin
  //  //SharedActivityContext.startActivity(TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW, TJnet_Uri.JavaClass.parse(StringToJString(  Trim( lblLink.Text )  ))));
  //  //TAndroidHelper.Context.startActivity(TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW, TJnet_Uri.JavaClass.parse(StringToJString(  Trim( lblLink.Text )  ))));
  Uri := TJnet_Uri.JavaClass.parse(StringToJString(Trim(edtLabel.Text)));
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setData(Uri);
  RequestCode := 0; // You can set an appropriate request code here if needed
  TAndroidHelper.Activity.startActivityForResult(Intent, RequestCode);
end;



procedure TTabbedForm.edtResponseClick(Sender: TObject);
begin
  ShowMessage(edtResponse.Text);
end;

procedure TTabbedForm.rbEnglishChange(Sender: TObject);
begin
  TranWhenRBClicked;
end;

procedure TTabbedForm.rbGreekChange(Sender: TObject);
begin
  TranWhenRBClicked;
end;



procedure TTabbedForm.TranWhenRBClicked;
begin
  cbAccessibility.Items.Clear;
  cbType.Items.Clear;
  cbParticipants.Items.Clear;
  edtResponse.Text := EmptyStr;
  lblCost.Text := EmptyStr;
  lblParts.Text := EmptyStr;
  lblCCssblt.Text := EmptyStr;
  lblTp.Text := EmptyStr;
  edtLabel.Text := EmptyStr;

  if ((rbEnglish.IsChecked) or (not rbGreek.IsChecked)) then
  begin
    ToolBarLabel.Text := 'Boredom Neutralization';
    TabItem1.Text := 'About';
    TabItem2.Text := 'Main';

    grpbSelLang.Text := ' Select language ';
    rbEnglish.Text := 'English';
    rbGreek.Text := 'Ελληνικά';

    grpbChoices.Text := ' Choices (not mandatory) ';

    lblParticipants.Text := 'Participants';
    lblAccessibility.Text := 'Difficulty';
    lblType.Text := 'Type';

    Button1.Text := 'Find Activity';
    Button3.Text := 'Exit';

    Label1.Text := 'Price/Cost';
    Label2.Text := 'Participants';
    Label3.Text := 'Difficulty';
    Label4.Text := 'Type';
  end
  else
  begin
    ToolBarLabel.Text := 'Καταπολέμηση Ανίας';
    TabItem1.Text := 'Περί';
    TabItem2.Text := 'Κυρίως';

    grpbSelLang.Text := ' Επιλογή γλώσσας ';
    rbEnglish.Text := 'English';
    rbGreek.Text := 'Ελληνικά';

    grpbChoices.Text := ' Επιλογές (όχι υποχρεωτικές) ';

    lblParticipants.Text := 'Συμμετέχοντες';
    lblAccessibility.Text := 'Δυσκολία';
    lblType.Text := 'Είδος';

    Button1.Text := 'Αναζήτηση Δραστηριότητας';
    Button3.Text := 'Κλείσιμο';

    Label1.Text := 'Κόστος';
    Label2.Text := 'Συμμετέχοντες';
    Label3.Text := 'Δυσκολία';
    Label4.Text := 'Είδος';
  end;
end;



function TTabbedForm.CheatTranslateStuffToSpecificLang(strTwoLetterLang, strInput: string): string;
var
  SourceText, SourceLang, TargetLang, TranslatedText: string;
  HttpClient: THTTPClient;
  Url, ResultJson: string;
  ResultArray, TranslationArray, SubArray: TJSONArray;
  TranslationValue: TJSONValue;
begin
  TranslatedText := EmptyStr;

  SourceText := strInput.Trim;
  SourceLang := 'auto';
  TargetLang := strTwoLetterLang;

  //TODO - Not working:
  //AniIndicator := TAniIndicator.Create(Self);
  //AniIndicator.Parent := Panel3; //Self; // Set the parent control or form
  //AniIndicator.Enabled := True;
  //AniIndicator.BringToFront;
  //AniIndicator.Align := TAlignLayout.Center; // Set the alignment
  //AniIndicator.Visible := True; // Show the control

  // Option 1: Use LanguageApp.translate = Would need to implement the translation logic using the appropriate translation library or service  =  $$$
  // Option 2: Use URL fetch and JSON parsing :
  HttpClient := THTTPClient.Create;
  try
    Url := Format('%s?client=gtx&sl=%s&tl=%s&dt=t&q=%s', [TranslationUrl, SourceLang, TargetLang, TNetEncoding.URL.EncodeQuery(SourceText)]);
    ResultJson := HttpClient.Get(Url).ContentAsString;

    ResultArray := TJSONArray(TJSONObject.ParseJSONValue(ResultJson));
    if (ResultArray <> nil) and (ResultArray.Count > 0) then
    begin
      TranslationArray := ResultArray.Items[0].GetValue<TJSONArray>;
      if (TranslationArray <> nil) and (TranslationArray.Count > 0) then
      begin
        SubArray := TranslationArray.Items[0].GetValue<TJSONArray>;
        if (SubArray <> nil) and (SubArray.Count > 0) then
        begin
          TranslationValue := SubArray.Items[0];
          if TranslationValue is TJSONString then
            TranslatedText := TJSONString(TranslationValue).Value;
        end;
      end;
    end;
  finally
    HttpClient.Free;
    //TODO - Not working:
    //AniIndicator.Visible := False; // Hide the control
    //AniIndicator.Parent := nil; // Remove the control from its parent
    //FreeAndNil(AniIndicator); // Free the control and release its memory
  end;

  Result := TranslatedText;
end;

(*
procedure TTabbedForm.TransationNotifyComplete;  //On a second thought, avoiding spam
var
  Notification: TNotification;
begin

  if NotificationCenter1.Supported then  { verify if the service is actually supported }
  begin
    Notification := NotificationCenter1.CreateNotification;
    Notification.Name := 'Background Chk';
    Notification.AlertBody := 'Translation Completed';
    Notification.FireDate := Now;
    NotificationCenter1.ScheduleNotification(Notification);  { Send notification in Notification Center }
  end
end;
*)




end.
