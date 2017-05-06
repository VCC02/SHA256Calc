{
Initial author: VCC
- 2017.05.05 -

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}

unit SHA256CalcMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DCPsha256, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TProcessHashThread = class(TThread)
  private
    FFileSize: Int64;
    FFilePosition: Int64;
    FFilename: TFilename;
    FHash: string;
  protected
    procedure Execute; override;
  end;

  { TfrmSHA256CalcMain }

  TfrmSHA256CalcMain = class(TForm)
    btnLoadFile: TButton;
    btnStop: TButton;
    chkDisplayAsLowerCase: TCheckBox;
    edtCredits: TEdit;
    lbeHash: TLabeledEdit;
    lbeFile: TLabeledEdit;
    OpenDialog1: TOpenDialog;
    prbShaProcessing: TProgressBar;
    tmrStartup: TTimer;
    tmrUpdateProgressBar: TTimer;
    procedure btnLoadFileClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure chkDisplayAsLowerCaseChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrStartupTimer(Sender: TObject);
    procedure tmrUpdateProgressBarTimer(Sender: TObject);
    procedure ThreadTerminated(Sender: TObject);
  private
    { private declarations }
    FProcessHashThread: TProcessHashThread;
  public
    { public declarations }
  end;

var
  frmSHA256CalcMain: TfrmSHA256CalcMain;

implementation

{$R *.lfm}

procedure TProcessHashThread.Execute;
var
  Sha256: TDCP_sha256;
  AFileStream: TFileStream;
  ADigest: array[0..31] of Byte;
  i: Integer;
begin
  try
    Sha256 := TDCP_sha256.Create(nil);
    try
      AFileStream := TFileStream.Create(FFileName, fmOpenRead);
      try
        Sha256.Burn;
        Sha256.Init;
        FFileSize := AFileStream.Size;
        AFileStream.Position := 0;
        repeat
          Sha256.UpdateStream(AFileStream, 8192);
          FFilePosition := AFileStream.Position;
        until (AFileStream.Position >= AFileStream.Size) or Terminated;
        Sha256.Final(ADigest);
      finally
        AFileStream.Free;
      end;

      FHash := '';
      if not Terminated then  //Leave an empty hash if manually terminated
        for i := 0 to 31 do
          FHash := FHash + IntToHex(ADigest[i], 2);
    finally
      Sha256.Free;
    end;
  except
  end;
end;

{ TfrmSHA256CalcMain }

procedure TfrmSHA256CalcMain.btnLoadFileClick(Sender: TObject);
begin
  if Sender = tmrStartup then
    OpenDialog1.FileName := ParamStr(1)
  else
    if not OpenDialog1.Execute then
      Exit;

  if FProcessHashThread <> nil then
    Exit;

  lbeFile.Text := OpenDialog1.FileName;

  FProcessHashThread := TProcessHashThread.Create(True);
  FProcessHashThread.FreeOnTerminate := False;
  FProcessHashThread.OnTerminate := @ThreadTerminated;
  FProcessHashThread.FFilename := OpenDialog1.FileName;
  btnLoadFile.Enabled := False;
  lbeHash.Text := '';
  prbShaProcessing.Visible := True;
  btnStop.Visible := True;
  tmrUpdateProgressBar.Enabled := True;

  FProcessHashThread.Start;
end;

procedure TfrmSHA256CalcMain.btnStopClick(Sender: TObject);
begin
  try
    FProcessHashThread.Terminate;
  except
  end;
end;

procedure TfrmSHA256CalcMain.chkDisplayAsLowerCaseChange(Sender: TObject);
begin
  if not chkDisplayAsLowerCase.Checked then
    lbeHash.Text := UpperCase(lbeHash.Text)
  else
    lbeHash.Text := LowerCase(lbeHash.Text);
end;

procedure TfrmSHA256CalcMain.FormCreate(Sender: TObject);
begin
  FProcessHashThread := nil;
  tmrStartup.Enabled := True;
end;

procedure TfrmSHA256CalcMain.tmrStartupTimer(Sender: TObject);
begin
  tmrStartup.Enabled := False;
  if ParamCount > 0 then
    if FileExists(ParamStr(1)) then
      btnLoadFileClick(tmrStartup);
end;

procedure TfrmSHA256CalcMain.ThreadTerminated(Sender: TObject);
begin
  tmrUpdateProgressBar.Enabled := False;
  btnLoadFile.Enabled := True;
  if chkDisplayAsLowerCase.Checked then
    lbeHash.Text := LowerCase(FProcessHashThread.FHash)
  else
    lbeHash.Text := FProcessHashThread.FHash;

  prbShaProcessing.Visible := False;
  btnStop.Visible := False;
  btnStop.Repaint;
  FreeAndNil(FProcessHashThread);
end;

procedure TfrmSHA256CalcMain.tmrUpdateProgressBarTimer(Sender: TObject);
begin
  if FProcessHashThread = nil then
    Exit;

  prbShaProcessing.Max := FProcessHashThread.FFileSize;
  prbShaProcessing.Position := FProcessHashThread.FFilePosition;
  prbShaProcessing.Repaint;
end;

end.

