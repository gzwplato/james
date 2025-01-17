{
  MIT License

  Copyright (c) 2017-2019 Marcos Douglas B. Santos

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
}
unit JamesBase64Adapters;

{$i James.inc}

interface

uses
  Classes,
  SysUtils,
  SynCommons,
  JamesDataBase,
  JamesDataCore;

type
  /// Base64 coded action
  TBase64Action = (baEncode, baDecode);

  /// object to adapt a Base64 text into other types
  TBase64Adapter = {$ifdef UNICODE}record{$else}object{$endif}
  private
    fAction: TBase64Action;
    fText: RawByteString;
    function AsCoded: RawByteString;
  public
    /// initialize the instance
    // - the action will determinate if the origin will be encoded or decoded for in adapter methods
    procedure Init(aAction: TBase64Action; const aText: RawByteString);
    /// return as RawByteString
    function AsRawByteString: RawByteString;
    /// return as DataStream
    function AsDataStream: IDataStream;
  end;

implementation

{ TBase64Adapter }

function TBase64Adapter.AsCoded: RawByteString;
begin
  case fAction of
    baEncode: result := BinToBase64(fText);
    baDecode: result := Base64ToBin(fText);
  else
    result := '';
  end;
end;

procedure TBase64Adapter.Init(aAction: TBase64Action; const aText: RawByteString);
begin
  fAction := aAction;
  fText := aText;
end;

function TBase64Adapter.AsRawByteString: RawByteString;
begin
  result := AsCoded;
end;

function TBase64Adapter.AsDataStream: IDataStream;
var
  m: TStream;
begin
  m := RawByteStringToStream(AsCoded);
  try
    result := TDataStream.Create(m);
  finally
    m.Free;
  end;
end;

end.

